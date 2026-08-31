import 'package:flutter/material.dart';
import 'package:singforme/audio_service.dart';
import 'package:singforme/mini_player.dart';
import 'package:singforme/lyrics_data.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class ArtistDetailScreen extends StatefulWidget {
  final String artistName;

  const ArtistDetailScreen({super.key, required this.artistName});

  @override
  State<ArtistDetailScreen> createState() => _ArtistDetailScreenState();
}

class _ArtistDetailScreenState extends State<ArtistDetailScreen> {
  late final AudioService _audioService;
  bool _isFollowing = false;
  bool _isLoading = true;
  bool _showFullBio = false;

  static const Map<String, Map<String, dynamic>> _artistsData = {
    'Dream Theater': {
      'image': 'assets/image/dreamtheater.jpg',
      'bio': 'Progressive metal band from Boston',
      'monthlyListeners': '2.5M',
      'songs': [
        {
          'title': 'Another Day',
          'path': 'audio/song01.mp3',
          'duration': '4:27',
        },
        {
          'title': 'The Spirit Carries On',
          'path': 'audio/song10.mp3',
          'duration': '6:38',
        },
      ],
    },
    'balloon': {
      'image': 'assets/image/balloon.webp',
      'bio': 'Indie musician from Japan',
      'monthlyListeners': '850K',
      'songs': [
        {
          'title': 'Charles (Self Cover)',
          'path': 'audio/song02.mp3',
          'duration': '3:49',
        },
        {'title': 'Nomad', 'path': 'audio/song09.mp3', 'duration': '3:51'},
      ],
    },
    'Green Day': {
      'image': 'assets/image/greenday.jpg',
      'bio': 'American punk rock band',
      'monthlyListeners': '15.8M',
      'songs': [
        {
          'title': 'Wake Me Up When September Ends',
          'path': 'audio/song03.mp3',
          'duration': '4:46',
        },
      ],
    },
    'Frank Sinatra': {
      'image': null,
      'bio': 'Legendary American singer and actor',
      'monthlyListeners': '18.2M',
      'songs': [
        {
          'title': 'My Way Of Life',
          'path': 'audio/song04.mp3',
          'duration': '3:08',
        },
        {'title': 'My Way', 'path': 'audio/song07.mp3', 'duration': '4:35'},
      ],
    },
    'Kahitna': {
      'image': null,
      'bio': 'Indonesian pop band',
      'monthlyListeners': '1.2M',
      'songs': [
        {
          'title': 'Titik Nadir',
          'path': 'audio/song05.mp3',
          'duration': '5:05',
        },
      ],
    },
    'Eminem': {
      'image': null,
      'bio': 'Rap icon from Detroit',
      'monthlyListeners': '45.3M',
      'songs': [
        {'title': 'Rap God', 'path': 'audio/song06.mp3', 'duration': '6:10'},
      ],
    },
    'Nirvana': {
      'image': 'assets/image/nirvana.webp',
      'bio': 'American rock band formed in Aberdeen, Washington, in 1987.',
      'monthlyListeners': '39.3M',
      'songs': [
        {
          'title': 'Smells Like Teen Spirit',
          'path': 'audio/song08.mp3',
          'duration': '4:39',
        },
      ],
    },
    'Denny Caknan': {
      'image': null,
      'bio': 'Indonesian Top Dangdut Singer',
      'monthlyListeners': '4.2M',
      'songs': [
        {'title': 'Wirang', 'path': 'audio/song11.mp3', 'duration': '5:12'},
      ],
    },
  };

  static const List<Color> _profileColors = [
    Color(0xFFD040A0),
    Color(0xFF8A2BE2),
    Color(0xFF00BCD4),
    Color(0xFFFF6B35),
    Color(0xFF4CAF50),
    Color(0xFFFFB300),
    Color(0xFF607D8B),
    Color(0xFFFF6B81),
    Color(0xFF7C4DFF),
    Color(0xFF2196F3),
  ];

  List<Map<String, String>> _artistSongs = [];
  String _bio = '';
  String _monthlyListeners = '';
  String? _imagePath;

  @override
  void initState() {
    super.initState();
    _audioService = AudioService();
    _loadArtistData();
    _checkFollowingStatus();
  }

  void _loadArtistData() {
    final data = _artistsData[widget.artistName];
    if (data != null) {
      final songs = data['songs'] as List;
      _artistSongs = songs
          .map(
            (s) => {
              'title': s['title'] as String,
              'artist': widget.artistName,
              'path': s['path'] as String,
              'duration': s['duration'] as String,
            },
          )
          .toList();
      _bio = data['bio'] as String;
      _monthlyListeners = data['monthlyListeners'] as String;
      _imagePath = data['image'] as String?;
    }
    setState(() {});
  }

