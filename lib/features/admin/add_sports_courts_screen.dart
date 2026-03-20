import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../../core/api/api_client.dart';
import '../../core/theme/app_theme.dart';

class AddSportsCourtsScreen extends StatefulWidget {
  final int turfId;

  const AddSportsCourtsScreen({super.key, required this.turfId});

  @override
  State<AddSportsCourtsScreen> createState() => _AddSportsCourtsScreenState();
}

class _AddSportsCourtsScreenState extends State<AddSportsCourtsScreen> {
  final ApiClient _api = ApiClient();
  bool _isLoading = false;
  String? _errorMessage;

  // Session timings (global per turf)
  TimeOfDay _morningStart = const TimeOfDay(hour: 6, minute: 0);
  TimeOfDay _morningEnd = const TimeOfDay(hour: 12, minute: 0);
  TimeOfDay _eveningStart = const TimeOfDay(hour: 16, minute: 0);
  TimeOfDay _eveningEnd = const TimeOfDay(hour: 22, minute: 0);

  // Sports list with search
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _availableSports = [];
  final List<Map<String, dynamic>> _selectedSports = [];

  // Sample sports data with proper icons
  final List<Map<String, dynamic>> _allSports = [
    {'id': 1, 'name': 'Badminton', 'icon': Icons.sports_tennis},
    {'id': 2, 'name': 'Cricket', 'icon': Icons.sports_cricket},
    {'id': 3, 'name': 'Football', 'icon': Icons.sports_soccer},
    {'id': 4, 'name': 'Tennis', 'icon': Icons.sports_tennis},
    {'id': 5, 'name': 'Basketball', 'icon': Icons.sports_basketball},
    {'id': 6, 'name': 'Volleyball', 'icon': Icons.sports_volleyball},
    {'id': 7, 'name': 'Table Tennis', 'icon': Icons.sports_tennis},
    {'id': 8, 'name': 'Swimming', 'icon': Icons.pool},
    {'id': 9, 'name': 'Pickleball', 'icon': Icons.sports_tennis},
    {'id': 10, 'name': 'Squash', 'icon': Icons.sports_tennis},
  ];

  @override
  void initState() {
    super.initState();
    _availableSports = List.from(_allSports);
    _searchController.addListener(_filterSports);
  }

