import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import '../models/track.dart';
import '../core/constants.dart';

enum RepeatMode { off, one, all }

class AudioProvider extends ChangeNotifier {
  // Track lists
  final List<Track> _originalQueue = [];
  List<Track> _activeQueue = [];
  
  // Playback state variables
  int _currentIndex = -1;
  bool _isPlaying = false;
  int _currentPosition = 0; // in seconds
  Timer? _playbackTimer;
  
  // Player settings
  bool _isShuffle = false;
  RepeatMode _repeatMode = RepeatMode.off;

  AudioProvider() {
    // Populate with mock data initially
    for (var trackData in MockData.mockTracks) {
      _originalQueue.add(Track.fromJson(trackData));
    }
    _activeQueue = List.from(_originalQueue);
    if (_activeQueue.isNotEmpty) {
      _currentIndex = 0;
    }
  }

  // Getters
  List<Track> get queue => _activeQueue;
  Track? get currentTrack => (_currentIndex >= 0 && _currentIndex < _activeQueue.length) 
      ? _activeQueue[_currentIndex] 
      : null;
  bool get isPlaying => _isPlaying;
  int get currentPosition => _currentPosition;
  bool get isShuffle => _isShuffle;
  RepeatMode get repeatMode => _repeatMode;

  double get progressPercentage {
    final track = currentTrack;
    if (track == null || track.duration == 0) return 0.0;
    return _currentPosition / track.duration;
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
    final track = currentTrack;
    if (track == null) return;
    
    _currentPosition = seconds.clamp(0, track.duration);
    notifyListeners();
  }

  void next() {
    if (_activeQueue.isEmpty) return;

    if (_repeatMode == RepeatMode.one) {
      // Loop current track
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

    // If more than 3 seconds in, restart track
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
        // Restart track since it's the first one
        _currentPosition = 0;
        notifyListeners();
      }
    }
  }

  // Queue Management
  void selectTrack(String trackId) {
    final index = _activeQueue.indexWhere((track) => track.id == trackId);
    if (index != -1) {
      _currentIndex = index;
      _currentPosition = 0;
      play();
    }
  }

  void toggleShuffle() {
    _isShuffle = !_isShuffle;
    final Track? activeTrack = currentTrack;

    if (_isShuffle) {
      // Shuffle list
      final random = Random();
      final List<Track> shuffled = List.from(_originalQueue);
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
        _currentIndex = _activeQueue.indexWhere((track) => track.id == activeTrack.id);
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
      final track = currentTrack;
      if (track == null) return;

      if (_currentPosition < track.duration) {
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
