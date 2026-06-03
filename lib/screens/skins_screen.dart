// lib/screens/skins_screen.dart
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../utils/constants.dart';
import '../utils/theme.dart';
import '../services/storage_service.dart';

class SkinData {
  final String id;
  final String name;
  final String description;
  final String unlockCondition;
  final int streakRequired;
  final Color dotColor;
  final Color glowColor;
  final bool isRainbow;
  final String rarityLabel;
  final Color rarityColor;

  const SkinData({
    required this.id,
    required this.name,
    required this.description,
    required this.unlockCondition,
    required this.streakRequired,
    required this.dotColor,
    required this.glowColor,
    this.isRainbow = false,
    required this.rarityLabel,
    required this.rarityColor,
  });
}

const List<SkinData> allSkins = [
  SkinData(
    id: 'default',
    name: 'VOID RUNNER',
    description: 'The original cyan dot. Simple but deadly.',
    unlockCondition: 'Unlocked by default',
    streakRequired: 0,
    dotColor: Color(0xFF00FFFF),
    glowColor: Color(0xFF00FFFF),
    rarityLabel: 'STANDARD',
    rarityColor: Color(0xFF4FC3F7),
  ),
  SkinData(
    id: 'gold',
    name: 'GOLDEN',
    description: 'Pure gold radiance. Proof you survived 7 days.',
    unlockCondition: '🔥 7-Day Streak',
    streakRequired: 7,
    dotColor: Color(0xFFFFD700),
    glowColor: Color(0xFFFFD700),
    rarityLabel: 'RARE',
    rarityColor: Color(0xFFCE93D8),
  ),
  SkinData(
    id: 'rainbow',
    name: 'RAINBOW',
    description: 'Cycles through every color in real time.',
    unlockCondition: '🔥 14-Day Streak',
    streakRequired: 14,
    dotColor: Color(0xFFFF0000),
    glowColor: Color(0xFFFF0000),
    isRainbow: true,
    rarityLabel: 'EPIC',
    rarityColor: Color(0xFFAB47BC),
  ),
  SkinData(
    id: 'void_god',
    name: 'VOID GOD',
    description: 'Absolute black with white aura. Master of the void.',
    unlockCondition: '🔥 30-Day Streak',
    streakRequired: 30,
    dotColor: Colors.black,
    glowColor: Colors.white,
    rarityLabel: 'LEGENDARY',
    rarityColor: Color(0xFFFFD700),
  ),
];

class SkinsScreen extends StatefulWidget {
  final String equippedSkin;
  final Function(String) onEquip;
  final VoidCallback onBack;

  const SkinsScreen({
    super.key,
    required this.equippedSkin,
    required this.onEquip,
    required this.onBack,
  });

  @override
  State<SkinsScreen> createState() => _SkinsScreenState();
}

