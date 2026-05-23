class Track {
  final String id;
  final String title;
  final String artist;
  final String album;
  final int duration; // in seconds
  final String audioUrl;
  final String coverUrl;

  Track({
    required this.id,
    required this.title,
    required this.artist,
    required this.album,
    required this.duration,
    required this.audioUrl,
    required this.coverUrl,
  });

  factory Track.fromJson(Map<String, dynamic> json) {
    return Track(
      id: json['id'] as String,
      title: json['title'] as String,
      artist: json['artist'] as String,
      album: json['album'] as String,
      duration: json['duration'] as int,
      audioUrl: json['audioUrl'] as String,
      coverUrl: json['coverUrl'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'artist': artist,
      'album': album,
      'duration': duration,
      'audioUrl': audioUrl,
      'coverUrl': coverUrl,
    };
  }
}
