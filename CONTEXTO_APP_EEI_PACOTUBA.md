# Lume — App de Monitoramento de Espécies Exóticas Invasoras da Flona de Pacotuba

> **Documento de contexto e definição do produto (v0.3 — 03/10/2026)**
> Projeto de Inovação da equipe de robótica do SESI Cachoeiro de Itapemirim — FIRST LEGO League, temporada BIOGLOW (2026/2027).
> Nome do app: **Lume** — slogan "Ilumine o que ameaça a floresta." Identidade visual na seção 16.1 (kit em `lume-logo-kit/`).
>
> Este arquivo é a fonte de verdade do projeto. Use-o como contexto para desenvolvimento (inclusive com assistentes de IA). Itens marcados com **[A CONFIRMAR]** dependem das respostas da equipe da Flona (questionário e entrevista).

---

## Sumário

1. [Resumo em uma página](#1-resumo-em-uma-página)
2. [Contexto do projeto](#2-contexto-do-projeto)
3. [A Floresta Nacional de Pacotuba](#3-a-floresta-nacional-de-pacotuba)
4. [O problema](#4-o-problema)
5. [Base legal e normativa](#5-base-legal-e-normativa)
6. [Visão do produto](#6-visão-do-produto)
7. [Personas](#7-personas)
8. [Jornadas e fluxos](#8-jornadas-e-fluxos)
9. [Escopo: MVP, v2 e futuro](#9-escopo-mvp-v2-e-futuro)
10. [Catálogo de espécies (dados iniciais)](#10-catálogo-de-espécies-dados-iniciais)
11. [Vocabulários controlados](#11-vocabulários-controlados)
12. [Modelo de dados](#12-modelo-de-dados)
13. [Regras de negócio](#13-regras-de-negócio)
14. [Arquitetura offline-first e sincronização](#14-arquitetura-offline-first-e-sincronização)
15. [Stack técnica (Flutter)](#15-stack-técnica-flutter)
16. [Telas](#16-telas)
17. [Relatórios e exportações](#17-relatórios-e-exportações)
18. [Perfis, segurança e LGPD](#18-perfis-segurança-e-lgpd)
19. [Requisitos não funcionais](#19-requisitos-não-funcionais)
20. [Validação com usuários e ligação com a FLL](#20-validação-com-usuários-e-ligação-com-a-fll)
21. [Plano de desenvolvimento](#21-plano-de-desenvolvimento)
22. [Riscos e decisões em aberto](#22-riscos-e-decisões-em-aberto)
23. [Perguntas pendentes para a Flona](#23-perguntas-pendentes-para-a-flona)
24. [Glossário](#24-glossário)
25. [Fontes](#25-fontes)

---

## 1. Resumo em uma página

**O quê:** aplicativo Android (Flutter), **offline-first**, para a equipe da Flona de Pacotuba registrar em campo as ocorrências de espécies exóticas invasoras (EEI), as ações de controle e as revisitas, com foto, GPS e mapa. Quando houver internet, os dados sincronizam com uma base central, onde podem ser consultados, filtrados e exportados em relatórios.

**Para quem:** equipe de campo e gestão da Flona de Pacotuba (ICMBio), em Cachoeiro de Itapemirim/ES.

**Por quê:** hoje o registro é feito em formulário de papel e WhatsApp. Os dados se perdem, demoram a ser digitados, ficam sem padrão e sem localização precisa. Quando há troca de servidores, o histórico se perde.

**Diferenciais:**
- Funciona 100% sem internet dentro da floresta.
- Já vem com as **10 espécies invasoras manejadas na Flona** cadastradas, com guia de identificação.
- Segue a estrutura de registro do **Guia de Orientação do ICMBio** (Ocorrências, Manejo, Colaboradores, Vocabulário) e gera o relatório no formato que a **IN ICMBio 19/2025** exige.
- Exporta em **Darwin Core**, o mesmo padrão que o ICMBio usa para publicar sua lista oficial de invasoras.

**MVP (v1):** registrar ocorrência → registrar manejo → revisitar foco → ver no mapa offline → navegar até o foco → sincronizar → filtrar e exportar.

---

## 2. Contexto do projeto

| Item | Descrição |
|---|---|
| Competição | FIRST LEGO League (FLL), temporada **BIOGLOW** 2026/2027, guarda-chuva FIRST CANOPY: biodiversidade, conservação e ecossistemas |
| Equipe | Equipe de robótica do SESI Cachoeiro de Itapemirim (alunos + professor orientador) |
| Apoio técnico | Pedro Henrique Miranda de Oliveira (Engenharia da Computação, IFF) |
| Parceiro / usuário | Floresta Nacional de Pacotuba — ICMBio |
| Método | Pesquisa com o usuário (questionário + entrevista) → Lean Inception → MVP → testes de campo → iterações |
| Situação atual | Questionário enviado à Flona (aguardando respostas). Primeira versão funcional será feita com as informações já levantadas e ajustada depois. |

---

## 3. A Floresta Nacional de Pacotuba

### 3.1 Ficha técnica

| Item | Valor |
|---|---|
| Criação | Decreto federal s/nº de 13/12/2002 |
| Gestão | ICMBio — Gerência Regional 4 (Sudeste) |
| Chefe | Augusta Rosa Gonçalves (2026) |
| Área | ≈ 450 ha (ICMBio informa 449,40 ha; o plano de manejo, 450,59 ha) |
| Perímetro | 16,12 km |
| Município | 100% em Cachoeiro de Itapemirim/ES, distrito de Pacotuba |
| Coordenada de referência | 20°44'43"S, 41°17'29"W (≈ −20,7453, −41,2914) |
| Bioma | Mata Atlântica — Floresta Estacional Semidecidual |
| Biodiversidade | 324 espécies de plantas (43 ameaçadas, ~50 endêmicas); 412 espécies de animais (32 vertebrados ameaçados) |
| Espécies-símbolo | Jequitibá-rosa, peroba-amarela, braúna; bugio (*Alouatta guariba*), macaco-prego (*Sapajus nigritus*) |
| Plano de manejo | Aprovado pela Portaria ICMBio 75/2011 (Vol. I Diagnóstico, Vol. II Planejamento) |
| Contato | flonapacotuba.es@icmbio.gov.br · (21) 97899-1550 · Instagram @florestanacionaldepacotuba |
| Endereço | Estrada para Monte Alegre, km 1,2, zona rural do distrito de Pacotuba |

### 3.2 Histórico resumido

- **1950:** a União compra 682 ha da antiga fazenda "Morro Seco e Bananal", ainda com mata nativa.
- **1951–1975:** a área funciona como Fazenda Regional de Criação de Bananal do Norte (Ministério da Agricultura).
- **1980:** cerca de 40% da área é cedida à Emcapa, hoje Incaper (Fazenda Experimental Bananal do Norte, vizinha da Flona).
- **1985:** decreto estadual declara cerca de 300 ha como área de preservação permanente.
- **2002:** criação da Floresta Nacional.
- **2011:** aprovação do plano de manejo.

Esse histórico explica a presença de **plantios antigos** (inclusive de exóticas, como eucalipto) e de **áreas abertas e de antigas lavouras de café** em regeneração, que são ambientes propícios à invasão.

### 3.3 Entorno e pressões

- **Limites:** ao sul, o rio Itapemirim e a Fazenda Experimental Bananal do Norte. Ao norte, a **Comunidade Quilombola de Monte Alegre**, que colabora com a Flona.
- **Estradas:** a rodovia **ES-483** e a estrada de Monte Alegre cortam a Flona. Entre ago/2024 e ago/2026 houve 18 ocorrências com primatas (atropelamentos, eletrocussões, ataques de cães).
- **Outras pressões citadas no plano:** caça, cães domésticos, incêndios no entorno, extração de areia no rio Castelo, alimentação de macacos por visitantes.
- **Uso público:** trilhas Científica, do Mirante e das Árvores Centenárias, e a trilha sensorial "Asas e Ecos da Floresta" (2026). A Flona também recebe pesquisas: 141 solicitações no SISBIO desde 2008.

### 3.4 Zoneamento (Plano de Manejo, Vol. II)

| Zona | Área | Uso |
|---|---|---|
| Manejo Florestal Sustentável | 368,10 ha (≈ 82%) | Manejo de produtos florestais; inclui talhões plantados |
| Primitiva | 46,36 ha | Mínima intervenção; só pesquisa, monitoramento e educação |
| Histórico-Cultural | 25,77 ha | Patrimônio quilombola; visitação acompanhada |
| Uso Conflitante | 6,02 ha | Estradas e linhas de transmissão |
| Uso Público e Especial | 4,34 ha | Sede, infraestrutura, visitação |

**Norma de monitoramento do plano:** os dados devem ser **georreferenciados sempre que possível**.

**Dados geográficos disponíveis:**
- Limite oficial em **KML**, no site do ICMBio.
- Polígonos de zonas, trilhas e talhões: **[A CONFIRMAR]** se a Flona tem esses arquivos em formato digital.

---

## 4. O problema

### 4.1 Processo atual (o que sabemos)

1. A equipe sai a campo, principalmente percorrendo as trilhas e áreas da floresta.
2. As observações são anotadas em **formulário de papel** e/ou enviadas por **WhatsApp** (fotos, mensagens).
3. Depois, os dados são digitados e analisados periodicamente.
4. **[A CONFIRMAR]** Frequência das saídas, campos do formulário, quem digita, onde os dados ficam, prazos dos relatórios.

### 4.2 Dores identificadas

Fonte: reunião inicial e alternativas do questionário elaborado com o professor.

| Dor | Evidência |
|---|---|
| Dados perdidos ou incompletos sem internet | Pergunta 11 do questionário; floresta sem sinal |
| Grande volume de papel para digitalizar | Alternativa da pergunta 7 |
| **Perda de histórico na troca de servidores do ICMBio** ("não armazenado em ambiente corporativo") | Alternativa da pergunta 7 |
| Imprevistos com equipamentos impedem o registro | Alternativa da pergunta 7 |
| Dificuldade de registrar localização exata | Perguntas 12 e 13 |
| Dificuldade de identificar espécies (semelhantes, falta de material de referência) | Perguntas 14 a 17 |
| Registros sem padrão entre pessoas | Pergunta 18 |
| Fotos e mensagens soltas no WhatsApp, sem vínculo com o registro | Reunião inicial |

### 4.3 Hipóteses a validar

- **H1:** registrar uma ocorrência no app leva menos tempo que no papel e não depende de digitação posterior.
- **H2:** GPS com indicação de precisão melhora a localização dos focos e permite reencontrá-los.
- **H3:** um guia de identificação offline reduz dúvidas em campo.
- **H4:** o histórico por foco (detecção → manejo → revisitas) permite medir se o controle funciona.
- **H5:** o relatório automático economiza horas de trabalho da gestão.

---

## 5. Base legal e normativa

| Norma | O que diz | Requisito para o app |
|---|---|---|
| **Lei 9.985/2000 (SNUC), art. 17** | Floresta Nacional: uso múltiplo sustentável e pesquisa científica | — |
| **Lei 9.985/2000 (SNUC), art. 31** | Proíbe introduzir espécies não autóctones em UCs; **Florestas Nacionais são exceção** (§1º) | Distinguir **plantio exótico manejado** (ex.: talhão de eucalipto) de **foco de invasão** |
| **Lei 9.605/1998, art. 61** | Crime: disseminar espécies que possam causar dano aos ecossistemas | Contexto para a apresentação |
| **Resolução CONABIO 7/2018** | Estratégia Nacional para EEI: prevenção, detecção precoce, controle, monitoramento | Etapas do manejo usadas como estrutura do app |
| **Portaria ICMBio 510/2025** | Lista oficial de EEI em UCs federais. UCs listadas devem priorizar controle/erradicação, considerando **impacto ambiental, dificuldade de manejo e área ocupada** | Esses três critérios orientam o painel de prioridades (v2) |
| **IN ICMBio 19/2025** | Prevenção, controle e erradicação de EEI em UCs federais e zonas de amortecimento. Manejo depende de projeto autorizado, **exceto em detecção precoce e resposta rápida** (art. 12). Exige **relatório anual** (até 30 dias após o aniversário da autorização) e **relatório final**. Colaboradores externos atuam por Termo de Adesão | Gerar dados para o relatório. Destacar casos de **detecção precoce**. Registrar o responsável por cada ação |
| **Guia de Orientação ICMBio para manejo de EEI em UCs federais** | Organiza o registro em 4 planilhas: **Ocorrências, Manejo, Rede de colaboradores, Vocabulário de referência**. Tem roteiro de projeto e de relatório e chave de decisão para controle químico | Modelo de dados do app (seção 12). Vocabulários padronizados (seção 11) |
| **Lista de EEI em UCs federais (ICMBio, IPT, Darwin Core, CC-BY 4.0)** | Lista oficial publicada no padrão Darwin Core | Exportação compatível com Darwin Core (seção 17) |
| **LGPD (Lei 13.709/2018)** | Proteção de dados pessoais | Coletar o mínimo de dados pessoais. Não expor nomes em exportações públicas (seção 18) |

> Não foi encontrada lista estadual de espécies exóticas invasoras do Espírito Santo; a lista estadual existente é de espécies **ameaçadas**.

---

## 6. Visão do produto

### 6.1 Frase de visão

> **Para** a equipe da Floresta Nacional de Pacotuba,
> **que** precisa monitorar e controlar espécies exóticas invasoras numa floresta sem sinal de internet,
> **o** Lume **é um** aplicativo de registro de campo offline-first
> **que** transforma cada observação em um dado georreferenciado, padronizado e com histórico,
> **diferente do** formulário de papel e do WhatsApp,
> **o nosso produto** não perde informação, guia a identificação das espécies e gera os relatórios exigidos pelo ICMBio automaticamente.

### 6.2 É / Não é / Faz / Não faz

| É | Não é |
|---|---|
| Ferramenta de registro de campo e acompanhamento de focos | Sistema oficial do ICMBio (é uma ferramenta de apoio) |
| Offline-first | Rede social ou app para o público em geral (no MVP) |
| Guia de identificação das invasoras da Flona | Identificador automático por IA (no MVP) |
| Gerador de relatórios e exportações | Substituto do julgamento técnico da equipe |

| Faz | Não faz |
|---|---|
| Registra ocorrência com espécie, GPS, foto e quantidade | Recomendar herbicida ou dose (só registra o que foi usado) |
| Registra ações de manejo e revisitas | Calcular rotas por ruas dentro da floresta |
| Mostra os focos num mapa offline | Monitorar fauna atropelada (fica para o futuro) |
| Sincroniza quando há internet | Exigir internet para funcionar |
| Exporta CSV, PDF, GeoJSON/KML e Darwin Core | Integrar diretamente com sistemas do ICMBio (futuro) |

### 6.3 Objetivos do produto

1. **Nenhum registro perdido:** tudo salvo no celular e sincronizado depois.
2. **Registro rápido:** uma ocorrência em até 30 segundos (meta), com uma mão.
3. **Localização confiável:** coordenada com precisão informada e foco reencontrável.
4. **Histórico por foco:** saber o que aconteceu com cada mancha de invasão ao longo do tempo.
5. **Relatórios sem retrabalho:** dados prontos no formato do ICMBio.
6. **Memória institucional:** os dados ficam numa base central, não no celular ou no WhatsApp de alguém.

---

## 7. Personas

> Personas provisórias, construídas com o que se sabe até agora. **[A CONFIRMAR]** com o questionário (pergunta 1: funções).

### P1 — Agente de campo
- **Quem:** servidor, brigadista, terceirizado ou voluntário que percorre a floresta.
- **Contexto:** mata fechada, sem sinal, sol ou chuva, mãos ocupadas, às vezes com equipamento de controle (facão, motosserra, pulverizador).
- **Precisa:** registrar rápido, saber se a planta é mesmo invasora, achar de novo um foco antigo.
- **Frustrações:** papel molha, foto perdida no WhatsApp, GPS impreciso, formulário longo.
- **Nível digital:** variado. A interface precisa ser simples.

### P2 — Gestor(a) / analista ambiental
- **Quem:** chefe da UC ou analista responsável pelo manejo.
- **Contexto:** escritório na sede, com internet. Responde ao ICMBio e prepara relatórios e projetos de manejo.
- **Precisa:** visão geral dos focos, evolução no tempo, prioridades, relatórios, exportações e dados que não se percam na troca de equipe.
- **Frustrações:** digitar papel, juntar informação espalhada, perder histórico.

### P3 — Colaborador externo (futuro)
- **Quem:** pesquisador, estudante, membro da comunidade quilombola, voluntário.
- **Precisa:** enviar avistamentos para a equipe validar.
- **Fora do MVP:** entra como perfil "colaborador" na v2.

### P4 — Administrador técnico
- **Quem:** equipe de desenvolvimento (FLL / Pedro).
- **Precisa:** cadastrar usuários, editar o catálogo de espécies e listas, acompanhar a sincronização.

---

## 8. Jornadas e fluxos

### 8.1 Antes de sair a campo (com internet, na sede)
1. Abrir o app e conferir a sincronização ("Tudo sincronizado").
2. Conferir se o mapa offline e o catálogo estão baixados (feito automaticamente na primeira vez).
3. (Opcional) Ver no mapa os focos que precisam de revisita.

### 8.2 Em campo — registrar uma nova ocorrência
1. Toca em **"Nova ocorrência"** (botão grande na tela inicial).
2. O GPS começa a coletar posição imediatamente e mostra a precisão ("±8 m").
3. Escolhe a **espécie** numa grade de fotos das 10 espécies, ou "Outra / não sei" com foto obrigatória.
4. Informa a **quantidade**: contagem, classe de abundância ou área (toques rápidos).
5. Informa o **estágio** e o **ambiente** (opcional, por toques).
6. Tira **foto(s)**.
7. (Opcional) Faz uma **observação** por texto ou ditado.
8. **Salvar.** O app confirma: "Salvo no celular. Será enviado quando houver internet."
9. Se houver um foco da mesma espécie a até 20 m, o app pergunta: **"É o mesmo foco de [data]?"** Se sim, vira revisita; se não, cria foco novo.

### 8.3 Em campo — registrar manejo (controle)
1. A partir do foco (no mapa ou na lista), toca **"Registrar manejo"**.
2. Escolhe o **método** (arranquio, corte, anelamento, corte + herbicida…).
3. Se o método for químico: produto, concentração e volume.
4. Informa os indivíduos tratados e/ou a área tratada, número de pessoas e tempo gasto.
5. Informa a **destinação** do material e tira foto do "depois".
6. Salva. O status do foco passa para **"Em controle"**.

### 8.4 Em campo — revisitar um foco
1. No mapa, toca no foco e em **"Navegar até aqui"**: seta (bússola) e distância.
2. Ao chegar (≤ 20 m), o app sugere **"Registrar revisita"**.
3. Informa: **presente / ausente**, quantidade atual, rebrota (sim/não), foto.
4. O status do foco é recalculado (regras na seção 13).

### 8.5 De volta à sede — sincronizar
1. Com internet, a sincronização roda sozinha. Opção: só no Wi-Fi.
2. A tela inicial mostra "8 registros e 15 fotos enviados".
3. Se houver erro, o registro fica marcado e o app tenta de novo.

### 8.6 Gestão — consultar e exportar
1. **Lista** com filtros por espécie, período, status, zona e responsável.
2. **Mapa** com cores por espécie ou status.
3. **Exportar** em CSV, PDF, GeoJSON/KML ou Darwin Core, de tudo ou do que está filtrado.
4. **Relatório do período** pronto para anexar ao relatório do ICMBio.

### 8.7 Fluxo de vida de um foco

```
[Detectado] ──manejo──▶ [Em controle] ──revisita: ausente──▶ [Controlado]
     ▲                       │                                   │
     │                       └──revisita: presente──┐            │ ausente em N revisitas
     │                                              ▼            ▼   ao longo de X meses
     └──────────── revisita: rebrotou ◀──────── [Ativo]     [Erradicado]
```

---

## 9. Escopo: MVP, v2 e futuro

Priorização MoSCoW: **M** = Must (obrigatório), **S** = Should (importante), **C** = Could (desejável), **W** = Won't now (fora por enquanto).

### 9.1 MVP (v1) — primeira versão funcional

| # | Funcionalidade | Prioridade |
|---|---|---|
| F01 | Login (e-mail e senha) com sessão mantida offline após o primeiro acesso | M |
| F02 | Catálogo das 10 espécies com fotos e características (guia offline) | M |
| F03 | Nova ocorrência: espécie, GPS com precisão, quantidade, estágio, ambiente, fotos, observação em texto | M |
| F04 | Ditado da observação (voz para texto, quando o aparelho permitir) | S |
| F05 | Registro de manejo vinculado ao foco | M |
| F06 | Revisita de foco (presente/ausente, quantidade, rebrota) | M |
| F07 | Status do foco calculado automaticamente | M |
| F08 | Sugestão "é o mesmo foco?" por proximidade | S |
| F09 | Mapa offline da Flona com limite oficial (KML) e focos | M |
| F10 | Ficha do foco com linha do tempo (detecção, manejos, revisitas) | M |
| F11 | Navegar até o foco (bússola + distância) | S |
| F12 | Banco local + sincronização automática com indicador de pendências | M |
| F13 | Lista com filtros (espécie, período, status) | M |
| F14 | Exportação CSV e GeoJSON | M |
| F15 | Relatório PDF do período | S |
| F16 | Exportação Darwin Core (CSV) | S |
| F17 | Registro "Outra espécie / não sei" com foto obrigatória (detecção de espécie nova) | M |
| F18 | Marcação de **detecção precoce** | S |

### 9.2 v2 — após os primeiros testes de campo

| Funcionalidade | Observação |
|---|---|
| Sessão de campo com trilha GPS gravada (esforço de busca) | Mostra onde se procurou e nada foi encontrado |
| Painel de indicadores (focos ativos ao longo do tempo, espécies que crescem, focos sem revisita) | Gestor |
| Alertas (foco sem revisita há X dias, rebrota, espécie nova) | |
| Zonas do zoneamento e trilhas no mapa | Depende dos arquivos da Flona |
| Perfil colaborador com validação pelo gestor | Comunidade quilombola, voluntários, pesquisadores |
| Gravação de áudio anexa à observação | Transcrição depois, quando houver internet |
| Edição do catálogo de espécies pelo gestor | |
| Relatório PDF completo no roteiro do ICMBio | |
| Mapa de calor de densidade | |

### 9.3 Futuro / diferenciais

| Funcionalidade | Observação |
|---|---|
| Identificação por IA na foto (modelo offline treinado só com as espécies da Flona) | Sugestão; a pessoa confirma |
| Roteamento pelas trilhas até o foco | Exige geometria das trilhas |
| Outros tipos de ocorrência (fauna atropelada, caça, fogo) | Previsto no plano de manejo (monitoramento de atropelamentos) |
| Painel web para a gestão | |
| Integração com bases nacionais (SiBBr / ICMBio) | Via Darwin Core |

### 9.4 Fora do escopo

- Recomendar herbicidas, doses ou métodos (responsabilidade técnica da equipe).
- Uso pelo público visitante.
- Versão iOS no MVP **[A CONFIRMAR]** (depende dos aparelhos da equipe).

---

## 10. Catálogo de espécies (dados iniciais)

> **Fonte:** Costa et al. (2024), capítulo sobre a Flona de Pacotuba, que tem a chefe da UC entre os autores. Lista as 10 espécies vegetais exóticas invasoras identificadas no manejo da Flona.
> **[A CONFIRMAR]** com a equipe: lista atual, nomes populares usados por eles, prioridade de cada espécie e fotos próprias da Flona.

| id | Nome científico | Nome popular (sugestão) | Família | Forma de vida | Controle citado na Flona |
|---|---|---|---|---|---|
| acacia_mangium | *Acacia mangium* Willd. | acácia, acácia-mangium | Fabaceae | Árvore | Corte na base com motosserra + herbicida triclopir |
| artocarpus_heterophyllus | *Artocarpus heterophyllus* Lam. | jaqueira | Moraceae | Árvore | Anelamento + triclopir |
| clitoria_fairchildiana | *Clitoria fairchildiana* R.A. Howard | sombreiro | Fabaceae | Árvore | — |
| euterpe_oleracea | *Euterpe oleracea* Mart. | açaí | Arecaceae | Palmeira | — |
| leucaena_leucocephala | *Leucaena leucocephala* (Lam.) de Wit | leucena | Fabaceae | Arbusto/árvore | — |
| mimosa_caesalpiniifolia | *Mimosa caesalpiniifolia* Benth. | sabiá, sansão-do-campo | Fabaceae | Árvore | — |
| muntingia_calabura | *Muntingia calabura* L. | calabura | Muntingiaceae | Árvore | Corte (isolada) ou anelamento (na mata) + herbicida |
| megathyrsus_maximus | *Megathyrsus maximus* (Jacq.) B.K.Simon & S.W.L.Jacobs | capim-colonião | Poaceae | Gramínea | — |
| thunbergia_alata | *Thunbergia alata* Bojer ex Sims | amarelinha, olho-de-poeta | Acanthaceae | Trepadeira | — |
| tradescantia_zebrina | *Tradescantia zebrina* Bosse | lambari-roxo, trapoeraba-roxa | Commelinaceae | Herbácea rasteira | Arranquio manual cuidadoso (sem deixar fragmentos) + secagem ao sol |

**Regra geral da Flona:** árvores isoladas são cortadas rente à base; árvores dentro da matriz florestal são aneladas.

### 10.1 Características para o guia de identificação (rascunho a validar)

| Espécie | Como reconhecer | Cuidado / confusão |
|---|---|---|
| Acácia-mangium | Árvore de crescimento rápido; "folhas" simples e largas com 3–4 nervuras paralelas no comprimento (filódios); flores em espigas amarelo-claras; vagens enroladas | — |
| Jaqueira | Árvore grande; látex branco; folhas simples, grossas e brilhantes; frutos enormes presos ao tronco e galhos grossos | Fruto atrai fauna e espalha sementes |
| Sombreiro | Folhas com 3 folíolos grandes; flores lilás a roxas; vagens longas | — |
| Açaí | Palmeira em **touceira** (vários caules juntos) | **Não confundir com a juçara (*Euterpe edulis*), nativa e ameaçada, que tem caule único** |
| Leucena | Folhas recortadas em muitos folíolos pequenos; flores brancas em "pompom"; vagens achatadas em cachos | — |
| Sabiá | Árvore com espinhos; folhas recortadas; flores brancas em espigas; comum em cercas vivas | Nativa do Nordeste, exótica aqui |
| Calabura | Árvore pequena; folhas assimétricas, peludas e pegajosas; flor branca; frutinhos vermelhos doces | Frutos muito procurados por aves (dispersão) |
| Capim-colonião | Capim alto em touceiras (pode passar de 2 m); inflorescência aberta e ramificada; domina clareiras e bordas | Aumenta risco de fogo |
| Amarelinha | Trepadeira; flores amarelo-alaranjadas com centro escuro ("olho"); folhas em forma de ponta de flecha | Cobre outras plantas |
| Lambari-roxo | Rasteira; folhas listradas de verde-prateado em cima e roxas embaixo; forma tapetes no chão da mata | Rebrota de qualquer pedaço; retirar inteira |

### 10.2 Outras exóticas citadas (fora do catálogo inicial)

| Espécie | Situação | Tratamento no app |
|---|---|---|
| Eucalipto (*Eucalyptus* sp.) | Talhões plantados (zona de manejo florestal) | **Não** é foco de invasão. Pode ser registrado só como "regeneração fora do talhão" via "Outra espécie" |
| Tilápia (*Oreochromis niloticus*) e bagre-africano (*Clarias gariepinus*) | No rio Itapemirim | Fora do MVP (fauna aquática) |
| Cão doméstico (*Canis familiaris*) | Ataca fauna dentro da Flona | Fora do MVP (futuro: tipo de ocorrência "fauna") |

---

## 11. Vocabulários controlados

> Equivale à planilha **"Vocabulário de referência"** do Guia do ICMBio. Todos os valores devem ser **editáveis** (tabela de listas), não fixos no código. Os códigos (em `snake_case`) são estáveis; os rótulos podem mudar.

### 11.1 Forma de vida
`arvore` Árvore · `arbusto` Arbusto · `palmeira` Palmeira · `graminea` Gramínea/capim · `trepadeira` Trepadeira · `herbacea` Herbácea · `outra` Outra

### 11.2 Estágio de desenvolvimento (`lifeStage`)
`plantula` Plântula · `jovem` Jovem · `adulto` Adulto · `reprodutivo` Adulto com flor/fruto · `misto` Vários estágios · `nao_informado` Não informado

### 11.3 Tipo de quantificação
`contagem` Número de indivíduos · `classe` Classe de abundância · `area` Área ocupada (m²) · `cobertura` Cobertura (%)

### 11.4 Classe de abundância
`c1` 1 indivíduo · `c2` 2–5 · `c3` 6–20 · `c4` 21–100 · `c5` Mais de 100 / mancha extensa

### 11.5 Ambiente do foco
`interior_mata` Interior da mata · `borda` Borda da mata · `clareira` Clareira · `beira_trilha` Beira de trilha · `beira_estrada` Beira de estrada · `area_aberta` Área aberta/pasto · `margem_rio` Margem de rio/córrego · `talhao` Talhão plantado · `outro` Outro

### 11.6 Status do foco
`detectado` Detectado (sem manejo) · `em_controle` Em controle · `controlado` Controlado (ausente na última revisita) · `rebrotou` Rebrotou · `erradicado` Erradicado · `descartado` Descartado (erro de identificação/duplicado)

### 11.7 Método de manejo
`arranquio` Arranquio manual · `rocada` Roçada/capina · `corte_raso` Corte rente à base · `anelamento` Anelamento · `corte_herbicida` Corte + herbicida no toco · `anelamento_herbicida` Anelamento + herbicida · `herbicida_foliar` Herbicida foliar · `remocao_frutos` Remoção de frutos/sementes · `outro` Outro

### 11.8 Destinação do material
`deixado_secar` Deixado no local para secar · `amontoado` Amontoado no local · `removido` Removido da área · `ensacado` Ensacado · `outro` Outro

### 11.9 Resultado da revisita
`ausente` Ausente · `presente_reduzido` Presente, reduzido · `presente_igual` Presente, sem mudança · `presente_aumentou` Presente, aumentou · `rebrota` Rebrota em indivíduos tratados

### 11.10 Origem da coordenada
`gps_auto` GPS automático · `gps_ajustado` Ajustado manualmente no mapa · `estimada` Estimada

---

## 12. Modelo de dados

### 12.1 Visão geral

```
usuario ─┐
         ├─< foco >─┬─< observacao >──< midia
especie ─┘          └─< acao_manejo >──< midia
                    
lista_valor  (vocabulários)
sessao_campo ─< observacao   (v2)
```

Correspondência com o Guia do ICMBio:

| Planilha do Guia | Entidade no app |
|---|---|
| Ocorrências | `foco` + `observacao` |
| Manejo | `acao_manejo` |
| Rede de colaboradores | `usuario` |
| Vocabulário de referência | `lista_valor` + `especie` |

### 12.2 Convenções

- **IDs:** UUID v4 gerado **no celular**, para que o registro exista offline sem conflito.
- **Datas:** ISO 8601 com fuso. Armazenar em UTC e exibir no fuso de Brasília.
- **Coordenadas:** WGS84 (EPSG:4326), graus decimais, 6 casas.
- **Campos de sincronização** (em todas as tabelas sincronizáveis):

| Campo | Tipo | Descrição |
|---|---|---|
| `created_at` | timestamp | Criação no aparelho |
| `updated_at` | timestamp | Última alteração no aparelho |
| `server_updated_at` | timestamp | Preenchido pelo servidor |
| `deleted` | bool | Exclusão lógica (nunca apagar fisicamente) |
| `sync_status` | enum | `pendente` · `enviado` · `erro` (só local) |
| `version` | int | Incrementa a cada alteração |

### 12.3 Entidades

#### `usuario`
| Campo | Tipo | Obrig. | Observação |
|---|---|---|---|
| id | uuid | ✓ | = id do Auth |
| nome | text | ✓ | Nome de exibição |
| email | text | ✓ | Login |
| perfil | enum | ✓ | `campo` · `gestor` · `admin` · (`colaborador` na v2) |
| funcao | text | | Ex.: analista, brigadista, voluntário |
| ativo | bool | ✓ | |

#### `especie`
| Campo | Tipo | Obrig. | Observação |
|---|---|---|---|
| id | text | ✓ | Código estável (ex.: `artocarpus_heterophyllus`) |
| nome_cientifico | text | ✓ | Com autor |
| nomes_populares | text[] | ✓ | O primeiro é o principal |
| familia | text | | |
| forma_vida | enum | ✓ | §11.1 |
| descricao_identificacao | text | | Guia |
| confusao_com | text | | Espécies parecidas (nativas) |
| metodos_sugeridos | text[] | | Códigos de §11.7 (informativo) |
| fotos_referencia | text[] | | Caminhos dos assets |
| prioridade | int | | 1 = alta **[A CONFIRMAR]** |
| na_lista_oficial_icmbio | bool | | Portaria 510/2025 **[A CONFIRMAR]** |
| ativa | bool | ✓ | |

> Registro especial `especie.id = "outra"` para "Outra espécie / não sei" (exige foto e texto).

#### `foco` — local persistente de uma população invasora
| Campo | Tipo | Obrig. | Observação |
|---|---|---|---|
| id | uuid | ✓ | |
| especie_id | text | ✓ | FK `especie` |
| especie_texto | text | | Quando `outra` |
| codigo | text | ✓ | Legível, ex.: `JAQ-0042` (prefixo da espécie + sequencial) |
| lat, lon | double | ✓ | Posição de referência (da primeira observação; pode ser ajustada) |
| precisao_m | double | ✓ | |
| origem_coordenada | enum | ✓ | §11.10 |
| zona | text | | Zona do zoneamento (v2, calculada) |
| ambiente | enum | | §11.5 |
| status | enum | ✓ | §11.6 (calculado; gestor pode sobrescrever) |
| deteccao_precoce | bool | ✓ | §13.4 |
| criado_por | uuid | ✓ | FK `usuario` |
| primeira_deteccao_em | timestamp | ✓ | |
| ultima_visita_em | timestamp | ✓ | |
| ultima_abundancia | text | | Resumo da última observação |
| + campos de sync | | | |

#### `observacao` — cada visita a um foco (inclui a detecção)
| Campo | Tipo | Obrig. | Observação |
|---|---|---|---|
| id | uuid | ✓ | |
| foco_id | uuid | ✓ | |
| tipo | enum | ✓ | `deteccao` · `revisita` |
| usuario_id | uuid | ✓ | |
| sessao_id | uuid | | v2 |
| data_hora | timestamp | ✓ | |
| lat, lon, precisao_m | double | ✓ | Posição desta visita |
| altitude_m | double | | Se disponível |
| presenca | enum | ✓ | `presente` · `ausente` |
| resultado | enum | | §11.9 (só revisita) |
| quantificacao_tipo | enum | | §11.3 |
| n_individuos | int | | |
| classe_abundancia | enum | | §11.4 |
| area_m2 | double | | |
| cobertura_pct | int | | 0–100 |
| estagio | enum | | §11.2 |
| ambiente | enum | | §11.5 |
| texto | text | | Observação livre ou ditada |
| ditado | bool | | Se veio de voz |
| dispositivo | text | | Modelo do aparelho |
| versao_app | text | | |
| + campos de sync | | | |

#### `acao_manejo`
| Campo | Tipo | Obrig. | Observação |
|---|---|---|---|
| id | uuid | ✓ | |
| foco_id | uuid | ✓ | |
| usuario_id | uuid | ✓ | Quem registrou |
| responsavel | text | ✓ | Responsável técnico/equipe (padrão: nome do usuário) |
| data_hora_inicio | timestamp | ✓ | |
| data_hora_fim | timestamp | | |
| metodo | enum | ✓ | §11.7 |
| metodo_texto | text | | Quando `outro` |
| herbicida_produto | text | | Obrigatório se método químico |
| herbicida_concentracao | text | | Ex.: "4% em óleo" |
| herbicida_volume_l | double | | |
| n_individuos_tratados | int | | |
| area_tratada_m2 | double | | |
| n_pessoas | int | ✓ | |
| horas | double | ✓ | Duração; esforço = n_pessoas × horas |
| destinacao | enum | | §11.8 |
| epi_utilizado | bool | | |
| condicao_tempo | enum | | `seco` · `nublado` · `chuva` (relevante para herbicida) |
| texto | text | | |
| + campos de sync | | | |

#### `midia`
| Campo | Tipo | Obrig. | Observação |
|---|---|---|---|
| id | uuid | ✓ | |
| dono_tipo | enum | ✓ | `observacao` · `acao_manejo` |
| dono_id | uuid | ✓ | |
| tipo | enum | ✓ | `foto` · `audio` (v2) |
| momento | enum | | `antes` · `depois` (manejo) |
| caminho_local | text | ✓ | Arquivo no aparelho |
| caminho_remoto | text | | Após upload |
| lat, lon | double | | |
| tirada_em | timestamp | ✓ | |
| tamanho_bytes | int | | |
| upload_status | enum | ✓ | `pendente` · `enviado` · `erro` |

#### `lista_valor`
| Campo | Tipo | Observação |
|---|---|---|
| lista | text | Ex.: `metodo_manejo` |
| codigo | text | Ex.: `anelamento` |
| rotulo | text | Ex.: "Anelamento" |
| ordem | int | |
| ativo | bool | |

#### `sessao_campo` (v2)
`id, usuario_id, inicio, fim, trilha (lista de pontos ou LineString), distancia_m, participantes, texto`

### 12.4 Correspondência com Darwin Core

| Darwin Core | Origem no app |
|---|---|
| `occurrenceID` | `observacao.id` |
| `basisOfRecord` | `HumanObservation` |
| `eventDate` | `observacao.data_hora` |
| `recordedBy` | `usuario.nome` (ou código anônimo em exportação pública) |
| `scientificName` | `especie.nome_cientifico` |
| `vernacularName` | `especie.nomes_populares[0]` |
| `family` | `especie.familia` |
| `decimalLatitude` / `decimalLongitude` | `observacao.lat` / `lon` |
| `geodeticDatum` | `WGS84` |
| `coordinateUncertaintyInMeters` | `observacao.precisao_m` |
| `occurrenceStatus` | `present` / `absent` (de `presenca`) |
| `individualCount` | `n_individuos` |
| `organismQuantity` / `organismQuantityType` | área, cobertura ou classe |
| `lifeStage` | `estagio` |
| `habitat` | `ambiente` |
| `establishmentMeans` | `introduced` |
| `degreeOfEstablishment` | `invasive` |
| `locationID` | `foco.codigo` |
| `locality` | "Floresta Nacional de Pacotuba" |
| `municipality` / `stateProvince` / `countryCode` | Cachoeiro de Itapemirim / Espírito Santo / BR |
| `occurrenceRemarks` | `texto` |
| `associatedMedia` | URLs das fotos |

---

## 13. Regras de negócio

### 13.1 Coleta de GPS
- **RN01:** ao abrir "Nova ocorrência", o app inicia o GPS em alta precisão e coleta leituras por até **30 s** ou até atingir **≤ 10 m**.
- **RN02:** a coordenada salva é a leitura de **melhor precisão**. A precisão é sempre gravada (`precisao_m`).
- **RN03:** se a precisão for **> 30 m**, mostrar aviso ("Precisão baixa: ±45 m") e permitir salvar mesmo assim ou ajustar o pino no mapa (`origem_coordenada = gps_ajustado`).
- **RN04:** nunca bloquear o salvamento por falta de GPS. Sem posição, registrar com `origem_coordenada = estimada` e pedir ajuste no mapa.
- **RN05:** avisar se o ponto estiver **fora do limite da Flona** (pode ser zona de amortecimento; permitir salvar).

### 13.2 Foco × observação
- **RN06:** toda detecção cria um `foco` e uma `observacao` do tipo `deteccao`.
- **RN07:** ao detectar, se houver foco **da mesma espécie** e não descartado a uma distância ≤ **20 m + precisão** do ponto, perguntar "É o mesmo foco?". Se sim, a observação vira `revisita` desse foco.
- **RN08:** o raio de 20 m é configurável **[A CONFIRMAR]** com a equipe (depende do tamanho típico das manchas).

### 13.3 Status do foco (cálculo automático)
- **RN09:** foco recém-detectado → `detectado`.
- **RN10:** registrou `acao_manejo` → `em_controle`.
- **RN11:** revisita com `presenca = ausente` → `controlado`.
- **RN12:** revisita com `resultado = rebrota` → `rebrotou`. Revisita presente após `controlado` → `rebrotou`.
- **RN13:** `erradicado` quando houver **N revisitas consecutivas ausentes** cobrindo **pelo menos X meses**. Valores iniciais: N = 3, X = 12 **[A CONFIRMAR]**; varia por espécie, por causa do banco de sementes.
- **RN14:** o gestor pode sobrescrever o status manualmente (registrar quem e quando) e marcar `descartado`.

### 13.4 Detecção precoce
- **RN15:** marcar `deteccao_precoce = true` quando ao menos uma condição for verdadeira:
  - espécie `outra` (possível espécie nova na Flona);
  - primeira ocorrência da espécie na Flona;
  - foco a mais de **200 m** de qualquer foco ativo da mesma espécie (nova frente de invasão);
  - abundância pequena (≤ 5 indivíduos ou ≤ 10 m²).
- **RN16:** focos de detecção precoce aparecem **em destaque** (cor, topo da lista), porque são os casos em que a IN 19/2025 dispensa autorização para resposta rápida.
- **RN17:** limites (200 m, 5 indivíduos, 10 m²) configuráveis **[A CONFIRMAR]**.

### 13.5 Validações de formulário
- **RN18:** obrigatórios na detecção: espécie, coordenada, data/hora, ao menos **1 foto** se espécie = `outra`.
- **RN19:** quantidade: ao menos um dos campos (contagem, classe, área ou cobertura).
- **RN20:** manejo químico (`corte_herbicida`, `anelamento_herbicida`, `herbicida_foliar`) exige `herbicida_produto`.
- **RN21:** o app **não sugere** produto nem dose, apenas registra.

### 13.6 Edição e exclusão
- **RN22:** o autor pode editar seu registro em até **24 h**. Depois disso, só o gestor.
- **RN23:** nunca apagar fisicamente; usar `deleted = true` (rastreabilidade).

---

## 14. Arquitetura offline-first e sincronização

### 14.1 Princípios
1. **O banco local é a fonte da verdade para a interface.** A tela lê do SQLite, nunca direto da rede.
2. **Toda escrita é local primeiro** e marcada como `pendente`.
3. **A sincronização é um processo separado** (fila de saída / *outbox*), que roda quando há conexão.
4. **Fotos sobem separadas dos dados**, depois, e podem ficar só no Wi-Fi.

### 14.2 Diagrama

```
┌────────────────────── Celular ──────────────────────┐
│  UI (Flutter) ──▶ Repositórios ──▶ SQLite (drift)    │
│                                      │  sync_status   │
│                       Serviço de Sync ◀┘               │
│                     (push pendentes / pull novidades)  │
│  Fotos: pasta do app ──▶ fila de upload                │
└───────────────────────────────┬──────────────────────┘
                                │ HTTPS (quando houver rede)
┌───────────────────────────────▼──────────────────────┐
│ Backend: PostgreSQL (+PostGIS) · Auth · Storage       │
│ Regras de acesso por perfil (RLS)                     │
└──────────────────────────────────────────────────────┘
```

### 14.3 Algoritmo de sincronização
1. **Gatilhos:** ao abrir o app, ao recuperar conexão, a cada 15 min em segundo plano (se permitido) e no botão "Sincronizar agora".
2. **Push:** enviar registros `pendente` na ordem `foco → observacao → acao_manejo → midia (metadados)`, em lotes, com *upsert* por `id`.
3. **Upload de arquivos:** depois do push, enviar as fotos `upload_status = pendente`. Comprimir antes (lado maior 1600 px, JPEG ~80%).
4. **Pull:** buscar no servidor tudo com `server_updated_at > último_pull` (inclui registros de outros usuários e catálogos) e aplicar localmente.
5. **Conflitos:**
   - `observacao`, `acao_manejo` e `midia` são praticamente **somente inserção** (conflito raro).
   - `foco` e `especie`: **última escrita vence** (`updated_at`), registrando o histórico de mudança de status.
6. **Erros:** registro com erro fica `erro`, com nova tentativa e espera crescente. Aparece em "Pendências" com o motivo.
7. **Idempotência:** como o ID nasce no celular, reenviar o mesmo registro não duplica.

### 14.4 Mapa offline
- **Área pequena** (~450 ha + entorno), então o pacote do mapa é leve.
- **Camadas:**
  1. mapa base;
  2. limite oficial da Flona (KML do ICMBio, convertido em GeoJSON e embutido no app);
  3. focos;
  4. (v2) zonas e trilhas.
- **Mapa base: decisão em aberto** (licenças):
  - **Não** baixar em massa tiles do servidor público `tile.openstreetmap.org`, porque a política de uso do OSM proíbe pré-download em massa.
  - **Opção A (recomendada):** gerar um arquivo **MBTiles** próprio da região a partir de dados abertos (OSM, licença ODbL, com atribuição) e/ou de **ortofoto do ES** (verificar disponibilidade e licença no GEOBASES/ES), e embutir no app.
  - **Opção B:** provedor de mapas com plano que permita uso offline (verificar termos).
- **Precisão do GPS sob a copa:** pode piorar para dezenas de metros. Daí as regras RN01 a RN04.

### 14.5 Navegação até o foco (MVP)
- Tela com **seta** apontando para o foco (rumo calculado entre a posição atual e o foco, compensado pela bússola do aparelho) e **distância** atualizada.
- Ao chegar a ≤ 20 m (considerando a precisão), sugerir "Registrar revisita".
- Rota pelas trilhas fica para o futuro (exige a geometria das trilhas).

---

## 15. Stack técnica (Flutter)

> Pacotes sugeridos. **Verificar versão, manutenção e licença no pub.dev antes de adotar.**

| Necessidade | Sugestão | Observação |
|---|---|---|
| Linguagem / framework | Flutter (Dart), Android primeiro | Mesmo stack do Agroecologia_5G (Flutter + SQLite) |
| Estado | `flutter_riverpod` | |
| Navegação | `go_router` | |
| Banco local | `drift` (SQLite) | Tipado, migrações, *streams* reativos |
| IDs | `uuid` | v4 no aparelho |
| GPS | `geolocator` | Precisão, *stream* de posição |
| Bússola | `flutter_compass` | Tela de navegação |
| Mapa | `flutter_map` | + leitor de MBTiles offline (avaliar pacote) |
| Geometria | `latlong2` | Distância, rumo, ponto no polígono (ou função própria) |
| Câmera / fotos | `image_picker` ou `camera` | |
| Compressão | `flutter_image_compress` | |
| Voz para texto | `speech_to_text` | Offline depende do aparelho e do pacote de idioma pt-BR |
| Conectividade | `connectivity_plus` | Gatilho de sync |
| Segundo plano | `workmanager` | Sync periódico |
| Permissões | `permission_handler` | Localização, câmera, microfone |
| Arquivos | `path_provider` | |
| PDF | `pdf` + `printing` | Relatório gerado no próprio app |
| CSV | `csv` | |
| Compartilhar | `share_plus` | Enviar exportações |
| Backend | **Supabase** (PostgreSQL + PostGIS, Auth, Storage, RLS) — `supabase_flutter` | Alternativa: Firebase |

### 15.1 Backend: Supabase × Firebase

| Critério | Supabase | Firebase (Firestore) |
|---|---|---|
| Modelo de dados | SQL relacional, igual ao modelo local | NoSQL (documentos) |
| Consultas geográficas | PostGIS (completo) | Limitadas |
| Offline | Sync próprio (drift + outbox) — mais código | Persistência offline nativa — menos código |
| Exportação / relatórios | SQL direto | Mais trabalho |
| Plano gratuito | Sim (verificar limites; projetos inativos podem pausar) | Sim (verificar limites) |
| **Recomendação** | ✅ Coerente com SQLite local e com os dados geográficos | Mais rápido de começar, pior para análise |

### 15.2 Estrutura de pastas sugerida

```
lib/
  main.dart
  app/            # rotas, tema, injeção (providers)
  core/           # utilidades: geo, datas, ids, erros
  data/
    local/        # drift: tabelas, DAOs, migrações
    remote/       # cliente Supabase
    sync/         # serviço de sync, outbox, upload de fotos
    repositories/
  domain/         # modelos, regras de negócio (status, detecção precoce)
  features/
    auth/
    home/
    ocorrencia/   # nova ocorrência, revisita
    manejo/
    foco/         # ficha + linha do tempo
    mapa/
    navegacao/
    especies/     # guia
    lista/
    exportacao/
    configuracoes/
assets/
  especies/       # fotos de referência
  geo/            # limite_flona.geojson, mapa.mbtiles
  seed/           # especies.json, listas.json
```

### 15.3 Dados iniciais (seed)
- `assets/seed/especies.json`: as 10 espécies (seção 10) + `outra`.
- `assets/seed/listas.json`: vocabulários da seção 11.
- `assets/geo/limite_flona.geojson`: convertido do KML oficial do ICMBio.
- O seed é carregado na primeira execução. Depois, atualizações vêm do servidor (pull).

---

## 16. Telas

> Interface em português, botões grandes (mínimo 48 dp), alto contraste para uso no sol, poucos campos digitados.

| # | Tela | Conteúdo principal | Versão |
|---|---|---|---|
| T01 | Login | E-mail, senha; mensagem de modo offline | v1 |
| T02 | Início | Botão grande **"Nova ocorrência"**; atalhos Mapa / Focos / Guia; status de sync ("3 pendentes"); focos de detecção precoce em destaque | v1 |
| T03 | Nova ocorrência | Passo a passo: **Espécie** (grade de fotos) → **Local** (precisão + mini-mapa) → **Quantidade** → **Estágio/ambiente** → **Fotos** → **Observação** (texto/ditado) → Salvar | v1 |
| T04 | "É o mesmo foco?" | Diálogo com foto e data do foco próximo | v1 |
| T05 | Ficha do foco | Código, espécie, status, mapa, fotos, **linha do tempo**; botões Registrar manejo / Revisita / Navegar | v1 |
| T06 | Registrar manejo | Método → (herbicida se químico) → quantidades → equipe e tempo → destinação → fotos antes/depois | v1 |
| T07 | Revisita | Presente/ausente → resultado → quantidade → foto | v1 |
| T08 | Mapa | Mapa offline, limite da Flona, focos coloridos por status ou espécie, filtro, minha posição | v1 |
| T09 | Navegar até o foco | Seta grande, distância, precisão do GPS | v1 |
| T10 | Lista de focos | Filtros (espécie, status, período, detecção precoce), busca por código | v1 |
| T11 | Guia de espécies | Lista → ficha com fotos, como reconhecer, confusões, métodos citados | v1 |
| T12 | Exportar / relatório | Período + filtros → CSV · GeoJSON · Darwin Core · PDF → compartilhar | v1 |
| T13 | Pendências / sincronização | O que falta enviar, erros, "Sincronizar agora", opção "só Wi-Fi" | v1 |
| T14 | Configurações | Usuário, raio de "mesmo foco", tema, sobre/licenças | v1 |
| T15 | Painel do gestor | Indicadores e gráficos (seção 17.3) | v2 |
| T16 | Sessão de campo | Iniciar/encerrar, trilha gravada | v2 |

### 16.1 Identidade visual (atualizada em 03/10/2026 — adota o `lume-logo-kit`)

> Substitui a direção anterior (anéis tracejados, `verdeMata #0B5D45`). Arquivos, regras de uso e ícones em `lume-logo-kit/LEIA-ME.md`.

- **Nome:** Lume. Remete a luz e vaga-lume, e ao tema BIOGLOW: cada registro "acende" um ponto no mapa.
- **Slogan:** "Ilumine o que ameaça a floresta."
- **Símbolo:** prancheta + marcador de mapa + folha. Em tamanhos pequenos e como pino usa-se só o marcador com a folha (`lume-marcador`).
- **Ícone do app:** símbolo sobre fundo creme (`#F7F4E5`); ícone adaptativo e monocromático do Android gerados do kit.
- **Logotipo:** "LUME" em Archivo larga (font-stretch 125%), peso 800, caixa alta, em verde-floresta.
- **Estilo:** instrumento de campo. Tema **claro** como padrão, mapa em primeiro plano, dados em fonte monoespaçada. O laranja fica reservado a focos detectados e à detecção precoce.

**Cores (tokens — `lib/app/theme.dart`, classe `LumeCores`)**

| Token | Hex | Uso |
|---|---|---|
| `verdeFloresta` | `#38613F` | **Cor principal** (logo): botões, links, aba ativa, logotipo |
| `verdeNoite` | `#1E3824` | Barra do registro (coordenadas/GPS), tela de navegação |
| `mentaClara` | `#ADD7B5` | Destaques sobre fundo escuro (seta da navegação, precisão boa) |
| `mentaEscura` | `#9CC599` | Detalhes, cor secundária |
| `creme` | `#F7F4E5` | Fundo do ícone, tela de login e de abertura |
| `fundo` | `#FBFAF5` | Fundo das telas |
| `nevoa` | `#EEF4EF` | Superfícies, chips, cabeçalhos de cartão |
| `selecao` | `#DCEEDF` | Item selecionado |
| `laranjaAlerta` | `#E35205` | **Só** focos detectados e detecção precoce |
| `laranjaTexto` | `#C2410C` | Texto de alerta laranja sobre branco |
| `grafite` | `#16201A` | Texto principal |
| `textoSecundario` | `#4A5650` | Legendas |
| `borda` | `#D5DBD7` | Divisórias |

**Tipografia** (embutida em `assets/fonts/`, funciona offline)

| Uso | Fonte |
|---|---|
| Títulos, códigos de foco (ex.: JAQ-0042), botões principais | Archivo larga (wdth 125), 700–800 |
| Texto e interface | IBM Plex Sans (400–600) |
| Coordenadas, precisão do GPS, dados | IBM Plex Mono (500) |

**Status do foco** (sempre forma + cor + rótulo, para daltônicos e sol forte):

| Status | Marcador | Cor |
|---|---|---|
| Detectado | Círculo cheio | `#E35205` |
| Em controle | Anel | `#2C6BAA` |
| Rebrotou | Triângulo | `#B42828` |
| Controlado | Quadrado | `#5E9B52` |
| Erradicado | Quadrado com ✓ | `#38613F` |
| Descartado | Círculo vazado cinza | `#8A958F` |

**Padrões de tela já definidos no protótipo:**
- Início com prévia do mapa, botão "Registrar ocorrência", indicadores e revisitas pendentes.
- Registro com barra escura no topo mostrando coordenadas e precisão.
- Escolha de espécie por **lista com busca** e opção "Outra espécie / não sei".

---

## 17. Relatórios e exportações

### 17.1 Formatos

| Formato | Conteúdo | Uso |
|---|---|---|
| **CSV** (3 arquivos) | `focos.csv`, `observacoes.csv`, `manejos.csv` (equivalem às planilhas do Guia) | Planilha, análise |
| **GeoJSON** e **KML** | Focos com atributos | QGIS, Google Earth |
| **Darwin Core (CSV)** | Ocorrências nos termos da seção 12.4 | Padrão de biodiversidade / ICMBio / SiBBr |
| **PDF** | Relatório do período | Anexo a relatórios e reuniões |

### 17.2 Relatório PDF do período (estrutura)

Inspirado no roteiro de relatório técnico do Guia do ICMBio.

1. **Identificação:** UC, período, responsável, data de geração.
2. **Resumo:** nº de focos (novos, ativos, controlados, erradicados), nº de observações e manejos, espécies registradas.
3. **Detecções precoces** no período.
4. **Por espécie:** focos, indivíduos e área registrados, área tratada.
5. **Ações de manejo:** métodos, indivíduos tratados, área tratada, **esforço (pessoas × horas)**, herbicidas usados.
6. **Monitoramento pós-controle:** revisitas, ausências, rebrotas.
7. **Mapa** dos focos.
8. **Tabela** detalhada (anexo).
9. **Observações e recomendações** (campo livre do gestor).

### 17.3 Indicadores (painel v2)
- Focos ativos ao longo do tempo (linha).
- Novos focos por mês e por espécie.
- Taxa de sucesso do controle: focos controlados ÷ focos manejados.
- Focos sem revisita há mais de X dias.
- Esforço total (pessoas × horas) por espécie.
- Prioridade por foco: impacto, dificuldade de manejo e área ocupada (critérios da Portaria 510/2025).

---

## 18. Perfis, segurança e LGPD

| Perfil | Pode |
|---|---|
| `campo` | Criar ocorrências, manejos e revisitas; ver todos os focos; editar os próprios registros por 24 h |
| `gestor` | Tudo de `campo` + editar qualquer registro, mudar status, descartar, exportar, gerenciar catálogo e listas |
| `admin` | Tudo + gerenciar usuários e configurações |
| `colaborador` (v2) | Enviar ocorrências que ficam "pendentes de validação" |

**Segurança:**
- Autenticação por e-mail e senha. A sessão persiste para uso offline.
- Regras de acesso no servidor (RLS do PostgreSQL) por perfil.
- HTTPS em toda comunicação.
- Banco local no armazenamento privado do app.

**LGPD:**
- Dados pessoais mínimos: nome, e-mail e função.
- A localização registrada é **do foco**, não rastreamento da pessoa. A trilha de sessão (v2) é opcional e avisada.
- Exportação pública/Darwin Core com opção de **anonimizar** `recordedBy`.
- Termo de uso simples no primeiro acesso.

**Dados sensíveis de biodiversidade:**
- Se algum registro envolver espécies ameaçadas (futuro), avaliar se a coordenada deve ser generalizada em exportações públicas.

---

## 19. Requisitos não funcionais

| Código | Requisito |
|---|---|
| RNF01 | Funcionar **100% offline** para registrar, consultar, mapear e navegar |
| RNF02 | Registrar uma ocorrência simples em **≤ 30 s** (meta, medida em teste de campo) |
| RNF03 | Uso com **uma mão**; botões ≥ 48 dp; legível sob sol (alto contraste; tema claro como padrão) |
| RNF04 | Nenhuma perda de dados em fechamento inesperado (gravação imediata no banco local) |
| RNF05 | Baixo consumo de bateria: GPS de alta precisão só durante o registro e a navegação |
| RNF06 | Fotos comprimidas (~300–600 KB cada) |
| RNF07 | Android 8.0+ **[A CONFIRMAR]** conforme os aparelhos da equipe |
| RNF08 | Interface em português (Brasil) |
| RNF09 | Acessibilidade básica: rótulos de leitor de tela, cor nunca como única informação |
| RNF10 | Atribuições de mapas e licenças visíveis em "Sobre" |

---

## 20. Validação com usuários e ligação com a FLL

### 20.1 Ciclo de validação
1. **Pesquisa:** questionário + entrevista com a Flona (em andamento).
2. **Lean Inception:** com as respostas, revisar personas, jornada e priorização (este documento é a base).
3. **Protótipo funcional (v1):** primeira versão com as informações atuais.
4. **Teste de campo** com a equipe da Flona numa trilha real:
   - tempo para registrar uma ocorrência (app × papel);
   - precisão do GPS sob a copa;
   - erros e dúvidas de uso (observar e anotar);
   - entrevista curta depois do teste.
5. **Iteração:** corrigir e ajustar. Registrar **o que mudou por causa do usuário** (antes/depois).
6. Repetir.

### 20.2 Métricas de sucesso do MVP
- Tempo médio de registro ≤ 30 s.
- 0 registros perdidos no teste.
- Precisão mediana do GPS registrada (linha de base).
- Satisfação da equipe (escala de 1 a 5) ≥ 4.
- Quantos registros de papel/WhatsApp o app substituiu no período de teste.

### 20.3 Ligação com a avaliação do Projeto de Inovação (FLL)

| Etapa da FLL | Evidência produzida neste projeto |
|---|---|
| **Identificar** | Pesquisa sobre a Flona, a legislação e as invasoras; questionário; entrevista |
| **Projetar** | Lean Inception, personas, jornada, este documento, protótipos de tela |
| **Criar** | App funcional em Flutter |
| **Iterar** | Testes de campo, métricas, mudanças feitas a partir do usuário |
| **Comunicar** | Apresentação com dados reais, mapa de focos, depoimento da equipe da Flona |

---

## 21. Plano de desenvolvimento

> Sprints de 1 semana. Datas a alinhar com o calendário do torneio da FLL **[A CONFIRMAR]**.

| Sprint | Entregas |
|---|---|
| **0 — Fundação** | Projeto Flutter, estrutura de pastas, tema, rotas; drift com tabelas da seção 12; seed de espécies e listas; limite da Flona em GeoJSON; projeto Supabase (tabelas, RLS, bucket de fotos) |
| **1 — Registro** | T02 Início, T03 Nova ocorrência (GPS com precisão, fotos, quantidade), T11 Guia de espécies; gravação local |
| **2 — Foco e mapa** | T05 Ficha do foco, T06 Manejo, T07 Revisita, regras de status (RN09–RN14), T08 Mapa offline, T04 "mesmo foco?" |
| **3 — Sync** | Login (T01), serviço de sincronização (push/pull, outbox), upload de fotos, T13 Pendências |
| **4 — Saídas** | T10 Lista com filtros, T12 Exportações (CSV, GeoJSON, Darwin Core, PDF), T09 Navegação (bússola), detecção precoce |
| **5 — Teste de campo** | Teste com a Flona, correções, métricas, versão para apresentação |

**Definição de pronto (por funcionalidade):**
- funciona offline;
- dados persistem após fechar o app;
- sincroniza sem duplicar;
- testado em aparelho Android real;
- textos revisados.

---

## 22. Riscos e decisões em aberto

| # | Risco / decisão | Impacto | Mitigação / próximo passo |
|---|---|---|---|
| R1 | Lista de espécies desatualizada | Catálogo errado | Validar com a Flona; catálogo editável pelo servidor |
| R2 | GPS impreciso sob a copa | Focos mal localizados | RN01–RN04; medir no teste de campo |
| R3 | Licença do mapa base offline | Uso indevido de tiles | Gerar MBTiles próprio (seção 14.4) |
| R4 | Ditado offline indisponível em alguns aparelhos | Observação só por texto | Ditado como opcional; áudio anexo na v2 |
| R5 | Aparelhos da equipe (Android/iOS, versão, armazenamento) | Compatibilidade | Pergunta do questionário; Android primeiro |
| R6 | Plano gratuito do backend (limites, pausa por inatividade) | Indisponibilidade | Verificar limites; rotina de uso; backup/exportação |
| R7 | Continuidade após a competição (quem mantém?) | App abandonado | Documentação; conversar com a Flona/ICMBio sobre uso contínuo |
| R8 | App não oficial do ICMBio | Dados não aceitos oficialmente | Exportações em formatos padrão (CSV, Darwin Core) para o fluxo oficial |
| D1 | Supabase ou Firebase | Arquitetura | Recomendado: Supabase (seção 15.1) |
| D2 | Raio "mesmo foco" e limites de detecção precoce | Regras | Valores iniciais configuráveis; validar com a Flona |
| D3 | Critério de "erradicado" | Status | N = 3 revisitas / 12 meses inicial; validar |
| D4 | Nome do app | Comunicação | **Decidido:** Lume, com a identidade do `lume-logo-kit` (seção 16.1) |

---

## 23. Perguntas pendentes para a Flona

1. As **10 espécies** da seção 10 ainda são as manejadas hoje? Alguma nova? Quais são **prioridade**?
2. Quais **nomes populares** a equipe usa para cada uma?
3. Existe **projeto de manejo autorizado** pela IN ICMBio 19/2025? Qual o prazo do **relatório anual**?
4. Quem executa o **controle** (equipe ICMBio, brigada, terceirizados, voluntários, comunidade)?
5. Quais **campos** têm hoje o formulário de papel? (Pedir cópia em branco e preenchida.)
6. A Flona tem em formato digital (KML, shapefile) as **zonas, trilhas e talhões**?
7. Qual o **tamanho típico** de um foco? Que distância considerar "o mesmo foco"?
8. Depois do controle, com que **frequência** revisitam? Quando consideram um foco **erradicado**?
9. Quais **herbicidas e métodos** usam de fato? Registram dose e esforço hoje?
10. Que **aparelhos** usam (sistema, celular pessoal ou institucional)?
11. Como é o **sinal** na sede e em pontos da floresta?
12. Quem seria a **pessoa de referência** para testar as versões?
13. Podem enviar **fotos próprias** das espécies na Flona para o guia?
14. Há interesse em usar o app para **outras ocorrências** (fauna atropelada, caça, fogo) no futuro?

---

## 24. Glossário

| Termo | Significado |
|---|---|
| **EEI** | Espécie exótica invasora: espécie fora da sua área natural cuja introdução ou dispersão ameaça a biodiversidade |
| **Flona** | Floresta Nacional, categoria de unidade de conservação de uso sustentável (SNUC, art. 17) |
| **UC** | Unidade de conservação |
| **ICMBio** | Instituto Chico Mendes de Conservação da Biodiversidade, gestor das UCs federais |
| **Foco** | Local onde uma população de EEI foi encontrada (ponto ou mancha); unidade de acompanhamento no app |
| **Observação** | Cada visita a um foco: a detecção ou uma revisita |
| **Manejo / controle** | Ação para reduzir ou eliminar a EEI (arranquio, corte, anelamento, herbicida) |
| **Anelamento** | Retirada de um anel de casca ao redor do tronco, que mata a árvore em pé aos poucos |
| **Detecção precoce e resposta rápida (DPRR)** | Agir logo que uma invasão nova e pequena é encontrada, quando ainda é possível erradicar |
| **Erradicação** | Eliminação completa da população no local |
| **Zona de amortecimento** | Entorno da UC com regras de uso para reduzir impactos |
| **Darwin Core** | Padrão internacional para dados de biodiversidade |
| **Offline-first** | App que funciona sem internet e sincroniza quando há conexão |
| **Outbox** | Fila local de registros a enviar ao servidor |
| **RLS** | *Row Level Security*: regras de acesso por linha no PostgreSQL |
| **MBTiles** | Arquivo único com o mapa em blocos (tiles), para uso offline |
| **Precisão do GPS** | Raio estimado de erro da posição, em metros |

---

## 25. Fontes

Pesquisa feita em 02/10/2026.

**Flona de Pacotuba**
- ICMBio — Flona de Pacotuba (ficha, contato, documentos, limite em KML): https://www.gov.br/icmbio/pt-br/assuntos/biodiversidade/unidade-de-conservacao/unidades-de-biomas/mata-atlantica/lista-de-ucs/flona-de-pacotuba
- Plano de Manejo — Volume I (Diagnóstico, 2011): https://www.gov.br/icmbio/pt-br/assuntos/biodiversidade/unidade-de-conservacao/unidades-de-biomas/mata-atlantica/lista-de-ucs/flona-de-pacotuba/arquivos/volume_i_pacotuba_junho_2011.pdf
- Plano de Manejo — Volume II (Planejamento, 2011): https://www.gov.br/icmbio/pt-br/assuntos/biodiversidade/unidade-de-conservacao/unidades-de-biomas/mata-atlantica/lista-de-ucs/flona-de-pacotuba/arquivos/volume_ii_pacotuba_junho_2011.pdf
- Costa, W. M. et al. (2024). *Floresta Nacional de Pacotuba: promoção da conservação…* (cap. 3): https://meridapublishers.com/tga3/cap03.pdf
- Wikipédia — Floresta Nacional de Pacotuba: https://pt.wikipedia.org/wiki/Floresta_Nacional_de_Pacotuba
- Revista Conexão (24/08/2026) — mortes de primatas na Flona: https://www.conexaoes.com.br/noticia/icmbio-esclarece-mortes-de-primatas-na-floresta-nacional-de-pacotuba-e-descarta-suspeita-de-febre-amarela
- Concurso News (03/2026) — seleção de voluntários: https://concursonews.com/2026/03/icmbio-abre-selecao-de-voluntarios-para-atuacao-na-floresta-nacional-de-pacotuba/
- ES Hoje (07/2026) — trilha sensorial: https://eshoje.com.br/geral/meio-ambiente/2026/07/flona-de-pacotuba-abre-agendamento-para-nova-trilha-sensorial-em-cachoeiro-de-itapemirim/

**Normas e orientações**
- Lei 9.985/2000 (SNUC): https://www.planalto.gov.br/ccivil_03/leis/l9985.htm
- Lei 9.605/1998 (Crimes Ambientais): https://www.planalto.gov.br/ccivil_03/leis/l9605.htm
- IN ICMBio nº 19, de 14/04/2025: https://www.gov.br/icmbio/pt-br/assuntos/biodiversidade/manejo-de-especies-exoticas-invasoras/manejodeeei/INSTRUONORMATIVAICMBION19DE14DEABRILDE2025INSTRUONORMATIVAICMBION19DE14DEABRILDE2025DOUImprensaNacional.pdf
- Comentário sobre a IN 19/2025 (Milaré Advogados): https://milare.adv.br/newsletters/icmbio-publica-instrucao-normativa-sobre-prevencao-controle-e-erradicacao-de-especies-exoticas-invasoras-em-unidades-de-conservacao-federais/
- Portaria ICMBio nº 510, de 11/02/2025: https://www.lex.com.br/portaria-icmbio-no-510-de-11-de-fevereiro-de-2025/
- ICMBio — Manejo de Espécies Exóticas Invasoras: https://www.gov.br/icmbio/pt-br/assuntos/biodiversidade/manejo-de-especies-exoticas-invasoras
- Guia de Orientação para o Manejo de EEI em UCs Federais (ICMBio): https://www.gov.br/icmbio/pt-br/centrais-de-conteudo/publicacoes/publicacoes-diversas/Guia_de_orientacao_para_o_manejo_de_especies_exoticas_invasoras_em_unidades_de_conservacao_federais_v4_outubro.pdf
- Lista de EEI em UCs Federais — Darwin Core (IPT ICMBio): https://ipt.icmbio.gov.br/resource?r=icmbio_eei_em_uc_federal_2024&v=1.0
- Sampaio, A. B.; Schmidt, I. B. (2013). *Espécies Exóticas Invasoras em UCs Federais do Brasil*: https://revistaeletronica.icmbio.gov.br/index.php/BioBR/article/download/351/362

**Padrões técnicos**
- Darwin Core (TDWG): https://dwc.tdwg.org/terms/
- Política de uso de tiles do OpenStreetMap: https://operations.osmfoundation.org/policies/tiles/

---

### Histórico
- **v0.3 (03/10/2026):** identidade visual trocada pela do `lume-logo-kit` (§16.1). Primeira versão funcional do app (MVP F01–F18) implementada; ver `README.md`.
- **v0.2 (02/10/2026):** nome Lume e identidade inicial.

*Documento vivo. Atualize a versão e a data no topo a cada revisão (ex.: v0.2 após as respostas do questionário).*
