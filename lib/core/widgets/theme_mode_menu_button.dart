import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../theme/design_system.dart';
import '../theme/theme_controller.dart';

class ThemeModeMenuButton extends ConsumerWidget {
  const ThemeModeMenuButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final palette = DesignSystem.paletteOf(context);
    final themeOption = ref.watch(themeOptionProvider);

    return PopupMenuButton<ThemeOption>(
      tooltip: 'Theme options',
      initialValue: themeOption,
      onSelected: (option) {
        ref.read(themeOptionProvider.notifier).setThemeOption(option);
      },
      color: palette.surfaceElevated,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: DesignSystem.borderRadiusLarge,
      ),
      itemBuilder: (context) => ThemeOption.values
          .map(
            (option) => PopupMenuItem<ThemeOption>(
              value: option,
              child: Row(
                children: [
                  Icon(
                    _iconFor(option),
                    color: option == themeOption
                        ? palette.primary
                        : palette.textSecondary,
                    size: 20,
                  ),
                  const SizedBox(width: DesignSystem.spacing12),
                  Expanded(
                    child: Text(
                      _labelFor(option),
                      style: DesignSystem.bodyMedium.copyWith(
                        color: palette.textPrimary,
                        fontWeight: option == themeOption
                            ? DesignSystem.fontWeightSemiBold
                            : DesignSystem.fontWeightRegular,
                      ),
                    ),
                  ),
                  if (option == themeOption)
                    Icon(
                      Icons.check_rounded,
                      color: palette.primary,
                      size: 18,
                    ),
                ],
              ),
            ),
          )
          .toList(),
      child: Container(
        width: 44,
        height: 44,
        margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
        decoration: BoxDecoration(
          color: palette.surfaceGlass,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: palette.glassBorder),
          boxShadow: DesignSystem.shadowSmallFor(context),
        ),
        child: Icon(
          Icons.tune_rounded,
          color: palette.textPrimary,
          size: 20,
        ),
      ),
    );
  }

  IconData _iconFor(ThemeOption option) {
    switch (option) {
      case ThemeOption.light:
        return Icons.light_mode_rounded;
      case ThemeOption.dark:
        return Icons.dark_mode_rounded;
      case ThemeOption.system:
        return Icons.brightness_auto_rounded;
    }
  }

  String _labelFor(ThemeOption option) {
    switch (option) {
      case ThemeOption.light:
        return 'Light';
      case ThemeOption.dark:
        return 'Dark';
      case ThemeOption.system:
        return 'System Default';
    }
  }
}
