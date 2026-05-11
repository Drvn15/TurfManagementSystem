import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/api/api_client.dart';
import '../../core/theme/app_theme.dart';
import '../booking/slot_selection_screen.dart';

class UserCourtListScreen extends ConsumerStatefulWidget {
  final Map<String, dynamic> sport;
  final String turfName;

  const UserCourtListScreen({
    super.key,
    required this.sport,
    required this.turfName,
  });

  @override
  ConsumerState<UserCourtListScreen> createState() => _UserCourtListScreenState();
}

class _UserCourtListScreenState extends ConsumerState<UserCourtListScreen> {
  final ApiClient _api = ApiClient();
  late Future<List<dynamic>> _courtsFuture;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchCourts();
  }

  void _fetchCourts() {
    setState(() {
      _courtsFuture = _api.get("/courts/${widget.sport['id']}").then((response) {
        if (response is List) {
          return response;
        }
        return [];
      }).catchError((error) {
        setState(() {
          _errorMessage = error.toString();
        });
        return [];
      });
    });
  }

  String _formatTime(String? time) {
    if (time == null || time.isEmpty) return 'Not set';
    if (time.length >= 5) {
      return time.substring(0, 5);
    }
    return time;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.sport['name']} Courts'),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: _courtsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError || _errorMessage != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(
                    'Error loading courts',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _errorMessage ?? snapshot.error.toString(),
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _fetchCourts,
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          final courts = snapshot.data ?? [];

          if (courts.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.sports_tennis, size: 64, color: Colors.grey),
                  const SizedBox(height: 16),
                  Text(
                    'No courts available',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'This sport hasn\'t been configured with courts yet',
                    style: TextStyle(color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: courts.length,
            itemBuilder: (context, index) {
              final court = courts[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 2,
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => SlotSelectionScreen(
                          court: court,
                          turfName: widget.turfName,
                          sportName: widget.sport['name'],
                        ),
                      ),
                    );
                  },
                  borderRadius: BorderRadius.circular(16),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                court['name'] ?? 'Court',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: DesignSystem.backgroundLight,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                '₹${court['price'] ?? 0}',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: DesignSystem.primaryIndigo,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade100,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                court['slot_type'] ?? 'hourly',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey.shade700,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Icon(Icons.access_time, size: 16, color: Colors.grey),
                            const SizedBox(width: 4),
                            Text(
                              '${_formatTime(court['morning_start'])} - ${_formatTime(court['morning_end'])}',
                              style: const TextStyle(fontSize: 12, color: Colors.grey),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Padding(
                          padding: const EdgeInsets.only(left: 24),
                          child: Text(
                            'Evening: ${_formatTime(court['evening_start'])} - ${_formatTime(court['evening_end'])}',
                            style: const TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
