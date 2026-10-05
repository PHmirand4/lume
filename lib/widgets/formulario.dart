import 'dart:io';

import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart';

import '../app/theme.dart';
import '../core/fotos.dart';
import '../core/formato.dart';
import '../core/gps.dart';
import '../data/repositories/catalogo_repository.dart';
import '../data/repositories/foco_repository.dart';
import '../domain/codigos.dart';
import 'comuns.dart';

// ---------------------------------------------------------------------------
// Barra escura de GPS (padrão do protótipo: coordenadas e precisão no topo)
// ---------------------------------------------------------------------------

class BarraGps extends StatelessWidget {
  const BarraGps({
    super.key,
    required this.coletor,
    required this.avisoM,
    this.ajustada,
    this.aoMedirDeNovo,
    this.aoAjustarNoMapa,
  });

  final ColetorGps coletor;
  final double avisoM;
  final Posicao? ajustada;
  final VoidCallback? aoMedirDeNovo;
  final VoidCallback? aoAjustarNoMapa;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: coletor,
      builder: (context, _) {
        final m = coletor.melhor;
        final t = Theme.of(context).textTheme;
        final branco = t.bodySmall!.copyWith(color: Colors.white70);
        String linha1;
        String linha2;
        Color corPrecisao = LumeCores.mentaClara;
        if (ajustada != null) {
          linha1 = coordenadas(ajustada!.lat, ajustada!.lon);
          linha2 = 'Posição ajustada no mapa';
        } else if (coletor.problema != null) {
          linha1 = 'Sem GPS';
          linha2 = mensagemProblemaGps(coletor.problema!);
          corPrecisao = const Color(0xFFFFB37A);
        } else if (m == null) {
          linha1 = 'Procurando satélites…';
          linha2 = '${coletor.segundos}s';
        } else {
          linha1 = coordenadas(m.lat, m.lon);
          linha2 = coletor.coletando
              ? 'Melhorando precisão… ${coletor.segundos}s'
              : (m.precisaoM > avisoM ? 'Precisão baixa' : 'Posição registrada');
          if (m.precisaoM > avisoM) corPrecisao = const Color(0xFFFFB37A);
        }
        return Container(
          color: LumeCores.verdeNoite,
          padding: const EdgeInsets.fromLTRB(16, 10, 8, 10),
          child: Row(children: [
            Icon(
              coletor.coletando ? Icons.gps_not_fixed : (m != null || ajustada != null ? Icons.gps_fixed : Icons.gps_off),
              color: corPrecisao,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(linha1, style: estiloMono(tamanho: 14.5, cor: Colors.white)),
                Text(linha2, style: branco, maxLines: 2, overflow: TextOverflow.ellipsis),
              ]),
            ),
            if (ajustada == null && m != null)
              Padding(
                padding: const EdgeInsets.only(right: 4),
                child: Text(precisao(m.precisaoM), style: estiloMono(tamanho: 18, cor: corPrecisao)),
              ),
            PopupMenuButton<int>(
              icon: const Icon(Icons.more_vert, color: Colors.white),
              tooltip: 'Opções de localização',
              onSelected: (v) => v == 0 ? aoMedirDeNovo?.call() : aoAjustarNoMapa?.call(),
              itemBuilder: (_) => const [
                PopupMenuItem(value: 0, child: Text('Medir de novo')),
                PopupMenuItem(value: 1, child: Text('Ajustar no mapa')),
              ],
            ),
          ]),
        );
      },
    );
  }
}

// ---------------------------------------------------------------------------
// Fotos do formulário
// ---------------------------------------------------------------------------

class FotosFormulario extends StatefulWidget {
  const FotosFormulario({
    super.key,
    required this.fotos,
    required this.aoMudar,
    this.posicao,
    this.momento,
    this.rotuloBotao = 'Tirar foto',
  });

  final List<FotoCapturada> fotos;
  final ValueChanged<List<FotoCapturada>> aoMudar;
  final Posicao? Function()? posicao;
  final String? momento;
  final String rotuloBotao;

  @override
  State<FotosFormulario> createState() => _FotosFormularioState();
}

class _FotosFormularioState extends State<FotosFormulario> {
  final _servico = ServicoFotos();
  bool _ocupado = false;

