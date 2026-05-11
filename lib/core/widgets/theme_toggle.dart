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
    final mode = ref.watch(themeControllerProvider);
    final isDark = mode == ThemeMode.dark;
    final width = compact ? 104.0 : 164.0;
    final height = compact ? 56.0 : 88.0;
    final knob = compact ? 46.0 : 72.0;

    return GestureDetector(
      onTap: () => ref.read(themeControllerProvider.notifier).toggle(),
      child: AnimatedContainer(
        duration: DesignSystem.animationSlow,
        curve: DesignSystem.curveEmphasized,
        width: width,
        height: height,
        padding: const EdgeInsets.all(6),
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
              color: (isDark ? const Color(0xFF7F8EFF) : const Color(0xFF8FBEFF))
                  .withValues(alpha: 0.24),
              blurRadius: 20,
              offset: const Offset(0, 10),
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
                  child: const _NightScene(),
                ),
              ),
            ),
            Positioned.fill(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(height / 2),
                child: AnimatedOpacity(
                  opacity: isDark ? 0 : 1,
                  duration: DesignSystem.animationSlow,
                  child: const _DayScene(),
                ),
              ),
            ),
            AnimatedAlign(
              duration: DesignSystem.animationSlow,
              curve: DesignSystem.curveEmphasized,
              alignment: isDark ? Alignment.centerLeft : Alignment.centerRight,
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
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: isDark ? const _MoonDisc() : const _SunDisc(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NightScene extends StatelessWidget {
  const _NightScene();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const Positioned(
          right: 18,
          top: 14,
          child: _Stars(),
        ),
        Positioned(
          right: 12,
          bottom: 8,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: List.generate(
              5,
              (index) => Container(
                margin: const EdgeInsets.symmetric(horizontal: 1.4),
                width: 8,
                height: 10 + (index % 3) * 8,
                decoration: BoxDecoration(
                  color: const Color(0xFF28307A),
                  borderRadius: BorderRadius.circular(2),
                ),
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                    margin: const EdgeInsets.only(top: 2),
                    width: 4,
                    height: 4,
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
  const _DayScene();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          left: 18,
          top: 12,
          child: Container(
            width: 34,
            height: 14,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.75),
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ),
        Positioned(
          left: 38,
          top: 20,
          child: Container(
            width: 28,
            height: 12,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.65),
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ),
        Positioned(
          left: 16,
          bottom: 12,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: List.generate(
              4,
              (index) => Transform.rotate(
                angle: -0.08,
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 1.4),
                  width: 10,
                  height: 12 + (index % 2) * 8,
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
  const _MoonDisc();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
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
              width: 24,
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
  const _SunDisc();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
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
  const _Stars();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 44,
      height: 28,
      child: Stack(
        children: List.generate(6, (index) {
          final dx = [6, 18, 30, 14, 36, 24][index].toDouble();
          final dy = [6, 2, 8, 18, 16, 12][index].toDouble();
          return Positioned(
            left: dx,
            top: dy,
            child: Transform.rotate(
              angle: pi / 4,
              child: Container(
                width: index.isEven ? 5 : 4,
                height: index.isEven ? 5 : 4,
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
