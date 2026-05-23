import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/audio_provider.dart';
import 'core/theme.dart';
import 'views/home_view.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AudioProvider()),
      ],
      child: const SoundWaveApp(),
    ),
  );
}

class SoundWaveApp extends StatelessWidget {
  const SoundWaveApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SoundWave',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: const HomeView(),
    );
  }
}
