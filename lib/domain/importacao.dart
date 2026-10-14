/// Regras puras da importação de planilhas (sem Flutter): reconhecer as
/// colunas, ler coordenadas e datas e montar os registros a gravar.
///
/// O formato das planilhas da equipe ainda vai chegar; os nomes de coluna
/// aceitos abaixo cobrem os jeitos mais comuns e podem ser ampliados.
library;

import 'regras.dart';

enum CampoImportacao {
  especie('Espécie (nome popular ou científico)'),
  nomeCientifico('Nome científico'),
  nomePopular('Nome popular'),
  latitude('Latitude'),
  longitude('Longitude'),
  data('Data'),
  quantidade('Quantidade de indivíduos'),
  observacao('Observação'),
  codigo('Código / ID do registro'),
  ambiente('Ambiente / local'),
  responsavel('Responsável'),
  bloco('Bloco'),
  cap('CAP (cm)'),
  fase('Fase (árvore/arbusto ou regenerante)'),
  ocorrencia('Ocorrência (isolada, mancha, contínua)'),
  cobertura('Cobertura (%)');

  const CampoImportacao(this.rotulo);
  final String rotulo;
}

/// Nomes de coluna aceitos (já normalizados: minúsculas, sem acento).
const _sinonimos = <CampoImportacao, List<String>>{
  CampoImportacao.nomeCientifico: ['nome cientifico', 'cientifico', 'scientificname', 'scientific name', 'taxon'],
  CampoImportacao.nomePopular: ['nome popular', 'nome comum', 'popular', 'vernacularname', 'nome vulgar'],
  CampoImportacao.especie: ['especie', 'especies', 'species', 'planta', 'eei'],
  // Ficha de campo do ICMBio: coordenadas em colunas "S" e "W".
  CampoImportacao.latitude: ['latitude', 'lat', 'decimallatitude', 'y', 'coord y', 'coordenada y', 's', 'coordenada s'],
  CampoImportacao.longitude: [
    'longitude', 'lon', 'long', 'lng', 'decimallongitude', 'x', 'coord x', 'coordenada x', 'w', 'coordenada w',
  ],
  CampoImportacao.data: ['data', 'date', 'eventdate', 'data da coleta', 'data do registro', 'data de registro', 'dia'],
  CampoImportacao.quantidade: [
    'quantidade', 'qtd', 'qtde', 'n individuos', 'no individuos', 'numero de individuos', 'individuos',
    'individualcount', 'abundancia', 'n de individuos',
  ],
  CampoImportacao.observacao: ['observacao', 'observacoes', 'obs', 'comentario', 'comentarios', 'notas', 'remarks'],
  CampoImportacao.codigo: [
    // "Nº" da ficha de campo vira "n" depois de normalizado.
    'codigo', 'cod', 'id', 'identificador', 'registro', 'n registro', 'ponto', 'occurrenceid', 'n', 'no', 'numero',
  ],
  CampoImportacao.ambiente: ['ambiente', 'local', 'localidade', 'habitat', 'trilha', 'area'],
  CampoImportacao.responsavel: ['responsavel', 'coletor', 'observador', 'recordedby', 'equipe'],
  CampoImportacao.bloco: ['bloco', 'parcela', 'talhao', 'transecto'],
  CampoImportacao.cap: ['cap', 'cap cm', 'circunferencia'],
  CampoImportacao.fase: ['fase', 'estagio', 'estadio', 'lifestage'],
  CampoImportacao.ocorrencia: ['ocorrencia', 'padrao', 'tipo de ocorrencia'],
  CampoImportacao.cobertura: ['cobertura', 'cobertura estimada'],
};

String _normalizarCabecalho(String s) =>
    normalizarTexto(s).replaceAll(RegExp(r'[^a-z0-9 ]'), ' ').replaceAll(RegExp(r'\s+'), ' ').trim();

/// Associa cada campo à coluna da planilha, pelo nome do cabeçalho. Nome
/// exato vence; depois, cabeçalho que começa com o sinônimo ("Latitude (S)").
Map<CampoImportacao, int> detectarColunas(List<String> cabecalho) {
  final norm = [for (final c in cabecalho) _normalizarCabecalho(c)];
  final r = <CampoImportacao, int>{};
  final usadas = <int>{};
  for (final exato in [true, false]) {
    for (final campo in CampoImportacao.values) {
      if (r.containsKey(campo)) continue;
      for (final s in _sinonimos[campo] ?? const <String>[]) {
        final i = List.generate(norm.length, (i) => i).where((i) => !usadas.contains(i)).where((i) {
          final h = norm[i];
          return exato ? h == s : (s.length > 2 && (h.startsWith('$s ') || h.endsWith(' $s')));
        }).firstOrNull;
        if (i != null) {
          r[campo] = i;
          usadas.add(i);
          break;
        }
      }
    }
  }
  return r;
}

