-- =============================================================================
-- BioLume v3: fauna no catálogo, campos da ficha de campo do ICMBio e
-- priorização de EEI por unidade (Ferramenta de Priorização, Portaria 510/2025).
-- A lista oficial de EEI por unidade (Lista de EEI em UC federais) é dado de
-- referência e, por ora, fica só no aparelho (seed + importação da planilha).
-- =============================================================================

alter table public.especies add column if not exists reino text not null default 'planta';

-- Ficha de campo: bloco, CAP, padrão de ocorrência e, para fauna, tipo de evidência.
alter table public.observacoes add column if not exists bloco text;
alter table public.observacoes add column if not exists cap_cm double precision;
alter table public.observacoes add column if not exists padrao_ocorrencia text;
alter table public.observacoes add column if not exists evidencia text;
alter table public.acoes_manejo add column if not exists bloco text;
alter table public.acoes_manejo add column if not exists cap_cm double precision;

create table if not exists public.priorizacoes (
  id uuid primary key,
  unidade_id text not null,
  especie_id text not null references public.especies (id),
  respostas text not null, -- JSON {"1": "codigo", ...}
  indice integer not null,
  usuario_id uuid not null references public.usuarios (id),
  observacao text,
  created_at timestamptz not null,
  updated_at timestamptz not null,
  server_updated_at timestamptz not null default now(),
  deleted boolean not null default false,
  version integer not null default 1
);
create unique index if not exists priorizacoes_unidade_especie_idx on public.priorizacoes (unidade_id, especie_id);
create index if not exists priorizacoes_server_upd_idx on public.priorizacoes (server_updated_at);

drop trigger if exists priorizacoes_server_upd on public.priorizacoes;
create trigger priorizacoes_server_upd before insert or update on public.priorizacoes
  for each row execute function public.marcar_server_updated_at();

alter table public.priorizacoes enable row level security;
drop policy if exists priorizacoes_ler on public.priorizacoes;
create policy priorizacoes_ler on public.priorizacoes for select to authenticated using (public.eh_ativo());
drop policy if exists priorizacoes_gestor on public.priorizacoes;
create policy priorizacoes_gestor on public.priorizacoes for all to authenticated
  using (public.eh_gestor()) with check (public.eh_gestor());
