-- =============================================================================
-- BioLume v2: várias unidades (Florestas Nacionais) e catálogo nacional de EEI
-- =============================================================================

-- Focos passam a pertencer a uma unidade (id do catálogo de unidades do app,
-- ex.: flona_pacotuba). Os focos existentes são todos da Flona de Pacotuba.
alter table public.focos add column if not exists unidade_id text not null default 'flona_pacotuba';
-- Identificador da linha na planilha de origem (importação sem duplicar).
alter table public.focos add column if not exists chave_externa text;
create index if not exists focos_unidade_idx on public.focos (unidade_id);
create unique index if not exists focos_chave_externa_idx
  on public.focos (unidade_id, chave_externa) where chave_externa is not null;

-- Catálogo nacional (Base de Dados Nacional de EEI — Instituto Hórus) e
-- espécies cadastradas pela equipe no app.
alter table public.especies add column if not exists origem_nativa text;
alter table public.especies add column if not exists ambientes_invasao text;
alter table public.especies add column if not exists impactos text;
alter table public.especies add column if not exists controle_literatura text;
alter table public.especies add column if not exists nativa_brasil boolean not null default false;
alter table public.especies add column if not exists fonte text;
alter table public.especies add column if not exists criado_por uuid references public.usuarios (id);
alter table public.especies add column if not exists unidade_origem text;

-- Qualquer usuário ativo cadastra espécie nova no catálogo; editar e
-- desativar continua com o gestor (política especies_gestor).
drop policy if exists especies_inserir on public.especies;
create policy especies_inserir on public.especies for insert to authenticated
  with check (public.eh_ativo() and criado_por = auth.uid());

-- Fotos de referência das espécies usam a tabela midias (dono_tipo = 'especie').
comment on column public.midias.dono_tipo is 'observacao · acao_manejo · especie';
