import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart' as audioplayers;
import 'package:singforme/lyrics_data.dart';

class AudioService extends ChangeNotifier {
  static final AudioService _instance = AudioService._internal();
  factory AudioService() => _instance;
  AudioService._internal() {
    _initListeners();
  }

  final audioplayers.AudioPlayer _player = audioplayers.AudioPlayer();

  String _currentSong = '';
  String _currentArtist = '';
  bool _isPlaying = false;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;
  List<Map<String, String>> _playlist = [];
  int _currentIndex = -1;

  // Getters
  String get currentSong => _currentSong;
  String get currentArtist => _currentArtist;
  bool get isPlaying => _isPlaying;
  Duration get duration => _duration;
  Duration get position => _position;
  List<Map<String, String>> get playlist => _playlist;
  int get currentIndex => _currentIndex;
  audioplayers.AudioPlayer get player => _player;

  // Get cover for current song
  String get currentCover {
    return LyricsData.getCover(_currentSong);
  }

  // Check if current song has cover
  bool get hasCurrentCover {
    return LyricsData.hasCover(_currentSong);
  }

  void _initListeners() {
    _player.onPlayerStateChanged.listen((state) {
      _isPlaying = state == audioplayers.PlayerState.playing;
      notifyListeners();
    });

    _player.onDurationChanged.listen((newDuration) {
      _duration = newDuration;
      notifyListeners();
    });

    _player.onPositionChanged.listen((newPosition) {
      _position = newPosition;
      notifyListeners();
    });

    _player.onPlayerComplete.listen((event) {
      nextTrack();
    });
  }

  Future<void> playSong({
    required String title,
    required String artist,
    String assetPath = 'audio/song02.mp3',
    String lyrics = '',
  }) async {
    try {
      if (_currentSong == title) {
        if (_isPlaying) {
          await _player.pause();
        } else {
          await _player.resume();
        }
        notifyListeners();
        return;
      }

      await _player.stop();
      _currentSong = title;
      _currentArtist = artist;
      await _player.play(audioplayers.AssetSource(assetPath));
      _updateCurrentIndex(title);
      notifyListeners();
    } catch (e) {
      print('Error playing audio: $e');
      _currentSong = '';
      _currentArtist = '';
      _isPlaying = false;
      notifyListeners();
    }
  }

  Future<void> togglePlayPause() async {
    try {
      if (_isPlaying) {
        await _player.pause();
      } else if (_currentSong.isNotEmpty) {
        await _player.resume();
      } else {
        await playSong(
          title: 'Song 02',
          artist: 'Unknown Artist',
          assetPath: 'audio/song02.mp3',
        );
      }
      notifyListeners();
    } catch (e) {
      print('Error toggling play/pause: $e');
    }
  }

  Future<void> seek(Duration newPosition) async {
    try {
      await _player.seek(newPosition);
    } catch (e) {
      print('Error seeking: $e');
    }
  }

  Future<void> stop() async {
    try {
      await _player.stop();
      _currentSong = '';
      _currentArtist = '';
      _isPlaying = false;
      _position = Duration.zero;
      notifyListeners();
    } catch (e) {
      print('Error stopping: $e');
    }
  }

  Future<void> nextTrack() async {
    try {
      if (_playlist.isNotEmpty && _currentIndex < _playlist.length - 1) {
        _currentIndex++;
        final song = _playlist[_currentIndex];
        await playSong(
          title: song['title'] ?? 'Unknown',
          artist: song['artist'] ?? 'Unknown Artist',
          assetPath: song['path'] ?? 'audio/song02.mp3',
        );
      } else if (_playlist.isNotEmpty &&
          _currentIndex == _playlist.length - 1) {
        _currentIndex = 0;
        final song = _playlist[_currentIndex];
        await playSong(
          title: song['title'] ?? 'Unknown',
          artist: song['artist'] ?? 'Unknown Artist',
          assetPath: song['path'] ?? 'audio/song02.mp3',
        );
      }
    } catch (e) {
      print('Error playing next track: $e');
    }
  }

  Future<void> previousTrack() async {
    try {
      if (_playlist.isNotEmpty && _currentIndex > 0) {
        _currentIndex--;
        final song = _playlist[_currentIndex];
        await playSong(
          title: song['title'] ?? 'Unknown',
          artist: song['artist'] ?? 'Unknown Artist',
          assetPath: song['path'] ?? 'audio/song02.mp3',
        );
      } else if (_playlist.isNotEmpty && _currentIndex == 0) {
        _currentIndex = _playlist.length - 1;
        final song = _playlist[_currentIndex];
        await playSong(
          title: song['title'] ?? 'Unknown',
          artist: song['artist'] ?? 'Unknown Artist',
          assetPath: song['path'] ?? 'audio/song02.mp3',
        );
      }
    } catch (e) {
      print('Error playing previous track: $e');
    }
  }

  void setPlaylist(List<Map<String, String>> songs, {int startIndex = 0}) {
    _playlist = songs;
    if (songs.isNotEmpty && startIndex < songs.length) {
      _currentIndex = startIndex;
      final song = songs[startIndex];
      playSong(
        title: song['title'] ?? 'Unknown',
        artist: song['artist'] ?? 'Unknown Artist',
        assetPath: song['path'] ?? 'audio/song02.mp3',
      );
    }
  }

  void _updateCurrentIndex(String title) {
    for (int i = 0; i < _playlist.length; i++) {
      if (_playlist[i]['title'] == title) {
        _currentIndex = i;
        break;
      }
    }
  }

  bool get isPlayingSong => _isPlaying;

  void addListener(VoidCallback listener) {
    super.addListener(listener);
  }

  void removeListener(VoidCallback listener) {
    super.removeListener(listener);
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }
}
