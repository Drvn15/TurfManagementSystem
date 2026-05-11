import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
    _NavItem('Bookings', Icons.handshake_outlined),
    _NavItem('Favourite', Icons.favorite_border_rounded),
    _NavItem('Message', Icons.chat_bubble_outline_rounded),
    _NavItem('Profile', Icons.person_rounded),
  ];

  @override
  void initState() {
    super.initState();
    _fetchTurfs();
    _searchController.addListener(_filterTurfs);
  }

  void _fetchTurfs() {
    Future.microtask(() {
      ref.read(turfControllerProvider.notifier).fetchTurfs();
    });
  }

  void _filterTurfs() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _searchController.removeListener(_filterTurfs);
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _refreshTurfs() async {
    await ref.read(turfControllerProvider.notifier).refreshAllTurfs();
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

  void _onNavTapped(int index) {
    setState(() {
      _selectedNavIndex = index;
    });

    if (index == 1) {
      _openBookings();
      return;
    }

    if (index == 4) {
      ref.read(authControllerProvider.notifier).logout();
      return;
    }

    if (index == 2 || index == 3) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            index == 2
                ? 'Favorites UI is ready for wiring.'
                : 'Messages UI is ready for wiring.',
          ),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  List<Map<String, dynamic>> _applyFilters(List<Map<String, dynamic>> turfs) {
    final query = _searchController.text.trim().toLowerCase();
    final selectedSport = _sportsCategories[_selectedCategoryIndex].label.toLowerCase();

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

      final matchesSport = selectedSport.isEmpty ||
          sport.contains(selectedSport) ||
          inferredSport == 'multi-sport' ||
          inferredSport.contains(selectedSport) ||
          name.contains(selectedSport) ||
          description.contains(selectedSport);

      return matchesQuery && matchesSport;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final turfState = ref.watch(turfControllerProvider);

    return Scaffold(
      extendBody: true,
      backgroundColor: const Color(0xFFF7F5F2),
      body: SafeArea(
        child: turfState.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => _ErrorState(
            error: error.toString(),
            onRetry: _refreshTurfs,
          ),
          data: (turfs) {
            final allTurfs = List<Map<String, dynamic>>.from(turfs);
            final filteredTurfs = _applyFilters(allTurfs);
            final recommendedTurfs = filteredTurfs.take(6).toList();
            final nearbyTurfs =
                filteredTurfs.skip(min(2, filteredTurfs.length)).toList();
            final displayedNearby = nearbyTurfs.isEmpty ? filteredTurfs : nearbyTurfs;

            return RefreshIndicator(
              onRefresh: _refreshTurfs,
              color: const Color(0xFF111111),
              child: CustomScrollView(
                physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics(),
                ),
                slivers: [
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(24, 10, 24, 120),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildHeader(),
                          const SizedBox(height: 28),
                          _buildSearchRow(),
                          const SizedBox(height: 22),
                          _buildCategoryRow(),
                          const SizedBox(height: 30),
                          _buildSectionHeader(
                            title: 'Recommend for You',
                            onTap: () {},
                          ),
                          const SizedBox(height: 14),
                          if (recommendedTurfs.isEmpty)
                            _buildEmptyState(
                              message: _searchController.text.isEmpty
                                  ? 'No turfs available right now.'
                                  : 'No turfs match this search yet.',
                            )
                          else
                            SizedBox(
                              height: 350,
                              child: ListView.separated(
                                clipBehavior: Clip.none,
                                scrollDirection: Axis.horizontal,
                                physics: const BouncingScrollPhysics(),
                                itemCount: recommendedTurfs.length,
                                separatorBuilder: (_, __) => const SizedBox(width: 16),
                                itemBuilder: (context, index) {
                                  final turf = recommendedTurfs[index];
                                  return _RecommendedTurfCard(
                                    turf: turf,
                                    isFavorite: _favoriteIds.contains('${turf['id']}'),
                                    onFavoriteToggle: () => _toggleFavorite(turf['id']),
                                    onTap: () => _openTurfDetails(turf),
                                  );
                                },
                              ),
                            ),
                          const SizedBox(height: 26),
                          _buildSectionHeader(
                            title: 'Popular nearby',
                            onTap: () {},
                          ),
                          const SizedBox(height: 14),
                          if (filteredTurfs.isEmpty)
                            _buildEmptyState(
                              message: 'Try another sport or clear the search.',
                            )
                          else
                            SizedBox(
                              height: 284,
                              child: ListView.separated(
                                clipBehavior: Clip.none,
                                scrollDirection: Axis.horizontal,
                                physics: const BouncingScrollPhysics(),
                                itemCount: displayedNearby.length,
                                separatorBuilder: (_, __) => const SizedBox(width: 16),
                                itemBuilder: (context, index) {
                                  final turf = displayedNearby[index];
                                  return SizedBox(
                                    width: 214,
                                    child: _NearbyTurfCard(
                                      turf: turf,
                                      isFavorite: _favoriteIds.contains('${turf['id']}'),
                                      onFavoriteToggle: () =>
                                          _toggleFavorite(turf['id']),
                                      onTap: () => _openTurfDetails(turf),
                                    ),
                                  );
                                },
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.fromLTRB(18, 0, 18, 18),
        child: _LiquidGlassNavBar(
          selectedIndex: _selectedNavIndex,
          items: _navItems,
          onTap: _onNavTapped,
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
            image: const DecorationImage(
              image: NetworkImage('https://i.pravatar.cc/120?img=12'),
              fit: BoxFit.cover,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 18,
                offset: const Offset(0, 8),
              ),
            ],
          ),
        ),
        const SizedBox(width: 14),
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Evan',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF202020),
                ),
              ),
              SizedBox(height: 2),
              Text(
                'Welcome back !',
                style: TextStyle(
                  fontSize: 13,
                  color: Color(0xFF9D9D9D),
                ),
              ),
            ],
          ),
        ),
        _GlassIconButton(
          icon: Icons.notifications_none_rounded,
          onTap: _openBookings,
        ),
      ],
    );
  }

  Widget _buildSearchRow() {
    return Row(
      children: [
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search',
                  hintStyle: const TextStyle(
                    color: Color(0xFF9B9B9B),
                    fontSize: 16,
                  ),
                  prefixIcon: const Icon(Icons.search_rounded, color: Color(0xFF9B9B9B)),
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.8),
                  contentPadding: const EdgeInsets.symmetric(vertical: 16),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: BorderSide(color: Colors.white.withOpacity(0.95)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: const BorderSide(color: Color(0x33000000), width: 1),
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        _GlassIconButton(
          icon: Icons.filter_alt_outlined,
          onTap: () {},
        ),
      ],
    );
  }

  Widget _buildCategoryRow() {
    return SizedBox(
      height: 106,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: _sportsCategories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final category = _sportsCategories[index];
          final isActive = index == _selectedCategoryIndex;
          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedCategoryIndex = index;
              });
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 240),
              width: 88,
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        width: 52,
                        height: 40,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.45),
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Icon(
                          category.icon,
                          size: 30,
                          color: const Color(0xFF404040),
                        ),
                      ),
                      if (index == 1 || index == 2)
                        Positioned(
                          top: -4,
                          right: -10,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(999),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: const Text(
                              'New',
                              style: TextStyle(
                                fontSize: 10,
                                color: Color(0xFF575757),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    category.label,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: isActive
                          ? const Color(0xFF1B1B1B)
                          : const Color(0xFF8E8E8E),
                    ),
                  ),
                  const SizedBox(height: 10),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 240),
                    height: 3.4,
                    width: isActive ? 78 : 0,
                    decoration: BoxDecoration(
                      color: const Color(0xFF1B1B1B),
                      borderRadius: BorderRadius.circular(100),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSectionHeader({
    required String title,
    required VoidCallback onTap,
  }) {
    return Row(
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFF222222),
          ),
        ),
        const Spacer(),
        IconButton(
          onPressed: onTap,
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
          icon: const Icon(
            Icons.arrow_forward_ios_rounded,
            size: 18,
            color: Color(0xFF202020),
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState({required String message}) {
    return _GlassCard(
      borderRadius: BorderRadius.circular(28),
      padding: const EdgeInsets.all(18),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: const Color(0xFF6C4CF1).withOpacity(0.12),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.sports_soccer_rounded, color: Color(0xFF6C4CF1)),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF6B7280),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RecommendedTurfCard extends StatelessWidget {
  const _RecommendedTurfCard({
    required this.turf,
    required this.isFavorite,
    required this.onFavoriteToggle,
    required this.onTap,
  });

  final Map<String, dynamic> turf;
  final bool isFavorite;
  final VoidCallback onFavoriteToggle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final imageUrl = (turf['image_url'] ?? '').toString();
    final price = turf['price_per_hour'] ?? 0;

    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 268,
        child: _GlassCard(
          borderRadius: BorderRadius.circular(30),
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(28),
                child: SizedBox(
                  height: 196,
                  width: double.infinity,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      _TurfImage(imageUrl: imageUrl, icon: _sportIconForTurf(turf)),
                      Positioned(
                        top: 12,
                        left: 12,
                        child: _CircleOverlayButton(
                          icon: isFavorite
                              ? Icons.favorite_rounded
                              : Icons.favorite_border_rounded,
                          iconColor: isFavorite
                              ? const Color(0xFF202020)
                              : const Color(0xFF919191),
                          onTap: onFavoriteToggle,
                        ),
                      ),
                      Positioned(
                        top: 12,
                        right: 12,
                        child: Container(
                          padding:
                              const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.82),
                            borderRadius: BorderRadius.circular(999),
                            border: Border.all(color: Colors.white.withOpacity(0.92)),
                          ),
                          child: Text(
                            _sportLabelForTurf(turf),
                            style: const TextStyle(
                              fontSize: 11,
                              color: Color(0xFF505050),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 14),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            turf['name'] ?? '',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF202020),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              const Icon(
                                Icons.location_on_outlined,
                                size: 14,
                                color: Color(0xFF979797),
                              ),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  _locationText(turf),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: Color(0xFF909090),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Row(
                      children: [
                        const Icon(Icons.star_rounded, size: 15, color: Color(0xFF202020)),
                        const SizedBox(width: 3),
                        Text(
                          _ratingForTurf(turf),
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF232323),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Rs ${_formatPrice(price)}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF212121),
                        ),
                      ),
                    ),
                    _ActionChip(
                      label: 'View details',
                      onTap: onTap,
                    ),
                    const SizedBox(width: 10),
                    InkWell(
                      onTap: onTap,
                      borderRadius: BorderRadius.circular(999),
                      child: Container(
                        width: 42,
                        height: 42,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFF1F1F1F),
                        ),
                        child: const Icon(
                          Icons.arrow_outward_rounded,
                          size: 18,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NearbyTurfCard extends StatelessWidget {
  const _NearbyTurfCard({
    required this.turf,
    required this.isFavorite,
    required this.onFavoriteToggle,
    required this.onTap,
  });

  final Map<String, dynamic> turf;
  final bool isFavorite;
  final VoidCallback onFavoriteToggle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final imageUrl = (turf['image_url'] ?? '').toString();
    final price = turf['price_per_hour'] ?? 0;

    return GestureDetector(
      onTap: onTap,
      child: _GlassCard(
        borderRadius: BorderRadius.circular(28),
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(26),
              child: SizedBox(
                height: 150,
                width: double.infinity,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    _TurfImage(imageUrl: imageUrl, icon: _sportIconForTurf(turf)),
                    Positioned(
                      top: 10,
                      left: 10,
                      child: _CircleOverlayButton(
                        icon: isFavorite
                            ? Icons.favorite_rounded
                            : Icons.favorite_border_rounded,
                        iconColor: isFavorite
                            ? const Color(0xFF202020)
                            : const Color(0xFF919191),
                        onTap: onFavoriteToggle,
                      ),
                    ),
                    Positioned(
                      top: 10,
                      right: 10,
                      child: Container(
                        padding:
                            const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.82),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(
                          _sportLabelForTurf(turf),
                          style: const TextStyle(
                            fontSize: 11,
                            color: Color(0xFF4F4F4F),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 14),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6),
              child: Text(
                turf['name'] ?? '',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF202020),
                ),
              ),
            ),
            const SizedBox(height: 6),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6),
              child: Text(
                _locationText(turf),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 13,
                  color: Color(0xFF909090),
                ),
              ),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6),
              child: Row(
                children: [
                  Text(
                    'Rs ${_formatPrice(price)}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF212121),
                    ),
                  ),
                  const Spacer(),
                  const Icon(Icons.star_rounded, size: 15, color: Color(0xFF202020)),
                  const SizedBox(width: 4),
                  Text(
                    _ratingForTurf(turf),
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF2A2A2A),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 4),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6),
              child: Text(
                _distanceForTurf(turf),
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFF9A9A9A),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LiquidGlassNavBar extends StatelessWidget {
  const _LiquidGlassNavBar({
    required this.selectedIndex,
    required this.items,
    required this.onTap,
  });

  final int selectedIndex;
  final List<_NavItem> items;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(30),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white.withOpacity(0.62),
                Colors.white.withOpacity(0.34),
              ],
            ),
            border: Border.all(color: Colors.white.withOpacity(0.55)),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF6C4CF1).withOpacity(0.14),
                blurRadius: 24,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(items.length, (index) {
              final item = items[index];
              final isSelected = index == selectedIndex;
              return Expanded(
                child: GestureDetector(
                  onTap: () => onTap(index),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 220),
                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(22),
                      color: isSelected
                          ? const Color(0xFF6C4CF1).withOpacity(0.16)
                          : Colors.transparent,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          item.icon,
                          size: 20,
                          color: isSelected
                              ? const Color(0xFF6C4CF1)
                              : const Color(0xFF6B7280),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          item.label,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                            color: isSelected
                                ? const Color(0xFF6C4CF1)
                                : const Color(0xFF6B7280),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

class _GlassCard extends StatelessWidget {
  const _GlassCard({
    required this.child,
    required this.borderRadius,
    this.padding = EdgeInsets.zero,
  });

  final Widget child;
  final BorderRadius borderRadius;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            borderRadius: borderRadius,
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white.withOpacity(0.62),
                Colors.white.withOpacity(0.28),
              ],
            ),
            border: Border.all(color: Colors.white.withOpacity(0.55)),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF6C4CF1).withOpacity(0.08),
                blurRadius: 24,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          child: child,
        ),
      ),
    );
  }
}