class _SkinsScreenState extends State<SkinsScreen>
    with TickerProviderStateMixin {
  late String _equippedSkin;
  int _selectedIndex = 0;
  late AnimationController _previewController;
  late AnimationController _bgController;

  @override
  void initState() {
    super.initState();
    _equippedSkin = widget.equippedSkin;
    _selectedIndex = allSkins.indexWhere((s) => s.id == _equippedSkin);
    if (_selectedIndex < 0) _selectedIndex = 0;

    _previewController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();

    _bgController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _previewController.dispose();
    _bgController.dispose();
    super.dispose();
  }

  void _selectSkin(int index) => setState(() => _selectedIndex = index);

  void _equipSkin(String skinId) async {
    await StorageService.instance.equipSkin(skinId);
    setState(() => _equippedSkin = skinId);
    widget.onEquip(skinId);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        duration: const Duration(seconds: 2),
        content: Center(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xFF0D0D1A),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppConstants.playerColor.withOpacity(0.6)),
              boxShadow: [
                BoxShadow(
                  color: AppConstants.playerColor.withOpacity(0.3),
                  blurRadius: 16,
                ),
              ],
            ),
            child: Text(
              '✓ Skin equipped!',
              style: AppTheme.neonText(fontSize: 13, color: AppConstants.playerColor),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final storage = StorageService.instance;
    final selectedSkin = allSkins[_selectedIndex];
    final isUnlocked = storage.isSkinUnlocked(selectedSkin.id);
    final isEquipped = _equippedSkin == selectedSkin.id;
    final currentStreak = storage.streakDay;

    return Scaffold(
      backgroundColor: AppConstants.bgColor,
      body: Stack(
        children: [
          // Animated background
          AnimatedBuilder(
            animation: _bgController,
            builder: (_, __) => CustomPaint(
              painter: _SkinsBgPainter(_bgController.value, selectedSkin.glowColor),
              size: Size.infinite,
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                _buildHeader(),
                const SizedBox(height: 8),
                Expanded(flex: 4, child: _buildPreview(selectedSkin, isUnlocked)),
                _buildSkinInfo(selectedSkin, isUnlocked, isEquipped, currentStreak),
                const SizedBox(height: 16),
                _buildSkinGrid(storage),
                const SizedBox(height: 20),
                _buildEquipButton(selectedSkin, isUnlocked, isEquipped),
                const SizedBox(height: 28),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: Row(
        children: [
          GestureDetector(
            onTap: widget.onBack,
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.white12),
              ),
              child: const Icon(Icons.arrow_back_ios_new, color: Colors.white70, size: 18),
            ),
          ),
          const Spacer(),
          Text(
            'SKINS',
            style: AppTheme.neonText(fontSize: 20, color: AppConstants.playerColor, weight: FontWeight.w900),
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.orange.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.orange.withOpacity(0.3)),
            ),
            child: Text(
              '🔥 Day ${StorageService.instance.streakDay}',
              style: AppTheme.neonText(fontSize: 12, color: Colors.orange),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPreview(SkinData skin, bool isUnlocked) {
    return Center(
      child: AnimatedBuilder(
        animation: _previewController,
        builder: (_, __) => CustomPaint(
          painter: _SkinPreviewPainter(
            skin: skin,
            animTime: _previewController.value,
            isUnlocked: isUnlocked,
          ),
          size: const Size(200, 200),
        ),
      ),
    ).animate(key: ValueKey(skin.id)).scale(
          begin: const Offset(0.7, 0.7),
          end: const Offset(1.0, 1.0),
          duration: 400.ms,
          curve: Curves.elasticOut,
        );
  }

  Widget _buildSkinInfo(SkinData skin, bool isUnlocked, bool isEquipped, int currentStreak) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          // Rarity badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
            decoration: BoxDecoration(
              color: skin.rarityColor.withOpacity(0.12),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: skin.rarityColor.withOpacity(0.5)),
            ),
            child: Text(
              skin.rarityLabel,
              style: TextStyle(
                fontFamily: 'Orbitron',
                fontSize: 10,
                color: skin.rarityColor,
                letterSpacing: 2,
              ),
            ),
          ).animate(key: ValueKey('rarity_${skin.id}')).fadeIn(duration: 300.ms),

          const SizedBox(height: 10),

          Text(
            skin.name,
            style: AppTheme.neonText(
              fontSize: 22,
              color: isUnlocked ? skin.glowColor : Colors.white38,
              weight: FontWeight.w900,
            ),
          ).animate(key: ValueKey('name_${skin.id}')).fadeIn(duration: 300.ms).slideY(begin: 0.2),

          const SizedBox(height: 8),

          Text(
            skin.description,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontFamily: 'Orbitron',
              fontSize: 11,
              color: Colors.white54,
              height: 1.6,
            ),
          ).animate(key: ValueKey('desc_${skin.id}')).fadeIn(delay: 100.ms, duration: 300.ms),

          const SizedBox(height: 10),

          if (!isUnlocked) ...[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.orange.withOpacity(0.08),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.orange.withOpacity(0.3)),
              ),
              child: Column(
                children: [
                  Text(
                    'LOCKED — ${skin.unlockCondition}',
                    style: const TextStyle(
                      fontFamily: 'Orbitron',
                      fontSize: 10,
                      color: Colors.orange,
                      letterSpacing: 1,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: (currentStreak / skin.streakRequired).clamp(0.0, 1.0),
                      minHeight: 4,
                      backgroundColor: Colors.white12,
                      valueColor: const AlwaysStoppedAnimation(Colors.orange),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '$currentStreak / ${skin.streakRequired} days',
                    style: const TextStyle(
                      fontFamily: 'Orbitron',
                      fontSize: 9,
                      color: Colors.white38,
                    ),
                  ),
                ],
              ),
            ).animate(key: ValueKey('lock_${skin.id}')).fadeIn(delay: 150.ms),
          ] else if (isEquipped) ...[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              decoration: BoxDecoration(
                color: AppConstants.playerColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppConstants.playerColor.withOpacity(0.4)),
              ),
              child: Text(
                '✓ EQUIPPED',
                style: AppTheme.neonText(fontSize: 11, color: AppConstants.playerColor),
              ),
            ).animate().fadeIn(),
          ],
        ],
      ),
    );
  }

  Widget _buildSkinGrid(StorageService storage) {
    return SizedBox(
      height: 80,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: allSkins.length,
        itemBuilder: (_, i) {
          final skin = allSkins[i];
          final isUnlocked = storage.isSkinUnlocked(skin.id);
          final isSelected = _selectedIndex == i;
          final isEquipped = _equippedSkin == skin.id;

          return GestureDetector(
            onTap: () => _selectSkin(i),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.symmetric(horizontal: 6),
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: isSelected
                    ? skin.rarityColor.withOpacity(0.15)
                    : AppConstants.cardBg,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: isSelected
                      ? skin.rarityColor
                      : isEquipped
                          ? AppConstants.playerColor.withOpacity(0.5)
                          : Colors.white12,
                  width: isSelected ? 2 : 1,
                ),
                boxShadow: isSelected
                    ? [BoxShadow(color: skin.rarityColor.withOpacity(0.3), blurRadius: 12)]
                    : null,
              ),
              child: Center(
                child: isUnlocked
                    ? _buildGridDot(skin, i)
                    : Stack(
                        alignment: Alignment.center,
                        children: [
                          _buildGridDot(skin, i, opacity: 0.2),
                          const Text('🔒', style: TextStyle(fontSize: 18)),
                        ],
                      ),
              ),
            ),
          ).animate().fadeIn(delay: Duration(milliseconds: i * 80), duration: 300.ms).slideY(begin: 0.3, end: 0);
        },
      ),
    );
  }

  Widget _buildGridDot(SkinData skin, int index, {double opacity = 1.0}) {
    if (skin.isRainbow) {
      return AnimatedBuilder(
        animation: _previewController,
        builder: (_, __) {
          final hue = (_previewController.value * 360 + index * 90) % 360;
          final color = HSVColor.fromAHSV(1.0, hue, 1.0, 1.0).toColor();
          return Container(
            width: 26,
            height: 26,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color.withOpacity(opacity),
              boxShadow: [BoxShadow(color: color.withOpacity(0.6 * opacity), blurRadius: 10)],
            ),
          );
        },
      );
    }
    return Container(
      width: 26,
      height: 26,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: skin.dotColor.withOpacity(opacity),
        border: skin.id == 'void_god'
            ? Border.all(color: Colors.white.withOpacity(opacity), width: 2)
            : null,
        boxShadow: [BoxShadow(color: skin.glowColor.withOpacity(0.6 * opacity), blurRadius: 10)],
      ),
    );
  }

  Widget _buildEquipButton(SkinData skin, bool isUnlocked, bool isEquipped) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: GestureDetector(
        onTap: (isUnlocked && !isEquipped) ? () => _equipSkin(skin.id) : null,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 18),
          decoration: BoxDecoration(
            color: isEquipped
                ? AppConstants.playerColor.withOpacity(0.08)
                : isUnlocked
                    ? skin.rarityColor.withOpacity(0.12)
                    : Colors.white.withOpacity(0.03),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isEquipped
                  ? AppConstants.playerColor.withOpacity(0.5)
                  : isUnlocked
                      ? skin.rarityColor.withOpacity(0.7)
                      : Colors.white12,
              width: 1.5,
            ),
            boxShadow: isUnlocked && !isEquipped
                ? [BoxShadow(color: skin.rarityColor.withOpacity(0.2), blurRadius: 16)]
                : null,
          ),
          child: Text(
            isEquipped ? '✓ EQUIPPED' : isUnlocked ? 'EQUIP' : '🔒 LOCKED',
            textAlign: TextAlign.center,
            style: AppTheme.neonText(
              fontSize: 15,
              color: isEquipped
                  ? AppConstants.playerColor
                  : isUnlocked
                      ? skin.rarityColor
                      : Colors.white24,
              weight: FontWeight.w900,
            ),
          ),
        ),
      ),
    );
  }
}

