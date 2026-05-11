import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../theme/design_system.dart';
import '../theme/theme_controller.dart';

class ThemeSceneToggle extends ConsumerWidget {
  const ThemeSceneToggle({
    super.key,
    this.compact = false,
  });

  final bool compact;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeOption = ref.watch(themeOptionProvider);
    final themeController = ref.read(themeOptionProvider.notifier);
    final isDark = themeController.getThemeMode(
          MediaQuery.platformBrightnessOf(context),
        ) ==
        ThemeMode.dark;
    final width = compact ? 78.0 : 164.0;
    final height = compact ? 42.0 : 88.0;
    final knob = compact ? 32.0 : 72.0;
    final inset = compact ? 5.0 : 8.0;

    return Semantics(
      button: true,
      toggled: isDark,
      label: 'Appearance switch',
      hint:
          '${isDark ? 'Switch to light mode' : 'Switch to dark mode'}. Long press to use system appearance.',
      child: Tooltip(
        message: themeOption == ThemeOption.system
            ? 'Using system appearance. Tap to override.'
            : '${isDark ? 'Switch to light mode' : 'Switch to dark mode'}. Long press for system appearance.',
        child: GestureDetector(
          onTap: () => themeController.setThemeOption(
            isDark ? ThemeOption.light : ThemeOption.dark,
          ),
          onLongPress: () =>
              themeController.setThemeOption(ThemeOption.system),
          child: AnimatedContainer(
            duration: DesignSystem.animationSlow,
            curve: DesignSystem.curveEmphasized,
            width: width,
            height: height,
            padding: EdgeInsets.all(inset),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(height / 2),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: isDark
                    ? const [Color(0xFF1F2766), Color(0xFF0B0F32)]
                    : const [Color(0xFFFFD7B3), Color(0xFF79B3FF)],
              ),
              boxShadow: [
                BoxShadow(
                  color: (isDark
                          ? const Color(0xFF7F8EFF)
                          : const Color(0xFF8FBEFF))
                      .withValues(alpha: 0.24),
                  blurRadius: compact ? 14 : 20,
                  offset: Offset(0, compact ? 6 : 10),
                ),
              ],
            ),
            child: Stack(
              children: [
                Positioned.fill(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(height / 2),
                    child: AnimatedOpacity(
                      opacity: isDark ? 1 : 0,
                      duration: DesignSystem.animationSlow,
                      child: _NightScene(compact: compact),
                    ),
                  ),
                ),
                Positioned.fill(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(height / 2),
                    child: AnimatedOpacity(
                      opacity: isDark ? 0 : 1,
                      duration: DesignSystem.animationSlow,
                      child: _DayScene(compact: compact),
                    ),
                  ),
                ),
                AnimatedAlign(
                  duration: DesignSystem.animationSlow,
                  curve: DesignSystem.curveEmphasized,
                  alignment:
                      isDark ? Alignment.centerLeft : Alignment.centerRight,
                  child: Container(
                    width: knob,
                    height: knob,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: isDark
                            ? const [Color(0xFFEEF1FF), Color(0xFFBCC6FF)]
                            : const [Color(0xFFFFF7D9), Color(0xFFFFCFA1)],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.18),
                          blurRadius: compact ? 10 : 16,
                          offset: Offset(0, compact ? 3 : 6),
                        ),
                      ],
                    ),
                    child: isDark
                        ? _MoonDisc(compact: compact)
                        : _SunDisc(compact: compact),
                  ),
                ),
                if (themeOption == ThemeOption.system)
                  Align(
                    alignment: Alignment.topCenter,
                    child: Container(
                      margin: EdgeInsets.only(top: compact ? 1 : 4),
                      width: compact ? 18 : 26,
                      height: compact ? 4 : 6,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.75),
                        borderRadius: BorderRadius.circular(999),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NightScene extends StatelessWidget {
  const _NightScene({required this.compact});

  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          right: compact ? 10 : 18,
          top: compact ? 8 : 14,
          child: _Stars(compact: compact),
        ),
        Positioned(
          right: compact ? 8 : 12,
          bottom: compact ? 5 : 8,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: List.generate(
              compact ? 4 : 5,
              (index) => Container(
                margin: EdgeInsets.symmetric(horizontal: compact ? 1 : 1.4),
                width: compact ? 5 : 8,
                height: compact ? 6 + (index % 2) * 5 : 10 + (index % 3) * 8,
                decoration: BoxDecoration(
                  color: const Color(0xFF28307A),
                  borderRadius: BorderRadius.circular(2),
                ),
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                    margin: EdgeInsets.only(top: compact ? 1 : 2),
                    width: compact ? 2.5 : 4,
                    height: compact ? 2.5 : 4,
                    decoration: const BoxDecoration(
                      color: Color(0xFFFFE08A),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _DayScene extends StatelessWidget {
  const _DayScene({required this.compact});

  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          left: compact ? 10 : 18,
          top: compact ? 8 : 12,
          child: Container(
            width: compact ? 18 : 34,
            height: compact ? 8 : 14,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.75),
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ),
        Positioned(
          left: compact ? 22 : 38,
          top: compact ? 14 : 20,
          child: Container(
            width: compact ? 14 : 28,
            height: compact ? 7 : 12,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.65),
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ),
        Positioned(
          left: compact ? 10 : 16,
          bottom: compact ? 7 : 12,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: List.generate(
              compact ? 3 : 4,
              (index) => Transform.rotate(
                angle: -0.08,
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: compact ? 1 : 1.4),
                  width: compact ? 6 : 10,
                  height: compact ? 7 + (index % 2) * 5 : 12 + (index % 2) * 8,
                  decoration: BoxDecoration(
                    color: const Color(0xFF6EA2FF).withValues(alpha: 0.9),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _MoonDisc extends StatelessWidget {
  const _MoonDisc({required this.compact});

  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(compact ? 7 : 10),
      child: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [Color(0xFF183C87), Color(0xFF071227)],
              ),
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Container(
              width: compact ? 14 : 24,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFFF6F7FF),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SunDisc extends StatelessWidget {
  const _SunDisc({required this.compact});

  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(compact ? 7 : 10),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const RadialGradient(
          colors: [Color(0xFFFFF7D8), Color(0xFFFFD2A1)],
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFFF4BD).withValues(alpha: 0.5),
            blurRadius: 14,
          ),
        ],
      ),
    );
  }
}

class _Stars extends StatelessWidget {
  const _Stars({required this.compact});

  final bool compact;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: compact ? 26 : 44,
      height: compact ? 18 : 28,
      child: Stack(
        children: List.generate(compact ? 4 : 6, (index) {
          final dx = compact
              ? [4, 11, 18, 14][index].toDouble()
              : [6, 18, 30, 14, 36, 24][index].toDouble();
          final dy = compact
              ? [4, 2, 6, 12][index].toDouble()
              : [6, 2, 8, 18, 16, 12][index].toDouble();
          return Positioned(
            left: dx,
            top: dy,
            child: Transform.rotate(
              angle: pi / 4,
              child: Container(
                width: compact ? 3 : (index.isEven ? 5 : 4),
                height: compact ? 3 : (index.isEven ? 5 : 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFF7F4FF),
                  borderRadius: BorderRadius.circular(1),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
