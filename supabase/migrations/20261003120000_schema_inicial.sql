-- =============================================================================
-- Lume — esquema do backend (Supabase / PostgreSQL)
-- Espelha o banco local (lib/data/local/tables.dart) em snake_case.
-- Rode no SQL Editor do projeto Supabase (uma vez). Idempotente onde possível.
-- =============================================================================

create extension if not exists postgis;

-- -----------------------------------------------------------------------------
-- Função: marca server_updated_at a cada escrita (base do pull incremental)
-- -----------------------------------------------------------------------------
create or replace function public.marcar_server_updated_at()
returns trigger language plpgsql as $$
begin
  new.server_updated_at := now();
  return new;
end $$;

-- -----------------------------------------------------------------------------
-- Usuários (= Rede de colaboradores do Guia ICMBio)
-- O id é o mesmo do auth.users. Cadastro feito pelo admin (ver fim do arquivo).
-- -----------------------------------------------------------------------------
create table if not exists public.usuarios (
  id uuid primary key references auth.users (id) on delete cascade,
  nome text not null,
  email text not null unique,
  perfil text not null check (perfil in ('campo', 'gestor', 'admin', 'colaborador')),
  funcao text,
  ativo boolean not null default true,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  server_updated_at timestamptz not null default now(),
  deleted boolean not null default false,
  version integer not null default 1
);

-- Perfil do usuário logado (usado nas regras de acesso).
create or replace function public.perfil_atual()
returns text language sql stable security definer set search_path = public as $$
  select perfil from public.usuarios where id = auth.uid() and ativo and not deleted
$$;

create or replace function public.eh_gestor()
returns boolean language sql stable as $$
  select coalesce(public.perfil_atual() in ('gestor', 'admin'), false)
$$;

create or replace function public.eh_ativo()
returns boolean language sql stable as $$
  select public.perfil_atual() is not null
$$;

-- -----------------------------------------------------------------------------
-- Vocabulários e catálogo de espécies (= Vocabulário de referência)
-- -----------------------------------------------------------------------------
create table if not exists public.lista_valor (
  lista text not null,
  codigo text not null,
  rotulo text not null,
  ordem integer not null default 0,
  ativo boolean not null default true,
  primary key (lista, codigo)
);

create table if not exists public.especies (
  id text primary key,
  prefixo text not null,
  nome_cientifico text not null,
  nomes_populares text[] not null default '{}',
  familia text,
  forma_vida text not null,
  descricao_identificacao text,
  confusao_com text,
  controle_citado text,
  metodos_sugeridos text[] not null default '{}',
  fotos_referencia text[] not null default '{}',
  prioridade integer,
  na_lista_oficial_icmbio boolean,
  ativa boolean not null default true,
  ordem integer not null default 0,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  server_updated_at timestamptz not null default now(),
  deleted boolean not null default false,
  version integer not null default 1
);

-- -----------------------------------------------------------------------------
-- Focos (= Ocorrências) — local persistente de uma população invasora
-- -----------------------------------------------------------------------------
create table if not exists public.focos (
  id uuid primary key,
  especie_id text not null references public.especies (id),
  especie_texto text,
  codigo text not null,
  lat double precision not null,
  lon double precision not null,
  precisao_m double precision,
  origem_coordenada text not null,
  zona text,
  ambiente text,
  status text not null,
  status_manual boolean not null default false,
  status_alterado_por uuid,
  status_alterado_em timestamptz,
  deteccao_precoce boolean not null default false,
  motivos_precoce text[] not null default '{}',
  fora_do_limite boolean not null default false,
  criado_por uuid not null references public.usuarios (id),
  primeira_deteccao_em timestamptz not null,
  ultima_visita_em timestamptz not null,
  ultima_abundancia text,
  geom geography(point, 4326) generated always as (st_setsrid(st_makepoint(lon, lat), 4326)::geography) stored,
  created_at timestamptz not null,
  updated_at timestamptz not null,
  server_updated_at timestamptz not null default now(),
  deleted boolean not null default false,
  version integer not null default 1
);
create index if not exists focos_especie_idx on public.focos (especie_id);
create index if not exists focos_server_upd_idx on public.focos (server_updated_at);
create index if not exists focos_geom_idx on public.focos using gist (geom);

