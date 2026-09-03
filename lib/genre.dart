import 'package:flutter/material.dart';
import 'package:singforme/audio_service.dart';
import 'package:singforme/mini_player.dart';
import 'package:singforme/lyrics_data.dart';

class GenreScreen extends StatefulWidget {
  final String genreName;

  const GenreScreen({super.key, required this.genreName});

  @override
  State<GenreScreen> createState() => _GenreScreenState();
}

class _GenreScreenState extends State<GenreScreen> {
  late final AudioService _audioService;
  late List<Map<String, String>> _songs;

  final Map<String, List<Map<String, String>>> _genreSongs = {
    'Pop': [
      {
        'title': 'Titik Nadir',
        'artist': "Kahitna ft. Monita Tahalea",
        'path': 'audio/song05.mp3',
        'duration': '5:05',
      },
      {
        'title': 'Charles (Self Cover)',
        'artist': 'balloon',
        'path': 'audio/song02.mp3',
        'duration': '3:49',
      },
      {
        'title': 'Nomad',
        'artist': 'balloon',
        'path': 'audio/song09.mp3',
        'duration': '3:51',
      },
    ],
    'Rock': [
      {
        'title': 'Smells Like Teen Spirit',
        'artist': 'Nirvana',
        'path': 'audio/song08.mp3',
        'duration': '5:01',
      },
      {
        'title': 'Wake Me Up When September Ends',
        'artist': 'Green Day',
        'path': 'audio/song03.mp3',
        'duration': '4:46',
      },
    ],
    'Hip-Hop': [
      {
        'title': 'Rap God',
        'artist': 'Eminem',
        'path': 'audio/song06.mp3',
        'duration': '6:10',
      },
    ],
    'Jazz': [
      {
        'title': 'My Way',
        'artist': 'Frank Sinatra',
        'path': 'audio/song07.mp3',
        'duration': '4:38',
      },
      {
        'title': 'My Way Of Life',
        'artist': 'Frank Sinatra',
        'path': 'audio/song04.mp3',
        'duration': '3:08',
      },
    ],
    'Metal': [
      {
        'title': 'Another Day',
        'artist': 'Dream Theater',
        'path': 'audio/song01.mp3',
        'duration': '4:30',
      },
      {
        'title': 'The Spirit Carries On',
        'artist': 'Dream Theater',
        'path': 'audio/song10.mp3',
        'duration': '6:38',
      },
    ],
    'Dangdut': [
      {
        'title': 'Wirang',
        'artist': 'Denny Caknan',
        'path': 'audio/song11.mp3',
        'duration': '5:12',
      },
    ],
    'EDM': [],
    'R&B': [],
  };

  final Map<String, Color> _genreColors = {
    'Pop': const Color(0xFFD040A0),
    'Rock': const Color(0xFFFF6B35),
    'Hip-Hop': const Color(0xFF00BCD4),
    'Jazz': const Color(0xFFFFB300),
    'Metal': const Color(0xFF607D8B),
    'Dangdut': const Color(0xFF4CAF50),
    'EDM': const Color(0xFF7C4DFF),
    'R&B': const Color(0xFFFF6B81),
  };

  final Map<String, Color> _genreColors2 = {
    'Pop': const Color(0xFF8A2BE2),
    'Rock': const Color(0xFFFF4757),
    'Hip-Hop': const Color(0xFF2196F3),
    'Jazz': const Color(0xFFFF6F00),
    'Metal': const Color(0xFF37474F),
    'Dangdut': const Color(0xFF2E7D32),
    'EDM': const Color(0xFF3D5AFE),
    'R&B': const Color(0xFFFF3D5C),
  };

  @override
  void initState() {
    super.initState();
    _audioService = AudioService();
    _songs = _genreSongs[widget.genreName] ?? [];
  }

  IconData _getGenreIcon(String genre) {
    switch (genre) {
      case 'Pop':
        return Icons.music_note;
      case 'Rock':
        return Icons.electric_bolt;
      case 'Hip-Hop':
        return Icons.mic;
      case 'Jazz':
        return Icons.piano;
      case 'Metal':
        return Icons.electric_bolt;
      case 'Dangdut':
        return Icons.celebration;
      case 'EDM':
        return Icons.auto_awesome;
      case 'R&B':
        return Icons.favorite;
      default:
        return Icons.category;
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
                  if (_songs.isNotEmpty) {
                    _audioService.setPlaylist(_songs, startIndex: 0);
                    setState(() {});
                  }
                },
              ),
              _buildOptionTile(
                icon: Icons.shuffle,
                title: 'Shuffle Play',
                onTap: () {
                  Navigator.pop(context);
                  if (_songs.isNotEmpty) {
                    final shuffled = List<Map<String, String>>.from(_songs);
                    shuffled.shuffle();
                    _audioService.setPlaylist(shuffled, startIndex: 0);
                    setState(() {});
                  }
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

  @override
  Widget build(BuildContext context) {
    final color1 = _genreColors[widget.genreName] ?? const Color(0xFF8A2BE2);
    final color2 = _genreColors2[widget.genreName] ?? const Color(0xFFD040A0);

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
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 8,
                    ),
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                            size: 28,
                          ),
                          onPressed: () => Navigator.pop(context),
                        ),
                        Expanded(
                          child: Text(
                            widget.genreName,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.more_vert,
                            color: Colors.white,
                            size: 28,
                          ),
                          onPressed: () {
                            _showOptionsMenu(context);
                          },
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Container(
                      height: 120,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        gradient: LinearGradient(
                          colors: [color1, color2],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            _getGenreIcon(widget.genreName),
                            size: 48,
                            color: Colors.white.withOpacity(0.8),
                          ),
                          const SizedBox(width: 16),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.genreName,
                                style: const TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                '${_songs.length} songs',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.white.withOpacity(0.8),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (_songs.isEmpty)
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.all(32),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.music_off, size: 80, color: Colors.grey),
                            SizedBox(height: 16),
                            Text(
                              'No songs in this genre yet',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Check back later for updates',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  else
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _songs.length,
                      itemBuilder: (context, index) {
                        final song = _songs[index];
                        final isCurrentSong =
                            _audioService.currentSong == song['title'] &&
                            _audioService.isPlaying;
                        final coverPath = LyricsData.getCover(song['title']!);
                        final hasCover = LyricsData.hasCover(song['title']!);

                        return Container(
                          margin: const EdgeInsets.only(bottom: 8),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: isCurrentSong
                                ? const Color(0xFFD040A0).withOpacity(0.15)
                                : const Color(0xFF282828),
                            borderRadius: BorderRadius.circular(16),
                            border: isCurrentSong
                                ? Border.all(
                                    color: const Color(
                                      0xFFD040A0,
                                    ).withOpacity(0.3),
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
                                            ? const Color(
                                                0xFFD040A0,
                                              ).withOpacity(0.3)
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
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  if (isCurrentSong) {
                                    _audioService.togglePlayPause();
                                  } else {
                                    _audioService.setPlaylist(
                                      _songs,
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
                                            colors: [
                                              Color(0xFFD040A0),
                                              Color(0xFF8A2BE2),
                                            ],
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                          ),
                                    color: isCurrentSong
                                        ? const Color(0xFFD040A0)
                                        : null,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    isCurrentSong
                                        ? Icons.pause
                                        : Icons.play_arrow,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
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
