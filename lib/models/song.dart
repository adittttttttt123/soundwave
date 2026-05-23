class Song {
  final String id;
  final String title;
  final String artist;
  final String duration; // e.g. "3:54"
  final String coverUrl;
  final String audioUrl;

  Song({
    required this.id,
    required this.title,
    required this.artist,
    required this.duration,
    required this.coverUrl,
    required this.audioUrl,
  });

  // Dynamic helper to parse "3:54" duration into seconds for the slider and seek states
  int get durationInSeconds {
    final parts = duration.split(':');
    if (parts.length == 2) {
      final minutes = int.tryParse(parts[0]) ?? 0;
      final seconds = int.tryParse(parts[1]) ?? 0;
      return minutes * 60 + seconds;
    }
    return 0;
  }
}