class _GlassIconButton extends StatelessWidget {
  const _GlassIconButton({
    required this.icon,
    required this.onTap,
    this.label,
  });

  final IconData icon;
  final VoidCallback onTap;
  final String? label;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
          child: Container(
            height: 46,
            padding: EdgeInsets.symmetric(horizontal: label == null ? 0 : 14),
            constraints: BoxConstraints(minWidth: label == null ? 46 : 72),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.52),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white.withOpacity(0.6)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 20, color: const Color(0xFF6C4CF1)),
                if (label != null) ...[
                  const SizedBox(width: 6),
                  Text(
                    label!,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF6C4CF1),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CircleOverlayButton extends StatelessWidget {
  const _CircleOverlayButton({
    required this.icon,
    required this.iconColor,
    required this.onTap,
  });

  final IconData icon;
  final Color iconColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 34,
        height: 34,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.78),
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white.withOpacity(0.92)),
        ),
        child: Icon(icon, size: 18, color: iconColor),
      ),
    );
  }
}

class _ActionChip extends StatelessWidget {
  const _ActionChip({
    required this.label,
    required this.onTap,
  });

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 11),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.88),
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: Colors.white.withOpacity(0.96)),
        ),
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: Color(0xFF3A3A3A),
          ),
        ),
      ),
    );
  }
}

