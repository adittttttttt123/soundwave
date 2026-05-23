import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import '../models/song.dart';

enum RepeatMode { off, one, all }

class AudioProvider extends ChangeNotifier {
  // Galdive Flagship 20-Song Playlist
  final List<Song> _originalQueue = [
    Song(
      id: '1',
      title: 'Window',
      artist: 'Galdive',
      duration: '3:54',
      coverUrl: 'assets/images/galdive_spiritual.png',
      audioUrl: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-5.mp3',
    ),
    Song(
      id: '2',
      title: 'Lotus',
      artist: 'Galdive',
      duration: '3:34',
      coverUrl: 'assets/images/galdive_lotus.png',
      audioUrl: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3',
    ),
    Song(
      id: '3',
      title: 'Sorrento',
      artist: 'Galdive',
      duration: '3:42',
      coverUrl: 'assets/images/galdive_sorrento.png',
      audioUrl: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-2.mp3',
    ),
    Song(
      id: '4',
      title: 'Dear',
      artist: 'Galdive',
      duration: '3:15',
      coverUrl: 'assets/images/galdive_dear.png',
      audioUrl: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-3.mp3',
    ),
    Song(
      id: '5',
      title: 'Blew Me',
      artist: 'Galdive',
      duration: '4:02',
      coverUrl: 'assets/images/galdive_blewme.png',
      audioUrl: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-4.mp3',
    ),
    Song(
      id: '6',
      title: 'Poetry',
      artist: 'Galdive',
      duration: '3:50',
      coverUrl: 'assets/images/galdive_poetry.png',
      audioUrl: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-6.mp3',
    ),
    Song(
      id: '7',
      title: 'Nescience',
      artist: 'Galdive',
      duration: '3:28',
      coverUrl: 'assets/images/galdive_nescience.png',
      audioUrl: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-7.mp3',
    ),
    Song(
      id: '8',
      title: 'Sway',
      artist: 'Galdive',
      duration: '3:10',
      coverUrl: 'assets/images/galdive_sway.png',
      audioUrl: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-8.mp3',
    ),
    Song(
      id: '9',
      title: 'Aisles',
      artist: 'Galdive',
      duration: '3:55',
      coverUrl: 'assets/images/galdive_aisles.png',
      audioUrl: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-9.mp3',
    ),
    Song(
      id: '10',
      title: 'Can Hide',
      artist: 'Galdive',
      duration: '3:22',
      coverUrl: 'assets/images/galdive_canhide.png',
      audioUrl: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-10.mp3',
    ),
    Song(
      id: '11',
      title: 'Cruisin\'',
      artist: 'Galdive',
      duration: '3:40',
      coverUrl: 'assets/images/galdive_cruisin.png',
      audioUrl: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-11.mp3',
    ),
    Song(
      id: '12',
      title: 'Coffee',
      artist: 'Galdive',
      duration: '3:05',
      coverUrl: 'assets/images/galdive_coffee.png',
      audioUrl: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-12.mp3',
    ),
    Song(
      id: '13',
      title: 'Pretentious',
      artist: 'Galdive',
      duration: '3:31',
      coverUrl: 'assets/images/galdive_pretentious.png',
      audioUrl: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-13.mp3',
    ),
    Song(
      id: '14',
      title: 'Cloud 9',
      artist: 'Galdive',
      duration: '4:10',
      coverUrl: 'assets/images/galdive_cloud9.png',
      audioUrl: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-14.mp3',
    ),
    Song(
      id: '15',
      title: 'Whisper',
      artist: 'Galdive',
      duration: '3:18',
      coverUrl: 'assets/images/galdive_whisper.png',
      audioUrl: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-15.mp3',
    ),
    Song(
      id: '16',
      title: 'Stay',
      artist: 'Galdive',
      duration: '3:48',
      coverUrl: 'assets/images/galdive_stay.png',
      audioUrl: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-16.mp3',
    ),
    Song(
      id: '17',
      title: 'Five',
      artist: 'Galdive',
      duration: '3:25',
      coverUrl: 'assets/images/galdive_five.png',
      audioUrl: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3',
    ),
    Song(
      id: '18',
      title: 'Thrive',
      artist: 'Galdive',
      duration: '3:52',
      coverUrl: 'assets/images/galdive_thrive.png',
      audioUrl: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-2.mp3',
    ),
    Song(
      id: '19',
      title: 'Gravity',
      artist: 'Galdive',
      duration: '4:05',
      coverUrl: 'assets/images/galdive_gravity.png',
      audioUrl: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-3.mp3',
    ),
    Song(
      id: '20',
      title: 'Blue',
      artist: 'Galdive',
      duration: '3:12',
      coverUrl: 'assets/images/galdive_blue.png',
      audioUrl: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-4.mp3',
    ),
  ];

  List<Song> _activeQueue = [];
  
