// lib/utils/constants.dart
import 'package:flutter/material.dart';

class AppConstants {
  // Colors
  static const Color bgColor = Color(0xFF000000);
  static const Color bgGradientEnd = Color(0xFF0A0014);
  static const Color playerColor = Color(0xFF00FFFF);
  static const Color voidBase = Color(0xFF1A0028);
  static const Color voidEdge = Color(0xFFCC00FF);
  static const Color gridColor = Color(0xFF1A1A2E);
  static const Color commonColor = Color(0xFF4FC3F7);
  static const Color rareColor = Color(0xCECE93D8);
  static const Color legendaryColor = Color(0xFFFFD700);
  static const Color cardBg = Color(0xFF0D0D1A);

  // Game physics
  static const double playerRadius = 14.0;
  static const double initialVoidSpeed = 8.0;
  static const double voidSpeedIncrement = 2.0;
  static const double voidSpeedInterval = 15.0; // seconds
  static const int trailLength = 40;
  static const int maxParticles = 200;

  // Timing
  static const double mutationInterval = 10.0; // seconds
  static const double eventInterval = 30.0; // seconds

  // SharedPreferences keys
  static const String keyHighscore = 'void_highscore';
  static const String keyTotalRuns = 'void_total_runs';
  static const String keyStreakDay = 'void_streak_day';
  static const String keyLastOpen = 'void_last_open';
  static const String keyNoAds = 'void_no_ads';
  static const String keyMutationPass = 'void_mutation_pass';
  static const String keyEquippedSkin = 'void_equipped_skin';
  static const String keyUnlockedSkins = 'void_unlocked_skins';

  // IAP product IDs
  static const String iapNoAds = 'com.voidrunner.noads';
  static const String iapMutationPass = 'com.voidrunner.mutationpass';

  // AdMob Test IDs
  static const String admobAppIdAndroid = 'ca-app-pub-3940256099942544~3347511713';
  static const String admobAppIdIos = 'ca-app-pub-3940256099942544~1458002511';
  static const String rewardedAdUnitAndroid = 'ca-app-pub-3940256099942544/5224354917';
  static const String rewardedAdUnitIos = 'ca-app-pub-3940256099942544/1712485313';
  static const String interstitialAdUnitAndroid = 'ca-app-pub-3940256099942544/1033173712';
  static const String interstitialAdUnitIos = 'ca-app-pub-3940256099942544/4411468910';

  // Competitor names pool
  static const List<String> competitorNames = [
    'VoidWalker99', 'NeonGhost', 'DarkPulse', 'CyberVoid', 'PhaseShift',
    'NullRunner', 'VoidKing', 'QuantumDot', 'NeonDrifter', 'ShadowPulse',
    'VoidLord', 'CyberGhost', 'NeonVoid', 'DarkRunner', 'PhantomDot',
    'VoidHunter', 'NeonStrike', 'PulseRunner', 'VoidEcho', 'CyberPulse',
    'NeonKnight', 'DarkWalker', 'VoidStar', 'QuantumRun', 'NeonPhase',
    'VoidStorm', 'CyberKnight', 'DarkPhase', 'NeonRun', 'VoidFlash',
    'PulseGhost', 'NeonWalker', 'DarkStar', 'VoidPulse', 'CyberRun',
    'NeonStar', 'DarkGhost', 'VoidRunner', 'QuantumPulse', 'NeonFlash',
    'VoidDrifter', 'CyberStar', 'DarkFlash', 'NeonKing', 'PulseWalker',
    'VoidPhase', 'CyberFlash', 'DarkKing', 'NeonDot', 'VoidGhost',
  ];

  // Skin IDs
  static const String skinDefault = 'default';
  static const String skinGold = 'gold';
  static const String skinRainbow = 'rainbow';
  static const String skinVoidGod = 'void_god';
}
