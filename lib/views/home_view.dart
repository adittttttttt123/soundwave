import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/audio_provider.dart';
import '../models/track.dart';
import 'player_view.dart';
import '../core/constants.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  String _formatDuration(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '$minutes:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            // Background Glows
            Positioned(
              top: -100,
              right: -100,
              child: Container(
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(AppConstants.primaryColorHex).withOpacity(0.15),
                  filter: const ImageFilter.blur(sigmaX: 100, sigmaY: 100),
                ),
              ),
            ),
            
            // Core Page Contents
            Padding(
              padding: const EdgeInsets.only(bottom: 80.0),
              child: CustomScrollView(
                slivers: [
                  // Beautiful Custom Premium Header
                  SliverAppBar(
                    expandedHeight: 120.0,
                    floating: false,
                    pinned: true,
                    flexibleSpace: FlexibleSpaceBar(
                      titlePadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                      centerTitle: false,
                      title: RichText(
                        text: const TextSpan(
                          style: TextStyle(
                            fontFamily: 'SpaceGrotesk',
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          children: [
                            TextSpan(text: 'Sound'),
                            TextSpan(
                              text: 'Wave',
                              style: TextStyle(color: Color(AppConstants.primaryColorHex)),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // Track Listing Grid / List
                  Consumer<AudioProvider>(
                    builder: (context, audioProvider, child) {
                      return SliverPadding(
                        padding: const EdgeInsets.symmetric(horizontal: 24.0),
                        sliver: SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              final Track track = audioProvider.queue[index];
                              final bool isCurrent = audioProvider.currentTrack?.id == track.id;

                              return Container(
                                margin: const EdgeInsets.only(bottom: 12),
                                child: InkWell(
                                  onTap: () => audioProvider.selectTrack(track.id),
                                  borderRadius: BorderRadius.circular(12),
                                  child: Card(
                                    margin: EdgeInsets.zero,
                                    child: Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: Row(
                                        children: [
                                          // Track Artwork Cover
                                          ClipRRect(
                                            borderRadius: BorderRadius.circular(8),
                                            child: Image.network(
                                              track.coverUrl,
                                              width: 50,
                                              height: 50,
                                              fit: BoxFit.cover,
                                              errorBuilder: (context, error, stackTrace) {
                                                return Container(
                                                  width: 50,
                                                  height: 50,
                                                  color: Colors.grey[900],
                                                  child: const Icon(Icons.music_note, color: Colors.white30),
                                                );
                                              },
                                            ),
                                          ),
                                          const SizedBox(width: 16),
                                          
                                          // Title & Artist
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  track.title,
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16,
                                                    color: isCurrent 
                                                        ? const Color(AppConstants.primaryColorHex) 
                                                        : Colors.white,
                                                  ),
                                                  maxLines: 1,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                                const SizedBox(height: 4),
                                                Text(
                                                  track.artist,
                                                  style: TextStyle(
                                                    color: Colors.grey[400],
                                                    fontSize: 13,
                                                  ),
                                                  maxLines: 1,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              ],
                                            ),
                                          ),
                                          
                                          // Duration or Playing Animation indicator
                                          if (isCurrent && audioProvider.isPlaying)
                                            const Icon(Icons.volume_up, color: Color(AppConstants.primaryColorHex))
                                          else
                                            Text(
                                              _formatDuration(track.duration),
                                              style: TextStyle(
                                                color: Colors.grey[600],
                                                fontSize: 12,
                                              ),
                                            ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                            childCount: audioProvider.queue.length,
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),

            // Persistent Floating Media Player Bar
            Positioned(
              bottom: 16,
              left: 16,
              right: 16,
              child: Consumer<AudioProvider>(
                builder: (context, audioProvider, child) {
                  final track = audioProvider.currentTrack;
                  if (track == null) return const SizedBox.shrink();

                  return GestureDetector(
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const PlayerView(),
                      ),
                    ),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      decoration: BoxDecoration(
                        color: const Color(AppConstants.cardBackgroundColorHex),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.white.withOpacity(0.08)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.5),
                            blurRadius: 20,
                            offset: const Offset(0, 5),
                          )
                        ],
                      ),
                      child: Row(
                        children: [
                          // Small Rotating/Animated artwork cover
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              track.coverUrl,
                              width: 44,
                              height: 44,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(width: 12),

                          // Metadata
                          Expanded(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  track.title,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  track.artist,
                                  style: TextStyle(
                                    color: Colors.grey[400],
                                    fontSize: 12,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),

                          // Play / Pause Controls
                          IconButton(
                            icon: Icon(
                              audioProvider.isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                              color: Colors.white,
                            ),
                            onPressed: audioProvider.togglePlay,
                          ),
                          IconButton(
                            icon: const Icon(Icons.skip_next_rounded, color: Colors.white),
                            onPressed: audioProvider.next,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Simulated ImageFilter to allow smooth web execution without UI filters exceptions
class ImageFilter {
  static blur({double sigmaX = 0, double sigmaY = 0}) => null;
}
