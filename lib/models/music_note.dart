class MusicNote {
  final String displayName;
  final String audioKey;
  final int duration;
  final int staffStep;
  final String rhythmLabel;

  const MusicNote({
    required this.displayName,
    required this.audioKey,
    required this.duration,
    required this.staffStep,
    required this.rhythmLabel,
  });
}
