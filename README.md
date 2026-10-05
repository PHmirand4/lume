# Lume

**Ilumine o que ameaça a floresta.**

App Android (Flutter), offline-first, para a equipe da Floresta Nacional de Pacotuba (ICMBio) registrar em campo espécies exóticas invasoras, ações de manejo e revisitas, com foto, GPS e mapa.

Projeto de Inovação da equipe de robótica do SESI Cachoeiro de Itapemirim — FIRST LEGO League, temporada BIOGLOW (2026/2027).

A fonte de verdade do produto é o [`CONTEXTO_APP_EEI_PACOTUBA.md`](CONTEXTO_APP_EEI_PACOTUBA.md). A identidade visual está em [`lume-logo-kit/`](lume-logo-kit/LEIA-ME.md).

## Como rodar

```bash
flutter pub get
dart run build_runner build      # gera lib/data/local/database.g.dart (só se mudar as tabelas)
flutter run                      # modo local (sem servidor)
```

Com o servidor (Supabase) — a URL e a chave pública ficam em `dart_defines.json` (fora do git):

```bash
flutter run --dart-define-from-file=dart_defines.json
```

No Android Studio: **Run → Edit Configurations → Additional run args**: `--dart-define-from-file=dart_defines.json`.

```json
{ "SUPABASE_URL": "https://<ref>.supabase.co", "SUPABASE_KEY": "sb_publishable_..." }
```

Testes: `flutter test` · Análise: `flutter analyze` · APK: `flutter build apk --release`.

### Modo local × modo servidor

| | Modo local (sem `--dart-define`) | Modo servidor |
|---|---|---|
| Login | Identificação (nome, e-mail, perfil) | E-mail e senha (Supabase Auth) |
| Dados | Só no aparelho | Sincroniza com o servidor |
| Exportação | CSV, GeoJSON, KML, Darwin Core, PDF | Igual |

O modo local já serve para demonstração e para o primeiro teste de campo.

## APK de Release (GitHub Actions)

Neste PC o Windows (Controle Inteligente de Aplicativos) bloqueia o compilador AOT do Flutter, então só o modo Debug roda localmente. O APK de Release é gerado na nuvem por [`.github/workflows/build-apk.yml`](.github/workflows/build-apk.yml):

- **push na `main`** → APK em *Actions → execução → Artifacts*;
- **tag `v*`** (ex.: `git tag v1.0.1 && git push --tags`) → também cria uma *Release* com o APK;
- **manual** → *Actions → Build APK → Run workflow*.

Secrets do repositório: `SUPABASE_URL`, `SUPABASE_KEY`, `ANDROID_KEYSTORE_BASE64`, `ANDROID_KEYSTORE_PASSWORD`, `ANDROID_KEY_ALIAS`. Os valores estão em `android/keystore/segredos-github.txt` (fora do git).

**Chave de assinatura** (`android/keystore/lume-release.jks` + `android/key.properties`): guarde uma cópia segura (ex.: Drive da equipe). Sem ela, versões novas não instalam por cima das antigas. O número da build é o número da execução do Actions, então cada APK novo atualiza o anterior.

APK de Debug local (instalável, porém maior e mais lento):
`flutter build apk --debug --dart-define-from-file=dart_defines.json`

## Configurar o servidor (Supabase)

