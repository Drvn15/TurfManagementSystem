import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_theme.dart'; // Fixed path
import 'turf_controller.dart';
import 'user_sport_list_screen.dart';

class TurfDetailScreen extends ConsumerStatefulWidget {
  final Map<String, dynamic> turf;

  const TurfDetailScreen({super.key, required this.turf});

  @override
  ConsumerState<TurfDetailScreen> createState() => _TurfDetailScreenState();
}

class _TurfDetailScreenState extends ConsumerState<TurfDetailScreen> {
  late Map<String, dynamic> _currentTurf;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _currentTurf = widget.turf;
    _refreshTurfData();
  }

  Future<void> _refreshTurfData() async {
    setState(() => _isLoading = true);

    try {
      final refreshedTurf = await ref.read(turfControllerProvider.notifier).refreshTurf(widget.turf['id']);
      if (refreshedTurf != null && mounted) {
        setState(() {
          _currentTurf = refreshedTurf;
        });
      }
    } catch (e) {
      print("Error refreshing turf data: $e");
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_currentTurf['name'] ?? 'Turf Details'),
        backgroundColor: AppTheme.purplePrimary,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _refreshTurfData,
          ),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : RefreshIndicator(
        onRefresh: _refreshTurfData,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(16),
                  image: _currentTurf['image_url'] != null &&
                      _currentTurf['image_url'].toString().isNotEmpty
                      ? DecorationImage(
                    image: NetworkImage(_currentTurf['image_url']),
                    fit: BoxFit.cover,
                  )
                      : null,
                ),
                child: _currentTurf['image_url'] == null ||
                    _currentTurf['image_url'].toString().isEmpty
                    ? Center(
                  child: Icon(
                    Icons.sports_soccer,
                    size: 80,
                    color: Colors.grey,
                  ),
                )
                    : null,
              ),

              SizedBox(height: 16),

              Text(
                _currentTurf['name'] ?? '',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),

              SizedBox(height: 8),

              Row(
                children: [
                  Icon(Icons.location_on, color: Colors.grey, size: 20),
                  SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      _currentTurf['location'] ?? '',
                      style: const TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ),
                ],
              ),

              if (_currentTurf['description'] != null &&
                  _currentTurf['description'].toString().isNotEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Text(
                    _currentTurf['description'],
                    style: const TextStyle(fontSize: 14),
                  ),
                ),

              SizedBox(height: 16),

              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: AppTheme.purpleLight,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '₹${_currentTurf['price_per_hour'] ?? 0}/hour',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.purplePrimary,
                  ),
                ),
              ),

              SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => UserSportListScreen(turf: _currentTurf),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.purplePrimary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Text(
                    "Select Sport",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
