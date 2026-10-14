# Kit de marca — BioLume

Conceito: um **pino de mapa** com uma **folha** dentro (o registro de campo de uma planta) e um **vaga-lume aceso** na borda: a luz que revela o que ameaça a floresta. No nome, o pingo do "i" de "BioLume" é o mesmo vaga-lume. As cores são as da marca anterior (Lume).

Gerado em vetor por script (formas geométricas + texto em curvas, fontes Archivo Expanded 800 e IBM Plex Sans 500, ambas OFL). Não precisa ter as fontes instaladas.

## Cores

| Nome | Hex | Uso |
|---|---|---|
| Verde-floresta | `#38613F` | Pino, contornos, nervura, nome |
| Menta clara | `#ADD7B5` | Metade da folha, halo do vaga-lume |
| Menta escura | `#9CC599` | Outra metade da folha |
| Creme | `#F7F4E5` | Disco do pino, luz do vaga-lume, fundo do ícone |

## Arquivos

### `svg/`
| Arquivo | Para quê |
|---|---|
| `biolume-simbolo.svg` | Símbolo colorido (também é o marcador da abertura do app) |
| `biolume-simbolo-branco.svg` | Símbolo para fundo verde/escuro |
| `biolume-simbolo-mono.svg` | Uma cor só (carimbo, ícone temático do Android) |
| `biolume-logo-horizontal.svg` | Símbolo + BioLume + slogan |
| `biolume-logo-horizontal-sem-slogan.svg` | Símbolo + BioLume (barra do app) |
| `biolume-logo-horizontal-branco.svg` | Versão para fundo verde |
| `biolume-logo-vertical.svg` | Símbolo em cima, nome embaixo |
| `icone-app-creme.svg` / `icone-app-verde.svg` | Ícone quadrado do app |
| `android-adaptive-foreground.svg` / `-monochrome.svg` | Camadas do ícone adaptativo |

### `png/`
- `app/` — ícone 1024 px, 512 px para a Play Store e versão verde.
- `android/` — camadas do ícone adaptativo (usadas pelo `flutter_launcher_icons`).
- `logo/` — logos em alta resolução.
- `simbolo/` — símbolo em 1024, 512 e 96 px de altura.
- `web/` — ícones 32, 192 e 512 px (para a futura versão PWA).

## Regras de uso
- Respiro em volta: pelo menos a largura do vaga-lume do pino.
- Abaixo de 32 px de altura, use só o símbolo, sem o nome.
- Em fundo verde ou escuro, use as versões **branco**.
- Não distorcer, girar, trocar as cores ou aplicar sombra.

Os SVGs usados pelo app ficam em `assets/branding/`.
