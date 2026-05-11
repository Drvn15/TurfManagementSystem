import 'dart:ui';

import 'package:flutter/material.dart';

import '../theme/design_system.dart';

class AppBackground extends StatelessWidget {
  const AppBackground({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final palette = DesignSystem.paletteOf(context);
    return Container(
      decoration: BoxDecoration(gradient: palette.backgroundGradient),
      child: Stack(
        children: [
          Positioned(
            top: -80,
            right: -40,
            child: _GlowOrb(
              size: 220,
              colors: [
                palette.primary.withValues(alpha: 0.18),
                Colors.transparent,
              ],
            ),
          ),
          Positioned(
            left: -100,
            bottom: -120,
            child: _GlowOrb(
              size: 280,
              colors: [
                palette.primarySoft.withValues(alpha: 0.12),
                Colors.transparent,
              ],
            ),
          ),
          Positioned.fill(child: child),
        ],
      ),
    );
  }
}

class PremiumScaffold extends StatelessWidget {
  const PremiumScaffold({
    super.key,
    required this.body,
    this.appBar,
    this.bottomNavigationBar,
    this.extendBody = false,
    this.floatingActionButton,
    this.drawer,
  });

  final Widget body;
  final PreferredSizeWidget? appBar;
  final Widget? bottomNavigationBar;
  final bool extendBody;
  final Widget? floatingActionButton;
  final Widget? drawer;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: extendBody,
      backgroundColor: Colors.transparent,
      appBar: appBar,
      drawer: drawer,
      floatingActionButton: floatingActionButton,
      bottomNavigationBar: bottomNavigationBar,
      body: AppBackground(child: body),
    );
  }
}

class GlassCard extends StatelessWidget {
  const GlassCard({
    super.key,
    required this.child,
    this.padding = DesignSystem.paddingAll20,
    this.borderRadius,
  });

  final Widget child;
  final EdgeInsets padding;
  final BorderRadius? borderRadius;

  @override
  Widget build(BuildContext context) {
    final radius = borderRadius ?? DesignSystem.borderRadiusXLarge;
    return ClipRRect(
      borderRadius: radius,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
        child: Container(
          padding: padding,
          decoration: DesignSystem.glassDecoration(context, radius: radius),
          child: child,
        ),
      ),
    );
  }
}

class GlowButton extends StatefulWidget {
  const GlowButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.leading,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final Widget? leading;

  @override
  State<GlowButton> createState() => _GlowButtonState();
}

class _GlowButtonState extends State<GlowButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final enabled = widget.onPressed != null && !widget.isLoading;
    final palette = DesignSystem.paletteOf(context);
    final isDark = DesignSystem.isDark(context);

    return GestureDetector(
      onTapDown: enabled ? (_) => setState(() => _pressed = true) : null,
      onTapCancel: enabled ? () => setState(() => _pressed = false) : null,
      onTapUp: enabled ? (_) => setState(() => _pressed = false) : null,
      child: AnimatedScale(
        scale: _pressed ? 0.985 : 1,
        duration: DesignSystem.animationFast,
        curve: DesignSystem.curveStandard,
        child: AnimatedOpacity(
          duration: DesignSystem.animationFast,
          opacity: enabled ? 1 : 0.55,
          child: Container(
            height: DesignSystem.spacing56,
            decoration: BoxDecoration(
              gradient: palette.primaryGradient,
              borderRadius: DesignSystem.borderRadiusLarge,
              boxShadow: DesignSystem.glowShadowFor(context),
            ),
            child: ElevatedButton(
              onPressed: enabled ? widget.onPressed : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                foregroundColor:
                    isDark ? palette.backgroundBase : DesignSystem.textWhite,
                shape: DesignSystem.buttonShape,
              ),
              child: widget.isLoading
                  ? SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.4,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          isDark ? palette.backgroundBase : DesignSystem.textWhite,
                        ),
                      ),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (widget.leading != null) ...[
                          widget.leading!,
                          const SizedBox(width: DesignSystem.spacing8),
                        ],
                        Text(
                          widget.label,
                          style: DesignSystem.button.copyWith(
                            color: isDark
                                ? palette.backgroundBase
                                : DesignSystem.textWhite,
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }
}

class SectionTitle extends StatelessWidget {
  const SectionTitle({
    super.key,
    required this.eyebrow,
    required this.title,
    this.subtitle,
  });

  final String eyebrow;
  final String title;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    final palette = DesignSystem.paletteOf(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          eyebrow.toUpperCase(),
          style: DesignSystem.overline.copyWith(color: palette.primary),
        ),
        const SizedBox(height: DesignSystem.spacing8),
        Text(
          title,
          style: DesignSystem.headline2.copyWith(color: palette.textPrimary),
        ),
        if (subtitle != null) ...[
          const SizedBox(height: DesignSystem.spacing8),
          Text(
            subtitle!,
            style: DesignSystem.bodyMedium.copyWith(color: palette.textSecondary),
          ),
        ],
      ],
    );
  }
}

class PremiumStatCard extends StatelessWidget {
  const PremiumStatCard({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
  });

  final String label;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final palette = DesignSystem.paletteOf(context);
    return GlassCard(
      padding: DesignSystem.paddingAll16,
      borderRadius: DesignSystem.borderRadiusLarge,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: palette.overlayStrong,
              borderRadius: DesignSystem.borderRadiusMedium,
              border: Border.all(color: palette.glassBorder),
            ),
            child: Icon(icon, color: palette.primary),
          ),
          const SizedBox(height: DesignSystem.spacing16),
          Text(
            value,
            style: DesignSystem.statValue.copyWith(color: palette.textPrimary),
          ),
          const SizedBox(height: DesignSystem.spacing4),
          Text(
            label,
            style: DesignSystem.bodySmall.copyWith(color: palette.textSecondary),
          ),
        ],
      ),
    );
  }
}

class PremiumEmptyState extends StatelessWidget {
  const PremiumEmptyState({
    super.key,
    required this.title,
    required this.message,
    this.action,
  });

  final String title;
  final String message;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    final palette = DesignSystem.paletteOf(context);
    return Center(
      child: GlassCard(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: palette.overlaySoft,
                border: Border.all(color: palette.glassBorder),
              ),
              child: Icon(
                Icons.sports_soccer_rounded,
                size: 34,
                color: palette.primary,
              ),
            ),
            const SizedBox(height: DesignSystem.spacing20),
            Text(
              title,
              style: DesignSystem.headline4.copyWith(color: palette.textPrimary),
            ),
            const SizedBox(height: DesignSystem.spacing8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: DesignSystem.bodyMedium.copyWith(color: palette.textSecondary),
            ),
            if (action != null) ...[
              const SizedBox(height: DesignSystem.spacing20),
              action!,
            ],
          ],
        ),
      ),
    );
  }
}

class _GlowOrb extends StatelessWidget {
  const _GlowOrb({
    required this.size,
    required this.colors,
  });

  final double size;
  final List<Color> colors;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(colors: colors),
        ),
      ),
    );
  }
}
