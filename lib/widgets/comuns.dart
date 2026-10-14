import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../app/theme.dart';
import '../data/local/database.dart';
import '../data/repositories/catalogo_repository.dart';

/// Logotipo da marca (biolume-logo-kit).
class LogoLume extends StatelessWidget {
  const LogoLume({super.key, this.altura = 40, this.variante = VarianteLogo.horizontal});

  final double altura;
  final VarianteLogo variante;

  @override
  Widget build(BuildContext context) => SvgPicture.asset(
        switch (variante) {
          VarianteLogo.horizontal => 'assets/branding/biolume-logo-horizontal.svg',
          VarianteLogo.semSlogan => 'assets/branding/biolume-logo-horizontal-sem-slogan.svg',
          VarianteLogo.branco => 'assets/branding/biolume-logo-horizontal-branco.svg',
          VarianteLogo.simbolo || VarianteLogo.marcador => 'assets/branding/biolume-simbolo.svg',
        },
        height: altura,
        semanticsLabel: 'BioLume',
      );
}

enum VarianteLogo { horizontal, semSlogan, branco, simbolo, marcador }

/// Título de seção em formulários e fichas.
class TituloSecao extends StatelessWidget {
  const TituloSecao(this.texto, {super.key, this.obrigatorio = false, this.ajuda});

  final String texto;
  final bool obrigatorio;
  final String? ajuda;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 8),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text.rich(TextSpan(children: [
          TextSpan(text: texto.toUpperCase(), style: t.labelSmall!.copyWith(color: LumeCores.textoSecundario)),
          if (obrigatorio)
            TextSpan(text: '  obrigatório', style: t.labelSmall!.copyWith(color: LumeCores.laranjaTexto)),
        ])),
        if (ajuda != null) ...[
          const SizedBox(height: 2),
          Text(ajuda!, style: t.bodySmall),
        ],
      ]),
    );
  }
}

/// Escolha única por toques (chips grandes), a partir de um vocabulário.
class OpcoesVocabulario extends StatelessWidget {
  const OpcoesVocabulario({
    super.key,
    required this.vocab,
    required this.lista,
    required this.valor,
    required this.aoMudar,
    this.permitirLimpar = true,
  });

  final Vocabulario vocab;
  final String lista;
  final String? valor;
  final ValueChanged<String?> aoMudar;
  final bool permitirLimpar;

  @override
  Widget build(BuildContext context) => OpcoesChips(
        opcoes: [for (final v in vocab.itens(lista)) (v.codigo, v.rotulo)],
        valor: valor,
        aoMudar: aoMudar,
        permitirLimpar: permitirLimpar,
      );
}

class OpcoesChips extends StatelessWidget {
  const OpcoesChips({
    super.key,
    required this.opcoes,
    required this.valor,
    required this.aoMudar,
    this.permitirLimpar = true,
  });

  final List<(String, String)> opcoes;
  final String? valor;
  final ValueChanged<String?> aoMudar;
  final bool permitirLimpar;

  @override
  Widget build(BuildContext context) => Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          for (final (codigo, rotulo) in opcoes)
            ChoiceChip(
              label: Text(rotulo),
              selected: valor == codigo,
              onSelected: (s) => aoMudar(s ? codigo : (permitirLimpar ? null : codigo)),
            ),
        ],
      );
}

/// Linha "rótulo: valor" em fichas.
class LinhaDado extends StatelessWidget {
  const LinhaDado(this.rotulo, this.valor, {super.key, this.mono = false});

  final String rotulo;
  final String? valor;
  final bool mono;

  @override
  Widget build(BuildContext context) {
    if (valor == null || valor!.isEmpty) return const SizedBox.shrink();
    final t = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        SizedBox(width: 130, child: Text(rotulo, style: t.bodySmall)),
        Expanded(child: Text(valor!, style: mono ? estiloMono(tamanho: 13.5) : t.bodyMedium)),
      ]),
    );
  }
}

/// Miniatura de uma foto gravada (arquivo local).
class MiniaturaMidia extends StatelessWidget {
  const MiniaturaMidia({super.key, required this.midia, this.tamanho = 72});

  final Midia midia;
  final double tamanho;

  @override
  Widget build(BuildContext context) {
    final caminho = midia.caminhoLocal;
    return InkWell(
      onTap: caminho == null ? null : () => abrirFoto(context, caminho),
      borderRadius: BorderRadius.circular(8),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: SizedBox.square(
          dimension: tamanho,
          child: caminho == null
              ? Container(
                  color: LumeCores.nevoa,
                  child: const Icon(Icons.cloud_outlined, color: LumeCores.textoSecundario),
                )
              : Image.file(File(caminho), fit: BoxFit.cover, cacheWidth: (tamanho * 3).round(),
                  errorBuilder: (_, _, _) => Container(
                        color: LumeCores.nevoa,
                        child: const Icon(Icons.broken_image_outlined),
                      )),
        ),
      ),
    );
  }
}

void abrirFoto(BuildContext context, String caminho) {
  Navigator.of(context).push(MaterialPageRoute(
    builder: (_) => Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(backgroundColor: Colors.black, foregroundColor: Colors.white),
      body: Center(child: InteractiveViewer(child: Image.file(File(caminho)))),
    ),
  ));
}

