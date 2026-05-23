import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/audio_provider.dart';
import '../models/song.dart';
import 'player_view.dart';
import '../core/constants.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> with SingleTickerProviderStateMixin {
  late AnimationController _waveformController;
  int _currentTab = 0;

  @override
  void initState() {
    super.initState();
    _waveformController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();
  }

  @override
  void dispose() {
    _waveformController.dispose();
    super.dispose();
  }

  Widget _buildCoverImage(String coverUrl, double size) {
    if (coverUrl.startsWith('http')) {
      return Image.network(
        coverUrl,
        fit: BoxFit.cover,
        height: size,
        width: size,
        errorBuilder: (context, error, stackTrace) => _buildPlaceholder(size),
      );
    } else {
      return Image.asset(
        coverUrl,
        fit: BoxFit.cover,
        height: size,
        width: size,
        errorBuilder: (context, error, stackTrace) => _buildPlaceholder(size),
      );
    }
  }

  Widget _buildPlaceholder(double size) {
    return Container(
      width: size,
      height: size,
      color: Colors.grey[900],
      child: const Icon(Icons.music_note_rounded, color: Colors.white30, size: 24),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth > 800;

            if (isWide) {
              return Row(
                children: [
                  // Responsive Frosted Glass Navigation Sidebar (IndexedStack Wired)
                  NavigationSidebar(
                    activeTab: _currentTab,
                    onTabSelected: (index) {
                      setState(() {
                        _currentTab = index;
                      });
                    },
                  ),
                  
                  // Main Content Area wrapped in IndexedStack to preserve playback state
                  Expanded(
                    child: Stack(
                      children: [
                        IndexedStack(
                          index: _currentTab,
                          children: [
                            _buildSongListTab(context),
                            _buildBrowseTab(context),
                            _buildPlaylistsTab(context),
                            _buildFavoritesTab(context),
                            _buildSettingsTab(context),
                          ],
                        ),
                        _buildBottomPlayer(context),
                      ],
                    ),
                  ),
                ],
              );
            } else {
              return Stack(
                children: [
                  IndexedStack(
                    index: _currentTab,
                    children: [
                      _buildSongListTab(context),
                      _buildBrowseTab(context),
                      _buildPlaylistsTab(context),
                      _buildFavoritesTab(context),
                      _buildSettingsTab(context),
                    ],
                  ),
                  _buildBottomPlayer(context),
                ],
              );
            }
          },
        ),
      ),
    );
  }

  // TAB 1: Song List (Main Dashboard)
  Widget _buildSongListTab(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 96.0),
      child: CustomScrollView(
        slivers: [
          // Custom Premium Header with Vibrant Neon Title Gradient
          SliverAppBar(
            expandedHeight: 120.0,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              centerTitle: false,
              title: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Sound',
                    style: TextStyle(
                      fontFamily: 'SpaceGrotesk',
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  ShaderMask(
                    shaderCallback: (bounds) => const LinearGradient(
                      colors: [Color(0xFF8B5CF6), Color(0xFF06B6D4)],
                    ).createShader(bounds),
                    child: const Text(
                      'Wave',
                      style: TextStyle(
                        fontFamily: 'SpaceGrotesk',
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Track Listing
          Consumer<AudioProvider>(
            builder: (context, audioProvider, child) {
              return SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final Song track = audioProvider.queue[index];
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
                                  // Track Artwork Cover with Depth-Filled Radial Neon Glow
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      boxShadow: [
                                        BoxShadow(
                                          color: const Color(AppConstants.primaryColorHex).withOpacity(0.2),
                                          blurRadius: 10,
                                          spreadRadius: 1,
                                        ),
                                        BoxShadow(
                                          color: const Color(AppConstants.secondaryColorHex).withOpacity(0.15),
                                          blurRadius: 10,
                                          spreadRadius: 1,
                                        ),
                                      ],
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: _buildCoverImage(track.coverUrl, 50),
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
                                                ? const Color(AppConstants.secondaryColorHex)
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
                                    const Icon(Icons.volume_up, color: Color(AppConstants.secondaryColorHex))
                                  else
                                    Text(
                                      track.duration, // Displays user preformatted "3:54" direct from model
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
    );
  }

  // TAB 2: Browse Tab (Vibrant Music Genres Grid)
  Widget _buildBrowseTab(BuildContext context) {
    final List<Map<String, dynamic>> genres = [
      {'name': 'Synthwave', 'color1': 0xFF8B5CF6, 'color2': 0xFFEC4899, 'icon': Icons.flash_on_rounded},
      {'name': 'Cyberpunk', 'color1': 0xFF06B6D4, 'color2': 0xFF3B82F6, 'icon': Icons.bolt_rounded},
      {'name': 'Ambient', 'color1': 0xFF10B981, 'color2': 0xFF059669, 'icon': Icons.waves_rounded},
      {'name': 'Chillhop', 'color1': 0xFFF59E0B, 'color2': 0xFFD97706, 'icon': Icons.spa_rounded},
      {'name': 'Retro Future', 'color1': 0xFFEF4444, 'color2': 0xFFC084FC, 'icon': Icons.wb_sunny_rounded},
      {'name': 'Electro', 'color1': 0xFF6366F1, 'color2': 0xFF4F46E5, 'icon': Icons.speaker_group_rounded},
    ];

    return Padding(
      padding: const EdgeInsets.only(bottom: 96.0, top: 40.0, left: 24.0, right: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Browse Genres',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              fontFamily: 'SpaceGrotesk',
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Explore audio vibes tailored for your current layout.',
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 24),
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.5,
              ),
              itemCount: genres.length,
              itemBuilder: (context, index) {
                final genre = genres[index];
                return Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    gradient: LinearGradient(
                      colors: [Color(genre['color1'] as int), Color(genre['color2'] as int)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Color(genre['color1'] as int).withOpacity(0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      )
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Stack(
                      children: [
                        Positioned(
                          right: -10,
                          bottom: -10,
                          child: Icon(
                            genre['icon'] as IconData,
                            size: 80,
                            color: Colors.white.withOpacity(0.15),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Icon(genre['icon'] as IconData, color: Colors.white, size: 28),
                              Text(
                                genre['name'] as String,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
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
      ),
    );
  }

  // TAB 3: Playlists View Placeholder
  Widget _buildPlaylistsTab(BuildContext context) {
    return _buildEmptyStateTab(Icons.queue_music_rounded, 'Playlists Empty', 'Create playlists to view synced tracks here.');
  }

  // TAB 4: Favorites View Placeholder
  Widget _buildFavoritesTab(BuildContext context) {
    return _buildEmptyStateTab(Icons.favorite_rounded, 'Favorites', 'Tracks you mark as favorites will be listed here.');
  }

  // TAB 5: Settings Tab Layout
  Widget _buildSettingsTab(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 96.0, top: 40.0, left: 24.0, right: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Settings',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              fontFamily: 'SpaceGrotesk',
            ),
          ),
          const SizedBox(height: 24),
          Card(
            child: ListView(
              shrinkWrap: true,
              children: [
                ListTile(
                  leading: const Icon(Icons.high_quality_rounded, color: Color(AppConstants.secondaryColorHex)),
                  title: const Text('Streaming Audio Quality'),
                  subtitle: const Text('High Fidelity (320kbps)'),
                  trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
                  onTap: () {},
                ),
                const Divider(height: 1),
                SwitchListTile(
                  secondary: const Icon(Icons.animation_rounded, color: Color(AppConstants.primaryColorHex)),
                  title: const Text('Equalizer Animations'),
                  subtitle: const Text('Draw dynamic wave painters on players'),
                  value: true,
                  activeColor: const Color(AppConstants.secondaryColorHex),
                  onChanged: (val) {},
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.storage_rounded, color: Colors.grey),
                  title: const Text('Clear Audio Cache'),
                  subtitle: const Text('Local temporary files'),
                  onTap: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyStateTab(IconData icon, String title, String subtitle) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 64, color: Colors.white12),
            const SizedBox(height: 16),
            Text(
              title,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, fontFamily: 'SpaceGrotesk'),
            ),
            const SizedBox(height: 8),
            Text(subtitle, style: const TextStyle(color: Colors.grey), textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomPlayer(BuildContext context) {
    return Positioned(
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
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Stack(
                children: [
                  // Base Background
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      color: const Color(AppConstants.cardBackgroundColorHex),
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
                        // Small artwork cover
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: _buildCoverImage(track.coverUrl, 44),
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

                  // Animated Translucent Waveform Overlay in background
                  if (audioProvider.isPlaying)
                    Positioned.fill(
                      child: IgnorePointer(
                        child: AnimatedBuilder(
                          animation: _waveformController,
                          builder: (context, child) {
                            return CustomPaint(
                              painter: WaveformPainter(
                                _waveformController.value,
                                audioProvider.isPlaying,
                              ),
                            );
                          },
                        ),
                      ),
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

// Responsive Frosted Glass Navigation Sidebar (Glassmorphism & IndexedStack Selection)
class NavigationSidebar extends StatelessWidget {
  final int activeTab;
  final ValueChanged<int> onTabSelected;

  const NavigationSidebar({
    super.key,
    required this.activeTab,
    required this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 240,
      decoration: BoxDecoration(
        color: const Color(AppConstants.cardBackgroundColorHex).withOpacity(0.7),
        border: Border(
          right: BorderSide(color: Colors.white.withOpacity(0.08)),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Sidebar Header Branding
            Row(
              children: [
                const Icon(Icons.music_note_rounded, color: Color(AppConstants.secondaryColorHex), size: 28),
                const SizedBox(width: 8),
                const Text(
                  'Sound',
                  style: TextStyle(
                    fontFamily: 'SpaceGrotesk',
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                ShaderMask(
                  shaderCallback: (bounds) => const LinearGradient(
                    colors: [Color(0xFF8B5CF6), Color(0xFF06B6D4)],
                  ).createShader(bounds),
                  child: const Text(
                    'Wave',
                    style: TextStyle(
                      fontFamily: 'SpaceGrotesk',
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 48),

            // Navigation Items mapped to IndexedStack indexes
            _buildNavItem(Icons.home_rounded, 'Home', activeTab == 0, () => onTabSelected(0)),
            _buildNavItem(Icons.explore_rounded, 'Browse', activeTab == 1, () => onTabSelected(1)),
            _buildNavItem(Icons.playlist_play_rounded, 'Playlists', activeTab == 2, () => onTabSelected(2)),
            _buildNavItem(Icons.favorite_rounded, 'Favorites', activeTab == 3, () => onTabSelected(3)),
            const Spacer(),
            _buildNavItem(Icons.settings_rounded, 'Settings', activeTab == 4, () => onTabSelected(4)),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String title, bool isActive, VoidCallback onTap) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: isActive ? Colors.white.withOpacity(0.05) : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
            border: isActive
                ? Border.all(color: const Color(AppConstants.secondaryColorHex).withOpacity(0.3))
                : null,
          ),
          child: Row(
            children: [
              Icon(
                icon,
                color: isActive ? const Color(AppConstants.secondaryColorHex) : Colors.grey[500],
                shadows: isActive
                    ? [
                        Shadow(
                          color: const Color(AppConstants.secondaryColorHex).withOpacity(0.5),
                          blurRadius: 10,
                        )
                      ]
                    : null,
              ),
              const SizedBox(width: 16),
              Text(
                title,
                style: TextStyle(
                  fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                  color: isActive ? Colors.white : Colors.grey[400],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Waveform Painter for Continuous Animated Sine Waves on bottom Mini Player
class WaveformPainter extends CustomPainter {
  final double animationValue;
  final bool isPlaying;

  WaveformPainter(this.animationValue, this.isPlaying);

  @override
  void paint(Canvas canvas, Size size) {
    if (!isPlaying) return;

    final paint = Paint()
      ..shader = const LinearGradient(
        colors: [Color(0x338B5CF6), Color(0x2206B6D4)],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    final path = Path();
    final yCenter = size.height / 2;

    // First Sine Wave
    for (double x = 0; x < size.width; x++) {
      final y = yCenter + 12 * sin((x / 60) + (animationValue * 2 * pi));
      if (x == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    // Phase Shifted second Wave
    final path2 = Path();
    final paint2 = Paint()
      ..shader = const LinearGradient(
        colors: [Color(0x2206B6D4), Color(0x338B5CF6)],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    for (double x = 0; x < size.width; x++) {
      final y = yCenter + 8 * sin((x / 40) - (animationValue * 2 * pi) + pi / 3);
      if (x == 0) {
        path2.moveTo(x, y);
      } else {
        path2.lineTo(x, y);
      }
    }

    canvas.drawPath(path, paint);
    canvas.drawPath(path2, paint2);
  }

  @override
  bool shouldRepaint(covariant WaveformPainter oldDelegate) {
    return oldDelegate.animationValue != animationValue || oldDelegate.isPlaying != isPlaying;
  }
}
