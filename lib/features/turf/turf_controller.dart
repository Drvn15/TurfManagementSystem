import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/api/api_client.dart';

final turfControllerProvider = StateNotifierProvider<TurfController, AsyncValue<List<Map<String, dynamic>>>>(
      (ref) => TurfController(),
);

// Individual turf detail provider
final turfDetailProvider = FutureProvider.family<Map<String, dynamic>, int>((ref, turfId) async {
  final api = ApiClient();
  try {
    final response = await api.get("/turfs/$turfId");
    return response as Map<String, dynamic>;
  } catch (e) {
    print("❌ Error fetching turf detail: $e");
    rethrow;
  }
});

class TurfController extends StateNotifier<AsyncValue<List<Map<String, dynamic>>>> {
  TurfController() : super(const AsyncValue.loading());

  final ApiClient _api = ApiClient();

  Future<void> fetchTurfs() async {
    state = const AsyncValue.loading();

    try {
      final response = await _api.get("/turfs");
      final turfs = List<Map<String, dynamic>>.from(response);
      state = AsyncValue.data(turfs);
      print("✅ Fetched ${turfs.length} turfs");
    } catch (e, st) {
      print("❌ Error fetching turfs: $e");
      state = AsyncValue.error(e, st);
    }
  }

  // Method to refresh a single turf after update
  Future<Map<String, dynamic>?> refreshTurf(int turfId) async {
    try {
      final response = await _api.get("/turfs/$turfId");
      final updatedTurf = response as Map<String, dynamic>;

      // Update the list state if we have it
      state.whenData((turfs) {
        final updatedList = turfs.map((turf) {
          if (turf['id'] == turfId) {
            return updatedTurf;
          }
          return turf;
        }).toList();

        // Only update if not disposed
        if (mounted) {
          state = AsyncValue.data(updatedList);
        }
      });

      print("✅ Refreshed turf $turfId");
      return updatedTurf;
    } catch (e) {
      print("❌ Error refreshing turf $turfId: $e");
      return null;
    }
  }

  // Force refresh all turfs
  Future<void> refreshAllTurfs() async {
    await fetchTurfs();
  }
}