// ── Skin preview painter (animated dot orbiting) ──────────────────────────
class _SkinPreviewPainter extends CustomPainter {
  final SkinData skin;
  final double animTime;
  final bool isUnlocked;

  _SkinPreviewPainter({required this.skin, required this.animTime, required this.isUnlocked});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final t = animTime * 2 * pi;
    final opacity = isUnlocked ? 1.0 : 0.25;

    Color dotColor, glowColor;
    if (skin.isRainbow) {
      final hue = (animTime * 360) % 360;
      dotColor = HSVColor.fromAHSV(1.0, hue, 1.0, 1.0).toColor();
      glowColor = dotColor;
    } else {
      dotColor = skin.dotColor;
      glowColor = skin.glowColor;
    }

    // Trail
    for (int i = 0; i < 20; i++) {
      final angle = t - i * 0.18;
      final trailPos = Offset(
        center.dx + cos(angle) * 55,
        center.dy + sin(angle) * 22,
      );
      final trailOpacity = (1.0 - i / 20) * 0.5 * opacity;
      final trailRadius = 6.0 * (1.0 - i / 20);
      canvas.drawCircle(
        trailPos,
        trailRadius,
        Paint()
          ..color = glowColor.withOpacity(trailOpacity)
          ..maskFilter = MaskFilter.blur(BlurStyle.normal, trailRadius),
      );
    }