/// Linha onde está o cabeçalho: a primeira, entre as 10 de cima, que
/// reconhece latitude e longitude (planilhas costumam ter título antes).
int acharLinhaCabecalho(List<List<String>> linhas) {
  for (var i = 0; i < linhas.length && i < 10; i++) {
    final c = detectarColunas(linhas[i]);
    if (c.containsKey(CampoImportacao.latitude) && c.containsKey(CampoImportacao.longitude)) return i;
  }
  return 0;
}

/// Coordenada em graus decimais ("-20,7453", "-20.7453") ou em graus, minutos
/// e segundos ("20°44'43\"S", "20 44 43.2 S"). Hemisfério S/O deixa negativo.
double? lerCoordenada(String bruto, {required bool latitude}) {
  var s = bruto.trim().toUpperCase();
  if (s.isEmpty) return null;
  final sul = RegExp(r'[SWO]$').hasMatch(s) || s.startsWith('-');
  s = s.replaceAll(RegExp(r'[NSLEWO]$'), '').trim();
  double? v;
  final simples = s.replaceAll(',', '.');
  final dec = double.tryParse(simples);
  if (dec != null) {
    v = dec;
  } else {
    final nums = RegExp(r'\d+(?:[.,]\d+)?').allMatches(s).map((m) => double.parse(m[0]!.replaceAll(',', '.'))).toList();
    if (nums.isEmpty || nums.length > 3) return null;
    v = nums[0] + (nums.length > 1 ? nums[1] / 60 : 0) + (nums.length > 2 ? nums[2] / 3600 : 0);
  }
  if (sul && v > 0) v = -v;
  final limite = latitude ? 90 : 180;
  return v.abs() <= limite ? v : null;
}

/// Data em "dd/mm/aaaa", "dd/mm/aa", "aaaa-mm-dd" (com ou sem hora) ou
/// número de série do Excel. Sem hora, fica ao meio-dia (evita trocar o dia
/// na conversão de fuso). Retorna UTC.
DateTime? lerData(String bruto) {
  final s = bruto.trim();
  if (s.isEmpty) return null;
  final serie = double.tryParse(s.replaceAll(',', '.'));
  if (serie != null && serie > 20000 && serie < 80000) {
    // Excel conta dias desde 30/12/1899.
    final d = DateTime.utc(1899, 12, 30).add(Duration(milliseconds: (serie * 86400000).round()));
    return d.hour == 0 && d.minute == 0 ? DateTime.utc(d.year, d.month, d.day, 15) : d;
  }
  final iso = DateTime.tryParse(s);
  if (iso != null) {
    final temHora = s.contains(':');
    return temHora ? iso.toUtc() : DateTime.utc(iso.year, iso.month, iso.day, 15);
  }
  final m = RegExp(r'^(\d{1,2})[/.-](\d{1,2})[/.-](\d{2,4})(?:\s+(\d{1,2}):(\d{2}))?').firstMatch(s);
  if (m == null) return null;
  var ano = int.parse(m[3]!);
  if (ano < 100) ano += 2000;
  final mes = int.parse(m[2]!), dia = int.parse(m[1]!);
  if (mes < 1 || mes > 12 || dia < 1 || dia > 31) return null;
  if (m[4] != null) {
    // Hora local de Brasília (UTC−3).
    return DateTime.utc(ano, mes, dia, int.parse(m[4]!) + 3, int.parse(m[5]!));
  }
  return DateTime.utc(ano, mes, dia, 15);
}

/// Uma linha da planilha já interpretada.
class RegistroImportado {
  RegistroImportado({
    required this.linha,
    required this.chave,
    this.especie,
    this.nomeCientifico,
    this.lat,
    this.lon,
    this.data,
    this.quantidade,
    this.observacao,
    this.ambiente,
    this.responsavel,
    this.bloco,
    this.capCm,
    this.estagio,
    this.padraoOcorrencia,
    this.coberturaPct,
    this.erros = const [],
  });

  /// Número da linha na planilha (1 = primeira linha).
  final int linha;

  /// Identifica o registro entre importações (não importa duas vezes).
  final String chave;
  final String? especie;
  final String? nomeCientifico;
  final double? lat;
  final double? lon;
  final DateTime? data;
  final int? quantidade;
  final String? observacao;
  final String? ambiente;
  final String? responsavel;
  final String? bloco;
  final double? capCm;
  final String? estagio;
  final String? padraoOcorrencia;
  final int? coberturaPct;
  final List<String> erros;

  bool get valido => erros.isEmpty;

  /// Nome a procurar no catálogo (científico primeiro).
  String get nomeParaBusca => nomeCientifico ?? especie ?? '';
}

