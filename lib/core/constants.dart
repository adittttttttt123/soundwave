class AppConstants {
  static const String appName = 'SoundWave';
  
  // Theme Color Hexes (Vibrant Neon Purples & Cyans matching portfolio styling)
  static const int primaryColorHex = 0xFF6D28D9; // Violet
  static const int secondaryColorHex = 0xFF06B6D4; // Cyan
  static const int backgroundColorHex = 0xFF0A0A0A; // Dark background
  static const int cardBackgroundColorHex = 0xFF121212; // Dark card background
}

class MockData {
  static const List<Map<String, dynamic>> mockTracks = [
    {
      'id': '1',
      'title': 'Neon Horizon',
      'artist': 'Aether Flow',
      'album': 'Synthwave Dreams',
      'duration': 184, // 3:04
      'audioUrl': 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3',
      'coverUrl': 'https://images.unsplash.com/photo-1614613535308-eb5fbd3d2c17?w=500&q=80',
    },
    {
      'id': '2',
      'title': 'Digital Mirage',
      'artist': 'Cyber Pulse',
      'album': 'Retro Future',
      'duration': 218, // 3:38
      'audioUrl': 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-2.mp3',
      'coverUrl': 'https://images.unsplash.com/photo-1508700115892-45ecd05ae2ad?w=500&q=80',
    },
    {
      'id': '3',
      'title': 'Starlight Echoes',
      'artist': 'Solaris',
      'album': 'Celestial Spheres',
      'duration': 302, // 5:02
      'audioUrl': 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-3.mp3',
      'coverUrl': 'https://images.unsplash.com/photo-1518609878373-06d740f60d8b?w=500&q=80',
    },
    {
      'id': '4',
      'title': 'Oceanic Whispers',
      'artist': 'Deep Blue',
      'album': 'Abyssal Beats',
      'duration': 256, // 4:16
      'audioUrl': 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-4.mp3',
      'coverUrl': 'https://images.unsplash.com/photo-1511671782779-c97d3d27a1d4?w=500&q=80',
    },
  ];
}
