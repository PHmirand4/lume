# Kit de logo — Lume

Logo redesenhada em vetor a partir da imagem original (prancheta + marcador de mapa + folha). Todos os arquivos têm fundo transparente, exceto os ícones de app.

## Cores da logo (medidas na imagem original)

| Nome | Hex | RGB | Uso |
|---|---|---|---|
| Verde-floresta | `#38613F` | 56, 97, 63 | Prancheta, contornos, folha, texto da marca |
| Menta clara | `#ADD7B5` | 173, 215, 181 | Metade esquerda do marcador |
| Menta escura | `#9CC599` | 156, 197, 153 | Metade direita do marcador |
| Creme | `#F7F4E5` | 247, 244, 229 | Contornos internos, círculo da folha, fundo do ícone |

> Os valores escritos embaixo dos quadrados na imagem original estavam incorretos (ex.: "RGB 259" não existe). Use os desta tabela.

## Arquivos

### `svg/` — vetores (use sempre que possível)
| Arquivo | Para quê |
|---|---|
| `lume-simbolo.svg` | Símbolo completo colorido |
| `lume-simbolo-mono-verde.svg` / `-branco` / `-preto` | Uma cor só (impressão, carimbo, fundo escuro, ícone temático do Android) |
| `lume-marcador.svg` | Só o marcador com a folha — usar como **pino dos focos no mapa** e em tamanhos pequenos |
| `lume-logo-horizontal.svg` | Símbolo + LUME + slogan |
| `lume-logo-horizontal-sem-slogan.svg` | Símbolo + LUME |
| `lume-logo-horizontal-branco.svg` | Versão branca para fundos verdes/escuros |
| `lume-logo-vertical.svg` | Símbolo em cima, LUME embaixo (slides, banner, camiseta) |
| `icone-app-creme.svg` / `icone-app-mint.svg` | Ícone quadrado do app |
| `android-adaptive-foreground.svg` / `-monochrome.svg` | Camadas do ícone adaptativo do Android |
| `favicon.svg` | Ícone simplificado (marcador sobre verde) |

O texto "LUME" e o slogan estão convertidos em curvas: não precisa ter a fonte instalada.

### `png/` — imagens prontas
- `simbolo/` — símbolo em 1024, 512 e 256 px de altura; versões mono; marcador em 512 px e 96 px (tamanho de pino no mapa).
- `logo/` — logos horizontal e vertical em alta resolução.
- `app/` — ícone 1024 px (base) e **512 px para a Play Store**.
- `android/` — camadas do ícone adaptativo (1024 px e 432 px).
- `web/` — favicons 32, 48, 192 e 512 px.

## Regras de uso
- Área de respiro: deixe em volta da logo um espaço livre de pelo menos a largura do círculo da folha.
- Tamanho mínimo: símbolo completo a partir de 32 px de altura na tela; abaixo disso, use `lume-marcador` ou o favicon.
- Em fundo verde ou escuro: use as versões **branco** ou **mono-branco**.
- Não distorcer, não girar, não trocar as cores, não aplicar sombra.

## Flutter — ícone do app

Copie a pasta `png/` para `assets/branding/` e adicione no `pubspec.yaml` (pacote `flutter_launcher_icons`):

```yaml
dev_dependencies:
  flutter_launcher_icons: ^0.14.0   # verifique a versão atual no pub.dev

flutter_launcher_icons:
  android: true
  ios: false
  image_path: "assets/branding/app/icone-app-1024.png"
  adaptive_icon_background: "#F7F4E5"
  adaptive_icon_foreground: "assets/branding/android/adaptive-foreground-1024.png"
  adaptive_icon_monochrome: "assets/branding/android/adaptive-monochrome-1024.png"
```

Depois rode: `dart run flutter_launcher_icons`.

## Tipografia da marca
- **LUME:** Archivo, largura 125%, peso 800.
- **Slogan e textos:** IBM Plex Sans.
