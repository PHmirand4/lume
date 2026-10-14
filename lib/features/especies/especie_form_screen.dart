import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/providers.dart';
import '../../app/router.dart';
import '../../app/theme.dart';
import '../../core/fotos.dart';
import '../../data/local/database.dart';
import '../../data/repositories/catalogo_repository.dart';
import '../../data/repositories/foco_repository.dart';
import '../../domain/codigos.dart';
import '../../widgets/comuns.dart';
import '../../widgets/formulario.dart';

/// Cadastro de espécie nova no catálogo (ou edição de uma existente).
/// Ao salvar um cadastro, devolve o id da espécie para quem abriu a tela.
class EspecieFormScreen extends ConsumerStatefulWidget {
  const EspecieFormScreen({super.key, this.especieId, this.nomeInicial});

  /// Nulo = cadastro de espécie nova.
  final String? especieId;
  final String? nomeInicial;

  @override
  ConsumerState<EspecieFormScreen> createState() => _EspecieFormScreenState();
}

class _EspecieFormScreenState extends ConsumerState<EspecieFormScreen> {
  final _form = GlobalKey<FormState>();
  final _nomePopular = TextEditingController();
  final _outrosNomes = TextEditingController();
  final _cientifico = TextEditingController();
  final _familia = TextEditingController();
  final _descricao = TextEditingController();
  final _confusao = TextEditingController();
  final _origem = TextEditingController();
  final _ambientes = TextEditingController();
  final _impactos = TextEditingController();
  final _controle = TextEditingController();
  String? _forma;
  bool _nativa = false;
  String _reino = Reino.planta;
  final _metodos = <String>{};
  List<FotoCapturada> _fotos = [];
  Especie? _original;
  Especie? _duplicada;
  bool _carregado = false;
  bool _salvando = false;
  bool _tentou = false;

  bool get _edicao => widget.especieId != null;

  @override
  void initState() {
    super.initState();
    if (_edicao) {
      ref.read(catalogoRepoProvider).especie(widget.especieId!).then((e) {
        if (!mounted || e == null) return;
        setState(() {
          _original = e;
          _nomePopular.text = e.nomesPopulares.firstOrNull ?? '';
          _outrosNomes.text = e.nomesPopulares.skip(1).join(', ');
          _cientifico.text = e.nomeCientifico;
          _familia.text = e.familia ?? '';
          _descricao.text = e.descricaoIdentificacao ?? '';
          _confusao.text = e.confusaoCom ?? '';
          _origem.text = e.origemNativa ?? '';
          _ambientes.text = e.ambientesInvasao ?? '';
          _impactos.text = e.impactos ?? '';
          _controle.text = e.controleCitado ?? '';
          _forma = e.formaVida;
          _nativa = e.nativaBrasil;
          _reino = e.reino;
          _metodos.addAll(e.metodosSugeridos);
          _carregado = true;
        });
      });
    } else {
      _nomePopular.text = widget.nomeInicial ?? '';
      _carregado = true;
    }
  }

  @override
  void dispose() {
    for (final c in [
      _nomePopular, _outrosNomes, _cientifico, _familia, _descricao, //
      _confusao, _origem, _ambientes, _impactos, _controle,
    ]) {
      c.dispose();
    }
    if (_fotos.isNotEmpty) ServicoFotos.descartar(_fotos);
    super.dispose();
  }

  /// Avisa se o nome científico já está no catálogo (evita duplicar espécie).
  Future<void> _verificarDuplicada() async {
    final achada = await ref.read(catalogoRepoProvider).porNomeCientifico(_cientifico.text);
    if (!mounted) return;
    setState(() => _duplicada = (achada != null && achada.id != _original?.id) ? achada : null);
  }

  List<String> get _nomes => [
        _nomePopular.text.trim().toLowerCase(),
        for (final n in _outrosNomes.text.split(','))
          if (n.trim().isNotEmpty) n.trim().toLowerCase(),
      ].where((n) => n.isNotEmpty).toList();