    // Dot position
    final dotPos = Offset(center.dx + cos(t) * 55, center.dy + sin(t) * 22);

    // Glow layers
    for (final (r, o) in [(50.0, 0.08), (35.0, 0.2), (20.0, 0.5)]) {
      canvas.drawCircle(
        dotPos, 14,
        Paint()
          ..color = glowColor.withOpacity(o * opacity)
          ..maskFilter = MaskFilter.blur(BlurStyle.normal, r),
      );
    }

    // Core dot
    canvas.drawCircle(dotPos, 14, Paint()..color = dotColor.withOpacity(opacity));

    // Bright center
    canvas.drawCircle(dotPos, 5, Paint()..color = Colors.white.withOpacity(0.8 * opacity));

    // Decorative ring
    final ringOpacity = (sin(t * 2) * 0.15 + 0.25) * opacity;
    canvas.drawCircle(
      center, 80,
      Paint()
        ..color = glowColor.withOpacity(ringOpacity)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4),
    );

    // Lock overlay
    if (!isUnlocked) {
      final lp = Paint()..color = Colors.white24..strokeWidth = 3..strokeCap = StrokeCap.round..style = PaintingStyle.stroke;
      canvas.drawLine(center - const Offset(20, 20), center + const Offset(20, 20), lp);
      canvas.drawLine(center + const Offset(-20, 20), center + const Offset(20, -20), lp);
    }
  }

  @override
  bool shouldRepaint(_SkinPreviewPainter old) => old.animTime != animTime || old.skin.id != skin.id;
}

// ── Background painter ────────────────────────────────────────────────────
class _SkinsBgPainter extends CustomPainter {
  final double t;
  final Color accentColor;

  _SkinsBgPainter(this.t, this.accentColor);

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()..color = AppConstants.bgColor,
    );

    final pulse = sin(t * 2 * pi) * 0.03 + 0.06;
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()
        ..shader = RadialGradient(
          center: Alignment.center,
          radius: 0.8,
          colors: [accentColor.withOpacity(pulse), Colors.transparent],
        ).createShader(Rect.fromLTWH(0, 0, size.width, size.height)),
    );

    final gridPaint = Paint()..color = Colors.white.withOpacity(0.03)..strokeWidth = 0.5;
    for (double x = 0; x < size.width; x += 40) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), gridPaint);
    }
    for (double y = 0; y < size.height; y += 40) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }
  }

  @override
  bool shouldRepaint(_SkinsBgPainter old) => old.t != t || old.accentColor != accentColor;
}
