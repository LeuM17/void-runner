// lib/screens/start_screen.dart
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../utils/constants.dart';
import '../utils/theme.dart';
import '../services/storage_service.dart';

class StartScreen extends StatefulWidget {
  final VoidCallback onPlay;
  final VoidCallback onOpenSkins;
  final String equippedSkin;
  final Function(String) onSkinEquip;

  const StartScreen({
    super.key,
    required this.onPlay,
    required this.onOpenSkins,
    required this.equippedSkin,
    required this.onSkinEquip,
  });

  @override
  State<StartScreen> createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen>
    with TickerProviderStateMixin {
  late AnimationController _voidController;
  late AnimationController _tapController;

  @override
  void initState() {
    super.initState();
    _voidController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);

    _tapController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _voidController.dispose();
    _tapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final storage = StorageService.instance;
    final streak = storage.streakDay;
    final highscore = storage.highscore;

    return Scaffold(
      backgroundColor: AppConstants.bgColor,
      body: Stack(
        children: [
          // Animated void background
          AnimatedBuilder(
            animation: _voidController,
            builder: (context, _) {
              final inset = _voidController.value * 30;
              return CustomPaint(
                painter: _VoidPreviewPainter(inset),
                size: Size.infinite,
              );
            },
          ),

          SafeArea(
            child: Column(
              children: [
                // Top row: streak + highscore
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Highscore
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.white12),
                        ),
                        child: Text(
                          '⚡ BEST: ${highscore}s',
                          style: AppTheme.neonText(
                            fontSize: 11,
                            color: AppConstants.playerColor,
                          ),
                        ),
                      ),
                      // Streak
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.orange.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.orange.withOpacity(0.3)),
                        ),
                        child: Text(
                          '🔥 DAY $streak',
                          style: AppTheme.neonText(
                            fontSize: 11,
                            color: Colors.orange,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const Spacer(),

                // Title
                Column(
                  children: [
                    Text(
                      'VOID',
                      style: AppTheme.neonText(
                        fontSize: 60,
                        color: AppConstants.voidEdge,
                        weight: FontWeight.w900,
                      ),
                    )
                        .animate(onPlay: (c) => c.repeat())
                        .shimmer(
                          duration: 3000.ms,
                          color: Colors.white,
                        )
                        .animate()
                        .fadeIn(duration: 800.ms)
                        .slideY(begin: -0.3),
                    Text(
                      'RUNNER',
                      style: AppTheme.neonText(
                        fontSize: 60,
                        color: AppConstants.playerColor,
                        weight: FontWeight.w900,
                      ),
                    )
                        .animate(onPlay: (c) => c.repeat())
                        .shimmer(
                          duration: 3000.ms,
                          delay: 1500.ms,
                          color: Colors.white,
                        )
                        .animate()
                        .fadeIn(duration: 800.ms, delay: 200.ms)
                        .slideY(begin: 0.3),
                  ],
                ),

                const SizedBox(height: 16),

                Text(
                  'SURVIVE THE CLOSING VOID',
                  style: AppTheme.neonText(
                    fontSize: 11,
                    color: Colors.white38,
                    weight: FontWeight.normal,
                  ),
                ).animate().fadeIn(delay: 400.ms),

                const Spacer(),

                // Skins button
                GestureDetector(
                  onTap: widget.onOpenSkins,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.04),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.white12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Equipped skin dot preview
                        _EquippedDotPreview(skinId: widget.equippedSkin),
                        const SizedBox(width: 10),
                        Text(
                          'SKINS',
                          style: AppTheme.neonText(fontSize: 13, color: Colors.white54),
                        ),
                        const SizedBox(width: 8),
                        const Icon(Icons.chevron_right, color: Colors.white24, size: 16),
                      ],
                    ),
                  ),
                ).animate().fadeIn(delay: 600.ms),

                const SizedBox(height: 40),

                // TAP TO SURVIVE button
                AnimatedBuilder(
                  animation: _tapController,
                  builder: (context, child) {
                    final glow = _tapController.value;
                    return GestureDetector(
                      onTap: widget.onPlay,
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 40),
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        decoration: BoxDecoration(
                          color: AppConstants.playerColor.withOpacity(0.05 + glow * 0.1),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: AppConstants.playerColor.withOpacity(0.5 + glow * 0.5),
                            width: 1.5,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: AppConstants.playerColor.withOpacity(0.2 + glow * 0.3),
                              blurRadius: 20 + glow * 20,
                              spreadRadius: glow * 4,
                            ),
                          ],
                        ),
                        child: Text(
                          'TAP TO SURVIVE',
                          textAlign: TextAlign.center,
                          style: AppTheme.neonText(
                            fontSize: 18,
                            color: AppConstants.playerColor,
                            weight: FontWeight.w900,
                          ),
                        ),
                      ),
                    );
                  },
                ).animate().fadeIn(delay: 800.ms).scale(begin: const Offset(0.9, 0.9)),

                const SizedBox(height: 48),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


// Small dot preview for the equipped skin shown on start screen button
class _EquippedDotPreview extends StatelessWidget {
  final String skinId;
  const _EquippedDotPreview({required this.skinId});

  @override
  Widget build(BuildContext context) {
    Color color;
    switch (skinId) {
      case 'gold': color = const Color(0xFFFFD700); break;
      case 'void_god': color = Colors.white; break;
      default: color = AppConstants.playerColor;
    }
    if (skinId == 'rainbow') {
      return ShaderMask(
        shaderCallback: (b) => const LinearGradient(
          colors: [Colors.red, Colors.orange, Colors.yellow, Colors.green, Colors.blue, Colors.purple],
        ).createShader(b),
        child: Container(
          width: 14, height: 14,
          decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.white),
        ),
      );
    }
    return Container(
      width: 14, height: 14,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: skinId == 'void_god' ? Colors.black : color,
        border: skinId == 'void_god' ? Border.all(color: Colors.white, width: 1.5) : null,
        boxShadow: [BoxShadow(color: color.withOpacity(0.7), blurRadius: 6)],
      ),
    );
  }
}