-- -----------------------------------------------------------------------------
-- Observações (detecção e revisitas)
-- -----------------------------------------------------------------------------
create table if not exists public.observacoes (
  id uuid primary key,
  foco_id uuid not null references public.focos (id),
  tipo text not null check (tipo in ('deteccao', 'revisita')),
  usuario_id uuid not null references public.usuarios (id),
  sessao_id uuid,
  data_hora timestamptz not null,
  lat double precision not null,
  lon double precision not null,
  precisao_m double precision,
  altitude_m double precision,
  presenca text not null check (presenca in ('presente', 'ausente')),
  resultado text,
  quantificacao_tipo text,
  n_individuos integer,
  classe_abundancia text,
  area_m2 double precision,
  cobertura_pct integer check (cobertura_pct between 0 and 100),
  estagio text,
  ambiente text,
  texto text,
  ditado boolean not null default false,
  dispositivo text,
  versao_app text,
  created_at timestamptz not null,
  updated_at timestamptz not null,
  server_updated_at timestamptz not null default now(),
  deleted boolean not null default false,
  version integer not null default 1
);
create index if not exists obs_foco_idx on public.observacoes (foco_id);
create index if not exists obs_server_upd_idx on public.observacoes (server_updated_at);

-- -----------------------------------------------------------------------------
-- Ações de manejo (= planilha Manejo)
-- -----------------------------------------------------------------------------
create table if not exists public.acoes_manejo (
  id uuid primary key,
  foco_id uuid not null references public.focos (id),
  usuario_id uuid not null references public.usuarios (id),
  responsavel text not null,
  data_hora_inicio timestamptz not null,
  data_hora_fim timestamptz,
  metodo text not null,
  metodo_texto text,
  herbicida_produto text,
  herbicida_concentracao text,
  herbicida_volume_l double precision,
  n_individuos_tratados integer,
  area_tratada_m2 double precision,
  n_pessoas integer not null,
  horas double precision not null,
  destinacao text,
  epi_utilizado boolean,
  condicao_tempo text,
  texto text,
  created_at timestamptz not null,
  updated_at timestamptz not null,
  server_updated_at timestamptz not null default now(),
  deleted boolean not null default false,
  version integer not null default 1,
  -- RN20: manejo químico exige o produto
  constraint manejo_quimico_tem_produto check (
    metodo not in ('corte_herbicida', 'anelamento_herbicida', 'herbicida_foliar')
    or coalesce(herbicida_produto, '') <> ''
  )
);
create index if not exists manejo_foco_idx on public.acoes_manejo (foco_id);
create index if not exists manejo_server_upd_idx on public.acoes_manejo (server_updated_at);

-- -----------------------------------------------------------------------------
-- Mídias (metadados; arquivos no bucket "midias")
-- -----------------------------------------------------------------------------
create table if not exists public.midias (
  id uuid primary key,
  dono_tipo text not null check (dono_tipo in ('observacao', 'acao_manejo')),
  dono_id uuid not null,
  tipo text not null default 'foto',
  momento text,
  caminho_remoto text,
  lat double precision,
  lon double precision,
  tirada_em timestamptz not null,
  tamanho_bytes integer,
  created_at timestamptz not null,
  updated_at timestamptz not null,
  server_updated_at timestamptz not null default now(),
  deleted boolean not null default false,
  version integer not null default 1
);
create index if not exists midia_dono_idx on public.midias (dono_id);
create index if not exists midia_server_upd_idx on public.midias (server_updated_at);

