import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/providers.dart';
import '../../app/theme.dart';
import '../../core/fotos.dart';
import '../../core/gps.dart';
import '../../data/repositories/foco_repository.dart';
import '../../domain/codigos.dart';
import '../../widgets/comuns.dart';
import '../../widgets/formulario.dart';
import '../../widgets/marcador_status.dart';

/// T07 — Revisita: presente/ausente → resultado → quantidade → foto.
class RevisitaScreen extends ConsumerStatefulWidget {
  const RevisitaScreen({super.key, required this.focoId});

  final String focoId;

  @override
  ConsumerState<RevisitaScreen> createState() => _RevisitaScreenState();
}

class _RevisitaScreenState extends ConsumerState<RevisitaScreen> {
  late final ColetorGps _gps;
  String? _presenca;
  String? _resultado;
  final _qtd = QuantidadeValor();
  List<FotoCapturada> _fotos = [];
  final _obs = TextEditingController();
  bool _ditado = false;
  bool _salvando = false;

  @override
  void initState() {
    super.initState();
    final r = ref.read(regrasAtuaisProvider);
    _gps = ColetorGps(tempoMax: Duration(seconds: r.gpsTempoMaxS), precisaoAlvoM: r.gpsPrecisaoAlvoM)..iniciar();
  }

  @override
  void dispose() {
    _gps.dispose();
    _obs.dispose();
    super.dispose();
  }

  Posicao? _posicao(FocoComEspecie f) {
    final m = _gps.melhor;
    if (m != null) return Posicao(lat: m.lat, lon: m.lon, precisaoM: m.precisaoM, altitudeM: m.altitudeM);
    // Sem GPS: usa a posição do foco como estimada (a revisita é do mesmo lugar).
    return Posicao(lat: f.foco.lat, lon: f.foco.lon, origem: OrigemCoordenada.estimada);
  }

