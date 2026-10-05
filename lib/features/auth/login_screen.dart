import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/providers.dart';
import '../../app/theme.dart';
import '../../data/repositories/sessao_repository.dart';
import '../../domain/codigos.dart';
import '../../widgets/comuns.dart';

/// T01 — Login. Com servidor configurado: e-mail e senha. Sem servidor (modo
/// local): identificação simples, para os dados terem autor.
class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _form = GlobalKey<FormState>();
  final _nome = TextEditingController();
  final _email = TextEditingController();
  final _senha = TextEditingController();
  final _funcao = TextEditingController();
  String _perfil = Perfil.campo;
  bool _termo = false;
  bool _ocupado = false;
  String? _erro;

  @override
  void dispose() {
    _nome.dispose();
    _email.dispose();
    _senha.dispose();
    _funcao.dispose();
    super.dispose();
  }

  Future<void> _entrar() async {
    if (!_form.currentState!.validate()) return;
    if (!_termo) {
      setState(() => _erro = 'Aceite o termo de uso para continuar.');
      return;
    }
    setState(() {
      _ocupado = true;
      _erro = null;
    });
    final sessao = ref.read(sessaoRepoProvider);
    try {
      if (sessao.modoServidor) {
        await sessao.entrarServidor(email: _email.text, senha: _senha.text);
        ref.read(syncServiceProvider).sincronizar();
      } else {
        await sessao.entrarLocal(
          nome: _nome.text,
          email: _email.text,
          funcao: _funcao.text,
          perfil: _perfil,
        );
      }
    } on FalhaLogin catch (e) {
      setState(() => _erro = e.mensagem);
    } finally {
      if (mounted) setState(() => _ocupado = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final servidor = ref.read(sessaoRepoProvider).modoServidor;
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
                  Text(servidor ? 'Entrar' : 'Identificação', style: t.headlineSmall),
                  const SizedBox(height: 6),
                  Text(
                    servidor
                        ? 'Use o e-mail e a senha cadastrados pela gestão. Depois do primeiro acesso, o app funciona sem internet.'
                        : 'Modo local: os registros ficam neste aparelho. Informe quem está registrando.',
                    style: t.bodyMedium!.copyWith(color: LumeCores.textoSecundario),
                  ),
                  const SizedBox(height: 20),
                  if (!servidor) ...[
                    TextFormField(
                      controller: _nome,
                      textCapitalization: TextCapitalization.words,
                      decoration: const InputDecoration(labelText: 'Nome'),
                      validator: (v) => (v?.trim().length ?? 0) < 2 ? 'Informe o nome' : null,
                    ),
                    const SizedBox(height: 12),
                  ],
                  TextFormField(
                    controller: _email,
                    keyboardType: TextInputType.emailAddress,
                    autocorrect: false,
                    decoration: const InputDecoration(labelText: 'E-mail'),
                    validator: (v) => (v == null || !v.contains('@')) ? 'E-mail inválido' : null,
                  ),
                  const SizedBox(height: 12),
                  if (servidor)
                    TextFormField(
                      controller: _senha,
                      obscureText: true,
                      decoration: const InputDecoration(labelText: 'Senha'),
                      validator: (v) => (v?.isEmpty ?? true) ? 'Informe a senha' : null,
                      onFieldSubmitted: (_) => _entrar(),
                    )
                  else ...[
                    TextFormField(
                      controller: _funcao,
                      decoration: const InputDecoration(
                          labelText: 'Função (opcional)', hintText: 'Ex.: analista, brigadista, voluntário'),
                    ),
                    const SizedBox(height: 16),
                    Text('Perfil', style: t.labelLarge),
                    const SizedBox(height: 8),
                    SegmentedButton<String>(
                      segments: const [
                        ButtonSegment(value: Perfil.campo, label: Text('Campo'), icon: Icon(Icons.hiking)),
                        ButtonSegment(value: Perfil.gestor, label: Text('Gestão'), icon: Icon(Icons.assessment_outlined)),
                      ],
                      selected: {_perfil},
                      onSelectionChanged: (s) => setState(() => _perfil = s.first),
                    ),
                  ],
                  const SizedBox(height: 16),
                  CheckboxListTile(
                    value: _termo,
                    onChanged: (v) => setState(() => _termo = v ?? false),
                    contentPadding: EdgeInsets.zero,
                    controlAffinity: ListTileControlAffinity.leading,
                    title: Text(
                      'Li e aceito o termo de uso: o Lume guarda nome, e-mail e função de quem registra, '
                      'e a localização registrada é a do foco, não a minha.',
                      style: t.bodySmall!.copyWith(color: LumeCores.grafite),
                    ),
                  ),
                  if (_erro != null) ...[
                    const SizedBox(height: 8),
                    Aviso(_erro!, tipo: TipoAviso.erro),
                  ],
                  const SizedBox(height: 16),
                  FilledButton(
                    onPressed: _ocupado ? null : _entrar,
                    child: _ocupado
                        ? const SizedBox.square(dimension: 22, child: CircularProgressIndicator(strokeWidth: 2.5))
                        : const Text('Entrar'),
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
