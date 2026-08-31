import 'package:flutter/material.dart';
import 'package:singforme/genre.dart';
import 'package:singforme/audio_service.dart';
import 'package:singforme/artist.dart';
import 'package:singforme/lyrics_data.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  late final AudioService _audioService;

  final List<Map<String, dynamic>> _genres = const [
    {'name': 'Pop', 'color1': Color(0xFFD040A0), 'color2': Color(0xFF8A2BE2)},
    {'name': 'Rock', 'color1': Color(0xFFFF6B35), 'color2': Color(0xFFFF4757)},
    {
      'name': 'Hip-Hop',
      'color1': Color(0xFF00BCD4),
      'color2': Color(0xFF2196F3),
    },
    {'name': 'Jazz', 'color1': Color(0xFFFFB300), 'color2': Color(0xFFFF6F00)},
    {'name': 'Metal', 'color1': Color(0xFF607D8B), 'color2': Color(0xFF37474F)},
    {
      'name': 'Dangdut',
      'color1': Color(0xFF4CAF50),
      'color2': Color(0xFF2E7D32),
    },
    {'name': 'EDM', 'color1': Color(0xFF7C4DFF), 'color2': Color(0xFF3D5AFE)},
    {'name': 'R&B', 'color1': Color(0xFFFF6B81), 'color2': Color(0xFFFF3D5C)},
  ];

  final List<Map<String, dynamic>> _searchResults = const [
    {
      'title': 'Green Day',
      'artist': '',
      'type': 'Artist',
      'path': '',
      'duration': '',
    },
    {
      'title': 'Dream Theater',
      'artist': '',
      'type': 'Artist',
      'path': '',
      'duration': '',
    },
    {
      'title': 'balloon',
      'artist': '',
      'type': 'Artist',
      'path': '',
      'duration': '',
    },
    {
      'title': 'Nirvana',
      'artist': '',
      'type': 'Artist',
      'path': '',
      'duration': '',
    },
    {
      'title': 'Denny Caknan',
      'artist': '',
      'type': 'Artist',
      'path': '',
      'duration': '',
    },
    {
      'title': 'Kahitna',
      'artist': '',
      'type': 'Artist',
      'path': '',
      'duration': '',
    },
    {
      'title': 'Eminem',
      'artist': '',
      'type': 'Artist',
      'path': '',
      'duration': '',
    },
    {
      'title': 'Frank Sinatra',
      'artist': '',
      'type': 'Artist',
      'path': '',
      'duration': '',
    },
    {
      'title': 'Wake Me Up When September Ends',
      'artist': 'Green Day',
      'type': 'Song',
      'path': 'audio/song03.mp3',
      'duration': '4:45',
    },
    {
      'title': 'My Way Of Life',
      'artist': 'Frank Sinatra',
      'type': 'Song',
      'path': 'audio/song04.mp3',
      'duration': '3:08',
    },
    {
      'title': 'Another Day',
      'artist': 'Dream Theater',
      'type': 'Song',
      'path': 'audio/song01.mp3',
      'duration': '4:30',
    },
    {
      'title': 'Charles (Self Cover)',
      'artist': 'balloon',
      'type': 'Song',
      'path': 'audio/song02.mp3',
      'duration': '3:49',
    },
    {
      'title': 'Titik Nadir',
      'artist': 'Kahitna',
      'type': 'Song',
      'path': 'audio/song05.mp3',
      'duration': '5:05',
    },
    {
      'title': 'Rap God',
      'artist': 'Eminem',
      'type': 'Song',
      'path': 'audio/song06.mp3',
      'duration': '6:10',
    },
    {
      'title': 'My Way',
      'artist': 'Frank Sinatra',
      'type': 'Song',
      'path': 'audio/song07.mp3',
      'duration': '4:38',
    },
    {
      'title': 'The Spirit Carries On',
      'artist': 'Dream Theater',
      'type': 'Song',
      'path': 'audio/song10.mp3',
      'duration': '6:38',
    },
    {
      'title': 'Wirang',
      'artist': 'Denny Caknan',
      'type': 'Song',
      'path': 'audio/song11.mp3',
      'duration': '5:12',
    },
    {
      'title': 'Smells Like Teen Spirit',
      'artist': 'Nirvana',
      'type': 'Song',
      'path': 'audio/song08.mp3',
      'duration': '5:01',
    },
    {
      'title': 'Nomad',
      'artist': 'balloon',
      'type': 'Song',
      'path': 'audio/song09.mp3',
      'duration': '3:51',
    },
  ];

  final List<Map<String, String>> _allSongs = const [
    {
      'title': 'Another Day',
      'artist': 'Dream Theater',
      'path': 'audio/song01.mp3',
      'duration': '4:30',
    },
    {
      'title': 'Charles (Self Cover)',
      'artist': 'balloon',
      'path': 'audio/song02.mp3',
      'duration': '3:45',
    },
    {
      'title': 'Wake Me Up When September Ends',
      'artist': 'Green Day',
      'path': 'audio/song03.mp3',
      'duration': '4:45',
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
      'title': 'Smells Like Teen Spirit',
      'artist': 'Nirvana',
      'path': 'audio/song08.mp3',
      'duration': '4:39',
    },
    {
      'title': 'Nomad',
      'artist': 'balloon',
      'path': 'audio/song09.mp3',
      'duration': '3:51',
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
  ];

  @override
  void initState() {
    super.initState();
    _audioService = AudioService();
  }

  List<Map<String, dynamic>> get _filteredGenres {
    if (_searchQuery.isEmpty) return _genres;
    return _genres
        .where(
          (genre) =>
              genre['name'].toLowerCase().contains(_searchQuery.toLowerCase()),
        )
        .toList();
  }

  List<Map<String, dynamic>> get _filteredResults {
    if (_searchQuery.isEmpty) return [];
    return _searchResults.where((result) {
      final title = result['title']?.toLowerCase() ?? '';
      final artist = result['artist']?.toLowerCase() ?? '';
      final query = _searchQuery.toLowerCase();
      return title.contains(query) || artist.contains(query);
    }).toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Widget _buildSearchBar() {
    return TextField(
      controller: _searchController,
      style: const TextStyle(color: Colors.white),
      onChanged: (value) {
        setState(() {
          _searchQuery = value;
        });
      },
      decoration: InputDecoration(
        hintText: 'Songs, Artists, or Genres',
        hintStyle: const TextStyle(color: Colors.grey),
        prefixIcon: const Icon(Icons.search, color: Colors.grey),
        suffixIcon: _searchQuery.isNotEmpty
            ? IconButton(
                icon: const Icon(Icons.clear, color: Colors.grey),
                onPressed: () {
                  setState(() {
                    _searchController.clear();
                    _searchQuery = '';
                  });
                },
              )
            : null,
        filled: true,
        fillColor: const Color(0xFF282828),
        contentPadding: const EdgeInsets.symmetric(vertical: 0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFD040A0), width: 1.5),
        ),
      ),
    );
  }

  Widget _buildGenresSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Browse Genres',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 16),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 2.2,
          ),
          itemCount: _filteredGenres.length,
          itemBuilder: (context, index) {
            final genre = _filteredGenres[index];
            return InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => GenreScreen(genreName: genre['name']),
                  ),
                );
              },
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  gradient: LinearGradient(
                    colors: [genre['color1'], genre['color2']],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      genre['name'],
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const Icon(
                      Icons.chevron_right,
                      color: Colors.white,
                      size: 28,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildSearchResults() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Results for "${_searchQuery}"',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 16),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _filteredResults.length,
          itemBuilder: (context, index) {
            final result = _filteredResults[index];
            return _buildResultItem(result);
          },
        ),
        const SizedBox(height: 16),
        if (_filteredGenres.isNotEmpty)
          TextButton.icon(
            onPressed: () {
              setState(() {
                _searchController.clear();
                _searchQuery = '';
              });
            },
            icon: const Icon(Icons.category, color: Color(0xFFD040A0)),
            label: const Text(
              'Browse all genres',
              style: TextStyle(
                color: Color(0xFFD040A0),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildResultItem(Map<String, dynamic> result) {
    final String title = result['title'] ?? 'Unknown';
    final String artist = result['artist'] ?? '';
    final String type = result['type'] ?? 'Unknown';
    final String path = result['path'] ?? '';
    final String duration = result['duration'] ?? '3:00';

    IconData icon;
    Color iconColor;

    switch (type) {
      case 'Song':
        icon = Icons.music_note;
        iconColor = const Color(0xFFD040A0);
        break;
      case 'Artist':
        icon = Icons.person;
        iconColor = const Color(0xFF8A2BE2);
        break;
      case 'Playlist':
        icon = Icons.playlist_play;
        iconColor = const Color(0xFFFF6B35);
        break;
      default:
        icon = Icons.search;
        iconColor = Colors.grey;
    }

    final isCurrentSong =
        type == 'Song' &&
        _audioService.currentSong == title &&
        _audioService.isPlaying;

    return GestureDetector(
      onTap: () {
        if (type == 'Song' && path.isNotEmpty) {
          _playSong(result);
        } else if (type == 'Artist' && title.isNotEmpty) {
          _navigateToArtist(title);
        }
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isCurrentSong
              ? const Color(0xFFD040A0).withOpacity(0.15)
              : const Color(0xFF282828),
          borderRadius: BorderRadius.circular(12),
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
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: isCurrentSong
                    ? const Color(0xFFD040A0).withOpacity(0.3)
                    : iconColor.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                isCurrentSong ? Icons.equalizer : icon,
                color: isCurrentSong ? const Color(0xFFD040A0) : iconColor,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: isCurrentSong
                          ? const Color(0xFFD040A0)
                          : Colors.white,
                      fontWeight: isCurrentSong
                          ? FontWeight.bold
                          : FontWeight.bold,
                      fontSize: 16,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (artist.isNotEmpty)
                    Text(
                      artist,
                      style: TextStyle(
                        color: isCurrentSong
                            ? const Color(0xFFD040A0).withOpacity(0.7)
                            : Colors.grey,
                        fontSize: 13,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                ],
              ),
            ),
            if (type == 'Song' && duration.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Text(
                  duration,
                  style: const TextStyle(fontSize: 13, color: Colors.grey),
                ),
              ),
            if (type == 'Song' && path.isNotEmpty)
              GestureDetector(
                onTap: () {
                  if (isCurrentSong) {
                    _audioService.togglePlayPause();
                  } else {
                    _playSong(result);
                  }
                },
                child: Container(
                  width: 32,
                  height: 32,
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
                    size: 16,
                  ),
                ),
              ),
            Container(
              margin: const EdgeInsets.only(left: 8),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                type,
                style: TextStyle(
                  color: iconColor,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _playSong(Map<String, dynamic> result) {
    final String title = result['title'] ?? 'Unknown';
    final String artist = result['artist'] ?? 'Unknown Artist';
    final String path = result['path'] ?? 'audio/song02.mp3';
    final String duration = result['duration'] ?? '3:00';

    final song = {
      'title': title,
      'artist': artist,
      'path': path,
      'duration': duration,
    };

    final songExists = _allSongs.any((s) => s['title'] == song['title']);

    if (songExists) {
      final playlist = _allSongs
          .map(
            (s) => {
              'title': s['title']!,
              'artist': s['artist']!,
              'path': s['path']!,
              'duration': s['duration'] ?? '3:00',
            },
          )
          .toList();

      final index = _allSongs.indexWhere((s) => s['title'] == song['title']);
      _audioService.setPlaylist(playlist, startIndex: index);
      setState(() {});
    } else {
      _audioService.playSong(
        title: song['title']!,
        artist: song['artist']!,
        assetPath: song['path']!,
      );
    }
  }

  void _navigateToArtist(String artistName) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ArtistDetailScreen(artistName: artistName),
      ),
    );
  }

  Widget _buildNoResults() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 40),
        child: Column(
          children: [
            Icon(Icons.search_off, size: 80, color: Colors.grey[600]),
            const SizedBox(height: 16),
            Text(
              'No results found for "${_searchQuery}"',
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Try searching for songs, artists, or genres',
              style: TextStyle(color: Colors.grey[600], fontSize: 14),
            ),
            const SizedBox(height: 20),
            TextButton.icon(
              onPressed: () {
                setState(() {
                  _searchController.clear();
                  _searchQuery = '';
                });
              },
              icon: const Icon(Icons.clear, color: Color(0xFFD040A0)),
              label: const Text(
                'Clear search',
                style: TextStyle(
                  color: Color(0xFFD040A0),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
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
                  bottom: 90,
                ),
                children: [
                  const Text(
                    'Search',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildSearchBar(),
                  const SizedBox(height: 24),
                  if (_searchQuery.isNotEmpty && _filteredResults.isNotEmpty)
                    _buildSearchResults()
                  else if (_searchQuery.isNotEmpty && _filteredResults.isEmpty)
                    _buildNoResults()
                  else
                    _buildGenresSection(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
