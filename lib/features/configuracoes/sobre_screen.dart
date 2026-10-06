import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../app/theme.dart';
import '../../core/apresentacao.dart';
import '../../data/remote/supabase_config.dart';
import '../../data/repositories/foco_repository.dart';
import '../../widgets/comuns.dart';

/// Sobre, atribuições de mapas e licenças (RNF10).
class SobreScreen extends StatelessWidget {
  const SobreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    Widget link(String texto, String url) => InkWell(
          onTap: () => launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Text(texto, style: t.bodyMedium!.copyWith(color: LumeCores.verdeFloresta, decoration: TextDecoration.underline)),
          ),
        );

    return Scaffold(
      appBar: AppBar(title: const Text('Sobre')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
        children: [
          const Center(child: LogoLume(altura: 110)),
          const SizedBox(height: 16),
          Text(
            'Monitoramento de espécies exóticas invasoras da Floresta Nacional de Pacotuba (ICMBio), '
            'Cachoeiro de Itapemirim/ES.',
            style: t.bodyLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text('Versão $versaoApp · ${modoApresentacao ? 'apresentação' : SupabaseConfig.configurado ? 'servidor configurado' : 'modo local'}',
              style: estiloMono(tamanho: 13, cor: LumeCores.textoSecundario), textAlign: TextAlign.center),
          const TituloSecao('Projeto'),
          Text(
            'Projeto de Inovação da equipe de robótica do SESI Cachoeiro de Itapemirim — FIRST LEGO League, '
            'temporada BIOGLOW (2026/2027). Ferramenta de apoio; não é um sistema oficial do ICMBio.',
            style: t.bodyMedium,
          ),
          const TituloSecao('Dados e atribuições'),
          Text('Mapa base: © colaboradores do OpenStreetMap (ODbL).', style: t.bodyMedium),
          link('openstreetmap.org/copyright', 'https://www.openstreetmap.org/copyright'),
          Text('Limite da Flona: ICMBio (arquivo oficial KMZ).', style: t.bodyMedium),
          const SizedBox(height: 6),
          Text('Catálogo de espécies: Costa et al. (2024), cap. 3 — Floresta Nacional de Pacotuba.', style: t.bodyMedium),
          const SizedBox(height: 6),
          Text('Estrutura de registro: Guia de Orientação do ICMBio para o manejo de EEI em UCs federais; '
              'exportação no padrão Darwin Core (TDWG).', style: t.bodyMedium),
          const TituloSecao('Privacidade (LGPD)'),
          Text(
            'O Lume guarda só nome, e-mail e função de quem registra. A localização gravada é a do foco, '
            'não um rastreamento da pessoa. A exportação Darwin Core pode ser anonimizada.',
            style: t.bodyMedium,
          ),
          const TituloSecao('Fontes'),
          Text('Archivo e IBM Plex — SIL Open Font License 1.1.', style: t.bodyMedium),
          const SizedBox(height: 12),
          OutlinedButton(
            onPressed: () => showLicensePage(context: context, applicationName: 'Lume', applicationVersion: versaoApp),
            child: const Text('Licenças de software'),
          ),
        ],
      ),
    );
  }
}
