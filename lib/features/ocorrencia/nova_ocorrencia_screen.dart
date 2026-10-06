import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/providers.dart';
import '../../app/router.dart';
import '../../app/theme.dart';
import '../../core/fotos.dart';
import '../../core/formato.dart' as fmt;
import '../../core/geo.dart';
import '../../core/gps.dart';
import '../../data/local/database.dart';
import '../../data/remote/supabase_config.dart';
import '../../data/repositories/foco_repository.dart';
import '../../domain/codigos.dart';
import '../../widgets/comuns.dart';
import '../../widgets/formulario.dart';
import '../../widgets/mapa_lume.dart';
import '../mapa/ajuste_posicao_screen.dart';
import 'mesmo_foco_dialog.dart';
import 'seletor_especie.dart';

/// T03 — Nova ocorrência. Passo 1: espécie. Passo 2: local, quantidade,
/// estágio/ambiente, fotos e observação. O GPS começa ao abrir a tela (RN01).
class NovaOcorrenciaScreen extends ConsumerStatefulWidget {
  const NovaOcorrenciaScreen({super.key, this.especieInicial});

  final String? especieInicial;

  @override
  ConsumerState<NovaOcorrenciaScreen> createState() => _NovaOcorrenciaScreenState();
}

class _NovaOcorrenciaScreenState extends ConsumerState<NovaOcorrenciaScreen> {
  late final ColetorGps _gps;
  Especie? _especie;
  Posicao? _ajustada;
  final _qtd = QuantidadeValor();
  String? _estagio;
  String? _ambiente;
  List<FotoCapturada> _fotos = [];
  final _obs = TextEditingController();
  final _descricaoOutra = TextEditingController();
  bool _ditado = false;
  bool _salvando = false;
  bool _tentouSalvar = false;

  @override
  void initState() {
    super.initState();
    final r = ref.read(regrasAtuaisProvider);
    _gps = ColetorGps(
      tempoMax: Duration(seconds: r.gpsTempoMaxS),
      precisaoAlvoM: r.gpsPrecisaoAlvoM,
    )..iniciar();
    if (widget.especieInicial != null) {
      ref.read(catalogoRepoProvider).especie(widget.especieInicial!).then((e) {
        if (mounted && e != null) setState(() => _especie = e);
      });
    }
  }

  @override
  void dispose() {
    _gps.dispose();
    _obs.dispose();
    _descricaoOutra.dispose();
    super.dispose();
  }

  Posicao? get _posicao {
    if (_ajustada != null) return _ajustada;
    final m = _gps.melhor;
    if (m == null) return null;
    return Posicao(lat: m.lat, lon: m.lon, precisaoM: m.precisaoM, altitudeM: m.altitudeM);
  }

  bool get _temDados => _fotos.isNotEmpty || _obs.text.isNotEmpty || _qtd.preenchida;

  Future<void> _ajustarNoMapa() async {
    final atual = _posicao;
    final p = await AjustePosicaoScreen.abrir(
      context,
      inicial: atual == null ? null : latLng(atual.lat, atual.lon),
      titulo: 'Posição do foco',
    );
    if (p == null) return;
    await _gps.parar();
    setState(() => _ajustada = Posicao(
          lat: p.latitude,
          lon: p.longitude,
          precisaoM: atual?.precisaoM,
          origem: _gps.melhor == null ? OrigemCoordenada.estimada : OrigemCoordenada.gpsAjustado,
        ));
  }

  String? _validar() {
    if (_especie == null) return 'Escolha a espécie.';
    if (_especie!.id == especieOutra) {
      if (_fotos.isEmpty) return '"Outra espécie" precisa de ao menos 1 foto.';
      if (_descricaoOutra.text.trim().isEmpty) return 'Descreva a planta ("Outra espécie").';
    }
    if (!_qtd.preenchida) return 'Informe a quantidade (contagem, classe, área ou cobertura).';
    return null;
  }

