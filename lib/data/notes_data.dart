import '../models/music_note.dart';

class NotesData {
  static List<MusicNote> byPhase({
    required int phase,
    required int duration,
  }) {
    switch (phase) {
      case 1:
        return _phaseOne(duration);
      case 2:
        return _phaseTwo(duration);
      case 3:
      default:
        return _phaseThree(duration);
    }
  }

  // Fase 1: Do a Sol (oitava central).
  static List<MusicNote> _phaseOne(int duration) {
    final label = _rhythmLabel(duration);
    return [
      _note('Dó', 'C', duration, -2, label),
      _note('Ré', 'D', duration, -1, label),
      _note('Mi', 'E', duration, 0, label),
      _note('Fá', 'F', duration, 1, label),
      _note('Sol', 'G', duration, 2, label),
    ];
  }

  // Fase 2: Do a Do (oitava completa).
  static List<MusicNote> _phaseTwo(int duration) {
    final label = _rhythmLabel(duration);
    return [
      _note('Dó', 'C', duration, -2, label),
      _note('Ré', 'D', duration, -1, label),
      _note('Mi', 'E', duration, 0, label),
      _note('Fá', 'F', duration, 1, label),
      _note('Sol', 'G', duration, 2, label),
      _note('Lá', 'A', duration, 3, label),
      _note('Si', 'B', duration, 4, label),
      _note('Dó', 'C', duration, 5, label),
    ];
  }

  // Fase 3: Do a Sol da segunda oitava.
  static List<MusicNote> _phaseThree(int duration) {
    final label = _rhythmLabel(duration);
    return [
      _note('Dó', 'C', duration, 5, label),
      _note('Ré', 'D', duration, 6, label),
      _note('Mi', 'E', duration, 7, label),
      _note('Fá', 'F', duration, 8, label),
      _note('Sol', 'G', duration, 9, label),
    ];
  }

  static MusicNote _note(
    String displayName,
    String audioKey,
    int duration,
    int staffStep,
    String label,
  ) {
    return MusicNote(
      displayName: displayName,
      audioKey: audioKey,
      duration: duration,
      staffStep: staffStep,
      rhythmLabel: label,
    );
  }

  static String _rhythmLabel(int duration) {
    switch (duration) {
      case 4:
        return 'Semibreve (4 tempos)';
      case 2:
        return 'Minima (2 tempos)';
      case 1:
        return 'Seminima (1 tempo)';
      default:
        return 'Figura ritmica';
    }
  }
}
