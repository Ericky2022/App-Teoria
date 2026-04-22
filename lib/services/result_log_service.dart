import 'dart:io';

import 'package:path_provider/path_provider.dart';

class ResultLogService {
  static Future<void> appendResult({
    required String playerName,
    required String levelLabel,
    required int phase,
    required int score,
    required int total,
    required double percentage,
  }) async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      final file = File('${dir.path}/resultados_teoria_musical.txt');
      final now = DateTime.now().toIso8601String();

      final line =
          '$now | nome=$playerName | nivel=$levelLabel | fase=$phase | acertos=$score/$total | percentual=${percentage.toStringAsFixed(1)}%\n';

      await file.writeAsString(line, mode: FileMode.append, flush: true);
    } catch (_) {
      // Em Web ou plataformas sem suporte, apenas ignora a gravacao.
    }
  }
}