  Future<void> _salvar() async {
    setState(() => _tentouSalvar = true);
    final erro = _validar();
    if (erro != null) {
      mostrarMensagem(context, erro);
      return;
    }
    // RN04: sem GPS, pede o ponto no mapa (origem "estimada").
    if (_posicao == null) {
      await _ajustarNoMapa();
      if (_posicao == null) return;
    }
    final usuario = ref.read(usuarioAtualProvider).value;
    if (usuario == null) return;
    setState(() => _salvando = true);
    await _gps.parar();

    final repo = ref.read(focoRepoProvider);
    final regras = ref.read(regrasAtuaisProvider);
    final pos = _posicao!;
    final dados = DadosObservacao(
      posicao: pos,
      quantificacaoTipo: _qtd.tipo,
      nIndividuos: _qtd.tipo == 'contagem' ? _qtd.n : null,
      classeAbundancia: _qtd.tipo == 'classe' ? _qtd.classe : null,
      areaM2: _qtd.tipo == 'area' ? _qtd.area : null,
      coberturaPct: _qtd.tipo == 'cobertura' ? _qtd.cobertura : null,
      estagio: _estagio,
      ambiente: _ambiente,
      texto: _obs.text.trim().isEmpty ? null : _obs.text.trim(),
      ditado: _ditado,
      fotos: _fotos,
    );

    try {
      // RN07: foco da mesma espécie por perto? Pergunta se é o mesmo.
      final proximos = await repo.focosProximos(especieId: _especie!.id, posicao: pos, cfg: regras);
      FocoComEspecie? mesmo;
      if (proximos.isNotEmpty && mounted) {
        final escolha = await mostrarDialogoMesmoFoco(context, ref, proximos);
        if (escolha == null) {
          setState(() => _salvando = false);
          return; // cancelou
        }
        mesmo = escolha.foco;
      }

      final String focoId;
      final String mensagem;
      List<String> motivos = const [];
      if (mesmo != null) {
        await repo.registrarRevisita(focoId: mesmo.foco.id, usuarioId: usuario.id, dados: dados, cfg: regras);
        focoId = mesmo.foco.id;
        mensagem = 'Registrado como revisita de ${mesmo.foco.codigo}.';
      } else {
        final r = await repo.registrarDeteccao(
          especieId: _especie!.id,
          especieTexto: _especie!.id == especieOutra ? _descricaoOutra.text.trim() : null,
          usuarioId: usuario.id,
          dados: dados,
          cfg: regras,
        );
        focoId = r.focoId;
        motivos = r.motivosPrecoce;
        mensagem = 'Foco ${r.codigo} salvo.';
      }
      _fotos = []; // já pertencem ao registro
      if (!mounted) return;
      final sync = ref.read(syncServiceProvider);
      mostrarMensagem(
        context,
        SupabaseConfig.configurado
            ? '$mensagem Salvo no celular. Será enviado quando houver internet.'
            : '$mensagem Salvo no celular.',
      );
      sync.sincronizar();
      if (motivos.isNotEmpty) await _avisarPrecoce(motivos);
      if (mounted) context.pushReplacement(Rotas.foco(focoId));
    } catch (e) {
      if (mounted) {
        setState(() => _salvando = false);
        mostrarMensagem(context, 'Não foi possível salvar: $e');
      }
    }
  }