  Future<void> _capturar({bool galeria = false}) async {
    setState(() => _ocupado = true);
    try {
      final pos = widget.posicao?.call();
      final f = await _servico.capturar(
        daGaleria: galeria,
        lat: pos?.lat,
        lon: pos?.lon,
        momento: widget.momento,
      );
      if (f != null) widget.aoMudar([...widget.fotos, f]);
    } catch (e) {
      if (mounted) mostrarMensagem(context, 'Não foi possível abrir a câmera: $e');
    } finally {
      if (mounted) setState(() => _ocupado = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      if (widget.fotos.isNotEmpty)
        SizedBox(
          height: 92,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: widget.fotos.length,
            separatorBuilder: (_, _) => const SizedBox(width: 8),
            itemBuilder: (_, i) {
              final f = widget.fotos[i];
              return Stack(children: [
                InkWell(
                  onTap: () => abrirFoto(context, f.caminho),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.file(File(f.caminho), width: 92, height: 92, fit: BoxFit.cover, cacheWidth: 280),
                  ),
                ),
                Positioned(
                  right: 0,
                  top: 0,
                  child: IconButton.filled(
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.black54,
                      minimumSize: const Size(32, 32),
                      padding: EdgeInsets.zero,
                    ),
                    iconSize: 18,
                    tooltip: 'Remover foto',
                    onPressed: () {
                      ServicoFotos.descartar([f]);
                      widget.aoMudar([...widget.fotos]..removeAt(i));
                    },
                    icon: const Icon(Icons.close, color: Colors.white),
                  ),
                ),
              ]);
            },
          ),
        ),
      if (widget.fotos.isNotEmpty) const SizedBox(height: 10),
      Row(children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: _ocupado ? null : () => _capturar(),
            icon: const Icon(Icons.photo_camera_outlined),
            label: Text(widget.rotuloBotao),
          ),
        ),
        const SizedBox(width: 8),
        IconButton.outlined(
          onPressed: _ocupado ? null : () => _capturar(galeria: true),
          tooltip: 'Escolher da galeria',
          style: IconButton.styleFrom(minimumSize: const Size(52, 52)),
          icon: const Icon(Icons.photo_library_outlined),
        ),
      ]),
    ]);
  }
}

// ---------------------------------------------------------------------------
// Quantidade (contagem, classe, área ou cobertura — RN19)
// ---------------------------------------------------------------------------

class QuantidadeValor {
  QuantidadeValor({this.tipo = 'contagem', this.n, this.classe, this.area, this.cobertura});

  String tipo;
  int? n;
  String? classe;
  double? area;
  int? cobertura;

  bool get preenchida => switch (tipo) {
        'contagem' => n != null && n! > 0,
        'classe' => classe != null,
        'area' => area != null && area! > 0,
        'cobertura' => cobertura != null,
        _ => false,
      };
}

class CampoQuantidade extends StatefulWidget {
  const CampoQuantidade({super.key, required this.valor, required this.vocab, required this.aoMudar});

  final QuantidadeValor valor;
  final Vocabulario vocab;
  final VoidCallback aoMudar;

  @override
  State<CampoQuantidade> createState() => _CampoQuantidadeState();
}

class _CampoQuantidadeState extends State<CampoQuantidade> {
  late final _nCtrl = TextEditingController(text: widget.valor.n?.toString() ?? '');
  late final _areaCtrl = TextEditingController(text: widget.valor.area == null ? '' : numero(widget.valor.area!));

  @override
  void dispose() {
    _nCtrl.dispose();
    _areaCtrl.dispose();
    super.dispose();
  }

  void _mudou() {
    setState(() {});
    widget.aoMudar();
  }

  void _somar(int d) {
    final n = ((widget.valor.n ?? 0) + d).clamp(0, 99999);
    widget.valor.n = n == 0 ? null : n;
    _nCtrl.text = n == 0 ? '' : '$n';
    _mudou();
  }