class _FavoriteButton extends StatelessWidget {
  const _FavoriteButton({
    required this.isFavorite,
    required this.onTap,
  });

  final bool isFavorite;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 34,
        height: 34,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.22),
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white.withOpacity(0.28)),
        ),
        child: Icon(
          isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
          size: 18,
          color: isFavorite ? const Color(0xFFFF6B81) : Colors.white,
        ),
      ),
    );
  }
}

class _InfoPill extends StatelessWidget {
  const _InfoPill({
    required this.icon,
    required this.text,
    required this.color,
  });

  final IconData icon;
  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 6),
          Flexible(
            child: Text(
              text,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TurfImage extends StatelessWidget {
  const _TurfImage({
    required this.imageUrl,
    required this.icon,
  });

  final String imageUrl;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    if (imageUrl.isEmpty) {
      return Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFA78BFA),
              Color(0xFF6C4CF1),
            ],
          ),
        ),
        child: Icon(icon, size: 42, color: Colors.white),
      );
    }

    return Image.network(
      imageUrl,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) {
        return Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFFA78BFA),
                Color(0xFF6C4CF1),
              ],
            ),
          ),
          child: Icon(icon, size: 42, color: Colors.white),
        );
      },
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({
    required this.error,
    required this.onRetry,
  });

  final String error;
  final Future<void> Function() onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: _GlassCard(
          borderRadius: BorderRadius.circular(30),
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.cloud_off_rounded, size: 44, color: Color(0xFF6C4CF1)),
              const SizedBox(height: 14),
              const Text(
                'Failed to load turfs',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1F2937),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                error,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 13,
                  color: Color(0xFF6B7280),
                ),
              ),
              const SizedBox(height: 18),
              ElevatedButton(
                onPressed: onRetry,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6C4CF1),
                  foregroundColor: Colors.white,
                ),
                child: const Text('Retry'),
              ),
            ],
          ),
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
  final dynamic raw = turf['rating'];
  if (raw is num) {
    return raw.toStringAsFixed(1);
  }

  final id = int.tryParse('${turf['id'] ?? 0}') ?? 0;
  final synthetic = 4.2 + (id % 6) * 0.1;
  return synthetic.toStringAsFixed(1);
}

String _distanceForTurf(Map<String, dynamic> turf) {
  final dynamic raw = turf['distance'];
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
