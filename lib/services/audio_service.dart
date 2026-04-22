import 'package:audioplayers/audioplayers.dart';

class AudioService {
  static const Duration _playDuration = Duration(seconds: 1);
  static const Duration _countdownDuration = Duration(milliseconds: 250);

  final AudioPlayer _feedbackPlayer = AudioPlayer();
  final AudioPlayer _countdownPlayer = AudioPlayer();

  Future<void> playError() async {
    try {
      await _playForDuration(
        _feedbackPlayer,
        AssetSource('audio/error.mp3'),
        _playDuration,
      );
    } catch (_) {
      // Ignore missing file errors during initial setup.
    }
  }

  Future<void> playNote(String noteName) async {
    try {
      await _playForDuration(
        _feedbackPlayer,
        AssetSource('audio/$noteName.mp3'),
        _playDuration,
      );
    } catch (_) {
      // Ignore missing file errors during initial setup.
    }
  }

  Future<void> playCountdown() async {
    try {
      await _playForDuration(
        _countdownPlayer,
        AssetSource('audio/contagem.wav'),
        _countdownDuration,
      );
    } catch (_) {
      // Ignore missing file errors during initial setup.
    }
  }

  Future<void> _playForDuration(
    AudioPlayer player,
    AssetSource source,
    Duration duration,
  ) async {
    await player.stop();
    await player.play(source);
    await Future<void>.delayed(duration);
    await player.stop();
  }

  Future<void> dispose() async {
    await _feedbackPlayer.dispose();
    await _countdownPlayer.dispose();
  }
}
