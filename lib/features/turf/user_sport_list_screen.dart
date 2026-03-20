import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/api/api_client.dart';
import '../../core/theme/app_theme.dart';
import 'user_court_list_screen.dart';  // ✅ FIXED: Correct relative path

class UserSportListScreen extends ConsumerStatefulWidget {
  final Map<String, dynamic> turf;

  const UserSportListScreen({super.key, required this.turf});

  @override
  ConsumerState<UserSportListScreen> createState() => _UserSportListScreenState();
}

class _UserSportListScreenState extends ConsumerState<UserSportListScreen> {
  final ApiClient _api = ApiClient();
  late Future<List<dynamic>> _sportsFuture;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchSports();
  }

  void _fetchSports() {
    setState(() {
      _sportsFuture = _api.get("/sports/${widget.turf['id']}").then((response) {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.turf['name'] ?? 'Select Sport'),
        backgroundColor: AppTheme.purplePrimary,
      ),
      body: FutureBuilder<List<dynamic>>(
        future: _sportsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError || _errorMessage != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64, color: Colors.red),
                  SizedBox(height: 16),
                  Text(
                    'Error loading sports',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  SizedBox(height: 8),
                  Text(
                    _errorMessage ?? snapshot.error.toString(),
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.grey),
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _fetchSports,
                    child: Text('Retry'),
                  ),
                ],
              ),
            );
          }

          final sports = snapshot.data ?? [];

          if (sports.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.sports, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'No sports available',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  SizedBox(height: 8),
                  Text(
                    'This turf hasn\'t added any sports yet',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          return GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 1.2,
            ),
            itemCount: sports.length,
            itemBuilder: (context, index) {
              final sport = sports[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => UserCourtListScreen(
                        sport: sport,
                        turfName: widget.turf['name'],
                      ),
                    ),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: AppTheme.purpleLight,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppTheme.purplePrimary.withOpacity(0.3)),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.sports_tennis,
                        size: 48,
                        color: AppTheme.purplePrimary,
                      ),
                      SizedBox(height: 8),
                      Text(
                        sport['name'] ?? '',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
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
