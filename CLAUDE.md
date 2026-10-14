# CLAUDE.md

BioLume (antes Lume) — app Flutter (Android; PWA para iPhone depois) offline-first para monitorar espécies exóticas invasoras nas Florestas Nacionais do ICMBio, com a Flona de Pacotuba como piloto. Produto definido em `CONTEXTO_APP_EEI_PACOTUBA.md` (fonte de verdade; regras RN01–RN23, telas T01–T16; a seção "Atualização v2" no topo amplia o escopo). Identidade visual: `biolume-logo-kit/`.

O pacote Dart continua `lume`, o banco continua `lume.sqlite` e o applicationId continua `app.lume.pacotuba`, para manter os dados de quem já tem o app.

## Comandos

O SDK do Flutter não está no PATH do Git Bash. Use:
`export PATH="/c/Users/Miranda/Downloads/flutter_windows_3.47.6-stable/flutter/bin:$PATH"`

- `flutter analyze` — deve ficar sem issues
- `flutter test` — regras (`test/regras_test.dart`, `test/importacao_test.dart`, `test/priorizacao_test.dart`), repositório com drift em memória e migração v1→v3 (`test/migracao_test.dart`)
- `dart run build_runner build` — depois de mudar `lib/data/local/tables.dart` (aumente `schemaVersion` e escreva o `onUpgrade`)
- `dart run flutter_launcher_icons` — depois de mudar os PNGs do `biolume-logo-kit/`
- `flutter build apk --debug`

## Arquitetura

- A tela lê sempre do SQLite (drift) via providers Riverpod (`lib/app/providers.dart`), nunca da rede.
- Toda escrita passa pelos repositórios (`lib/data/repositories/`), que marcam `sync_status = pendente`, `updated_at` e `version + 1`.
- Regras de negócio puras em `lib/domain/regras.dart` (status, foco próximo, detecção precoce, catálogo) e `lib/domain/importacao.dart` (planilhas). Mantenha-as sem dependência de Flutter e cubra com testes.
- Unidades: `CatalogoUnidades` (`lib/data/geo/unidades.dart`) lê `assets/geo/flonas.geojson` (limites oficiais do ICMBio, simplificados). A unidade escolhida fica em `configs` (`unidade_atual_id`); `unidadeAtualProvider` dá a unidade das telas. Todo foco tem `unidade_id`, e as consultas de focos sempre filtram por ela. O catálogo de espécies é nacional (`assets/seed/especies.json`, da Base de Dados Nacional de EEI do Instituto Hórus + as 10 de Pacotuba).
- Fotos de referência de espécie usam a tabela `midias` com `dono_tipo = 'especie'`.
- Lista oficial do ICMBio (Lista de EEI em UC federais, Portaria 510/2025): tabela local `especies_unidade` (não sincroniza), vem de `assets/seed/lista_uc.json` e é trocada pela importação da planilha oficial de cada ciclo. Espécie registrada fora da lista da unidade gera o motivo de detecção precoce `motivoForaDaLista` e entra no "Informe de novos registros (CMEEI)" da exportação.
- Catálogo tem flora e fauna (`especies.reino`); para animais, `forma_vida` guarda o grupo (mamífero, peixe…).
- Priorização (`lib/domain/priorizacao.dart`, critérios em `assets/seed/priorizacao.json`): 12 critérios da Ferramenta de Priorização do ICMBio; tabela `priorizacoes` (sincroniza).
- Importação de planilhas (`lib/features/importacao`): reconhece a lista oficial (abas com CNUC e Espécie) ou registros de campo no formato da ficha (colunas S/W, CAP, Fase, Bloco). Interruptor em `lib/core/recursos.dart`.
- Documentos e planilhas originais da equipe ficam em `arquivos/` (fonte para os seeds; `test/planilhas_reais_test.dart` usa a lista oficial se a pasta existir).
- Códigos de vocabulário são constantes em `lib/domain/codigos.dart`; rótulos vêm da tabela `lista_valor` (`Vocabulario.rotulo`).
- Sync (`lib/data/sync/sync_service.dart`) converte camelCase do drift ⇄ snake_case do Supabase. Uma coluna nova no drift precisa da mesma coluna numa nova migração em `supabase/migrations/`.
- Supabase só é ativado com `--dart-define=SUPABASE_URL` e `SUPABASE_KEY`; sem eles o app roda em modo local.

## Convenções

- Interface e código de domínio em português (pt-BR), como o resto do projeto.
- Datas em UTC no banco; exiba com `lib/core/formato.dart` (fuso do aparelho).
- Cores e fontes só por `LumeCores`, `estiloMono`, `estiloCodigo` e o tema (`lib/app/theme.dart`). Status do foco sempre com forma + cor + rótulo (`MarcadorStatus`, `EtiquetaStatus`).
- Botões com 48 dp ou mais; tema claro (uso sob sol).
