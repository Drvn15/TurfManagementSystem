import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/api/api_client.dart';
import '../../core/theme/app_theme.dart';
import 'add_edit_court_screen.dart';

class CourtListScreen extends ConsumerStatefulWidget {
  final Map<String, dynamic> sport;
  final String turfName;

  const CourtListScreen({
    super.key,
    required this.sport,
    required this.turfName,
  });

  @override
  ConsumerState<CourtListScreen> createState() => _CourtListScreenState();
}

class _CourtListScreenState extends ConsumerState<CourtListScreen> {
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

  Future<void> _deleteCourt(int id) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Delete Court"),
        content: Text("Are you sure you want to delete this court?"),
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
      await _api.delete("/courts/$id");
      _fetchCourts();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Court deleted successfully"),
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
      backgroundColor: AppTheme.purpleBackground,
      appBar: AppBar(
        title: Text("${widget.sport['name']} Courts"),
        backgroundColor: AppTheme.purplePrimary,
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => AddEditCourtScreen(
                    sportId: widget.sport['id'],
                  ),
                ),
              );
              _fetchCourts();
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
              onPressed: _fetchCourts,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.purplePrimary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: const Text("Retry"),
            ),
          ],
        ),
      )
          : FutureBuilder<List<dynamic>>(
        future: _courtsFuture,
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
                  Text('Error loading courts: ${snapshot.error}'),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _fetchCourts,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.purplePrimary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: const Text("Retry"),
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
                  Icon(
                    Icons.sports_tennis,
                    size: 64,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 16),
                  Text(
                    "No courts added yet",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "Tap the + button to add a court for ${widget.sport['name']}",
                    style: const TextStyle(color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => AddEditCourtScreen(
                            sportId: widget.sport['id'],
                          ),
                        ),
                      );
                      _fetchCourts();
                    },
                    icon: Icon(Icons.add),
                    label: Text("Add Court"),
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
            itemCount: courts.length,
            itemBuilder: (context, index) {
              final court = courts[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 2,
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
                              court['name'] ?? '',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              IconButton(
                                icon: Icon(Icons.edit, color: Colors.blue),
                                onPressed: () async {
                                  await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => AddEditCourtScreen(
                                        sportId: widget.sport['id'],
                                        court: court,
                                      ),
                                    ),
                                  );
                                  _fetchCourts();
                                },
                              ),
                              IconButton(
                                icon: Icon(Icons.delete, color: Colors.red),
                                onPressed: () => _deleteCourt(court['id']),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppTheme.purpleLight,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              court['slot_type'] ?? 'hourly',
                              style: TextStyle(
                                fontSize: 12,
                                color: AppTheme.purplePrimary,
                              ),
                            ),
                          ),
                          SizedBox(width: 8),
                          Text(
                            '₹${court['price'] ?? 0} per slot',
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 12),
                      Text(
                        'Morning Session:',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        '${_formatTime(court['morning_start'])} - ${_formatTime(court['morning_end'])}',
                        style: const TextStyle(fontSize: 14),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Evening Session:',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        '${_formatTime(court['evening_start'])} - ${_formatTime(court['evening_end'])}',
                        style: const TextStyle(fontSize: 14),
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