  Future<void> _salvar() async {
    setState(() => _tentou = true);
    if (!_form.currentState!.validate() || _forma == null) return;
    await _verificarDuplicada();
    if (_duplicada != null) return;
    final usuario = ref.read(usuarioAtualProvider).value;
    if (usuario == null) return;
    setState(() => _salvando = true);
    final dados = DadosEspecie(
      nomeCientifico: _cientifico.text,
      nomesPopulares: _nomes,
      formaVida: _forma!,
      familia: _familia.text,
      descricaoIdentificacao: _descricao.text,
      confusaoCom: _confusao.text,
      origemNativa: _origem.text,
      ambientesInvasao: _ambientes.text,
      impactos: _impactos.text,
      controleCitado: _controle.text,
      metodosSugeridos: _metodos.toList(),
      nativaBrasil: _nativa,
      reino: _reino,
    );
    final repo = ref.read(catalogoRepoProvider);
    try {
      if (_edicao) {
        await repo.editar(_original!, dados);
        if (!mounted) return;
        mostrarMensagem(context, 'Espécie atualizada.');
        context.pop();
      } else {
        final e = await repo.cadastrar(dados, usuarioId: usuario.id, unidadeId: ref.read(unidadeAtualProvider).id);
        for (final f in _fotos) {
          await repo.adicionarFoto(e.id, f);
        }
        _fotos = []; // já pertencem ao catálogo
        if (!mounted) return;
        mostrarMensagem(context, '${capitalizar(e.nomeComum)} entrou no catálogo (código ${e.prefixo}).');
        context.pop(e.id);
      }
    } catch (e) {
      if (mounted) mostrarMensagem(context, 'Não foi possível salvar: $e');
    } finally {
      if (mounted) setState(() => _salvando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final vocab = ref.watch(vocabProvider);
    final t = Theme.of(context).textTheme;

    Widget campo(TextEditingController c, String rotulo,
            {String? dica, int linhas = 1, String? Function(String?)? validar, ValueChanged<String>? aoMudar}) =>
        Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: TextFormField(
            controller: c,
            minLines: linhas,
            maxLines: linhas == 1 ? 1 : 8,
            textCapitalization: TextCapitalization.sentences,
            decoration: InputDecoration(labelText: rotulo, hintText: dica, alignLabelWithHint: linhas > 1),
            validator: validar,
            onChanged: aoMudar,
          ),
        );

    return Scaffold(
      appBar: AppBar(title: Text(_edicao ? 'Editar espécie' : 'Nova espécie')),
      body: !_carregado
          ? const Center(child: CircularProgressIndicator())
          : Form(
              key: _form,
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 32),
                children: [
                  if (!_edicao)
                    const Aviso(
                      'Use para uma espécie invasora que ainda não está no catálogo. '
                      'Se não souber o nome, registre a ocorrência como "Outra espécie / não sei".',
                    ),
                  const TituloSecao('Identificação', obrigatorio: true),
                  campo(_nomePopular, 'Nome popular',
                      dica: 'Ex.: jaqueira',
                      validar: (v) => (v?.trim().isEmpty ?? true) ? 'Informe o nome popular' : null),
                  campo(_outrosNomes, 'Outros nomes populares', dica: 'Separados por vírgula'),
                  campo(_cientifico, 'Nome científico',
                      dica: 'Ex.: Artocarpus heterophyllus Lam.',
                      validar: (v) => (v?.trim().split(' ').where((p) => p.isNotEmpty).length ?? 0) < 2
                          ? 'Informe gênero e espécie'
                          : null,
                      aoMudar: (_) => _verificarDuplicada()),
                  if (_duplicada != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Aviso(
                        'Essa espécie já está no catálogo: ${capitalizar(_duplicada!.nomeComum)} '
                        '(${_duplicada!.nomeCientifico}).',
                        tipo: TipoAviso.alerta,
                        acao: TextButton(
                          onPressed: () => context.push(Rotas.especie(_duplicada!.id)),
                          child: const Text('Ver a ficha'),
                        ),
                      ),
                    ),
                  campo(_familia, 'Família', dica: 'Ex.: Moraceae'),
                  const TituloSecao('Tipo', obrigatorio: true),
                  SegmentedButton<String>(
                    showSelectedIcon: false,
                    segments: const [
                      ButtonSegment(value: Reino.planta, icon: Icon(Icons.eco_outlined), label: Text('Planta')),
                      ButtonSegment(value: Reino.animal, icon: Icon(Icons.pets_outlined), label: Text('Animal')),
                    ],
                    selected: {_reino},
                    onSelectionChanged: (s) => setState(() {
                      _reino = s.first;
                      _forma = null;
                    }),
                  ),
                  TituloSecao(_reino == Reino.animal ? 'Grupo' : 'Forma de vida', obrigatorio: true,
                      ajuda: _tentou && _forma == null ? 'Escolha uma opção' : null),
                  OpcoesChips(
                    opcoes: [
                      for (final v in vocab.itens(Listas.formaVida))
                        if (v.codigo == 'outra' || _gruposAnimais.contains(v.codigo) == (_reino == Reino.animal))
                          (v.codigo, v.rotulo),
                    ],
                    valor: _forma,
                    aoMudar: (v) => setState(() => _forma = v),
                  ),
                  const SizedBox(height: 8),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Nativa do Brasil'),
                    subtitle: const Text('Invasora fora da sua área natural'),
                    value: _nativa,
                    onChanged: (v) => setState(() => _nativa = v),
                  ),
                  if (!_edicao) ...[
                    const TituloSecao('Fotos', ajuda: 'Folha, flor, fruto e a planta inteira ajudam a reconhecer.'),
                    FotosFormulario(fotos: _fotos, aoMudar: (f) => setState(() => _fotos = f)),
                  ],
                  const TituloSecao('Características'),
                  campo(_descricao, 'Como reconhecer', dica: 'Porte, folhas, flores, frutos', linhas: 3),
                  campo(_confusao, 'Pode ser confundida com', dica: 'Espécies parecidas, inclusive nativas', linhas: 2),
                  campo(_origem, 'Origem', dica: 'De onde a espécie é nativa', linhas: 2),
                  campo(_ambientes, 'Onde costuma invadir', linhas: 2),
                  campo(_impactos, 'Impactos', linhas: 2),
                  const TituloSecao('Manejo'),
                  campo(_controle, 'Controle já usado pela equipe', linhas: 2),
                  Text('Métodos usados', style: t.bodySmall),
                  const SizedBox(height: 6),
                  Wrap(spacing: 8, runSpacing: 8, children: [
                    for (final m in vocab.itens(Listas.metodoManejo))
                      FilterChip(
                        label: Text(m.rotulo),
                        selected: _metodos.contains(m.codigo),
                        onSelected: (s) => setState(() => s ? _metodos.add(m.codigo) : _metodos.remove(m.codigo)),
                      ),
                  ]),
                  const SizedBox(height: 24),
                  FilledButton.icon(
                    onPressed: _salvando ? null : _salvar,
                    icon: _salvando
                        ? const SizedBox.square(dimension: 20, child: CircularProgressIndicator(strokeWidth: 2.5))
                        : const Icon(Icons.check),
                    label: Text(_edicao ? 'Salvar alterações' : 'Adicionar ao catálogo',
                        style: estiloCodigo(tamanho: 16, cor: Colors.white)),
                  ),
                ],
              ),
            ),
    );
  }
}

String capitalizar(String s) => s.isEmpty ? s : s[0].toUpperCase() + s.substring(1);

const _gruposAnimais = {'mamifero', 'ave', 'peixe', 'reptil', 'anfibio', 'invertebrado'};
