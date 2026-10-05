import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

import '../data/repositories/foco_repository.dart';

/// Captura e guarda fotos na pasta privada do app, já comprimidas
/// (lado maior 1600 px, JPEG ~80% — §14.3 e RNF06).
class ServicoFotos {
  ServicoFotos({ImagePicker? picker}) : _picker = picker ?? ImagePicker();

  final ImagePicker _picker;
  static const _uuid = Uuid();

  static Future<Directory> pastaMidias() async {
    final base = await getApplicationDocumentsDirectory();
    final dir = Directory(p.join(base.path, 'midias'));
    if (!await dir.exists()) await dir.create(recursive: true);
    return dir;
  }

  Future<FotoCapturada?> capturar({
    bool daGaleria = false,
    double? lat,
    double? lon,
    String? momento,
  }) async {
    final x = await _picker.pickImage(
      source: daGaleria ? ImageSource.gallery : ImageSource.camera,
      maxWidth: 1600,
      maxHeight: 1600,
      imageQuality: 80,
      requestFullMetadata: false,
    );
    if (x == null) return null;
    final destino = p.join((await pastaMidias()).path, '${_uuid.v4()}.jpg');
    final arquivo = await File(x.path).copy(destino);
    return FotoCapturada(
      caminho: arquivo.path,
      tiradaEm: DateTime.now().toUtc(),
      lat: lat,
      lon: lon,
      tamanhoBytes: await arquivo.length(),
      momento: momento,
    );
  }

  /// Apaga fotos tiradas num formulário que foi cancelado.
  static Future<void> descartar(Iterable<FotoCapturada> fotos) async {
    for (final f in fotos) {
      try {
        await File(f.caminho).delete();
      } catch (_) {}
    }
  }
}
