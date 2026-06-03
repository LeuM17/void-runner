// lib/main.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'screens/start_screen.dart';
import 'screens/skins_screen.dart';
import 'screens/game_screen.dart';
import 'services/storage_service.dart';
import 'services/ad_service.dart';
import 'services/iap_service.dart';
import 'utils/theme.dart';
import 'utils/constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Lock portrait
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Fullscreen immersive
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

  // Initialize services
  await StorageService.instance.init();
  await StorageService.instance.updateStreak();

  // Initialize ads (non-blocking)
  try {
    await AdService.instance.initialize();
  } catch (_) {}

  // Initialize IAP (non-blocking)
  try {
    await IapService.instance.initialize();
  } catch (_) {}

  runApp(const VoidRunnerApp());
}

class VoidRunnerApp extends StatelessWidget {
  const VoidRunnerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'VOID RUNNER',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: const AppNavigator(),
    );
  }
}

class AppNavigator extends StatefulWidget {
  const AppNavigator({super.key});

  @override
  State<AppNavigator> createState() => _AppNavigatorState();
}

class _AppNavigatorState extends State<AppNavigator> {
  bool _inGame = false;
  bool _inSkins = false;
  int _streakDay = 0;
  bool _showStreakToast = false;
  String _equippedSkin = AppConstants.skinDefault;

  @override
  void initState() {
    super.initState();
    _equippedSkin = StorageService.instance.equippedSkin;
    _streakDay = StorageService.instance.streakDay;

    // Show streak toast if Day 7
    if (_streakDay == 7) {
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) setState(() => _showStreakToast = true);
        Future.delayed(const Duration(seconds: 3), () {
          if (mounted) setState(() => _showStreakToast = false);
        });
      });
    }
  }

  void _openSkins() => setState(() => _inSkins = true);
  void _closeSkins() => setState(() => _inSkins = false);

  void _startGame() {
    setState(() => _inGame = true);
  }

  void _backToMenu() {
    setState(() => _inGame = false);
    _equippedSkin = StorageService.instance.equippedSkin;
  }

  void _onSkinEquip(String skinId) async {
    await StorageService.instance.equipSkin(skinId);
    setState(() => _equippedSkin = skinId);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 400),
          child: _inGame
              ? GameScreen(
                  key: const ValueKey('game'),
                  onBackToMenu: _backToMenu,
                )
              : _inSkins
                  ? SkinsScreen(
                      key: const ValueKey('skins'),
                      equippedSkin: _equippedSkin,
                      onEquip: _onSkinEquip,
                      onBack: _closeSkins,
                    )
                  : StartScreen(
                      key: const ValueKey('start'),
                      onPlay: _startGame,
                      onOpenSkins: _openSkins,
                      equippedSkin: _equippedSkin,
                      onSkinEquip: _onSkinEquip,
                    ),
        ),

        // Streak toast
        if (_showStreakToast)
          Positioned(
            top: MediaQuery.of(context).padding.top + 16,
            left: 16,
            right: 16,
            child: Material(
              color: Colors.transparent,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                decoration: BoxDecoration(
                  color: const Color(0xFF1A1000),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppConstants.legendaryColor.withOpacity(0.7)),
                  boxShadow: [
                    BoxShadow(
                      color: AppConstants.legendaryColor.withOpacity(0.3),
                      blurRadius: 20,
                    ),
                  ],
                ),
                child: Text(
                  '🔥 LEGENDARY SKIN UNLOCKED!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Orbitron',
                    fontSize: 13,
                    color: AppConstants.legendaryColor,
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(
                        color: AppConstants.legendaryColor.withOpacity(0.8),
                        blurRadius: 10,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
