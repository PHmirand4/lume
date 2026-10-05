# CLAUDE.md

Lume — app Flutter (Android) offline-first para monitorar espécies exóticas invasoras da Flona de Pacotuba. Produto definido em `CONTEXTO_APP_EEI_PACOTUBA.md` (fonte de verdade; regras RN01–RN23, telas T01–T16). Identidade visual: `lume-logo-kit/` (a seção 16.1 do contexto foi atualizada para ela).

## Comandos

O SDK do Flutter não está no PATH do Git Bash. Use:
`export PATH="/c/Users/Miranda/Downloads/flutter_windows_3.47.6-stable/flutter/bin:$PATH"`

- `flutter analyze` — deve ficar sem issues
- `flutter test` — regras (`test/regras_test.dart`) e repositório com drift em memória
- `dart run build_runner build` — depois de mudar `lib/data/local/tables.dart`
- `flutter build apk --debug`

## Arquitetura

- A tela lê sempre do SQLite (drift) via providers Riverpod (`lib/app/providers.dart`), nunca da rede.
- Toda escrita passa pelos repositórios (`lib/data/repositories/`), que marcam `sync_status = pendente`, `updated_at` e `version + 1`.
- Regras de negócio puras em `lib/domain/regras.dart` (status, foco próximo, detecção precoce). Mantenha-as sem dependência de Flutter e cubra com testes.
- Códigos de vocabulário são constantes em `lib/domain/codigos.dart`; rótulos vêm da tabela `lista_valor` (`Vocabulario.rotulo`).
- Sync (`lib/data/sync/sync_service.dart`) converte camelCase do drift ⇄ snake_case do Supabase. Uma coluna nova no drift precisa da mesma coluna numa nova migração em `supabase/migrations/`.
- Supabase só é ativado com `--dart-define=SUPABASE_URL` e `SUPABASE_KEY`; sem eles o app roda em modo local.

## Convenções

- Interface e código de domínio em português (pt-BR), como o resto do projeto.
- Datas em UTC no banco; exiba com `lib/core/formato.dart` (fuso do aparelho).
- Cores e fontes só por `LumeCores`, `estiloMono`, `estiloCodigo` e o tema (`lib/app/theme.dart`). Status do foco sempre com forma + cor + rótulo (`MarcadorStatus`, `EtiquetaStatus`).
- Botões com 48 dp ou mais; tema claro (uso sob sol).
