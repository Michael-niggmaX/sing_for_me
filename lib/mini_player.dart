import 'package:flutter/material.dart';
import 'package:singforme/audio_service.dart';
import 'package:singforme/now_playing.dart';
import 'package:singforme/lyrics_data.dart';

class MiniPlayer extends StatefulWidget {
  const MiniPlayer({super.key});

  @override
  State<MiniPlayer> createState() => _MiniPlayerState();
}

class _MiniPlayerState extends State<MiniPlayer> {
  late final AudioService _audioService;
  bool _hasSong = false;

  @override
  void initState() {
    super.initState();
    _audioService = AudioService();
    _audioService.addListener(_update);
    _checkSong();
  }

  void _update() {
    if (mounted) {
      setState(() {
        _hasSong = _audioService.currentSong.isNotEmpty;
      });
    }
  }

  void _checkSong() {
    setState(() {
      _hasSong = _audioService.currentSong.isNotEmpty;
    });
  }

  @override
  void dispose() {
    _audioService.removeListener(_update);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_hasSong) {
      return const SizedBox.shrink();
    }

    final currentSong = _audioService.currentSong;
    final currentArtist = _audioService.currentArtist;
    final coverPath = LyricsData.getCover(currentSong);
    final hasCover = LyricsData.hasCover(currentSong) && coverPath.isNotEmpty;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const NowPlayingScreen()),
        ).then((_) {
          setState(() {});
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: const Color(0xFF2A1525),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(12),
            topRight: Radius.circular(12),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.5),
              blurRadius: 8,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    image: hasCover
                        ? DecorationImage(
                            image: AssetImage(coverPath),
                            fit: BoxFit.cover,
                          )
                        : null,
                    color: hasCover ? null : const Color(0xFFD040A0),
                  ),
                  child: hasCover
                      ? null
                      : const Icon(Icons.music_note, color: Colors.white),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        currentSong.isEmpty ? 'No Song Playing' : currentSong,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        currentArtist.isEmpty
                            ? 'Unknown Artist'
                            : currentArtist,
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(
                    _audioService.isPlaying
                        ? Icons.pause_circle_filled
                        : Icons.play_circle_fill,
                    color: const Color(0xFFD040A0),
                    size: 36,
                  ),
                  onPressed: () {
                    _audioService.togglePlayPause();
                    setState(() {});
                  },
                ),
              ],
            ),
            if (_audioService.duration.inSeconds > 0)
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  thumbShape: const RoundSliderThumbShape(
                    enabledThumbRadius: 3,
                  ),
                  trackHeight: 2,
                ),
                child: Slider(
                  activeColor: const Color(0xFFD040A0),
                  inactiveColor: Colors.grey.shade800,
                  min: 0,
                  max: _audioService.duration.inSeconds.toDouble(),
                  value: _audioService.position.inSeconds
                      .clamp(0, _audioService.duration.inSeconds)
                      .toDouble(),
                  onChanged: (val) {
                    _audioService.seek(Duration(seconds: val.toInt()));
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
