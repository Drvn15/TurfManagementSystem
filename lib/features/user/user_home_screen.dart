import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_theme.dart'; // Fixed path
import '../auth/auth_controller.dart';
import '../turf/turf_controller.dart';
import '../turf/turf_detail_screen.dart';
import '../booking/screens/my_booking_screen.dart';

class UserHomeScreen extends ConsumerStatefulWidget {
  const UserHomeScreen({super.key});

  @override
  ConsumerState<UserHomeScreen> createState() => _UserHomeScreenState();
}

class _UserHomeScreenState extends ConsumerState<UserHomeScreen> {
  final TextEditingController _searchController = TextEditingController();

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

  @override
  Widget build(BuildContext context) {
    final turfState = ref.watch(turfControllerProvider);
    final query = _searchController.text.toLowerCase();
    final turfCount = turfState.maybeWhen(
      data: (turfs) {
        final allTurfs = List<Map<String, dynamic>>.from(turfs);
        final filteredTurfs = query.isEmpty
            ? allTurfs
            : allTurfs.where((turf) {
                final name = (turf["name"] ?? "").toString().toLowerCase();
                final location = (turf["location"] ?? "").toString().toLowerCase();
                return name.contains(query) || location.contains(query);
              }).toList();
        return filteredTurfs.length;
      },
      orElse: () => 0,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text("Explore Turfs"),
        backgroundColor: AppTheme.purplePrimary,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _refreshTurfs,
          ),
          IconButton(
            icon: Icon(Icons.calendar_today),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const MyBookingsScreen()),
              ).then((_) {
                _refreshTurfs();
              });
            },
          ),
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              ref.read(authControllerProvider.notifier).logout();
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refreshTurfs,
        color: AppTheme.purplePrimary,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: "Search turfs by name or location...",
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "All Locations",
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppTheme.purpleLight,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.filter_list, size: 16, color: AppTheme.purplePrimary),
                        SizedBox(width: 4),
                        Text(
                          "$turfCount turfs",
                          style: TextStyle(
                            fontSize: 12,
                            color: AppTheme.purplePrimary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 16),

            Expanded(
              child: turfState.when(
                loading: () => Center(
                  child: CircularProgressIndicator(),
                ),
                error: (error, stack) => Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error_outline, size: 48, color: Colors.red),
                      SizedBox(height: 16),
                      Text(
                        "Failed to load turfs",
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      SizedBox(height: 8),
                      Text(
                        error.toString(),
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.grey),
                      ),
                      SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _refreshTurfs,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.purplePrimary,
                        ),
                        child: Text("Retry"),
                      ),
                    ],
                  ),
                ),
                data: (turfs) {
                  final allTurfs = List<Map<String, dynamic>>.from(turfs);
                  final filteredTurfs = query.isEmpty
                      ? allTurfs
                      : allTurfs.where((turf) {
                          final name = (turf["name"] ?? "").toString().toLowerCase();
                          final location = (turf["location"] ?? "").toString().toLowerCase();
                          return name.contains(query) || location.contains(query);
                        }).toList();

                  if (filteredTurfs.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            _searchController.text.isEmpty
                                ? Icons.sports_soccer
                                : Icons.search_off,
                            size: 64,
                            color: Colors.grey.shade400,
                          ),
                          SizedBox(height: 16),
                          Text(
                            _searchController.text.isEmpty
                                ? "No turfs available"
                                : "No turfs match your search",
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: Colors.grey.shade600,
                            ),
                          ),
                          if (_searchController.text.isNotEmpty) ...[
                            SizedBox(height: 8),
                            TextButton(
                              onPressed: () {
                                _searchController.clear();
                                _filterTurfs();
                              },
                              child: Text("Clear search"),
                            ),
                          ],
                        ],
                      ),
                    );
                  }

                  return GridView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    itemCount: filteredTurfs.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                      childAspectRatio: 0.85,
                    ),
                    itemBuilder: (context, index) {
                      final turf = filteredTurfs[index];

                      return GestureDetector(
                        onTap: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => TurfDetailScreen(turf: turf),
                            ),
                          );
                          _refreshTurfs();
                        },
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: Colors.grey.shade300),
                            color: Colors.white,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width: double.infinity,
                                height: 80,
                                decoration: BoxDecoration(
                                  color: AppTheme.purpleLight,
                                  borderRadius: BorderRadius.circular(12),
                                  image: turf["image_url"] != null &&
                                      turf["image_url"].toString().isNotEmpty
                                      ? DecorationImage(
                                    image: NetworkImage(turf["image_url"]),
                                    fit: BoxFit.cover,
                                  )
                                      : null,
                                ),
                                child: turf["image_url"] == null ||
                                    turf["image_url"].toString().isEmpty
                                    ? Icon(
                                  Icons.sports_soccer,
                                  size: 40,
                                  color: AppTheme.purplePrimary,
                                )
                                    : null,
                              ),
                              SizedBox(height: 8),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    turf["name"] ?? "",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  SizedBox(height: 4),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.location_on,
                                        size: 12,
                                        color: Colors.grey.shade500,
                                      ),
                                      SizedBox(width: 2),
                                      Expanded(
                                        child: Text(
                                          turf["location"] ?? "",
                                          style: TextStyle(
                                            fontSize: 11,
                                            color: Colors.grey.shade600,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    "₹${turf["price_per_hour"] ?? 0}/hr",
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: AppTheme.purplePrimary,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
