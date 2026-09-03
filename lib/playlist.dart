import 'package:flutter/material.dart';
import 'package:singforme/audio_service.dart';
import 'package:singforme/mini_player.dart';
import 'package:singforme/lyrics_data.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class PlaylistScreen extends StatefulWidget {
  final String playlistName;

  const PlaylistScreen({super.key, required this.playlistName});

  @override
  State<PlaylistScreen> createState() => _PlaylistScreenState();
}

class _PlaylistScreenState extends State<PlaylistScreen> {
  late final AudioService _audioService;
  List<Map<String, String>> _playlistSongs = [];
  bool _isLoading = true;

  final List<Map<String, String>> _availableSongs = const [
    {
      'title': 'Another Day',
      'artist': 'Dream Theater',
      'path': 'audio/song01.mp3',
      'duration': '4:27',
    },
    {
      'title': 'Charles (Self Cover)',
      'artist': 'balloon',
      'path': 'audio/song02.mp3',
      'duration': '3:49',
    },
    {
      'title': 'Wake Me Up When September Ends',
      'artist': 'Green Day',
      'path': 'audio/song03.mp3',
      'duration': '4:46',
    },
    {
      'title': 'My Way Of Life',
      'artist': 'Frank Sinatra',
      'path': 'audio/song04.mp3',
      'duration': '3:08',
    },
    {
      'title': 'Titik Nadir',
      'artist': 'Kahitna',
      'path': 'audio/song05.mp3',
      'duration': '5:05',
    },
    {
      'title': 'Rap God',
      'artist': 'Eminem',
      'path': 'audio/song06.mp3',
      'duration': '6:10',
    },
    {
      'title': 'My Way',
      'artist': 'Frank Sinatra',
      'path': 'audio/song07.mp3',
      'duration': '4:38',
    },
    {
      'title': 'The Spirit Carries On',
      'artist': 'Dream Theater',
      'path': 'audio/song10.mp3',
      'duration': '6:38',
    },
    {
      'title': 'Wirang',
      'artist': 'Denny Caknan',
      'path': 'audio/song11.mp3',
      'duration': '5:12',
    },
    {
      'title': 'Smells Like Teen Spirit',
      'artist': 'Nirvana',
      'path': 'audio/song08.mp3',
      'duration': '5:01',
    },
    {
      'title': 'Nomad',
      'artist': 'balloon',
      'path': 'audio/song09.mp3',
      'duration': '3:51',
    },
  ];

  @override
  void initState() {
    super.initState();
    _audioService = AudioService();
    _loadPlaylist();
  }