/// Converte as linhas (sem o cabeçalho) em registros, com os erros de cada um.
List<RegistroImportado> interpretarLinhas(
  List<List<String>> linhas,
  Map<CampoImportacao, int> colunas, {
  int primeiraLinha = 2,
  List<String> cabecalho = const [],
}) {
  // Colunas "S" e "W" da ficha: o hemisfério está no cabeçalho, o número vem sem sinal.
  bool cabecalhoEh(CampoImportacao c, Set<String> nomes) {
    final i = colunas[c];
    return i != null && i < cabecalho.length && nomes.contains(_normalizarCabecalho(cabecalho[i]));
  }

  final latSul = cabecalhoEh(CampoImportacao.latitude, {'s', 'coordenada s'});
  final lonOeste = cabecalhoEh(CampoImportacao.longitude, {'w', 'coordenada w'});
  String? valor(List<String> l, CampoImportacao c) {
    final i = colunas[c];
    if (i == null || i >= l.length) return null;
    final v = l[i].trim();
    return v.isEmpty ? null : v;
  }

  final r = <RegistroImportado>[];
  for (var k = 0; k < linhas.length; k++) {
    final l = linhas[k];
    if (l.every((c) => c.trim().isEmpty)) continue;
    final erros = <String>[];
    final cientifico = valor(l, CampoImportacao.nomeCientifico);
    final especie = valor(l, CampoImportacao.especie) ?? valor(l, CampoImportacao.nomePopular);
    if (cientifico == null && especie == null) erros.add('sem espécie');
    final latTxt = valor(l, CampoImportacao.latitude);
    final lonTxt = valor(l, CampoImportacao.longitude);
    var lat = latTxt == null ? null : lerCoordenada(latTxt, latitude: true);
    var lon = lonTxt == null ? null : lerCoordenada(lonTxt, latitude: false);
    if (latSul && lat != null && lat > 0) lat = -lat;
    if (lonOeste && lon != null && lon > 0) lon = -lon;
    if (lat == null || lon == null) erros.add('coordenada ausente ou inválida');
    final dataTxt = valor(l, CampoImportacao.data);
    final data = dataTxt == null ? null : lerData(dataTxt);
    if (dataTxt != null && data == null) erros.add('data inválida ("$dataTxt")');
    final qtdTxt = valor(l, CampoImportacao.quantidade);
    final qtd = qtdTxt == null ? null : int.tryParse(qtdTxt.replaceAll(RegExp(r'[^\d]'), ''));
    final codigo = valor(l, CampoImportacao.codigo);
    final chave = codigo != null
        ? 'cod:${normalizarTexto(codigo)}'
        : [
            'reg',
            binomioNormalizado(cientifico ?? '').isNotEmpty ? binomioNormalizado(cientifico!) : normalizarTexto(especie ?? ''),
            lat?.toStringAsFixed(5) ?? '',
            lon?.toStringAsFixed(5) ?? '',
            data?.toIso8601String().substring(0, 10) ?? '',
          ].join('|');
    r.add(RegistroImportado(
      linha: primeiraLinha + k,
      chave: chave,
      especie: especie,
      nomeCientifico: cientifico,
      lat: lat,
      lon: lon,
      data: data,
      quantidade: qtd,
      observacao: valor(l, CampoImportacao.observacao),
      ambiente: valor(l, CampoImportacao.ambiente),
      responsavel: valor(l, CampoImportacao.responsavel),
      bloco: valor(l, CampoImportacao.bloco),
      capCm: double.tryParse((valor(l, CampoImportacao.cap) ?? '').replaceAll(',', '.')),
      estagio: lerFase(valor(l, CampoImportacao.fase)),
      padraoOcorrencia: lerPadraoOcorrencia(valor(l, CampoImportacao.ocorrencia)),
      coberturaPct: lerCobertura(valor(l, CampoImportacao.cobertura)),
      erros: erros,
    ));
  }
  return r;
}

/// Fase da ficha: "(6) Árvore/arbusto" → adulto; "(7) Regenerante" → regenerante.
String? lerFase(String? v) {
  if (v == null) return null;
  final t = normalizarTexto(v);
  if (t == '7' || t.contains('regener')) return 'regenerante';
  if (t == '6' || t.contains('arvore') || t.contains('arbusto') || t.contains('adulto')) return 'adulto';
  if (t == 'r' || t.contains('reprod')) return 'reprodutivo';
  if (t.contains('plantula')) return 'plantula';
  if (t.contains('jovem')) return 'jovem';
  return null;
}