  void _filterSports() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _availableSports = List.from(_allSports);
      } else {
        _availableSports = _allSports
            .where((sport) => sport['name'].toLowerCase().contains(query))
            .toList();
      }
    });
  }

  void _addSport(Map<String, dynamic> sport) {
    setState(() {
      _selectedSports.add({
        ...sport,
        'courtCount': 1,
        'slotType': 'hourly', // Default slot type
      });
      _availableSports.remove(sport);
      _searchController.clear();
      _errorMessage = null;
    });
  }

  void _removeSport(Map<String, dynamic> sport) {
    setState(() {
      _selectedSports.remove(sport);
      _availableSports.add(sport);
      _availableSports.sort((a, b) => a['name'].compareTo(b['name']));
      _errorMessage = null;
    });
  }

  void _updateCourtCount(Map<String, dynamic> sport, int increment) {
    setState(() {
      final newCount = (sport['courtCount'] ?? 1) + increment;
      if (newCount >= 1 && newCount <= 10) {
        sport['courtCount'] = newCount;
      }
    });
  }

  void _updateSlotType(Map<String, dynamic> sport, String value) {
    setState(() {
      sport['slotType'] = value;
    });
  }

  Future<void> _selectTime(BuildContext context, TimeOfDay initialTime,
      Function(TimeOfDay) onSelected) async {
    final selected = await showTimePicker(
      context: context,
      initialTime: initialTime,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppTheme.purplePrimary,
            ),
          ),
          child: child!,
        );
      },
    );
    if (selected != null) {
      onSelected(selected);
    }
  }

  String _formatTimeOfDay(TimeOfDay time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}:00';
  }

  bool _validateTimings() {
    // Convert to minutes for comparison
    int morningStart = _morningStart.hour * 60 + _morningStart.minute;
    int morningEnd = _morningEnd.hour * 60 + _morningEnd.minute;
    int eveningStart = _eveningStart.hour * 60 + _eveningStart.minute;
    int eveningEnd = _eveningEnd.hour * 60 + _eveningEnd.minute;

    if (morningStart >= morningEnd) {
      _showErrorDialog("Morning start time must be before end time");
      return false;
    }
    if (eveningStart >= eveningEnd) {
      _showErrorDialog("Evening start time must be before end time");
      return false;
    }
    if (morningEnd > eveningStart) {
      _showErrorDialog("Morning session cannot overlap with evening session");
      return false;
    }
    return true;
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Validation Error"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("OK"),
          ),
        ],
      ),
    );
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text("Success! 🎉"),
        content: Text("Your turf has been set up successfully."),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              Navigator.popUntil(context, (route) => route.isFirst); // Go to home
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.purplePrimary,
            ),
            child: Text("Go to Dashboard"),
          ),
        ],
      ),
    );
  }

  Future<void> _saveAll() async {
    // Validation
    if (_selectedSports.isEmpty) {
      _showErrorDialog("Please add at least one sport");
      return;
    }

    if (!_validateTimings()) {
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // For each selected sport, create it and then create courts
      for (var sport in _selectedSports) {
        print("📝 Creating sport: ${sport['name']}");

        // Create sport
        final sportResponse = await _api.post(
          "/sports",
          body: {
            "turf_id": widget.turfId,
            "name": sport['name'],
          },
        );

        if (sportResponse == null || sportResponse['id'] == null) {
          throw Exception("Failed to create sport: Invalid response from server");
        }

        final sportId = sportResponse['id'];
        print("✅ Sport created with ID: $sportId");

        // Create courts for this sport
        for (int i = 1; i <= sport['courtCount']; i++) {
          final courtName = sport['courtCount'] > 1
              ? "${sport['name']} Court $i"
              : sport['name'];

          print("🏟️ Creating court: $courtName");

          final courtData = {
            "sport_id": sportId,
            "name": courtName,
            "slot_type": sport['slotType'] ?? 'hourly',
            "price": 500, // Default price - can be made configurable later
            "morning_start": _formatTimeOfDay(_morningStart),
            "morning_end": _formatTimeOfDay(_morningEnd),
            "evening_start": _formatTimeOfDay(_eveningStart),
            "evening_end": _formatTimeOfDay(_eveningEnd),
          };

          print("Court data: $courtData");

          final courtResponse = await _api.post(
            "/courts",
            body: courtData,
          );

          if (courtResponse == null) {
            throw Exception("Failed to create court: $courtName");
          }

          print("✅ Court created successfully");
        }
      }

      print("✅ All sports and courts created successfully!");

      if (!mounted) return;

      // Show success dialog
      _showSuccessDialog();

    } catch (e) {
      print("❌ ERROR: $e");

      String errorMessage = "Failed to save configuration";

      if (e is DioException) {
        print("Status code: ${e.response?.statusCode}");
        print("Response data: ${e.response?.data}");

        if (e.response?.data != null) {
          if (e.response?.data is Map) {
            errorMessage = (e.response?.data as Map)['error'] ??
                (e.response?.data as Map)['message'] ??
                "Server error";
          } else {
            errorMessage = e.response?.data?.toString() ?? "Unknown error";
          }
        }

        if (e.response?.statusCode == 400) {
          errorMessage = "Invalid data sent to server. Please check all fields.";
        } else if (e.response?.statusCode == 401) {
          errorMessage = "Authentication failed. Please login again.";
        } else if (e.response?.statusCode == 403) {
          errorMessage = "You don't have permission to perform this action.";
        } else if (e.response?.statusCode == 404) {
          errorMessage = "Server endpoint not found.";
        } else if (e.response?.statusCode == 500) {
          errorMessage = "Server error. Please try again later.";
        }
      } else {
        errorMessage = e.toString();
      }

      if (!mounted) return;

      setState(() {
        _errorMessage = errorMessage;
      });

      // Show error dialog
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Error"),
          content: Text(errorMessage),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("OK"),
            ),
          ],
        ),
      );

    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Configure Sports & Courts"),
        backgroundColor: AppTheme.purplePrimary,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Progress Indicator
                Row(
                  children: [
                    _buildStepIndicator(1, true),
                    Expanded(child: Divider(color: Colors.grey.shade300)),
                    _buildStepIndicator(2, true),
                    Expanded(child: Divider(color: Colors.grey.shade300)),
                    _buildStepIndicator(3, true),
                  ],
                ),

                SizedBox(height: 32),

                // Error Message (if any)
                if (_errorMessage != null)
                  Container(
                    padding: const EdgeInsets.all(16),
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.red.shade200),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.error_outline, color: Colors.red.shade700),
                        SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            _errorMessage!,
                            style: TextStyle(color: Colors.red.shade700),
                          ),
                        ),
                      ],
                    ),
                  ),

                // Session Timings Card
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Session Timings",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 16),

                        // Morning Session
                        Text(
                          "Morning Session",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.purplePrimary,
                          ),
                        ),
                        SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              child: ListTile(
                                title: Text("Start Time"),
                                subtitle: Text(_morningStart.format(context)),
                                trailing: Icon(Icons.access_time),
                                onTap: () => _selectTime(
                                  context,
                                  _morningStart,
                                      (time) => setState(() => _morningStart = time),
                                ),
                              ),
                            ),
                            Expanded(
                              child: ListTile(
                                title: Text("End Time"),
                                subtitle: Text(_morningEnd.format(context)),
                                trailing: Icon(Icons.access_time),
                                onTap: () => _selectTime(
                                  context,
                                  _morningEnd,
                                      (time) => setState(() => _morningEnd = time),
                                ),
                              ),
                            ),
                          ],
                        ),

                        const Divider(height: 32),

                        // Evening Session
                        Text(
                          "Evening Session",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.purplePrimary,
                          ),
                        ),
                        SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              child: ListTile(
                                title: Text("Start Time"),
                                subtitle: Text(_eveningStart.format(context)),
                                trailing: Icon(Icons.access_time),
                                onTap: () => _selectTime(
                                  context,
                                  _eveningStart,
                                      (time) => setState(() => _eveningStart = time),
                                ),
                              ),
                            ),
                            Expanded(
                              child: ListTile(
                                title: Text("End Time"),
                                subtitle: Text(_eveningEnd.format(context)),
                                trailing: Icon(Icons.access_time),
                                onTap: () => _selectTime(
                                  context,
                                  _eveningEnd,
                                      (time) => setState(() => _eveningEnd = time),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: 24),

                // Add Sports Section
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Add Sports",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 16),

                        // Search Bar
                        TextField(
                          controller: _searchController,
                          decoration: InputDecoration(
                            hintText: "Search sports...",
                            prefixIcon: Icon(Icons.search),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            filled: true,
                            fillColor: Colors.grey.shade50,
                          ),
                        ),

                        SizedBox(height: 16),

                        // Available Sports List
                        _availableSports.isEmpty
                            ? Center(
                          child: Padding(
                            padding: EdgeInsets.all(16),
                            child: Text("No sports found"),
                          ),
                        )
                            : SizedBox(
                          height: 120,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: _availableSports.length,
                            itemBuilder: (context, index) {
                              final sport = _availableSports[index];
                              return GestureDetector(
                                onTap: () => _addSport(sport),
                                child: Container(
                                  width: 100,
                                  margin: const EdgeInsets.only(right: 12),
                                  decoration: BoxDecoration(
                                    color: AppTheme.purpleLight,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: AppTheme.purplePrimary.withOpacity(0.3),
                                    ),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        sport['icon'],
                                        color: AppTheme.purplePrimary,
                                        size: 32,
                                      ),
                                      SizedBox(height: 8),
                                      Text(
                                        sport['name'],
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: 24),

                // Selected Sports with Court Counters
                if (_selectedSports.isNotEmpty)
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Configure Courts",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 16),

                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: _selectedSports.length,
                            itemBuilder: (context, index) {
                              final sport = _selectedSports[index];
                              return Container(
                                margin: const EdgeInsets.only(bottom: 16),
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade50,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: Colors.grey.shade200),
                                ),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            sport['name'],
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                        IconButton(
                                          icon: Icon(Icons.close, color: Colors.red),
                                          onPressed: () => _removeSport(sport),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 12),

                                    // Slot Type Dropdown
                                    Row(
                                      children: [
                                        Text(
                                          "Slot Type: ",
                                          style: TextStyle(fontSize: 14),
                                        ),
                                        SizedBox(width: 8),
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 8),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(8),
                                            border: Border.all(color: Colors.grey.shade300),
                                          ),
                                          child: DropdownButton<String>(
                                            value: sport['slotType'],
                                            underline: SizedBox(),
                                            items: const [
                                              DropdownMenuItem(
                                                value: 'hourly',
                                                child: Text('Hourly'),
                                              ),
                                              DropdownMenuItem(
                                                value: 'half-hourly',
                                                child: Text('Half-Hourly'),
                                              ),
                                            ],
                                            onChanged: (value) {
                                              if (value != null) {
                                                _updateSlotType(sport, value);
                                              }
                                            },
                                          ),
                                        ),
                                      ],
                                    ),

                                    SizedBox(height: 12),

                                    // Court Counter
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Number of Courts",
                                          style: TextStyle(fontSize: 14),
                                        ),
                                        Row(
                                          children: [
                                            IconButton(
                                              icon: Icon(Icons.remove_circle_outline),
                                              onPressed: () => _updateCourtCount(sport, -1),
                                            ),
                                            Text(
                                              "${sport['courtCount']}",
                                              style: const TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            IconButton(
                                              icon: Icon(Icons.add_circle_outline),
                                              onPressed: () => _updateCourtCount(sport, 1),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),

                SizedBox(height: 100), // Space for bottom button
              ],
            ),
          ),

          // Bottom Save Button
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: _isLoading
                    ? Center(child: CircularProgressIndicator())
                    : ElevatedButton(
                  onPressed: _saveAll,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.purplePrimary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Text(
                    "Complete Setup",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepIndicator(int step, bool isActive) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isActive ? AppTheme.purplePrimary : Colors.grey.shade300,
      ),
      child: Center(
        child: Text(
          step.toString(),
          style: TextStyle(
            color: isActive ? Colors.white : Colors.grey.shade600,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.removeListener(_filterSports);
    _searchController.dispose();
    super.dispose();
  }
}
