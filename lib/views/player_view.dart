import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/audio_provider.dart';
import '../core/constants.dart';

class PlayerView extends StatelessWidget {
  const PlayerView({super.key});

  String _formatDuration(int totalSeconds) {
    final minutes = totalSeconds ~/ 60;
    final remainingSeconds = totalSeconds % 60;
    return '$minutes:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.keyboard_arrow_down_rounded, size: 30),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('NOW PLAYING'),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {},
          ),
        ],
      ),
      body: Consumer<AudioProvider>(
        builder: (context, audioProvider, child) {
          final track = audioProvider.currentTrack;
          if (track == null) {
            return const Center(child: Text('No track selected'));
          }

          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28.0, vertical: 16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Album Art Cover Container with shadows
                  Expanded(
                    child: Center(
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 20),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(AppConstants.primaryColorHex).withOpacity(0.3),
                              blurRadius: 40,
                              spreadRadius: 2,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(24),
                          child: Image.network(
                            track.coverUrl,
                            fit: BoxFit.cover,
                            height: MediaQuery.of(context).size.width * 0.8,
                            width: MediaQuery.of(context).size.width * 0.8,
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Metadata Text Details
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  track.title,
                                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                    fontSize: 24,
                                    fontFamily: 'SpaceGrotesk',
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  track.artist,
                                  style: const TextStyle(
                                    color: Colors.grey,
                                    fontSize: 16,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.favorite_border_rounded, size: 28, color: Colors.grey),
                            onPressed: () {},
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // Slider & Time Display
                      Column(
                        children: [
                          SliderTheme(
                            data: SliderThemeData(
                              activeTrackColor: const Color(AppConstants.primaryColorHex),
                              inactiveTrackColor: Colors.white.withOpacity(0.1),
                              thumbColor: Colors.white,
                              trackHeight: 4.0,
                              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6.0),
                              overlayColor: const Color(AppConstants.primaryColorHex).withOpacity(0.15),
                              overlayShape: const RoundSliderOverlayShape(overlayRadius: 14.0),
                            ),
                            child: Slider(
                              value: audioProvider.currentPosition.toDouble(),
                              min: 0,
                              max: track.duration.toDouble(),
                              onChanged: (value) {
                                audioProvider.seek(value.toInt());
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  _formatDuration(audioProvider.currentPosition),
                                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                                ),
                                Text(
                                  _formatDuration(track.duration),
                                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Controls Bar (Shuffle, Prev, Play, Next, Repeat)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Shuffle Button
                          IconButton(
                            icon: Icon(
                              Icons.shuffle_rounded,
                              color: audioProvider.isShuffle 
                                  ? const Color(AppConstants.secondaryColorHex) 
                                  : Colors.grey[600],
                              size: 24,
                            ),
                            onPressed: audioProvider.toggleShuffle,
                          ),
                          
                          // Skip Previous
                          IconButton(
                            icon: const Icon(Icons.skip_previous_rounded, color: Colors.white, size: 36),
                            onPressed: audioProvider.previous,
                          ),
                          
                          // Main Play / Pause Button
                          GestureDetector(
                            onTap: audioProvider.togglePlay,
                            child: Container(
                              height: 72,
                              width: 72,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: LinearGradient(
                                  colors: [
                                    const Color(AppConstants.primaryColorHex),
                                    const Color(AppConstants.primaryColorHex).withOpacity(0.8),
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(AppConstants.primaryColorHex).withOpacity(0.4),
                                    blurRadius: 15,
                                    offset: const Offset(0, 5),
                                  )
                                ],
                              ),
                              child: Icon(
                                audioProvider.isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                                size: 38,
                                color: Colors.white,
                              ),
                            ),
                          ),

                          // Skip Next
                          IconButton(
                            icon: const Icon(Icons.skip_next_rounded, color: Colors.white, size: 36),
                            onPressed: audioProvider.next,
                          ),

                          // Repeat Mode
                          IconButton(
                            icon: Icon(
                              audioProvider.repeatMode == RepeatMode.one 
                                  ? Icons.repeat_one_rounded 
                                  : Icons.repeat_rounded,
                              color: audioProvider.repeatMode != RepeatMode.off 
                                  ? const Color(AppConstants.secondaryColorHex) 
                                  : Colors.grey[600],
                              size: 24,
                            ),
                            onPressed: audioProvider.toggleRepeat,
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