/// Ícone por forma de vida (quando a espécie ainda não tem foto).
IconData iconeFormaVida(String forma) => switch (forma) {
      'arvore' => Icons.park_outlined,
      'arbusto' => Icons.grass,
      'palmeira' => Icons.forest_outlined,
      'graminea' => Icons.grass_outlined,
      'trepadeira' => Icons.local_florist_outlined,
      'herbacea' => Icons.eco_outlined,
      'aquatica' => Icons.water_drop_outlined,
      'pteridofita' => Icons.spa_outlined,
      'suculenta' => Icons.filter_vintage_outlined,
      'bambu' => Icons.grass,
      'mamifero' => Icons.pets_outlined,
      'ave' => Icons.flutter_dash,
      'peixe' => Icons.set_meal_outlined,
      'reptil' => Icons.bug_report_outlined,
      'anfibio' => Icons.water_outlined,
      'invertebrado' => Icons.pest_control_outlined,
      _ => Icons.help_outline,
    };

/// Foto redonda da espécie (ou o ícone da forma de vida, sem foto).
class AvatarEspecie extends StatelessWidget {
  const AvatarEspecie({super.key, required this.especie, this.foto, this.raio = 24});

  final Especie especie;
  final String? foto;
  final double raio;

  @override
  Widget build(BuildContext context) {
    final icone = CircleAvatar(
      radius: raio,
      backgroundColor: especie.id == 'outra' ? const Color(0xFFFFF0E6) : LumeCores.nevoa,
      foregroundColor: especie.id == 'outra' ? LumeCores.laranjaTexto : LumeCores.verdeFloresta,
      child: Icon(iconeFormaVida(especie.formaVida), size: raio),
    );
    if (foto == null) return icone;
    return ClipOval(
      child: Image.file(
        File(foto!),
        width: raio * 2,
        height: raio * 2,
        fit: BoxFit.cover,
        cacheWidth: (raio * 6).round(),
        errorBuilder: (_, _, _) => icone,
      ),
    );
  }
}

/// Selo "Lista oficial ICMBio" (ou "Fora da lista oficial", em laranja).
class SeloListaOficial extends StatelessWidget {
  const SeloListaOficial({super.key, this.fora = false});

  final bool fora;

  @override
  Widget build(BuildContext context) {
    final cor = fora ? LumeCores.laranjaTexto : LumeCores.verdeFloresta;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: fora ? const Color(0xFFFFF0E6) : LumeCores.selecao,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Icon(fora ? Icons.new_releases_outlined : Icons.verified_outlined, size: 13, color: cor),
        const SizedBox(width: 4),
        Text(fora ? 'Fora da lista oficial' : 'Lista oficial ICMBio',
            style: Theme.of(context).textTheme.labelSmall!.copyWith(color: cor)),
      ]),
    );
  }
}

/// Aviso em caixa (informação, alerta ou erro).
class Aviso extends StatelessWidget {
  const Aviso(this.texto, {super.key, this.tipo = TipoAviso.info, this.icone, this.acao});

  final String texto;
  final TipoAviso tipo;
  final IconData? icone;
  final Widget? acao;

  @override
  Widget build(BuildContext context) {
    final (fundo, borda, cor, ic) = switch (tipo) {
      TipoAviso.info => (LumeCores.nevoa, LumeCores.borda, LumeCores.verdeNoite, Icons.info_outline),
      TipoAviso.alerta => (const Color(0xFFFFF4E5), const Color(0xFFF2C38B), LumeCores.aviso, Icons.warning_amber_rounded),
      TipoAviso.erro => (const Color(0xFFFDECEC), const Color(0xFFF0B4B4), LumeCores.erro, Icons.error_outline),
      TipoAviso.sucesso => (LumeCores.selecao, LumeCores.mentaEscura, LumeCores.verdeNoite, Icons.check_circle_outline),
    };
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: fundo,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: borda),
      ),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Icon(icone ?? ic, color: cor, size: 20),
        const SizedBox(width: 10),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(texto, style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: cor)),
            if (acao != null) Padding(padding: const EdgeInsets.only(top: 6), child: acao),
          ]),
        ),
      ]),
    );
  }
}

enum TipoAviso { info, alerta, erro, sucesso }

/// Confirmação simples. Retorna true se confirmado.
Future<bool> confirmar(BuildContext context,
    {required String titulo, required String mensagem, String confirmar = 'Confirmar', bool perigo = false}) async {
  final r = await showDialog<bool>(
    context: context,
    builder: (c) => AlertDialog(
      title: Text(titulo),
      content: Text(mensagem),
      actions: [
        TextButton(onPressed: () => Navigator.pop(c, false), child: const Text('Cancelar')),
        FilledButton(
          style: perigo ? FilledButton.styleFrom(backgroundColor: LumeCores.erro) : null,
          onPressed: () => Navigator.pop(c, true),
          child: Text(confirmar),
        ),
      ],
    ),
  );
  return r ?? false;
}

void mostrarMensagem(BuildContext context, String texto) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(texto)));
}
