import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/api/api_client.dart';
import '../../core/theme/app_theme.dart';
import 'add_edit_sport_screen.dart';
import 'court_list_screen.dart';

class SportListScreen extends ConsumerStatefulWidget {
  final Map<String, dynamic> turf;

  const SportListScreen({super.key, required this.turf});

  @override
  ConsumerState<SportListScreen> createState() => _SportListScreenState();
}

class _SportListScreenState extends ConsumerState<SportListScreen> {
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

  Future<void> _deleteSport(int id) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Delete Sport"),
        content: Text("Are you sure you want to delete this sport? All associated courts will also be deleted."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: Text("Delete"),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    try {
      await _api.delete("/sports/$id");
      _fetchSports();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Sport deleted successfully"),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Delete failed: ${e.toString()}"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sports at ${widget.turf['name']}"),
        backgroundColor: AppTheme.purplePrimary,
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => AddEditSportScreen(
                    turfId: widget.turf['id'],
                  ),
                ),
              );
              _fetchSports();
            },
          ),
        ],
      ),
      body: _errorMessage != null
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 48, color: Colors.red),
            SizedBox(height: 16),
            Text(
              _errorMessage!,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.grey),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _fetchSports,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.purplePrimary,
              ),
              child: Text("Retry"),
            ),
          ],
        ),
      )
          : FutureBuilder<List<dynamic>>(
        future: _sportsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 48, color: Colors.red),
                  SizedBox(height: 16),
                  Text('Error loading sports: ${snapshot.error}'),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _fetchSports,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.purplePrimary,
                    ),
                    child: Text("Retry"),
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
                  Icon(
                    Icons.sports_tennis,
                    size: 64,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 16),
                  Text(
                    "No sports added yet",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "Tap the + button to add your first sport",
                    style: TextStyle(color: Colors.grey),
                  ),
                  SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => AddEditSportScreen(
                            turfId: widget.turf['id'],
                          ),
                        ),
                      );
                      _fetchSports();
                    },
                    icon: Icon(Icons.add),
                    label: Text("Add Sport"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.purplePrimary,
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: sports.length,
            itemBuilder: (context, index) {
              final sport = sports[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16),
                  leading: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: AppTheme.purpleLight,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.sports_tennis,
                      color: AppTheme.purplePrimary,
                    ),
                  ),
                  title: Text(
                    sport['name'] ?? '',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    'Click to manage courts',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit, color: Colors.blue),
                        onPressed: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => AddEditSportScreen(
                                turfId: widget.turf['id'],
                                sport: sport,
                              ),
                            ),
                          );
                          _fetchSports();
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _deleteSport(sport['id']),
                      ),
                    ],
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => CourtListScreen(
                          sport: sport,
                          turfName: widget.turf['name'],
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
