import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/providers.dart';
import '../../app/theme.dart';
import '../../widgets/comuns.dart';

/// Versão de apresentação — substitui o T01 (login): pede só nome e função.
/// A sessão fica salva no aparelho; ao abrir de novo, vai direto ao Início.
class IdentificacaoScreen extends ConsumerStatefulWidget {
  const IdentificacaoScreen({super.key});

  @override
  ConsumerState<IdentificacaoScreen> createState() => _IdentificacaoScreenState();
}

class _IdentificacaoScreenState extends ConsumerState<IdentificacaoScreen> {
  final _form = GlobalKey<FormState>();
  final _nome = TextEditingController();
  final _funcao = TextEditingController();
  bool _ocupado = false;
  String? _erro;

  @override
  void dispose() {
    _nome.dispose();
    _funcao.dispose();
    super.dispose();
  }

  Future<void> _entrar() async {
    if (!_form.currentState!.validate()) return;
    FocusScope.of(context).unfocus();
    setState(() {
      _ocupado = true;
      _erro = null;
    });
    try {
      // O roteador leva ao Início assim que a sessão é gravada.
      await ref.read(sessaoRepoProvider).entrarApresentacao(nome: _nome.text, funcao: _funcao.text);
    } catch (e) {
      if (mounted) setState(() => _erro = 'Não foi possível continuar: $e');
    } finally {
      if (mounted) setState(() => _ocupado = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return Scaffold(
      backgroundColor: LumeCores.creme,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 460),
              child: Form(
                key: _form,
                child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                  const Center(child: LogoLume(altura: 96)),
                  const SizedBox(height: 28),
                  Text('Quem está usando?', style: t.headlineSmall),
                  const SizedBox(height: 6),
                  Text(
                    'Versão de apresentação: os registros ficam guardados neste aparelho e não são enviados ao servidor.',
                    style: t.bodyMedium!.copyWith(color: LumeCores.textoSecundario),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _nome,
                    textCapitalization: TextCapitalization.words,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(labelText: 'Nome'),
                    validator: (v) => (v?.trim().length ?? 0) < 2 ? 'Informe o nome' : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _funcao,
                    textCapitalization: TextCapitalization.sentences,
                    textInputAction: TextInputAction.done,
                    decoration: const InputDecoration(
                        labelText: 'Função', hintText: 'Ex.: analista ambiental, brigadista, voluntário'),
                    validator: (v) => (v?.trim().isEmpty ?? true) ? 'Informe a função' : null,
                    onFieldSubmitted: (_) => _entrar(),
                  ),
                  if (_erro != null) ...[
                    const SizedBox(height: 12),
                    Aviso(_erro!, tipo: TipoAviso.erro),
                  ],
                  const SizedBox(height: 24),
                  FilledButton(
                    onPressed: _ocupado ? null : _entrar,
                    child: _ocupado
                        ? const SizedBox.square(dimension: 22, child: CircularProgressIndicator(strokeWidth: 2.5))
                        : const Text('Começar'),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Floresta Nacional de Pacotuba · ICMBio\nProjeto de Inovação — FIRST LEGO League BIOGLOW',
                    textAlign: TextAlign.center,
                    style: t.bodySmall,
                  ),
                ]),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