-- -----------------------------------------------------------------------------
-- Gatilhos de server_updated_at
-- -----------------------------------------------------------------------------
do $$
declare t text;
begin
  foreach t in array array['usuarios', 'especies', 'focos', 'observacoes', 'acoes_manejo', 'midias'] loop
    execute format('drop trigger if exists %I_server_upd on public.%I', t, t);
    execute format(
      'create trigger %I_server_upd before insert or update on public.%I
         for each row execute function public.marcar_server_updated_at()', t, t);
  end loop;
end $$;

-- -----------------------------------------------------------------------------
-- Regras de acesso (RLS) — seção 18
--   campo:  cria ocorrências, manejos e revisitas; vê tudo; edita os próprios por 24 h
--   gestor: tudo de campo + edita qualquer registro, muda status, gerencia catálogo
--   admin:  tudo + gerencia usuários
-- Nada é apagado fisicamente (sem política de DELETE): exclusão é lógica.
-- -----------------------------------------------------------------------------
alter table public.usuarios enable row level security;
alter table public.lista_valor enable row level security;
alter table public.especies enable row level security;
alter table public.focos enable row level security;
alter table public.observacoes enable row level security;
alter table public.acoes_manejo enable row level security;
alter table public.midias enable row level security;

-- Usuários
drop policy if exists usuarios_ler on public.usuarios;
create policy usuarios_ler on public.usuarios for select to authenticated
  using (id = auth.uid() or public.eh_ativo());
drop policy if exists usuarios_admin on public.usuarios;
create policy usuarios_admin on public.usuarios for all to authenticated
  using (public.perfil_atual() = 'admin') with check (public.perfil_atual() = 'admin');

-- Catálogos: todos leem; gestão escreve
drop policy if exists lista_ler on public.lista_valor;
create policy lista_ler on public.lista_valor for select to authenticated using (public.eh_ativo());
drop policy if exists lista_gestor on public.lista_valor;
create policy lista_gestor on public.lista_valor for all to authenticated
  using (public.eh_gestor()) with check (public.eh_gestor());

drop policy if exists especies_ler on public.especies;
create policy especies_ler on public.especies for select to authenticated using (public.eh_ativo());
drop policy if exists especies_gestor on public.especies;
create policy especies_gestor on public.especies for all to authenticated
  using (public.eh_gestor()) with check (public.eh_gestor());

-- Focos: qualquer usuário ativo cria e atualiza (a revisita de um colega
-- recalcula status e última visita do foco). Mudança manual de status é
-- registrada em status_alterado_por/em.
drop policy if exists focos_ler on public.focos;
create policy focos_ler on public.focos for select to authenticated using (public.eh_ativo());
drop policy if exists focos_inserir on public.focos;
create policy focos_inserir on public.focos for insert to authenticated
  with check (public.eh_ativo() and criado_por = auth.uid());
drop policy if exists focos_atualizar on public.focos;
create policy focos_atualizar on public.focos for update to authenticated
  using (public.eh_ativo()) with check (public.eh_ativo());

-- Observações e manejos: autor cria; autor edita por 24 h; gestão sempre (RN22)
drop policy if exists obs_ler on public.observacoes;
create policy obs_ler on public.observacoes for select to authenticated using (public.eh_ativo());
drop policy if exists obs_inserir on public.observacoes;
create policy obs_inserir on public.observacoes for insert to authenticated
  with check (public.eh_ativo() and usuario_id = auth.uid());
drop policy if exists obs_atualizar on public.observacoes;
create policy obs_atualizar on public.observacoes for update to authenticated
  using (public.eh_gestor() or (usuario_id = auth.uid() and created_at > now() - interval '24 hours'))
  with check (public.eh_gestor() or usuario_id = auth.uid());

drop policy if exists manejo_ler on public.acoes_manejo;
create policy manejo_ler on public.acoes_manejo for select to authenticated using (public.eh_ativo());
drop policy if exists manejo_inserir on public.acoes_manejo;
create policy manejo_inserir on public.acoes_manejo for insert to authenticated
  with check (public.eh_ativo() and usuario_id = auth.uid());
drop policy if exists manejo_atualizar on public.acoes_manejo;
create policy manejo_atualizar on public.acoes_manejo for update to authenticated
  using (public.eh_gestor() or (usuario_id = auth.uid() and created_at > now() - interval '24 hours'))
  with check (public.eh_gestor() or usuario_id = auth.uid());

-- Mídias: usuários ativos (o app grava a mídia junto com o registro do autor)
drop policy if exists midia_ler on public.midias;
create policy midia_ler on public.midias for select to authenticated using (public.eh_ativo());
drop policy if exists midia_escrever on public.midias;
create policy midia_escrever on public.midias for insert to authenticated with check (public.eh_ativo());
drop policy if exists midia_atualizar on public.midias;
create policy midia_atualizar on public.midias for update to authenticated
  using (public.eh_ativo()) with check (public.eh_ativo());

-- -----------------------------------------------------------------------------
-- Storage: bucket privado "midias"
-- -----------------------------------------------------------------------------
insert into storage.buckets (id, name, public)
values ('midias', 'midias', false)
on conflict (id) do nothing;

drop policy if exists midias_bucket_ler on storage.objects;
create policy midias_bucket_ler on storage.objects for select to authenticated
  using (bucket_id = 'midias' and public.eh_ativo());
drop policy if exists midias_bucket_enviar on storage.objects;
create policy midias_bucket_enviar on storage.objects for insert to authenticated
  with check (bucket_id = 'midias' and public.eh_ativo());
drop policy if exists midias_bucket_atualizar on storage.objects;
create policy midias_bucket_atualizar on storage.objects for update to authenticated
  using (bucket_id = 'midias' and public.eh_ativo());

-- =============================================================================
-- Cadastro de usuários (feito pelo admin)
-- 1. Authentication → Users → "Add user" (e-mail e senha).
-- 2. Copie o UUID do usuário criado e rode:
--
-- insert into public.usuarios (id, nome, email, perfil, funcao)
-- values ('<uuid-do-auth>', 'Nome da Pessoa', 'email@exemplo.gov.br', 'campo', 'brigadista');
--
-- Perfis: campo · gestor · admin
-- =============================================================================