  Future<void> _checkFollowingStatus() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final key = 'following_artists';
      final jsonString = prefs.getString(key);
      if (jsonString != null) {
        final List<dynamic> following = jsonDecode(jsonString);
        setState(() {
          _isFollowing = following.contains(widget.artistName);
          _isLoading = false;
        });
      } else {
        setState(() {
          _isFollowing = false;
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _isFollowing = false;
        _isLoading = false;
      });
    }
  }

  Future<void> _toggleFollow() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final key = 'following_artists';
      final jsonString = prefs.getString(key);
      List<dynamic> following = jsonString != null
          ? jsonDecode(jsonString)
          : [];

      setState(() {
        _isFollowing = !_isFollowing;
      });

      if (_isFollowing) {
        following.add(widget.artistName);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Following ${widget.artistName} ❤️'),
            backgroundColor: const Color(0xFFD040A0),
            duration: const Duration(seconds: 2),
          ),
        );
      } else {
        following.remove(widget.artistName);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Unfollowed ${widget.artistName}'),
            backgroundColor: Colors.grey,
            duration: const Duration(seconds: 2),
          ),
        );
      }

      await prefs.setString(key, jsonEncode(following));
      setState(() {});
    } catch (e) {
      print('Error toggling follow: $e');
    }
  }

  Color _getProfileColor(String name) {
    int hash = 0;
    for (int i = 0; i < name.length; i++) {
      hash = name.codeUnitAt(i) + ((hash << 5) - hash);
    }
    return _profileColors[hash.abs() % _profileColors.length];
  }

  String _getInitials(String name) {
    final parts = name.split(' ');
    if (parts.length >= 2) {
      return parts[0][0] + parts[1][0];
    }
    return name.substring(0, 2).toUpperCase();
  }

  String _getTruncatedBio() {
    if (_bio.length <= 80) return _bio;
    return _bio.substring(0, 80) + '...';
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
                icon: Icons.share,
                title: 'Share Artist',
                onTap: () => Navigator.pop(context),
              ),
              _buildOptionTile(
                icon: Icons.playlist_add,
                title: 'Add to Playlist',
                onTap: () => Navigator.pop(context),
              ),
              _buildOptionTile(
                icon: _isFollowing ? Icons.favorite : Icons.favorite_border,
                title: _isFollowing
                    ? 'Remove from Favorites'
                    : 'Add to Favorites',
                onTap: () {
                  Navigator.pop(context);
                  _toggleFollow();
                },
              ),
              _buildOptionTile(
                icon: Icons.info_outline,
                title: 'About Artist',
                onTap: () => Navigator.pop(context),
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
    final color = _getProfileColor(widget.artistName);
    final initials = _getInitials(widget.artistName);
    final hasImage = _imagePath != null;
    final displayBio = _showFullBio ? _bio : _getTruncatedBio();
    final isBioLong = _bio.length > 80;

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
                            widget.artistName,
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
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            image: hasImage
                                ? DecorationImage(
                                    image: AssetImage(_imagePath!),
                                    fit: BoxFit.cover,
                                  )
                                : null,
                            gradient: hasImage
                                ? null
                                : LinearGradient(
                                    colors: [color, color.withOpacity(0.5)],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                          ),
                          child: hasImage
                              ? null
                              : Center(
                                  child: CircleAvatar(
                                    radius: 28,
                                    backgroundColor: Colors.white,
                                    child: Text(
                                      initials,
                                      style: TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                        color: color,
                                      ),
                                    ),
                                  ),
                                ),
                        ),
                        const SizedBox(width: 12),
                        Flexible(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.artistName,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 2),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    displayBio,
                                    style: const TextStyle(
                                      fontSize: 11,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  if (isBioLong)
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          _showFullBio = !_showFullBio;
                                        });
                                      },
                                      child: Text(
                                        _showFullBio
                                            ? 'Read Less'
                                            : 'Read More',
                                        style: const TextStyle(
                                          fontSize: 11,
                                          color: Color(0xFFD040A0),
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                              const SizedBox(height: 2),
                              Text(
                                '${_artistSongs.length} songs • $_monthlyListeners',
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Wrap(
                                spacing: 8,
                                runSpacing: 4,
                                children: [
                                  ElevatedButton.icon(
                                    onPressed: _artistSongs.isEmpty
                                        ? null
                                        : () {
                                            _audioService.setPlaylist(
                                              _artistSongs,
                                              startIndex: 0,
                                            );
                                            setState(() {});
                                          },
                                    icon: const Icon(
                                      Icons.play_arrow,
                                      size: 14,
                                    ),
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
                                    onPressed: _toggleFollow,
                                    icon: Icon(
                                      _isFollowing ? Icons.check : Icons.add,
                                      size: 14,
                                    ),
                                    label: Text(
                                      _isFollowing ? 'Following' : 'Follow',
                                      style: const TextStyle(fontSize: 11),
                                    ),
                                    style: OutlinedButton.styleFrom(
                                      foregroundColor: _isFollowing
                                          ? Colors.green
                                          : Colors.white,
                                      side: BorderSide(
                                        color: _isFollowing
                                            ? Colors.green
                                            : Colors.white,
                                      ),
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
                  ),
                  if (_artistSongs.isEmpty)
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.all(32),
                        child: Text(
                          'No songs available',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                    )
                  else
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _artistSongs.length,
                      itemBuilder: (context, index) {
                        final song = _artistSongs[index];
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
                                      _artistSongs,
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
                                        : LinearGradient(
                                            colors: [
                                              const Color(0xFFD040A0),
                                              const Color(0xFF8A2BE2),
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

  @override
  void dispose() {
    super.dispose();
  }
}