  Future<void> _salvar(FocoComEspecie f) async {
    if (_presenca == null) {
      mostrarMensagem(context, 'Informe se a espécie está presente ou ausente.');
      return;
    }
    final usuario = ref.read(usuarioAtualProvider).value;
    if (usuario == null) return;
    setState(() => _salvando = true);
    await _gps.parar();
    final presente = _presenca == Presenca.presente;
    try {
      await ref.read(focoRepoProvider).registrarRevisita(
            focoId: f.foco.id,
            usuarioId: usuario.id,
            cfg: ref.read(regrasAtuaisProvider),
            dados: DadosObservacao(
              posicao: _posicao(f)!,
              presenca: _presenca!,
              resultado: presente ? _resultado : ResultadoRevisita.ausente,
              quantificacaoTipo: presente && _qtd.preenchida ? _qtd.tipo : null,
              nIndividuos: presente && _qtd.tipo == 'contagem' ? _qtd.n : null,
              classeAbundancia: presente && _qtd.tipo == 'classe' ? _qtd.classe : null,
              areaM2: presente && _qtd.tipo == 'area' ? _qtd.area : null,
              coberturaPct: presente && _qtd.tipo == 'cobertura' ? _qtd.cobertura : null,
              texto: _obs.text.trim().isEmpty ? null : _obs.text.trim(),
              ditado: _ditado,
              fotos: _fotos,
            ),
          );
      _fotos = [];
      ref.read(syncServiceProvider).sincronizar();
      if (!mounted) return;
      mostrarMensagem(context, 'Revisita de ${f.foco.codigo} salva.');
      context.pop();
    } catch (e) {
      if (mounted) {
        setState(() => _salvando = false);
        mostrarMensagem(context, 'Não foi possível salvar: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final foco = ref.watch(focoProvider(widget.focoId)).value;
    final vocab = ref.watch(vocabProvider);
    if (foco == null) return const Scaffold(body: Center(child: CircularProgressIndicator()));
    final presente = _presenca == Presenca.presente;
    final resultadosPresente =
        vocab.itens(Listas.resultadoRevisita).where((v) => v.codigo != ResultadoRevisita.ausente).toList();

    return PopScope(
      canPop: _fotos.isEmpty,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) return;
        if (await confirmar(context,
            titulo: 'Descartar revisita?', mensagem: 'As fotos tiradas serão apagadas.', confirmar: 'Descartar', perigo: true)) {
          await ServicoFotos.descartar(_fotos);
          _fotos = [];
          if (context.mounted) context.pop();
        }
      },
      child: Scaffold(
        appBar: AppBar(title: Text('Revisita · ${foco.foco.codigo}')),
        body: Column(children: [
          BarraGps(
            coletor: _gps,
            avisoM: ref.watch(regrasAtuaisProvider).gpsPrecisaoAvisoM,
            aoMedirDeNovo: _gps.iniciar,
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
              children: [
                Card(
                  child: ListTile(
                    leading: MarcadorStatus(status: foco.foco.status, tamanho: 28, precoce: foco.foco.deteccaoPrecoce),
                    title: Text(foco.nomeExibicao),
                    subtitle: Text('Status atual: ${vocab.rotulo(Listas.statusFoco, foco.foco.status)}'),
                  ),
                ),
                const TituloSecao('A espécie está no local?', obrigatorio: true),
                Row(children: [
                  Expanded(
                    child: _BotaoGrande(
                      rotulo: 'Presente',
                      icone: Icons.visibility_outlined,
                      selecionado: _presenca == Presenca.presente,
                      cor: LumeCores.laranjaAlerta,
                      aoTocar: () => setState(() => _presenca = Presenca.presente),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _BotaoGrande(
                      rotulo: 'Ausente',
                      icone: Icons.visibility_off_outlined,
                      selecionado: _presenca == Presenca.ausente,
                      cor: const Color(0xFF5E9B52),
                      aoTocar: () => setState(() {
                        _presenca = Presenca.ausente;
                        _resultado = ResultadoRevisita.ausente;
                      }),
                    ),
                  ),
                ]),
                if (presente) ...[
                  const TituloSecao('Resultado'),
                  OpcoesChips(
                    opcoes: [for (final v in resultadosPresente) (v.codigo, v.rotulo)],
                    valor: _resultado,
                    aoMudar: (v) => setState(() => _resultado = v),
                  ),
                  const TituloSecao('Quantidade atual'),
                  CampoQuantidade(valor: _qtd, vocab: vocab, aoMudar: () => setState(() {})),
                ],
                const TituloSecao('Fotos'),
                FotosFormulario(
                  fotos: _fotos,
                  aoMudar: (f) => setState(() => _fotos = f),
                  posicao: () => _posicao(foco),
                ),
                const TituloSecao('Observação'),
                CampoObservacao(controller: _obs, aoDitar: () => _ditado = true),
              ],
            ),
          ),
        ]),
        bottomNavigationBar: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
            child: SizedBox(
              height: 60,
              child: FilledButton.icon(
                onPressed: _salvando ? null : () => _salvar(foco),
                icon: const Icon(Icons.check, size: 26),
                label: Text('Salvar revisita', style: estiloCodigo(tamanho: 17, cor: Colors.white)),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _BotaoGrande extends StatelessWidget {
  const _BotaoGrande({
    required this.rotulo,
    required this.icone,
    required this.selecionado,
    required this.cor,
    required this.aoTocar,
  });

  final String rotulo;
  final IconData icone;
  final bool selecionado;
  final Color cor;
  final VoidCallback aoTocar;

  @override
  Widget build(BuildContext context) => Material(
        color: selecionado ? cor.withValues(alpha: 0.12) : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: selecionado ? cor : LumeCores.borda, width: selecionado ? 2.5 : 1),
        ),
        child: InkWell(
          onTap: aoTocar,
          borderRadius: BorderRadius.circular(12),
          child: SizedBox(
            height: 84,
            child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Icon(icone, size: 30, color: selecionado ? cor : LumeCores.textoSecundario),
              const SizedBox(height: 4),
              Text(rotulo, style: Theme.of(context).textTheme.titleMedium),
            ]),
          ),
        ),
      );
}