1. Crie um projeto em [supabase.com](https://supabase.com).
2. Pelo CLI, na pasta do projeto: `npx supabase login --token <token>`, `npx supabase link --project-ref <ref>` e `npx supabase db push --linked --include-seed` (senha do banco em `supabase/.env.local`, fora do git). Sem CLI: rode no **SQL Editor** o conteúdo de [`supabase/migrations/`](supabase/migrations/) e depois [`supabase/seed.sql`](supabase/seed.sql).
3. Crie os usuários em **Authentication → Users** e cadastre cada um na tabela `usuarios` (instrução no fim da migração inicial).
4. Copie a **URL** e a **publishable key** (Settings → API) para o `dart_defines.json`. Nunca use a chave `service_role` no app.

## O que já funciona (MVP)

| # | Funcionalidade | Onde |
|---|---|---|
| F01 | Login, com sessão guardada para uso offline | `features/auth` |
| F02 | Guia offline das 10 espécies | `features/especies` |
| F03 | Nova ocorrência: espécie, GPS com precisão, quantidade, estágio, ambiente, fotos, observação | `features/ocorrencia` |
| F04 | Ditado da observação (voz para texto) | `widgets/formulario.dart` |
| F05 | Registro de manejo | `features/manejo` |
| F06 | Revisita | `features/ocorrencia/revisita_screen.dart` |
| F07 | Status do foco automático (RN09–RN13) | `domain/regras.dart` |
| F08 | "É o mesmo foco?" por proximidade | `features/ocorrencia/mesmo_foco_dialog.dart` |
| F09 | Mapa com o limite oficial da Flona e os focos | `features/mapa` |
| F10 | Ficha do foco com linha do tempo | `features/foco` |
| F11 | Navegar até o foco (bússola + distância) | `features/navegacao` |
| F12 | Banco local + sincronização com pendências | `data/local`, `data/sync` |
| F13 | Lista com filtros | `features/lista` |
| F14–F16 | Exportação CSV, GeoJSON, KML, Darwin Core e relatório PDF | `features/exportacao` |
| F17 | "Outra espécie / não sei" com foto obrigatória | `features/ocorrencia` |
| F18 | Detecção precoce em destaque | `domain/regras.dart` |

## Estrutura

```
lib/
  main.dart            inicialização (seed, limite da Flona, Supabase)
  app/                 tema da marca, rotas (go_router), providers (Riverpod)
  core/                geometria, GPS, fotos, formatação
  domain/              códigos dos vocabulários e regras de negócio (puras, testadas)
  data/
    local/             drift: tabelas, banco, seed
    geo/               limite oficial da Flona
    remote/            configuração do Supabase
    repositories/      focos, catálogo, sessão, configurações
    sync/              push/pull, fila de envio, upload de fotos
  features/            telas (T01–T14)
  widgets/             componentes compartilhados (mapa, marcadores, formulário)
assets/
  branding/            SVGs do lume-logo-kit usados no app
  fonts/               Archivo (larga) e IBM Plex Sans/Mono, embutidas (funcionam offline)
  geo/                 limite_flona.geojson (convertido do KMZ oficial do ICMBio)
  seed/                especies.json, listas.json
supabase/              config.toml, migrations/ (tabelas + RLS + bucket) e seed.sql
test/                  regras de negócio e repositório (banco em memória)
```

## Decisões tomadas

- **Identidade:** a do `lume-logo-kit` (verde-floresta `#38613F`, menta, creme). O laranja `#E35205` fica só para focos detectados e detecção precoce. Cada status tem forma e cor própria (seção 16.1).
- **Mapa base:** OpenStreetMap com o cache automático do `flutter_map` (só guarda os blocos já vistos, sem baixar tudo de uma vez, como pede a política do OSM). Sem conexão, o mapa mostra o limite da Flona e os focos sobre fundo neutro. O MBTiles próprio (§14.4, opção A) continua em aberto.
- **Erradicado (RN13):** N revisitas ausentes seguidas no fim da linha do tempo **e** pelo menos X meses entre o último registro de presença ou manejo e a última ausência. Padrão: N = 3, X = 12. A gestão ajusta em Configurações.
- **Código do foco** (`JAQ-0042`): sequencial por espécie, gerado no aparelho. Com vários aparelhos registrando offline pode haver código repetido. O `id` (UUID) é sempre único; o código é só para leitura.
- **Fotos:** redimensionadas na captura (lado maior 1600 px, JPEG 80%).
- **CSV:** UTF-8 com BOM e separador vírgula (abre no Excel, QGIS, R e Python).
- **Android 8.0+** (`minSdk 26`). ID do app: `app.lume.pacotuba`.

## Próximos passos

- Fotos de referência da Flona no guia (pergunta 13 do questionário).
- Mapa base offline (MBTiles da região ou ortofoto do GEOBASES/ES).
- Sincronização em segundo plano (`workmanager`). Hoje ela roda com o app aberto: ao abrir, ao voltar a conexão, a cada 15 min e no botão.
- Edição de registros dentro de 24 h. Hoje o autor pode excluir; editar fica para depois.
- Itens da v2 (§9.2): sessão de campo com trilha, painel do gestor, alertas, zonas e trilhas no mapa.
