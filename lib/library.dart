import 'package:flutter/material.dart';
import 'package:singforme/playlist.dart';
import 'package:singforme/artist.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key});

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  List<String> _followedArtists = [];
  bool _isLoading = true;

  final List<String> _allArtists = const [
    'Dream Theater',
    'balloon',
    'Green Day',
    'Frank Sinatra',
    'Kahitna',
    'Eminem',
    'Nirvana',
    'Denny Caknan',
  ];

  final List<String> _playlists = const [
    'Favorites',
    'Workout Mix',
    'Chill Vibes',
    'Road Trip',
  ];

  @override
  void initState() {
    super.initState();
    _loadFollowedArtists();
  }

  Future<void> _loadFollowedArtists() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final key = 'following_artists';
      final jsonString = prefs.getString(key);

      if (jsonString != null && jsonString.isNotEmpty) {
        final List<dynamic> following = jsonDecode(jsonString);
        setState(() {
          _followedArtists = following.map((e) => e.toString()).toList();
          _isLoading = false;
        });
      } else {
        setState(() {
          _followedArtists = [];
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error loading followed artists: $e');
      setState(() {
        _followedArtists = [];
        _isLoading = false;
      });
    }
  }

  Future<void> _followArtist(String artistName) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final key = 'following_artists';
      final jsonString = prefs.getString(key);
      List<dynamic> following = jsonString != null && jsonString.isNotEmpty
          ? jsonDecode(jsonString)
          : [];

      if (!following.contains(artistName)) {
        following.add(artistName);
        await prefs.setString(key, jsonEncode(following));
        setState(() {
          _followedArtists = following.map((e) => e.toString()).toList();
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Now following $artistName ❤️'),
            backgroundColor: const Color(0xFFD040A0),
            duration: const Duration(seconds: 2),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Already following this artist'),
            backgroundColor: Colors.orange,
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      print('Error following artist: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  void _showDiscoverArtistsDialog() {
    final List<String> availableArtists = _allArtists
        .where((artist) => !_followedArtists.contains(artist))
        .toList();

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
                      'Discover Artists',
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
                if (availableArtists.isEmpty)
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
                            "You're following all artists!",
                            style: TextStyle(color: Colors.grey, fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  )
                else
                  Expanded(
                    child: ListView.builder(
                      itemCount: availableArtists.length,
                      itemBuilder: (context, index) {
                        final artistName = availableArtists[index];
                        final color = _getArtistColor(artistName);
                        final initials = _getInitials(artistName);

                        return ListTile(
                          leading: CircleAvatar(
                            backgroundColor: color,
                            child: Text(
                              initials,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ),
                          title: Text(
                            artistName,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          trailing: IconButton(
                            icon: const Icon(
                              Icons.add_circle,
                              color: Color(0xFFD040A0),
                              size: 28,
                            ),
                            onPressed: () {
                              _followArtist(artistName);
                              Navigator.pop(context);
                              _showDiscoverArtistsDialog();
                            },
                          ),
                          onTap: () {
                            Navigator.pop(context);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    ArtistDetailScreen(artistName: artistName),
                              ),
                            );
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

  Color _getPlaylistColor(int index) {
    const colors = [
      Color(0xFF8A2BE2),
      Color(0xFFD040A0),
      Color(0xFF00BCD4),
      Color(0xFFFF6B35),
    ];
    return colors[index % colors.length];
  }

  Color _getArtistColor(String name) {
    const colors = [
      Color(0xFFE74C3C),
      Color(0xFF3498DB),
      Color(0xFF2ECC71),
      Color(0xFFF39C12),
      Color(0xFF9B59B6),
      Color(0xFF1ABC9C),
      Color(0xFFE67E22),
      Color(0xFF2C3E50),
    ];
    int hash = 0;
    for (int i = 0; i < name.length; i++) {
      hash = name.codeUnitAt(i) + ((hash << 5) - hash);
    }
    return colors[hash.abs() % colors.length];
  }

  String _getInitials(String name) {
    final parts = name.split(' ');
    if (parts.length >= 2) {
      return parts[0][0] + parts[1][0];
    }
    return name.substring(0, 2).toUpperCase();
  }

  Widget _buildPlaylistSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Your Playlists',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 16),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _playlists.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          PlaylistScreen(playlistName: _playlists[index]),
                    ),
                  );
                },
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF282828),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(12),
                            bottomLeft: Radius.circular(12),
                          ),
                          gradient: LinearGradient(
                            colors: [
                              _getPlaylistColor(index),
                              _getPlaylistColor(index).withOpacity(0.5),
                            ],
                            begin: Alignment.bottomLeft,
                            end: Alignment.topRight,
                          ),
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.music_note,
                            color: Colors.white,
                            size: 28,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          _playlists[index],
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(right: 16),
                        child: Icon(Icons.chevron_right, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildArtistSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Following Artists',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            TextButton(
              onPressed: _showDiscoverArtistsDialog,
              child: const Text(
                'Discover',
                style: TextStyle(
                  color: Color(0xFFD040A0),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        if (_isLoading)
          const Center(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: CircularProgressIndicator(color: Color(0xFFD040A0)),
            ),
          )
        else if (_followedArtists.isEmpty)
          Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: const Color(0xFF282828),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                Icon(Icons.person_add, size: 60, color: Colors.grey[600]),
                const SizedBox(height: 16),
                const Text(
                  'No artists followed yet',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Follow artists you love by tapping the "Follow" button',
                  style: TextStyle(fontSize: 14, color: Colors.grey[500]),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: _showDiscoverArtistsDialog,
                  icon: const Icon(Icons.search),
                  label: const Text('Discover Artists'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFD040A0),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                ),
              ],
            ),
          )
        else
          SizedBox(
            height: 160,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _followedArtists.length,
              itemBuilder: (context, index) {
                final artistName = _followedArtists[index];
                final color = _getArtistColor(artistName);
                final initials = _getInitials(artistName);

                return Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ArtistDetailScreen(artistName: artistName),
                        ),
                      );
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              colors: [color, color.withOpacity(0.5)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                          child: Center(
                            child: CircleAvatar(
                              radius: 32,
                              backgroundColor: Colors.white,
                              child: Text(
                                initials,
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: color,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        SizedBox(
                          width: 80,
                          child: Text(
                            artistName,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
      ],
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
                  top: 20,
                  bottom: 16,
                ),
                children: [
                  const Text(
                    'Library',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildPlaylistSection(),
                  const SizedBox(height: 30),
                  _buildArtistSection(),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
