import 'package:flutter_test/flutter_test.dart';
import 'package:lume/domain/importacao.dart';
import 'package:lume/domain/regras.dart';

void main() {
  group('Importação de planilhas', () {
    test('reconhece colunas com acento, caixa e unidade no nome', () {
      final c = detectarColunas(['Nº', 'Nome científico', 'Nome popular', 'Latitude (S)', 'Longitude (O)', 'Data da coleta', 'Obs.']);
      expect(c[CampoImportacao.nomeCientifico], 1);
      expect(c[CampoImportacao.nomePopular], 2);
      expect(c[CampoImportacao.latitude], 3);
      expect(c[CampoImportacao.longitude], 4);
      expect(c[CampoImportacao.data], 5);
      expect(c[CampoImportacao.observacao], 6);
    });

    test('acha o cabeçalho abaixo de um título', () {
      final linhas = <List<String>>[
        ['Levantamento de EEI — 2025'],
        [],
        ['Espécie', 'Lat', 'Long'],
        ['jaqueira', '-20.7', '-41.2'],
      ];
      expect(acharLinhaCabecalho(linhas), 2);
    });

    test('coordenadas decimais e em graus, minutos e segundos', () {
      expect(lerCoordenada('-20,7453', latitude: true), closeTo(-20.7453, 1e-9));
      expect(lerCoordenada('-41.2914', latitude: false), closeTo(-41.2914, 1e-9));
      expect(lerCoordenada('20°44\'43"S', latitude: true), closeTo(-20.74528, 1e-4));
      expect(lerCoordenada('41 17 29 O', latitude: false), closeTo(-41.29139, 1e-4));
      expect(lerCoordenada('95', latitude: true), isNull);
      expect(lerCoordenada('abc', latitude: true), isNull);
    });

    test('datas brasileiras, ISO e número de série do Excel', () {
      expect(lerData('05/03/2025'), DateTime.utc(2025, 3, 5, 15));
      expect(lerData('5/3/25'), DateTime.utc(2025, 3, 5, 15));
      expect(lerData('2025-04-01'), DateTime.utc(2025, 4, 1, 15));
      expect(lerData('45720'), DateTime.utc(2025, 3, 4, 15));
      expect(lerData('31/13/2025'), isNull);
    });

    test('linhas sem coordenada ou espécie são marcadas com erro; chave estável', () {
      final colunas = detectarColunas(['Espécie', 'Latitude', 'Longitude', 'Data']);
      final r = interpretarLinhas([
        ['leucena', '-20.7', '-41.2', '01/02/2025'],
        ['', '-20.7', '-41.2', ''],
        ['leucena', '', '-41.2', ''],
        ['', '', '', ''],
      ], colunas);
      expect(r, hasLength(3), reason: 'linha vazia é ignorada');
      expect(r[0].valido, isTrue);
      expect(r[0].linha, 2);
      expect(r[1].erros, contains('sem espécie'));
      expect(r[2].erros, contains('coordenada ausente ou inválida'));
      final deNovo = interpretarLinhas([
        ['Leucena', '-20.70000', '-41.2', '01/02/2025'],
      ], colunas);
      expect(deNovo.single.chave, r[0].chave);
    });
  });

  group('Catálogo', () {
    test('binômio ignora autor, acento e caixa', () {
      expect(binomioNormalizado('Acacia mangium Willd.'), 'acacia mangium');
      expect(binomioNormalizado('ACACIA  Mangium'), 'acacia mangium');
    });

    test('id de espécie nova não repete', () {
      expect(idNovaEspecie('Acacia mangium Willd.', {}), 'acacia_mangium');
      expect(idNovaEspecie('Acacia mangium', {'acacia_mangium'}), 'acacia_mangium_2');
    });

    test('prefixo de 3 letras, sem repetir', () {
      expect(sugerirPrefixo('jaqueira', {}), 'JAQ');
      final p = sugerirPrefixo('jaqueira', {'JAQ'});
      expect(p, hasLength(3));
      expect(p, isNot('JAQ'));
      expect(sugerirPrefixo('açaí', {}), 'ACA');
    });
  });

  group('Ficha de campo do ICMBio', () {
    test('colunas S e W da ficha viram coordenadas negativas; CAP, fase e bloco', () {
      final cab = ['Bloco', 'Nº', 'Espécie', 'S', 'W', 'CAP (cm)', 'Fase', 'Data'];
      final colunas = detectarColunas(cab);
      expect(colunas[CampoImportacao.latitude], 3);
      expect(colunas[CampoImportacao.longitude], 4);
      expect(colunas[CampoImportacao.codigo], 1);
      final r = interpretarLinhas([
        ['B2', '7', 'Syzygium jambos', '20.7453', '41.2914', '35,5', '7', '10/09/2025'],
        ['B2', '8', 'Syzygium cumini', '20°44\'43"', '41°17\'29"', '', 'Árvore/arbusto', '10/09/2025'],
      ], colunas, cabecalho: cab);
      expect(r[0].lat, closeTo(-20.7453, 1e-9));
      expect(r[0].lon, closeTo(-41.2914, 1e-9));
      expect(r[0].capCm, 35.5);
      expect(r[0].estagio, 'regenerante');
      expect(r[0].bloco, 'B2');
      expect(r[0].chave, 'cod:7');
      expect(r[1].lat, lessThan(0));
      expect(r[1].estagio, 'adulto');
    });

    test('ocorrência e faixas de cobertura da ficha de rasteiras', () {
      expect(lerPadraoOcorrencia('2'), 'mancha');
      expect(lerPadraoOcorrencia('Contínua/Densa'), 'continua');
      expect(lerCobertura('<25'), 12);
      expect(lerCobertura('25-50'), 38);
      expect(lerCobertura('>75'), 88);
      expect(lerCobertura('40%'), 40);
    });
  });

  group('Lista de EEI em UC federais', () {
    final linhas = [
      ['CNUC', 'Unidade de Conservação Federal', 'A espécie do registro é animal ou planta?', 'Grupo', 'Espécie',
        'Nome popular', 'Autor', 'Ambiente'],
      ['0000.00.0101', 'FLORESTA NACIONAL DE PACOTUBA', 'Planta', 'Árvore', 'Acacia mangium', 'acácia', 'Willd.',
        'terrestre'],
      ['0000.00.0101', 'FLORESTA NACIONAL DE PACOTUBA', 'Animal', 'Anfíbio', 'Aquarana catesbeiana', 'rã-touro',
        '(Shaw, 1802)', 'terrestre'],
      ['0000.00.0001', 'ÁREA DE PROTEÇÃO AMBIENTAL ANHATOMIRIM', 'Animal', 'Mamífero', 'Canis familiaris (feral)', 'NI',
        'Linnaeus, 1758', 'terrestre'],
    ];

    test('reconhece a planilha oficial e lê as linhas', () {
      expect(ehListaOficial(linhas.first), isTrue);
      expect(ehListaOficial(['Espécie', 'Latitude', 'Longitude']), isFalse);
      final l = lerListaOficial(linhas);
      expect(l, hasLength(3));
      expect(l[1].animal, isTrue);
      expect(grupoListaOficial(l[1].grupo, animal: true), 'anfibio');
      expect(l[2].especie, 'Canis familiaris', reason: '"(feral)" sai do nome');
      expect(l[2].nomePopular, isNull, reason: 'NI = não informado');
      expect(cicloDoArquivo('Lista EEI em UC federais_2025 (1).xlsx'), 2025);
    });
  });
}