/// Ocorrência da ficha de rasteiras: (1) isolada, (2) mancha/reboleira, (3) contínua/densa.
String? lerPadraoOcorrencia(String? v) {
  if (v == null) return null;
  final t = normalizarTexto(v);
  if (t == '1' || t.startsWith('isolad')) return 'isolada';
  if (t == '2' || t.contains('mancha') || t.contains('reboleira')) return 'mancha';
  if (t == '3' || t.contains('continu') || t.contains('densa')) return 'continua';
  return null;
}

/// Cobertura em % ou nas faixas da ficha ("<25", "25-50", "50-75", ">75") → meio da faixa.
int? lerCobertura(String? v) {
  if (v == null) return null;
  final t = v.replaceAll(' ', '').replaceAll('%', '');
  if (t.startsWith('<')) return 12;
  if (t.startsWith('>')) return 88;
  final faixa = RegExp(r'^(\d+)[-–a](\d+)$').firstMatch(t);
  if (faixa != null) return ((int.parse(faixa[1]!) + int.parse(faixa[2]!)) / 2).round();
  final n = double.tryParse(t.replaceAll(',', '.'));
  return n == null || n < 0 || n > 100 ? null : n.round();
}

// ---------------------------------------------------------------------------
// Lista de EEI em UC federais (planilha oficial do ICMBio)
// ---------------------------------------------------------------------------

/// Linha da Lista de EEI em UC federais: uma espécie numa unidade.
class LinhaListaOficial {
  const LinhaListaOficial({
    required this.cnuc,
    required this.unidade,
    required this.especie,
    required this.animal,
    this.grupo,
    this.nomePopular,
    this.autor,
    this.ambiente,
  });

  final String cnuc;
  final String unidade;
  final String especie;
  final bool animal;
  final String? grupo;
  final String? nomePopular;
  final String? autor;
  final String? ambiente;
}

/// A aba é da lista oficial? (colunas CNUC e Espécie.)
bool ehListaOficial(List<String> cabecalho) {
  final n = {for (final c in cabecalho) _normalizarCabecalho(c)};
  return n.contains('cnuc') && n.contains('especie');
}

/// Lê uma aba da lista oficial (primeira linha = cabeçalho).
List<LinhaListaOficial> lerListaOficial(List<List<String>> linhas) {
  if (linhas.isEmpty) return const [];
  final cab = [for (final c in linhas.first) _normalizarCabecalho(c)];
  int? col(bool Function(String) teste) {
    final i = cab.indexWhere(teste);
    return i < 0 ? null : i;
  }

  final iCnuc = col((h) => h == 'cnuc');
  final iUc = col((h) => h.startsWith('unidade'));
  final iEsp = col((h) => h == 'especie');
  final iReino = col((h) => h.contains('animal ou planta'));
  final iGrupo = col((h) => h == 'grupo');
  final iPop = col((h) => h.startsWith('nome popular'));
  final iAutor = col((h) => h == 'autor');
  final iAmb = col((h) => h == 'ambiente');
  if (iCnuc == null || iEsp == null) return const [];
  String? v(List<String> l, int? i) {
    if (i == null || i >= l.length) return null;
    final t = l[i].trim();
    return t.isEmpty || t.toUpperCase() == 'NI' ? null : t;
  }

  return [
    for (final l in linhas.skip(1))
      if (v(l, iCnuc) != null && v(l, iEsp) != null)
        LinhaListaOficial(
          cnuc: v(l, iCnuc)!,
          unidade: v(l, iUc) ?? '',
          especie: v(l, iEsp)!.replaceAll(' (feral)', ''),
          animal: normalizarTexto(v(l, iReino) ?? '').startsWith('animal'),
          grupo: v(l, iGrupo),
          nomePopular: v(l, iPop),
          autor: v(l, iAutor),
          ambiente: v(l, iAmb),
        ),
  ];
}

/// Código do grupo da lista oficial no vocabulário de forma de vida/grupo.
String grupoListaOficial(String? grupo, {required bool animal}) {
  const mapa = {
    'arvore': 'arvore', 'arbusto': 'arbusto', 'palmeira': 'palmeira', 'graminea': 'graminea', 'bambu': 'bambu', //
    'trepadeira': 'trepadeira', 'herbacea': 'herbacea', 'samambaia': 'pteridofita', 'planta aquatica': 'aquatica',
    'mamifero': 'mamifero', 'ave': 'ave', 'peixe': 'peixe', 'reptil': 'reptil', 'anfibio': 'anfibio',
    'invertebrado': 'invertebrado',
  };
  return mapa[normalizarTexto(grupo ?? '')] ?? (animal ? 'invertebrado' : 'outra');
}

/// Ano do ciclo no nome do arquivo ("Lista EEI em UC federais_2025.xlsx" → 2025).
int? cicloDoArquivo(String nome) {
  final anos = RegExp(r'(20\d\d)').allMatches(nome).map((m) => int.parse(m[1]!)).toList();
  return anos.isEmpty ? null : anos.last;
}