  Future<void> _avisarPrecoce(List<String> motivos) => showDialog<void>(
        context: context,
        builder: (c) => AlertDialog(
          icon: const Icon(Icons.bolt, color: LumeCores.laranjaAlerta, size: 36),
          title: const Text('Detecção precoce'),
          content: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
            for (final m in motivos) Padding(padding: const EdgeInsets.only(bottom: 4), child: Text('• $m')),
            const SizedBox(height: 8),
            Text(
              'Casos de detecção precoce e resposta rápida podem ser manejados sem projeto autorizado '
              '(IN ICMBio 19/2025, art. 12).',
              style: Theme.of(c).textTheme.bodySmall,
            ),
          ]),
          actions: [FilledButton(onPressed: () => Navigator.pop(c), child: const Text('Entendi'))],
        ),
      );

  Future<bool> _confirmarSaida() async {
    if (!_temDados) return true;
    return confirmar(context,
        titulo: 'Descartar registro?',
        mensagem: 'As informações e fotos deste registro serão perdidas.',
        confirmar: 'Descartar',
        perigo: true);
  }

  @override
  Widget build(BuildContext context) {
    final especies = ref.watch(especiesProvider).value ?? const <Especie>[];
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) return;
        if (_especie != null && widget.especieInicial == null && !_temDados) {
          setState(() => _especie = null);
          return;
        }
        if (await _confirmarSaida()) {
          await ServicoFotos.descartar(_fotos);
          if (context.mounted) context.pop();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(_especie == null ? 'Qual espécie?' : 'Nova ocorrência'),
        ),
        body: Column(children: [
          BarraGps(
            coletor: _gps,
            avisoM: ref.watch(regrasAtuaisProvider).gpsPrecisaoAvisoM,
            ajustada: _ajustada,
            aoMedirDeNovo: () {
              setState(() => _ajustada = null);
              _gps.iniciar();
            },
            aoAjustarNoMapa: _ajustarNoMapa,
          ),
          Expanded(
            child: _especie == null
                ? SeletorEspecie(especies: especies, aoEscolher: (e) => setState(() => _especie = e))
                : _formulario(context),
          ),
        ]),
        bottomNavigationBar: _especie == null
            ? null
            : SafeArea(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                  child: SizedBox(
                    height: 60,
                    child: FilledButton.icon(
                      onPressed: _salvando ? null : _salvar,
                      icon: _salvando
                          ? const SizedBox.square(
                              dimension: 22, child: CircularProgressIndicator(strokeWidth: 2.5, color: Colors.white))
                          : const Icon(Icons.check, size: 26),
                      label: Text('Salvar', style: estiloCodigo(tamanho: 17, cor: Colors.white)),
                    ),
                  ),
                ),
              ),
      ),
    );
  }

  Widget _formulario(BuildContext context) {
    final vocab = ref.watch(vocabProvider);
    final regras = ref.watch(regrasAtuaisProvider);
    final limite = ref.watch(limiteFlonaProvider);
    final t = Theme.of(context).textTheme;
    final e = _especie!;
    final outra = e.id == especieOutra;

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
      children: [
        // Espécie escolhida
        Card(
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: outra ? const Color(0xFFFFF0E6) : LumeCores.nevoa,
              foregroundColor: outra ? LumeCores.laranjaTexto : LumeCores.verdeFloresta,
              child: Icon(iconeFormaVida(e.formaVida)),
            ),
            title: Text(capitalizar(e.nomesPopulares.first)),
            subtitle: outra ? null : Text(e.nomeCientifico, style: const TextStyle(fontStyle: FontStyle.italic)),
            trailing: TextButton(onPressed: () => setState(() => _especie = null), child: const Text('Trocar')),
          ),
        ),
        if (outra) ...[
          const TituloSecao('Descreva a planta', obrigatorio: true),
          TextField(
            controller: _descricaoOutra,
            textCapitalization: TextCapitalization.sentences,
            decoration: InputDecoration(
              hintText: 'Nome, se souber, ou como ela é (folha, flor, porte)',
              errorText: _tentouSalvar && _descricaoOutra.text.trim().isEmpty ? 'Obrigatório' : null,
            ),
            onChanged: (_) => setState(() {}),
          ),
        ],

        // Local
        const TituloSecao('Local'),
        ListenableBuilder(
          listenable: _gps,
          builder: (context, _) {
            final p = _posicao;
            final avisos = <Widget>[];
            if (p != null && p.precisaoM != null && p.precisaoM! > regras.gpsPrecisaoAvisoM && _ajustada == null) {
              avisos.add(Aviso(
                'Precisão baixa: ${fmt.precisao(p.precisaoM)}. Você pode salvar assim, esperar ou ajustar no mapa.',
                tipo: TipoAviso.alerta,
              ));
            }
            if (p != null && !limite.contem(GeoPonto(p.lat, p.lon))) {
              avisos.add(const Aviso(
                'Este ponto fica fora do limite da Flona (pode ser zona de amortecimento). Dá para salvar mesmo assim.',
                tipo: TipoAviso.alerta,
              ));
            }
            if (p == null && _gps.problema != null) {
              avisos.add(Aviso(
                '${mensagemProblemaGps(_gps.problema!)} Ao salvar, você vai marcar o ponto no mapa.',
                tipo: TipoAviso.alerta,
              ));
            }
            return Column(children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: SizedBox(
                  height: 150,
                  child: Stack(children: [
                    MapaLume(
                      key: ValueKey(p == null ? 'sem' : '${p.lat.toStringAsFixed(5)}${p.lon.toStringAsFixed(5)}'),
                      interativo: false,
                      focos: ref.watch(focosProvider).value?.where((f) => f.foco.especieId == e.id).toList() ?? const [],
                      tamanhoMarcador: 16,
                      centro: p == null ? null : latLng(p.lat, p.lon),
                      zoom: 17,
                      pino: p == null ? null : latLng(p.lat, p.lon),
                    ),
                    Positioned(
                      right: 8,
                      bottom: 8,
                      child: FilledButton.tonalIcon(
                        // Cor do texto explícita: o tema deixa o texto dos FilledButton branco.
                        style: FilledButton.styleFrom(
                          minimumSize: const Size(48, 48),
                          backgroundColor: Colors.white,
                          foregroundColor: LumeCores.verdeFloresta,
                          side: const BorderSide(color: LumeCores.verdeFloresta),
                          elevation: 2,
                        ),
                        onPressed: _ajustarNoMapa,
                        icon: const Icon(Icons.edit_location_alt_outlined),
                        label: const Text('Ajustar no mapa'),
                      ),
                    ),
                  ]),
                ),
              ),
              for (final a in avisos) Padding(padding: const EdgeInsets.only(top: 8), child: a),
            ]);
          },
        ),

        // Quantidade
        TituloSecao('Quantidade', obrigatorio: _tentouSalvar && !_qtd.preenchida),
        CampoQuantidade(valor: _qtd, vocab: vocab, aoMudar: () => setState(() {})),

        // Estágio e ambiente
        const TituloSecao('Estágio'),
        OpcoesVocabulario(
          vocab: vocab,
          lista: Listas.estagio,
          valor: _estagio,
          aoMudar: (v) => setState(() => _estagio = v),
        ),
        const TituloSecao('Ambiente'),
        OpcoesVocabulario(
          vocab: vocab,
          lista: Listas.ambiente,
          valor: _ambiente,
          aoMudar: (v) => setState(() => _ambiente = v),
        ),

        // Fotos
        TituloSecao('Fotos', obrigatorio: outra),
        FotosFormulario(
          fotos: _fotos,
          aoMudar: (f) => setState(() => _fotos = f),
          posicao: () => _posicao,
        ),

        // Observação
        const TituloSecao('Observação'),
        CampoObservacao(controller: _obs, aoDitar: () => _ditado = true),
        const SizedBox(height: 8),
        Text(
          'O registro é salvo no celular na hora, mesmo sem internet.',
          style: t.bodySmall,
        ),
      ],
    );
  }
}