  @override
  Widget build(BuildContext context) {
    final v = widget.valor;
    final tipos = widget.vocab.itens(Listas.quantificacaoTipo);
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SegmentedButton<String>(
          showSelectedIcon: false,
          segments: [
            for (final t in tipos)
              ButtonSegment(
                value: t.codigo,
                label: Text(switch (t.codigo) {
                  'contagem' => 'Contagem',
                  'classe' => 'Classe',
                  'area' => 'Área',
                  'cobertura' => 'Cobertura',
                  _ => t.rotulo,
                }),
              ),
          ],
          selected: {v.tipo},
          onSelectionChanged: (s) {
            v.tipo = s.first;
            _mudou();
          },
        ),
      ),
      const SizedBox(height: 12),
      switch (v.tipo) {
        'contagem' => Row(children: [
            IconButton.outlined(
              onPressed: () => _somar(-1),
              icon: const Icon(Icons.remove),
              style: IconButton.styleFrom(minimumSize: const Size(56, 56)),
              tooltip: 'Menos um',
            ),
            const SizedBox(width: 10),
            SizedBox(
              width: 110,
              child: TextField(
                controller: _nCtrl,
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                style: estiloMono(tamanho: 22),
                decoration: const InputDecoration(hintText: '0', suffixText: 'ind.'),
                onChanged: (s) {
                  v.n = lerInteiro(s);
                  widget.aoMudar();
                },
              ),
            ),
            const SizedBox(width: 10),
            IconButton.filled(
              onPressed: () => _somar(1),
              icon: const Icon(Icons.add),
              style: IconButton.styleFrom(minimumSize: const Size(56, 56)),
              tooltip: 'Mais um',
            ),
            const SizedBox(width: 6),
            TextButton(onPressed: () => _somar(10), child: const Text('+10')),
          ]),
        'classe' => OpcoesVocabulario(
            vocab: widget.vocab,
            lista: Listas.classeAbundancia,
            valor: v.classe,
            aoMudar: (c) {
              v.classe = c;
              _mudou();
            },
          ),
        'area' => TextField(
            controller: _areaCtrl,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            style: estiloMono(tamanho: 18),
            decoration: const InputDecoration(hintText: 'Área ocupada', suffixText: 'm²'),
            onChanged: (s) {
              v.area = lerNumero(s);
              widget.aoMudar();
            },
          ),
        _ => Row(children: [
            Expanded(
              child: Slider(
                value: (v.cobertura ?? 0).toDouble(),
                max: 100,
                divisions: 20,
                label: '${v.cobertura ?? 0}%',
                onChanged: (x) {
                  v.cobertura = x.round();
                  _mudou();
                },
              ),
            ),
            SizedBox(
              width: 64,
              child: Text('${v.cobertura ?? 0}%', style: estiloMono(tamanho: 18), textAlign: TextAlign.end),
            ),
          ]),
      },
    ]);
  }
}

// ---------------------------------------------------------------------------
// Observação em texto com ditado (F04)
// ---------------------------------------------------------------------------

class CampoObservacao extends StatefulWidget {
  const CampoObservacao({super.key, required this.controller, this.aoDitar, this.dica});

  final TextEditingController controller;
  final VoidCallback? aoDitar;
  final String? dica;

  @override
  State<CampoObservacao> createState() => _CampoObservacaoState();
}

class _CampoObservacaoState extends State<CampoObservacao> {
  final _fala = SpeechToText();
  bool _disponivel = false;
  bool _ouvindo = false;
  String _base = '';

  @override
  void dispose() {
    _fala.stop();
    super.dispose();
  }

  Future<void> _alternar() async {
    if (_ouvindo) {
      await _fala.stop();
      setState(() => _ouvindo = false);
      return;
    }
    if (!_disponivel) {
      _disponivel = await _fala.initialize(
        onStatus: (s) {
          if ((s == 'done' || s == 'notListening') && mounted) setState(() => _ouvindo = false);
        },
        onError: (_) {
          if (mounted) setState(() => _ouvindo = false);
        },
      );
      if (!_disponivel) {
        if (mounted) mostrarMensagem(context, 'Ditado indisponível neste aparelho. Digite a observação.');
        return;
      }
    }
    _base = widget.controller.text.trim();
    setState(() => _ouvindo = true);
    await _fala.listen(
      listenOptions: SpeechListenOptions(localeId: 'pt_BR', partialResults: true, cancelOnError: true),
      onResult: (r) {
        final sep = _base.isEmpty ? '' : ' ';
        widget.controller.text = '$_base$sep${r.recognizedWords}';
        widget.controller.selection = TextSelection.collapsed(offset: widget.controller.text.length);
        widget.aoDitar?.call();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Expanded(
        child: TextField(
          controller: widget.controller,
          minLines: 2,
          maxLines: 6,
          textCapitalization: TextCapitalization.sentences,
          decoration: InputDecoration(hintText: widget.dica ?? 'Observação (opcional)'),
        ),
      ),
      const SizedBox(width: 8),
      IconButton.filled(
        onPressed: _alternar,
        tooltip: _ouvindo ? 'Parar ditado' : 'Ditar observação',
        style: IconButton.styleFrom(
          minimumSize: const Size(56, 56),
          backgroundColor: _ouvindo ? LumeCores.laranjaAlerta : LumeCores.verdeFloresta,
        ),
        icon: Icon(_ouvindo ? Icons.stop : Icons.mic_none),
      ),
    ]);
  }
}
