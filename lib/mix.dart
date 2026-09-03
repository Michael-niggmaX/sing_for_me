import 'package:flutter/material.dart';
import 'package:singforme/audio_service.dart';
import 'package:singforme/mini_player.dart';
import 'package:singforme/lyrics_data.dart';

class MixScreen extends StatefulWidget {
  final String mixName;

  const MixScreen({super.key, required this.mixName});

  @override
  State<MixScreen> createState() => _MixScreenState();
}

class _MixScreenState extends State<MixScreen> {
  late final AudioService _audioService;

  final List<Map<String, String>> _mixSongs = const [
    {
      'title': 'Another Day',
      'artist': 'Dream Theater',
      'path': 'audio/song01.mp3',
      'duration': '4:27',
    },
    {
      'title': 'Wake Me Up When September Ends',
      'artist': 'Green Day',
      'path': 'audio/song03.mp3',
      'duration': '4:46',
    },
  ];

  @override
  void initState() {
    super.initState();
    _audioService = AudioService();
  }

  void _shuffleAndPlay() {
    final shuffledList = List<Map<String, String>>.from(_mixSongs);
    shuffledList.shuffle();
    _audioService.setPlaylist(shuffledList, startIndex: 0);
    setState(() {});
  }

  String _getTotalDuration() {
    int totalSeconds = 0;
    for (var song in _mixSongs) {
      final duration = song['duration'] ?? '3:00';
      final parts = duration.split(':');
      if (parts.length == 2) {
        totalSeconds += int.parse(parts[0]) * 60 + int.parse(parts[1]);
      }
    }
    final minutes = (totalSeconds / 60).floor();
    final hours = (minutes / 60).floor();
    if (hours > 0) {
      return '$hours hr ${minutes % 60} min';
    }
    return '$minutes min';
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
                  _audioService.setPlaylist(_mixSongs, startIndex: 0);
                  setState(() {});
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
  }) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFFD040A0)),
      title: Text(
        title,
        style: const TextStyle(color: Colors.white, fontSize: 16),
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
              widget.mixName,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              overflow: TextOverflow.ellipsis,
            ),
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

  Widget _buildMixHeader() {
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
                colors: [
                  Color(0xFFD040A0),
                  Color(0xFF8A2BE2),
                  Color(0xFF6C5CE7),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: const Center(
              child: Icon(Icons.album, size: 32, color: Colors.white),
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
                    'MIX',
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
                  widget.mixName,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  '${_mixSongs.length} songs • ${_getTotalDuration()}',
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 4,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () {
                        _audioService.setPlaylist(_mixSongs, startIndex: 0);
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
                    OutlinedButton.icon(
                      onPressed: () {
                        _shuffleAndPlay();
                      },
                      icon: const Icon(Icons.shuffle, size: 14),
                      label: const Text(
                        'Shuffle',
                        style: TextStyle(fontSize: 11),
                      ),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white,
                        side: const BorderSide(color: Colors.grey),
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

  Widget _buildSongsList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _mixSongs.length,
      itemBuilder: (context, index) {
        final song = _mixSongs[index];
        final isCurrentSong =
            _audioService.currentSong == song['title'] &&
            _audioService.isPlaying;
        final coverPath = LyricsData.getCover(song['title']!);
        final hasCover = LyricsData.hasCover(song['title']!);

        return Container(
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
                      style: const TextStyle(fontSize: 13, color: Colors.grey),
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
                    _audioService.setPlaylist(_mixSongs, startIndex: index);
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
              child: ListView(
                padding: const EdgeInsets.only(
                  left: 16,
                  right: 16,
                  top: 16,
                  bottom: 16,
                ),
                children: [
                  _buildTopBar(),
                  _buildMixHeader(),
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
