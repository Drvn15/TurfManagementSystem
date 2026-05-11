import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/design_system.dart';
import '../../core/widgets/premium_widgets.dart';
import '../../core/widgets/theme_dropdown.dart';
import '../auth/auth_controller.dart';
import '../booking/screens/my_booking_screen.dart';
import '../turf/turf_controller.dart';
import '../turf/turf_detail_screen.dart';

class UserHomeScreen extends ConsumerStatefulWidget {
  const UserHomeScreen({super.key});

  @override
  ConsumerState<UserHomeScreen> createState() => _UserHomeScreenState();
}

class _UserHomeScreenState extends ConsumerState<UserHomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  final Set<String> _favoriteIds = <String>{};

  int _selectedCategoryIndex = 0;
  int _selectedNavIndex = 0;

  static const List<_SportCategory> _sportsCategories = [
    _SportCategory('Cricket', Icons.sports_cricket),
    _SportCategory('Football', Icons.sports_soccer),
    _SportCategory('Badminton', Icons.sports_tennis),
    _SportCategory('Tennis', Icons.sports_tennis),
    _SportCategory('Basketball', Icons.sports_basketball),
  ];

  static const List<_NavItem> _navItems = [
    _NavItem('Explore', Icons.explore_rounded),
    _NavItem('Bookings', Icons.event_note_rounded),
    _NavItem('Favourite', Icons.favorite_border_rounded),
    _NavItem('Messages', Icons.chat_bubble_outline_rounded),
    _NavItem('Profile', Icons.person_rounded),
  ];

  @override
  void initState() {
    super.initState();
    _fetchTurfs();
    _searchController.addListener(_refreshSearch);
  }

  @override
  void dispose() {
    _searchController.removeListener(_refreshSearch);
    _searchController.dispose();
    super.dispose();
  }

  void _fetchTurfs() {
    Future.microtask(() {
      ref.read(turfControllerProvider.notifier).fetchTurfs();
    });
  }

  void _refreshSearch() {
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _refreshTurfs() async {
    await ref.read(turfControllerProvider.notifier).refreshAllTurfs();
  }

  Future<void> _openBookings() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const MyBookingsScreen()),
    );
    _refreshTurfs();
  }

  Future<void> _openTurfDetails(Map<String, dynamic> turf) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => TurfDetailScreen(turf: turf)),
    );
    _refreshTurfs();
  }

  void _toggleFavorite(dynamic turfId) {
    final key = '$turfId';
    setState(() {
      if (_favoriteIds.contains(key)) {
        _favoriteIds.remove(key);
      } else {
        _favoriteIds.add(key);
      }
    });
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<void> _showLogoutSheet() async {
    final palette = DesignSystem.paletteOf(context);
    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: GlassCard(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Profile',
                    style: DesignSystem.headline4.copyWith(
                      color: palette.textPrimary,
                    ),
                  ),
                  const SizedBox(height: DesignSystem.spacing8),
                  Text(
                    'Account controls are being expanded. You can sign out safely below.',
                    style: DesignSystem.bodyMedium.copyWith(
                      color: palette.textSecondary,
                    ),
                  ),
                  const SizedBox(height: DesignSystem.spacing20),
                  GlowButton(
                    label: 'Sign Out',
                    onPressed: () {
                      Navigator.pop(context);
                      ref.read(authControllerProvider.notifier).logout();
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _onNavTapped(int index) {
    setState(() => _selectedNavIndex = index);

    switch (index) {
      case 0:
        break;
      case 1:
        _openBookings();
        break;
      case 2:
        _showMessage('Favorites will surface here as you save venues.');
        break;
      case 3:
        _showMessage('Messaging is planned next for venue communication.');
        break;
      case 4:
        _showLogoutSheet();
        break;
    }
  }

  List<Map<String, dynamic>> _applyFilters(List<Map<String, dynamic>> turfs) {
    final query = _searchController.text.trim().toLowerCase();
    final selectedSport =
        _sportsCategories[_selectedCategoryIndex].label.toLowerCase();

    return turfs.where((turf) {
      final name = (turf['name'] ?? '').toString().toLowerCase();
      final location = (turf['location'] ?? '').toString().toLowerCase();
      final description = (turf['description'] ?? '').toString().toLowerCase();
      final sport = (turf['sport'] ?? '').toString().toLowerCase();
      final inferredSport = _sportLabelForTurf(turf).toLowerCase();

      final matchesQuery = query.isEmpty ||
          name.contains(query) ||
          location.contains(query) ||
          description.contains(query);

      final matchesSport = sport.contains(selectedSport) ||
          inferredSport == 'multi-sport' ||
          inferredSport.contains(selectedSport) ||
          name.contains(selectedSport) ||
          description.contains(selectedSport);

      return matchesQuery && matchesSport;
    }).toList();
  }

  void _showAllTurfsSheet(String title, List<Map<String, dynamic>> turfs) {
    final palette = DesignSystem.paletteOf(context);
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: GlassCard(
              child: SizedBox(
                height: MediaQuery.sizeOf(context).height * 0.72,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: DesignSystem.headline4.copyWith(
                        color: palette.textPrimary,
                      ),
                    ),
                    const SizedBox(height: DesignSystem.spacing8),
                    Text(
                      '${turfs.length} venues found',
                      style: DesignSystem.bodyMedium.copyWith(
                        color: palette.textSecondary,
                      ),
                    ),
                    const SizedBox(height: DesignSystem.spacing16),
                    Expanded(
                      child: ListView.separated(
                        itemCount: turfs.length,
                        separatorBuilder: (_, __) =>
                            const SizedBox(height: DesignSystem.spacing12),
                        itemBuilder: (context, index) {
                          final turf = turfs[index];
                          return _VenueListTile(
                            turf: turf,
                            onTap: () {
                              Navigator.pop(context);
                              _openTurfDetails(turf);
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final turfState = ref.watch(turfControllerProvider);
    final palette = DesignSystem.paletteOf(context);

    return PremiumScaffold(
      extendBody: true,
      body: SafeArea(
        child: turfState.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => _HomeErrorState(
            error: error.toString(),
            onRetry: _refreshTurfs,
          ),
          data: (turfs) {
            final filteredTurfs = _applyFilters(List<Map<String, dynamic>>.from(turfs));
            final featuredTurfs = filteredTurfs.take(5).toList();
            final nearbyTurfs = filteredTurfs.skip(1).take(6).toList();

            return RefreshIndicator(
              onRefresh: _refreshTurfs,
              color: palette.primary,
              child: CustomScrollView(
                physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics(),
                ),
                slivers: [
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(20, 8, 20, 140),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate([
                        _HeaderBar(
                          onBookingsTap: _openBookings,
                        ),
                        const SizedBox(height: DesignSystem.spacing20),
                        _SearchBar(
                          controller: _searchController,
                          onFilterTap: () {
                            _showMessage(
                              'Use the sport chips below to refine results.',
                            );
                          },
                        ),
                        const SizedBox(height: DesignSystem.spacing20),
                        SizedBox(
                          height: 120,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemCount: _sportsCategories.length,
                            separatorBuilder: (_, __) =>
                                const SizedBox(width: DesignSystem.spacing12),
                            itemBuilder: (context, index) {
                              final category = _sportsCategories[index];
                              return _SportCategoryChip(
                                category: category,
                                isSelected: _selectedCategoryIndex == index,
                                onTap: () {
                                  setState(() => _selectedCategoryIndex = index);
                                },
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: DesignSystem.spacing28),
                        _SectionHeader(
                          title: 'Recommended for you',
                          subtitle: 'Curated venues based on the sport you picked.',
                          onTap: featuredTurfs.isEmpty
                              ? null
                              : () => _showAllTurfsSheet(
                                    'Recommended venues',
                                    featuredTurfs,
                                  ),
                        ),
                        const SizedBox(height: DesignSystem.spacing16),
                        if (featuredTurfs.isEmpty)
                          const PremiumEmptyState(
                            title: 'No matching venues',
                            message:
                                'Try another sport or clear the current search to view more venues.',
                          )
                        else
                          SizedBox(
                            height: 320,
                            child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              clipBehavior: Clip.none,
                              itemCount: featuredTurfs.length,
                              separatorBuilder: (_, __) =>
                                  const SizedBox(width: DesignSystem.spacing16),
                              itemBuilder: (context, index) {
                                final turf = featuredTurfs[index];
                                return SizedBox(
                                  width: 286,
                                  child: _FeaturedVenueCard(
                                    turf: turf,
                                    isFavorite:
                                        _favoriteIds.contains('${turf['id']}'),
                                    onFavoriteTap: () =>
                                        _toggleFavorite(turf['id']),
                                    onTap: () => _openTurfDetails(turf),
                                  ),
                                );
                              },
                            ),
                          ),
                        const SizedBox(height: DesignSystem.spacing28),
                        _SectionHeader(
                          title: 'Nearby venues',
                          subtitle: 'Clean, fast access to courts and pricing.',
                          onTap: nearbyTurfs.isEmpty
                              ? null
                              : () => _showAllTurfsSheet(
                                    'Nearby venues',
                                    nearbyTurfs,
                                  ),
                        ),
                        const SizedBox(height: DesignSystem.spacing16),
                        if (nearbyTurfs.isEmpty)
                          PremiumEmptyState(
                            title: 'No nearby venues yet',
                            message:
                                'Once more venues are available in this category, they will appear here.',
                            action: SizedBox(
                              width: 180,
                              child: GlowButton(
                                label: 'View bookings',
                                onPressed: _openBookings,
                              ),
                            ),
                          )
                        else
                          ...nearbyTurfs.map(
                            (turf) => Padding(
                              padding:
                                  const EdgeInsets.only(bottom: DesignSystem.spacing16),
                              child: _VenueListTile(
                                turf: turf,
                                isFavorite:
                                    _favoriteIds.contains('${turf['id']}'),
                                onFavoriteTap: () =>
                                    _toggleFavorite(turf['id']),
                                onTap: () => _openTurfDetails(turf),
                              ),
                            ),
                          ),
                      ]),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        child: _HomeNavigationBar(
          selectedIndex: _selectedNavIndex,
          items: _navItems,
          onTap: _onNavTapped,
        ),
      ),
    );
  }
}

class _HeaderBar extends StatelessWidget {
  const _HeaderBar({
    required this.onBookingsTap,
  });

  final VoidCallback onBookingsTap;

  @override
  Widget build(BuildContext context) {
    final palette = DesignSystem.paletteOf(context);

    return Row(
      children: [
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: palette.glassBorder),
            boxShadow: DesignSystem.shadowSmallFor(context),
            image: const DecorationImage(
              image: NetworkImage('https://i.pravatar.cc/120?img=12'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(width: DesignSystem.spacing16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Evan',
                style: DesignSystem.headline4.copyWith(
                  color: palette.textPrimary,
                ),
              ),
              const SizedBox(height: DesignSystem.spacing4),
              Text(
                'Welcome back. Find your next game fast.',
                style: DesignSystem.bodyMedium.copyWith(
                  color: palette.textSecondary,
                ),
              ),
            ],
          ),
        ),
        const ThemeDropdown(),
        const SizedBox(width: DesignSystem.spacing8),
        _HeaderIconButton(
          icon: Icons.event_available_rounded,
          onTap: onBookingsTap,
        ),
      ],
    );
  }
}

class _SearchBar extends StatelessWidget {
  const _SearchBar({
    required this.controller,
    required this.onFilterTap,
  });

  final TextEditingController controller;
  final VoidCallback onFilterTap;

  @override
  Widget build(BuildContext context) {
    final palette = DesignSystem.paletteOf(context);

    return Row(
      children: [
        Expanded(
          child: GlassCard(
            padding: EdgeInsets.zero,
            borderRadius: BorderRadius.circular(24),
            child: TextField(
              controller: controller,
              style: DesignSystem.bodyLarge.copyWith(color: palette.textPrimary),
              decoration: InputDecoration(
                hintText: 'Search venues, locations, or sports',
                hintStyle:
                    DesignSystem.bodyMedium.copyWith(color: palette.textMuted),
                prefixIcon: Icon(Icons.search_rounded, color: palette.textSecondary),
                contentPadding: const EdgeInsets.symmetric(vertical: 16),
                filled: false,
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
              ),
            ),
          ),
        ),
        const SizedBox(width: DesignSystem.spacing12),
        _HeaderIconButton(
          icon: Icons.tune_rounded,
          onTap: onFilterTap,
        ),
      ],
    );
  }
}

class _SportCategoryChip extends StatelessWidget {
  const _SportCategoryChip({
    required this.category,
    required this.isSelected,
    required this.onTap,
  });

  final _SportCategory category;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final palette = DesignSystem.paletteOf(context);

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: DesignSystem.animationFast,
        width: 96,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected
              ? palette.overlayStrong
              : palette.surfaceGlass.withValues(alpha: 0.88),
          borderRadius: DesignSystem.borderRadiusXLarge,
          border: Border.all(
            color: isSelected ? palette.primary : palette.glassBorder,
          ),
          boxShadow: DesignSystem.shadowSmallFor(context),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? palette.primary : palette.backgroundSecondary,
              ),
              child: Icon(
                category.icon,
                color: isSelected ? palette.textWhite : palette.primary,
              ),
            ),
            const SizedBox(height: DesignSystem.spacing8),
            Text(
              category.label,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: DesignSystem.bodyMedium.copyWith(
                color: isSelected ? palette.textPrimary : palette.textSecondary,
                fontWeight: isSelected
                    ? DesignSystem.fontWeightSemiBold
                    : DesignSystem.fontWeightMedium,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.title,
    required this.subtitle,
    this.onTap,
  });

  final String title;
  final String subtitle;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final palette = DesignSystem.paletteOf(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: DesignSystem.headline4.copyWith(color: palette.textPrimary),
              ),
              const SizedBox(height: DesignSystem.spacing4),
              Text(
                subtitle,
                style: DesignSystem.bodyMedium.copyWith(
                  color: palette.textSecondary,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: DesignSystem.spacing12),
        IconButton(
          onPressed: onTap,
          icon: Icon(
            Icons.arrow_forward_rounded,
            color: onTap == null ? palette.textMuted : palette.primary,
          ),
        ),
      ],
    );
  }
}

class _FeaturedVenueCard extends StatelessWidget {
  const _FeaturedVenueCard({
    required this.turf,
    required this.isFavorite,
    required this.onFavoriteTap,
    required this.onTap,
  });

  final Map<String, dynamic> turf;
  final bool isFavorite;
  final VoidCallback onFavoriteTap;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final palette = DesignSystem.paletteOf(context);
    final imageUrl = (turf['image_url'] ?? '').toString();
    final price = turf['price_per_hour'] ?? 0;

    return GlassCard(
      borderRadius: DesignSystem.borderRadiusXLarge,
      padding: const EdgeInsets.all(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: DesignSystem.borderRadiusXLarge,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: DesignSystem.borderRadiusLarge,
              child: SizedBox(
                height: 168,
                width: double.infinity,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    _VenueImage(imageUrl: imageUrl, icon: _sportIconForTurf(turf)),
                    Positioned(
                      left: 10,
                      top: 10,
                      child: _FavoriteBadge(
                        isFavorite: isFavorite,
                        onTap: onFavoriteTap,
                      ),
                    ),
                    Positioned(
                      right: 10,
                      top: 10,
                      child: _PillLabel(text: _sportLabelForTurf(turf)),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: DesignSystem.spacing16),
            Text(
              turf['name'] ?? 'Unnamed turf',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: DesignSystem.headline5.copyWith(color: palette.textPrimary),
            ),
            const SizedBox(height: DesignSystem.spacing6),
            Text(
              _locationText(turf),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: DesignSystem.bodyMedium.copyWith(
                color: palette.textSecondary,
              ),
            ),
            const Spacer(),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Rs ${_formatPrice(price)}',
                        style: DesignSystem.headline4.copyWith(
                          color: palette.textPrimary,
                        ),
                      ),
                      const SizedBox(height: DesignSystem.spacing4),
                      Text(
                        _distanceForTurf(turf),
                        style: DesignSystem.bodySmall.copyWith(
                          color: palette.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: DesignSystem.spacing12),
                SizedBox(
                  width: 118,
                  child: GlowButton(
                    label: 'View',
                    onPressed: onTap,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _VenueListTile extends StatelessWidget {
  const _VenueListTile({
    required this.turf,
    required this.onTap,
    this.isFavorite = false,
    this.onFavoriteTap,
  });

  final Map<String, dynamic> turf;
  final VoidCallback onTap;
  final bool isFavorite;
  final VoidCallback? onFavoriteTap;

  @override
  Widget build(BuildContext context) {
    final palette = DesignSystem.paletteOf(context);
    final imageUrl = (turf['image_url'] ?? '').toString();

    return GlassCard(
      padding: const EdgeInsets.all(12),
      borderRadius: DesignSystem.borderRadiusLarge,
      child: InkWell(
        onTap: onTap,
        borderRadius: DesignSystem.borderRadiusLarge,
        child: Row(
          children: [
            ClipRRect(
              borderRadius: DesignSystem.borderRadiusMedium,
              child: SizedBox(
                width: 92,
                height: 92,
                child: _VenueImage(
                  imageUrl: imageUrl,
                  icon: _sportIconForTurf(turf),
                ),
              ),
            ),
            const SizedBox(width: DesignSystem.spacing12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    turf['name'] ?? 'Unnamed turf',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: DesignSystem.headline5.copyWith(
                      color: palette.textPrimary,
                    ),
                  ),
                  const SizedBox(height: DesignSystem.spacing6),
                  Text(
                    _locationText(turf),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: DesignSystem.bodyMedium.copyWith(
                      color: palette.textSecondary,
                    ),
                  ),
                  const SizedBox(height: DesignSystem.spacing8),
                  Wrap(
                    spacing: DesignSystem.spacing8,
                    runSpacing: DesignSystem.spacing8,
                    children: [
                      _MetaBadge(
                        icon: Icons.currency_rupee_rounded,
                        text: _formatPrice(turf['price_per_hour'] ?? 0),
                      ),
                      _MetaBadge(
                        icon: Icons.star_rounded,
                        text: _ratingForTurf(turf),
                      ),
                      _MetaBadge(
                        icon: Icons.route_rounded,
                        text: _distanceForTurf(turf),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: DesignSystem.spacing8),
            Column(
              children: [
                if (onFavoriteTap != null)
                  _FavoriteBadge(
                    isFavorite: isFavorite,
                    onTap: onFavoriteTap!,
                    small: true,
                  ),
                const SizedBox(height: DesignSystem.spacing8),
                Icon(
                  Icons.arrow_forward_rounded,
                  color: palette.primary,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _HomeNavigationBar extends StatelessWidget {
  const _HomeNavigationBar({
    required this.selectedIndex,
    required this.items,
    required this.onTap,
  });

  final int selectedIndex;
  final List<_NavItem> items;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    final palette = DesignSystem.paletteOf(context);

    return GlassCard(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      borderRadius: BorderRadius.circular(30),
      child: Row(
        children: List.generate(items.length, (index) {
          final item = items[index];
          final isSelected = index == selectedIndex;

          return Expanded(
            child: GestureDetector(
              onTap: () => onTap(index),
              child: AnimatedContainer(
                duration: DesignSystem.animationFast,
                padding:
                    const EdgeInsets.symmetric(horizontal: 6, vertical: 10),
                decoration: BoxDecoration(
                  color: isSelected ? palette.overlayStrong : Colors.transparent,
                  borderRadius: BorderRadius.circular(22),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      item.icon,
                      size: 20,
                      color: isSelected ? palette.primary : palette.textMuted,
                    ),
                    const SizedBox(height: DesignSystem.spacing4),
                    Text(
                      item.label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: DesignSystem.bodySmall.copyWith(
                        color:
                            isSelected ? palette.primary : palette.textSecondary,
                        fontWeight: isSelected
                            ? DesignSystem.fontWeightSemiBold
                            : DesignSystem.fontWeightMedium,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

class _HeaderIconButton extends StatelessWidget {
  const _HeaderIconButton({
    required this.icon,
    required this.onTap,
  });

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final palette = DesignSystem.paletteOf(context);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        width: 46,
        height: 46,
        decoration: BoxDecoration(
          color: palette.surfaceGlass,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: palette.glassBorder),
          boxShadow: DesignSystem.shadowSmallFor(context),
        ),
        child: Icon(icon, color: palette.primary, size: 20),
      ),
    );
  }
}

class _FavoriteBadge extends StatelessWidget {
  const _FavoriteBadge({
    required this.isFavorite,
    required this.onTap,
    this.small = false,
  });

  final bool isFavorite;
  final VoidCallback onTap;
  final bool small;

  @override
  Widget build(BuildContext context) {
    final palette = DesignSystem.paletteOf(context);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: small ? 34 : 40,
        height: small ? 34 : 40,
        decoration: BoxDecoration(
          color: palette.surfaceGlass,
          shape: BoxShape.circle,
          border: Border.all(color: palette.glassBorder),
        ),
        child: Icon(
          isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
          size: small ? 18 : 20,
          color: isFavorite ? palette.error : palette.textSecondary,
        ),
      ),
    );
  }
}

class _PillLabel extends StatelessWidget {
  const _PillLabel({
    required this.text,
  });

  final String text;

  @override
  Widget build(BuildContext context) {
    final palette = DesignSystem.paletteOf(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: palette.surfaceGlass,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: palette.glassBorder),
      ),
      child: Text(
        text,
        style: DesignSystem.bodySmall.copyWith(
          color: palette.textPrimary,
          fontWeight: DesignSystem.fontWeightSemiBold,
        ),
      ),
    );
  }
}

class _MetaBadge extends StatelessWidget {
  const _MetaBadge({
    required this.icon,
    required this.text,
  });

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    final palette = DesignSystem.paletteOf(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: palette.overlaySoft,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: palette.primary),
          const SizedBox(width: DesignSystem.spacing6),
          Text(
            text,
            style: DesignSystem.bodySmall.copyWith(
              color: palette.textPrimary,
              fontWeight: DesignSystem.fontWeightSemiBold,
            ),
          ),
        ],
      ),
    );
  }
}

class _VenueImage extends StatelessWidget {
  const _VenueImage({
    required this.imageUrl,
    required this.icon,
  });

  final String imageUrl;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final palette = DesignSystem.paletteOf(context);

    if (imageUrl.isEmpty) {
      return DecoratedBox(
        decoration: BoxDecoration(gradient: palette.primaryGradient),
        child: Icon(icon, size: 44, color: palette.textWhite),
      );
    }

    return Image.network(
      imageUrl,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) {
        return DecoratedBox(
          decoration: BoxDecoration(gradient: palette.primaryGradient),
          child: Icon(icon, size: 44, color: palette.textWhite),
        );
      },
    );
  }
}

class _HomeErrorState extends StatelessWidget {
  const _HomeErrorState({
    required this.error,
    required this.onRetry,
  });

  final String error;
  final Future<void> Function() onRetry;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: PremiumEmptyState(
        title: 'Unable to load venues',
        message: error,
        action: SizedBox(
          width: 180,
          child: GlowButton(
            label: 'Retry',
            onPressed: () {
              onRetry();
            },
          ),
        ),
      ),
    );
  }
}

class _SportCategory {
  const _SportCategory(this.label, this.icon);

  final String label;
  final IconData icon;
}

class _NavItem {
  const _NavItem(this.label, this.icon);

  final String label;
  final IconData icon;
}

String _locationText(Map<String, dynamic> turf) {
  final location = (turf['location'] ?? 'City turf').toString();
  return location.isEmpty ? 'City turf' : location;
}

String _sportLabelForTurf(Map<String, dynamic> turf) {
  final rawSport = (turf['sport'] ?? '').toString().trim();
  if (rawSport.isNotEmpty) {
    return rawSport;
  }

  final name = (turf['name'] ?? '').toString().toLowerCase();
  final description = (turf['description'] ?? '').toString().toLowerCase();
  final haystack = '$name $description';

  for (final category in _UserHomeScreenState._sportsCategories) {
    if (haystack.contains(category.label.toLowerCase())) {
      return category.label;
    }
  }

  return 'Multi-sport';
}

String _ratingForTurf(Map<String, dynamic> turf) {
  final raw = turf['rating'];
  if (raw is num) {
    return raw.toStringAsFixed(1);
  }

  final id = int.tryParse('${turf['id'] ?? 0}') ?? 0;
  final synthetic = 4.2 + (id % 6) * 0.1;
  return synthetic.toStringAsFixed(1);
}

String _distanceForTurf(Map<String, dynamic> turf) {
  final raw = turf['distance'];
  if (raw != null && raw.toString().trim().isNotEmpty) {
    return raw.toString();
  }

  final id = int.tryParse('${turf['id'] ?? 0}') ?? 0;
  final distance = 1.2 + (id % 5) * 0.7;
  return '${distance.toStringAsFixed(1)} km';
}

IconData _sportIconForTurf(Map<String, dynamic> turf) {
  final sport = _sportLabelForTurf(turf).toLowerCase();

  if (sport.contains('cricket')) return Icons.sports_cricket;
  if (sport.contains('football')) return Icons.sports_soccer;
  if (sport.contains('basketball')) return Icons.sports_basketball;
  if (sport.contains('badminton') || sport.contains('tennis')) {
    return Icons.sports_tennis;
  }

  return Icons.sports_soccer;
}

String _formatPrice(dynamic price) {
  final value = price is num ? price.toDouble() : double.tryParse('$price') ?? 0;
  return value.toStringAsFixed(2);
}
