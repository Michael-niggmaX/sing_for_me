import 'package:flutter/material.dart';
import 'package:singforme/audio_service.dart';
import 'package:singforme/lyrics_data.dart';

class NowPlayingScreen extends StatefulWidget {
  const NowPlayingScreen({super.key});

  @override
  State<NowPlayingScreen> createState() => _NowPlayingScreenState();
}

class _NowPlayingScreenState extends State<NowPlayingScreen>
    with SingleTickerProviderStateMixin {
  late final AudioService _audioService;
  late AnimationController _animationController;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _audioService = AudioService();
    _audioService.addListener(_updateState);

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  void _updateState() {
    if (mounted) {
      setState(() {
        _isPlaying = _audioService.isPlaying;
      });
    }
  }

  @override
  void dispose() {
    _audioService.removeListener(_updateState);
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentSong = _audioService.currentSong;
    final currentArtist = _audioService.currentArtist;
    final coverPath = LyricsData.getCover(currentSong);
    final hasCover = LyricsData.hasCover(currentSong) && coverPath.isNotEmpty;
    final lyrics = LyricsData.getLyrics(currentSong);
    final hasLyrics = LyricsData.hasLyrics(currentSong);

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/bgvid.gif',
              fit: BoxFit.cover,
              gaplessPlayback: true,
            ),
          ),

          // Overlay gelap agar teks terbaca
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.black.withOpacity(0.7),
                    Colors.black.withOpacity(0.4),
                    Colors.black.withOpacity(0.8),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: const [0.0, 0.3, 1.0],
                ),
              ),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                _buildTopBar(),

                // Album Art
                Expanded(
                  flex: 2,
                  child: Center(
                    child: Hero(
                      tag: 'album_art',
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.85,
                        height: MediaQuery.of(context).size.width * 0.85,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          image: hasCover && coverPath.isNotEmpty
                              ? DecorationImage(
                                  image: AssetImage(coverPath),
                                  fit: BoxFit.cover,
                                )
                              : null,
                          gradient: hasCover && coverPath.isNotEmpty
                              ? null
                              : const LinearGradient(
                                  colors: [
                                    Color(0xFFD040A0),
                                    Color(0xFF8A2BE2),
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFFD040A0).withOpacity(0.3),
                              blurRadius: 50,
                              offset: const Offset(0, 20),
                            ),
                          ],
                        ),
                        child: (!hasCover || coverPath.isEmpty)
                            ? const Center(
                                child: Icon(
                                  Icons.music_note,
                                  size: 100,
                                  color: Colors.white,
                                ),
                              )
                            : null,
                      ),
                    ),
                  ),
                ),

                // Song Info
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 16,
                  ),
                  child: Column(
                    children: [
                      Text(
                        currentSong.isEmpty ? 'No Song Playing' : currentSong,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        currentArtist.isEmpty
                            ? 'Unknown Artist'
                            : currentArtist,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),

                // Progress Bar
                _buildProgressBar(),

                // Controls
                _buildControls(),

                // Lyrics
                _buildLyrics(lyrics, hasLyrics),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(
              Icons.arrow_downward,
              color: Colors.white,
              size: 28,
            ),
            onPressed: () => Navigator.pop(context),
          ),
          const Text(
            'Now Playing',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.white, size: 28),
            onPressed: _showOptionsMenu,
          ),
        ],
      ),
    );
  }

  Widget _buildProgressBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
              trackHeight: 4,
              activeTrackColor: const Color(0xFFD040A0),
              inactiveTrackColor: Colors.grey[800],
              thumbColor: const Color(0xFFD040A0),
              overlayColor: const Color(0xFFD040A0).withOpacity(0.2),
            ),
            child: Slider(
              value: _audioService.position.inSeconds.toDouble(),
              max: _audioService.duration.inSeconds.toDouble(),
              onChanged: (value) {
                _audioService.seek(Duration(seconds: value.toInt()));
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _formatDuration(_audioService.position),
                style: const TextStyle(color: Colors.grey, fontSize: 12),
              ),
              Text(
                _formatDuration(_audioService.duration),
                style: const TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildControls() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(
            icon: const Icon(Icons.shuffle, color: Colors.grey, size: 28),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(
              Icons.skip_previous,
              color: Colors.white,
              size: 36,
            ),
            onPressed: _audioService.previousTrack,
          ),
          GestureDetector(
            onTap: () {
              _audioService.togglePlayPause();
            },
            child: Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFD040A0), Color(0xFF8A2BE2)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFD040A0).withOpacity(0.3),
                    blurRadius: 30,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Icon(
                _isPlaying ? Icons.pause : Icons.play_arrow,
                color: Colors.white,
                size: 40,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.skip_next, color: Colors.white, size: 36),
            onPressed: _audioService.nextTrack,
          ),
          IconButton(
            icon: const Icon(Icons.repeat, color: Colors.grey, size: 28),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildLyrics(String lyrics, bool hasLyrics) {
    return Expanded(
      flex: 2,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.6),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withOpacity(0.1), width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Lyrics',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                if (_isPlaying)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFD040A0).withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 6,
                          height: 6,
                          decoration: const BoxDecoration(
                            color: Color(0xFFD040A0),
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Text(
                          'Playing',
                          style: TextStyle(
                            fontSize: 10,
                            color: Color(0xFFD040A0),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Expanded(
              child: SingleChildScrollView(
                child: Text(
                  lyrics,
                  style: TextStyle(
                    fontSize: 14,
                    height: 1.8,
                    color: hasLyrics ? Colors.white70 : Colors.grey[500],
                    fontStyle: hasLyrics ? FontStyle.normal : FontStyle.italic,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showOptionsMenu() {
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
                icon: Icons.favorite_border,
                title: 'Add to Favorites',
                onTap: () => Navigator.pop(context),
              ),
              _buildOptionTile(
                icon: Icons.playlist_add,
                title: 'Add to Playlist',
                onTap: () => Navigator.pop(context),
              ),
              _buildOptionTile(
                icon: Icons.share,
                title: 'Share',
                onTap: () => Navigator.pop(context),
              ),
              _buildOptionTile(
                icon: Icons.equalizer,
                title: 'Equalizer',
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

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }
}
