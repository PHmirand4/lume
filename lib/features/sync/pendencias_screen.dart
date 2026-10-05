import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/providers.dart';
import '../../app/theme.dart';
import '../../core/formato.dart' as fmt;
import '../../data/repositories/config_repository.dart';
import '../../data/sync/sync_service.dart';
import '../../widgets/comuns.dart';

final _pendentesProvider = FutureProvider.autoDispose((ref) {
  ref.watch(pendenciasProvider);
  return listarPendentes(ref.watch(databaseProvider));
});

final _errosProvider = StreamProvider.autoDispose((ref) {
  final db = ref.watch(databaseProvider);
  return db.select(db.errosSync).watch();
});

final _soWifiProvider = StreamProvider.autoDispose(
    (ref) => ref.watch(configRepoProvider).observar(ConfigRepository.fotosSoWifi).map((v) => v != 'false'));

/// T13 — Pendências e sincronização.
class PendenciasScreen extends ConsumerWidget {
  const PendenciasScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final servico = ref.watch(syncServiceProvider);
    final p = ref.watch(pendenciasProvider).value ?? const Pendencias();
    final pendentes = ref.watch(_pendentesProvider).value ?? const [];
    final erros = ref.watch(_errosProvider).value ?? const [];
    final soWifi = ref.watch(_soWifiProvider).value ?? true;
    final t = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Sincronização')),
      body: ValueListenableBuilder(
        valueListenable: servico.estado,
        builder: (context, estado, _) => ListView(
          padding: const EdgeInsets.all(16),
          children: [
            if (!servico.disponivel)
              const Aviso(
                'Modo local: o servidor ainda não foi configurado. Os registros ficam guardados neste aparelho '
                'e podem ser exportados em CSV, GeoJSON ou Darwin Core.',
                icone: Icons.phone_android,
              )
            else if (!servico.logado)
              const Aviso('Sessão do servidor expirada. Saia e entre de novo para sincronizar.', tipo: TipoAviso.alerta)
            else if (estado.erro != null)
              Aviso(estado.erro!, tipo: TipoAviso.erro)
            else if (p.vazio)
              Aviso(estado.ultimaMensagem ?? 'Tudo sincronizado', tipo: TipoAviso.sucesso)
            else
              Aviso('${p.registros} registros e ${p.fotos} fotos aguardando envio.', tipo: TipoAviso.alerta),
            const SizedBox(height: 16),
            Row(children: [
              Expanded(child: _Numero(valor: p.registros, rotulo: 'Registros pendentes')),
              const SizedBox(width: 10),
              Expanded(child: _Numero(valor: p.fotos, rotulo: 'Fotos pendentes')),
              const SizedBox(width: 10),
              Expanded(child: _Numero(valor: p.erros, rotulo: 'Com erro', cor: p.erros > 0 ? LumeCores.erro : null)),
            ]),
            const SizedBox(height: 16),
            if (servico.disponivel)
              FilledButton.icon(
                onPressed: estado.rodando || !servico.logado ? null : servico.sincronizar,
                icon: estado.rodando
                    ? const SizedBox.square(dimension: 20, child: CircularProgressIndicator(strokeWidth: 2.5))
                    : const Icon(Icons.sync),
                label: Text(estado.rodando ? 'Sincronizando…' : 'Sincronizar agora'),
              ),
            if (estado.ultimoSucesso != null)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text('Última sincronização: ${fmt.dataHora(estado.ultimoSucesso!)}',
                    style: t.bodySmall, textAlign: TextAlign.center),
              ),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              value: soWifi,
              onChanged: (v) => ref.read(configRepoProvider).gravar(ConfigRepository.fotosSoWifi, '$v'),
              title: const Text('Enviar fotos só no Wi-Fi'),
              subtitle: const Text('Os dados sobem pelos dados móveis; as fotos esperam o Wi-Fi.'),
            ),
            if (erros.isNotEmpty) ...[
              const TituloSecao('Erros'),
              for (final e in erros)
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.error_outline, color: LumeCores.erro),
                  title: Text('${e.tabela} · ${e.registroId.substring(0, 8)}', style: estiloMono(tamanho: 13)),
                  subtitle: Text('${e.mensagem}\n${e.tentativas} tentativas · última ${fmt.dataHora(e.ultimaTentativa)}'),
                  isThreeLine: true,
                ),
              OutlinedButton(onPressed: servico.tentarNovamenteErros, child: const Text('Tentar de novo agora')),
            ],
            if (pendentes.isNotEmpty) ...[
              const TituloSecao('Aguardando envio'),
              for (final (tipo, codigo, status) in pendentes.take(100))
                ListTile(
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                  leading: Icon(status == 'erro' ? Icons.error_outline : Icons.schedule,
                      color: status == 'erro' ? LumeCores.erro : LumeCores.textoSecundario),
                  title: Text('$tipo · $codigo'),
                ),
            ],
          ],
        ),
      ),
    );
  }
}

class _Numero extends StatelessWidget {
  const _Numero({required this.valor, required this.rotulo, this.cor});

  final int valor;
  final String rotulo;
  final Color? cor;

  @override
  Widget build(BuildContext context) => Card(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('$valor', style: estiloCodigo(tamanho: 24, cor: cor ?? LumeCores.verdeFloresta)),
            Text(rotulo, style: Theme.of(context).textTheme.bodySmall),
          ]),
        ),
      );
}