  Future<void> _loadPlaylist() async {
    setState(() => _isLoading = true);
    try {
      final prefs = await SharedPreferences.getInstance();
      final key = 'playlist_${widget.playlistName}';
      final jsonString = prefs.getString(key);

      if (jsonString != null) {
        final List<dynamic> decoded = jsonDecode(jsonString);
        setState(() {
          _playlistSongs = decoded
              .map((e) => Map<String, String>.from(e))
              .toList();
          _isLoading = false;
        });
      } else {
        setState(() {
          _playlistSongs = [];
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error loading playlist: $e');
      setState(() {
        _playlistSongs = [];
        _isLoading = false;
      });
    }
  }

  Future<void> _savePlaylist() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final key = 'playlist_${widget.playlistName}';
      final jsonString = jsonEncode(_playlistSongs);
      await prefs.setString(key, jsonString);
    } catch (e) {
      print('Error saving playlist: $e');
    }
  }

  void _addSongToPlaylist(Map<String, String> song) {
    final exists = _playlistSongs.any((s) => s['title'] == song['title']);
    if (exists) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Song already in playlist'),
          backgroundColor: Colors.orange,
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    setState(() {
      _playlistSongs.add(song);
    });
    _savePlaylist();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('"${song['title']}" added to ${widget.playlistName}'),
        backgroundColor: const Color(0xFFD040A0),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _removeSongFromPlaylist(int index) {
    final removedSong = _playlistSongs[index];
    setState(() {
      _playlistSongs.removeAt(index);
    });
    _savePlaylist();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('"${removedSong['title']}" removed from playlist'),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _clearPlaylist() {
    setState(() {
      _playlistSongs.clear();
    });
    _savePlaylist();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Playlist cleared'),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _shuffleAndPlay() {
    if (_playlistSongs.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Playlist is empty! Add some songs first.'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }
    final shuffledList = List<Map<String, String>>.from(_playlistSongs);
    shuffledList.shuffle();
    _audioService.setPlaylist(shuffledList, startIndex: 0);
    setState(() {});
  }

  void _showClearConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF282828),
        title: const Text(
          'Clear Playlist',
          style: TextStyle(color: Colors.white),
        ),
        content: const Text(
          'Are you sure you want to remove all songs from this playlist?',
          style: TextStyle(color: Colors.grey),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _clearPlaylist();
            },
            child: const Text('Clear All', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showAddSongDialog(BuildContext context) {
    final List<Map<String, String>> songsToAdd = _availableSongs.where((song) {
      return !_playlistSongs.any((s) => s['title'] == song['title']);
    }).toList();

    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF282828),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      isScrollControlled: true,
      builder: (context) {
        return SafeArea(
          child: Container(
            padding: const EdgeInsets.all(20),
            height: MediaQuery.of(context).size.height * 0.6,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Add Songs',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                if (songsToAdd.isEmpty)
                  Expanded(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.check_circle,
                            size: 60,
                            color: Colors.green[400],
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'All songs are already in your playlist!',
                            style: TextStyle(color: Colors.grey, fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  )
                else
                  Expanded(
                    child: ListView.builder(
                      itemCount: songsToAdd.length,
                      itemBuilder: (context, index) {
                        final song = songsToAdd[index];
                        return ListTile(
                          leading: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: const Color(0xFF1E1E1E),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.music_note,
                              color: Colors.grey,
                            ),
                          ),
                          title: Text(
                            song['title']!,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          subtitle: Text(
                            song['artist']!,
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 13,
                            ),
                          ),
                          trailing: IconButton(
                            icon: const Icon(
                              Icons.add_circle,
                              color: Color(0xFFD040A0),
                              size: 28,
                            ),
                            onPressed: () {
                              _addSongToPlaylist(song);
                              Navigator.pop(context);
                              _showAddSongDialog(context);
                            },
                          ),
                          onTap: () {
                            _addSongToPlaylist(song);
                            Navigator.pop(context);
                            _showAddSongDialog(context);
                          },
                        );
                      },
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF282828),
        title: const Text(
          'Clear Playlist',
          style: TextStyle(color: Colors.white),
        ),
        content: const Text(
          'Are you sure you want to clear this playlist?',
          style: TextStyle(color: Colors.grey),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _deletePlaylistData();
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${widget.playlistName} cleared'),
                  backgroundColor: Colors.red,
                ),
              );
            },
            child: const Text('Clear', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Future<void> _deletePlaylistData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final key = 'playlist_${widget.playlistName}';
      await prefs.remove(key);
    } catch (e) {
      print('Error deleting playlist: $e');
    }
  }

  void _showOptionsMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF282828),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 8),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[600],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 16),
              _buildOptionTile(
                icon: Icons.play_arrow,
                title: 'Play All',
                onTap: () {
                  Navigator.pop(context);
                  if (_playlistSongs.isNotEmpty) {
                    _audioService.setPlaylist(_playlistSongs, startIndex: 0);
                    setState(() {});
                  }
                },
              ),
              _buildOptionTile(
                icon: Icons.shuffle,
                title: 'Shuffle Play',
                onTap: () {
                  Navigator.pop(context);
                  _shuffleAndPlay();
                },
              ),
              _buildOptionTile(
                icon: Icons.add,
                title: 'Add Songs',
                onTap: () {
                  Navigator.pop(context);
                  _showAddSongDialog(context);
                },
              ),
              _buildOptionTile(
                icon: Icons.delete_outline,
                title: 'Delete Playlist',
                onTap: () {
                  Navigator.pop(context);
                  _showDeleteConfirmation(context);
                },
                isDestructive: true,
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  Widget _buildOptionTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: isDestructive ? Colors.red : const Color(0xFFD040A0),
      ),
      title: Text(
        title,
        style: TextStyle(
          color: isDestructive ? Colors.red : Colors.white,
          fontSize: 16,
        ),
      ),
      trailing: const Icon(Icons.chevron_right, color: Colors.grey),
      onTap: onTap,
    );
  }

  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white, size: 28),
            onPressed: () => Navigator.pop(context),
          ),
          Expanded(
            child: Text(
              widget.playlistName,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (_playlistSongs.isNotEmpty)
            IconButton(
              icon: const Icon(
                Icons.delete_outline,
                color: Colors.red,
                size: 24,
              ),
              onPressed: _showClearConfirmation,
            ),
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.white, size: 28),
            onPressed: () {
              _showOptionsMenu(context);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPlaylistHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: const LinearGradient(
                colors: [Color(0xFFD040A0), Color(0xFF8A2BE2)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Stack(
              children: [
                const Center(
                  child: Icon(
                    Icons.playlist_play,
                    size: 32,
                    color: Colors.white,
                  ),
                ),
                if (_playlistSongs.isNotEmpty)
                  Positioned(
                    right: 6,
                    bottom: 6,
                    child: Container(
                      padding: const EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.6),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '${_playlistSongs.length}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFD040A0).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    'PLAYLIST',
                    style: TextStyle(
                      fontSize: 8,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFD040A0),
                      letterSpacing: 1.0,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  widget.playlistName,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  '${_playlistSongs.length} songs',
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 4,
                  children: [
                    ElevatedButton.icon(
                      onPressed: _playlistSongs.isEmpty
                          ? null
                          : () {
                              _audioService.setPlaylist(
                                _playlistSongs,
                                startIndex: 0,
                              );
                              setState(() {});
                            },
                      icon: const Icon(Icons.play_arrow, size: 14),
                      label: const Text(
                        'Play All',
                        style: TextStyle(fontSize: 11),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFD040A0),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 5,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: () {
                        _showAddSongDialog(context);
                      },
                      icon: const Icon(Icons.add, size: 14),
                      label: const Text('Add', style: TextStyle(fontSize: 11)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF282828),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 5,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.playlist_add, size: 80, color: Colors.grey[600]),
            const SizedBox(height: 16),
            const Text(
              'Playlist is empty',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Add songs to this playlist by tapping the "Add" button',
              style: TextStyle(fontSize: 16, color: Colors.grey[500]),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                _showAddSongDialog(context);
              },
              icon: const Icon(Icons.add),
              label: const Text('Add Your First Song'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFD040A0),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSongsList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _playlistSongs.length,
      itemBuilder: (context, index) {
        final song = _playlistSongs[index];
        final isCurrentSong =
            _audioService.currentSong == song['title'] &&
            _audioService.isPlaying;
        final coverPath = LyricsData.getCover(song['title']!);
        final hasCover = LyricsData.hasCover(song['title']!);

        return Dismissible(
          key: Key(song['title']! + index.toString()),
          direction: DismissDirection.endToStart,
          background: Container(
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(16),
            ),
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 20),
            child: const Icon(Icons.delete, color: Colors.white),
          ),
          onDismissed: (direction) {
            _removeSongFromPlaylist(index);
          },
          child: Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: isCurrentSong
                  ? const Color(0xFFD040A0).withOpacity(0.15)
                  : const Color(0xFF282828),
              borderRadius: BorderRadius.circular(16),
              border: isCurrentSong
                  ? Border.all(
                      color: const Color(0xFFD040A0).withOpacity(0.3),
                      width: 1,
                    )
                  : null,
            ),
            child: Row(
              children: [
                Container(
                  width: 45,
                  height: 45,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    image: hasCover && coverPath.isNotEmpty
                        ? DecorationImage(
                            image: AssetImage(coverPath),
                            fit: BoxFit.cover,
                          )
                        : null,
                    color: hasCover && coverPath.isNotEmpty
                        ? null
                        : (isCurrentSong
                              ? const Color(0xFFD040A0).withOpacity(0.3)
                              : const Color(0xFF1E1E1E)),
                  ),
                  child: (!hasCover || coverPath.isEmpty)
                      ? Center(
                          child: isCurrentSong
                              ? const Icon(
                                  Icons.equalizer,
                                  color: Color(0xFFD040A0),
                                  size: 24,
                                )
                              : Text(
                                  '${index + 1}',
                                  style: const TextStyle(
                                    color: Colors.grey,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                        )
                      : null,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        song['title']!,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: isCurrentSong
                              ? FontWeight.bold
                              : FontWeight.w600,
                          color: isCurrentSong
                              ? const Color(0xFFD040A0)
                              : Colors.white,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        song['artist']!,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.grey,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: Text(
                    song['duration'] ?? '3:00',
                    style: const TextStyle(fontSize: 13, color: Colors.grey),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    if (isCurrentSong) {
                      _audioService.togglePlayPause();
                    } else {
                      _audioService.setPlaylist(
                        _playlistSongs,
                        startIndex: index,
                      );
                    }
                    setState(() {});
                  },
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      gradient: isCurrentSong
                          ? null
                          : const LinearGradient(
                              colors: [Color(0xFFD040A0), Color(0xFF8A2BE2)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                      color: isCurrentSong ? const Color(0xFFD040A0) : null,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      isCurrentSong ? Icons.pause : Icons.play_arrow,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      body: Column(
        children: [
          Expanded(
            child: SafeArea(
              child: _isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFFD040A0),
                      ),
                    )
                  : ListView(
                      padding: const EdgeInsets.only(
                        left: 16,
                        right: 16,
                        top: 16,
                        bottom: 16,
                      ),
                      children: [
                        _buildTopBar(),
                        _buildPlaylistHeader(),
                        if (_playlistSongs.isEmpty)
                          _buildEmptyState()
                        else
                          _buildSongsList(),
                      ],
                    ),
            ),
          ),
          const MiniPlayer(),
        ],
      ),
    );
  }
}