  // Playback state variables
  int _currentIndex = -1;
  bool _isPlaying = false;
  int _currentPosition = 0; // in seconds
  Timer? _playbackTimer;
  
  // Player settings
  bool _isShuffle = false;
  RepeatMode _repeatMode = RepeatMode.off;

  AudioProvider() {
    _activeQueue = List.from(_originalQueue);
    if (_activeQueue.isNotEmpty) {
      _currentIndex = 0;
    }
  }

  // Getters
  List<Song> get queue => _activeQueue;
  Song? get currentTrack => (_currentIndex >= 0 && _currentIndex < _activeQueue.length) 
      ? _activeQueue[_currentIndex] 
      : null;
  bool get isPlaying => _isPlaying;
  int get currentPosition => _currentPosition;
  bool get isShuffle => _isShuffle;
  RepeatMode get repeatMode => _repeatMode;

  double get progressPercentage {
    final song = currentTrack;
    if (song == null || song.durationInSeconds == 0) return 0.0;
    return _currentPosition / song.durationInSeconds;
  }

  // Global Controls
  void play() {
    if (currentTrack == null) return;
    _isPlaying = true;
    _startTimer();
    notifyListeners();
  }

  void pause() {
    _isPlaying = false;
    _stopTimer();
    notifyListeners();
  }

  void togglePlay() {
    if (_isPlaying) {
      pause();
    } else {
      play();
    }
  }

  void seek(int seconds) {
    final song = currentTrack;
    if (song == null) return;
    
    _currentPosition = seconds.clamp(0, song.durationInSeconds);
    notifyListeners();
  }

  void next() {
    if (_activeQueue.isEmpty) return;

    if (_repeatMode == RepeatMode.one) {
      // Loop current song
      _currentPosition = 0;
      play();
      return;
    }

    if (_currentIndex < _activeQueue.length - 1) {
      _currentIndex++;
      _currentPosition = 0;
      play();
    } else {
      if (_repeatMode == RepeatMode.all) {
        _currentIndex = 0;
        _currentPosition = 0;
        play();
      } else {
        // End of queue and no repeat all
        _isPlaying = false;
        _currentPosition = 0;
        _stopTimer();
        notifyListeners();
      }
    }
  }

  void previous() {
    if (_activeQueue.isEmpty) return;

    // If more than 3 seconds in, restart song
    if (_currentPosition > 3) {
      _currentPosition = 0;
      notifyListeners();
      return;
    }

    if (_currentIndex > 0) {
      _currentIndex--;
      _currentPosition = 0;
      play();
    } else {
      if (_repeatMode == RepeatMode.all) {
        _currentIndex = _activeQueue.length - 1;
        _currentPosition = 0;
        play();
      } else {
        // Restart song since it's the first one
        _currentPosition = 0;
        notifyListeners();
      }
    }
  }

  // Queue Management
  void selectTrack(String songId) {
    final index = _activeQueue.indexWhere((song) => song.id == songId);
    if (index != -1) {
      _currentIndex = index;
      _currentPosition = 0;
      play();
    }
  }

  void toggleShuffle() {
    _isShuffle = !_isShuffle;
    final Song? activeTrack = currentTrack;

    if (_isShuffle) {
      // Shuffle list
      final random = Random();
      final List<Song> shuffled = List.from(_originalQueue);
      for (var i = shuffled.length - 1; i > 0; i--) {
        var n = random.nextInt(i + 1);
        var temp = shuffled[i];
        shuffled[i] = shuffled[n];
        shuffled[n] = temp;
      }

      // Keep current playing track as active track in queue
      if (activeTrack != null) {
        shuffled.remove(activeTrack);
        shuffled.insert(0, activeTrack);
      }
      _activeQueue = shuffled;
      _currentIndex = 0;
    } else {
      // Revert to original order
      _activeQueue = List.from(_originalQueue);
      if (activeTrack != null) {
        _currentIndex = _activeQueue.indexWhere((song) => song.id == activeTrack.id);
      }
    }
    notifyListeners();
  }

  void toggleRepeat() {
    switch (_repeatMode) {
      case RepeatMode.off:
        _repeatMode = RepeatMode.all;
        break;
      case RepeatMode.all:
        _repeatMode = RepeatMode.one;
        break;
      case RepeatMode.one:
        _repeatMode = RepeatMode.off;
        break;
    }
    notifyListeners();
  }

  // Timer utilities for real-time progress synchronization
  void _startTimer() {
    _playbackTimer?.cancel();
    _playbackTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final song = currentTrack;
      if (song == null) return;

      if (_currentPosition < song.durationInSeconds) {
        _currentPosition++;
        notifyListeners();
      } else {
        next();
      }
    });
  }

  void _stopTimer() {
    _playbackTimer?.cancel();
  }

  @override
  void dispose() {
    _stopTimer();
    super.dispose();
  }
}
