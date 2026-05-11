import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../core/api/api_client.dart';
import '../../core/theme/app_theme.dart';
import 'add_photos_screen.dart';

class AddTurfDetailsScreen extends StatefulWidget {
  const AddTurfDetailsScreen({super.key});

  @override
  State<AddTurfDetailsScreen> createState() => _AddTurfDetailsScreenState();
}

class _AddTurfDetailsScreenState extends State<AddTurfDetailsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();

  // Location variables
  String _selectedAddress = "";
  LatLng? _selectedLatLng;
  bool _isLocationSelected = false;
  bool _isLoadingLocation = false;

  // Map controller
  final MapController _mapController = MapController();

  // Default location (center of India)
  static const LatLng _defaultLocation = LatLng(28.6139, 77.2090); // New Delhi

  bool _isLoading = false;
  final ApiClient _api = ApiClient();

  int? _createdTurfId;

  @override
  void initState() {
    super.initState();
    _checkLocationPermission();
  }

  Future<void> _checkLocationPermission() async {
    setState(() => _isLoadingLocation = true);

    var status = await Permission.location.status;

    if (!status.isGranted) {
      status = await Permission.location.request();
    }

    if (status.isGranted) {
      _getCurrentLocation();
    } else {
      setState(() {
        _isLoadingLocation = false;
        _selectedAddress = "Location permission denied. You can tap on map to select location.";
      });
    }
  }

  Future<void> _getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      setState(() {
        _selectedLatLng = LatLng(position.latitude, position.longitude);
      });

      // Move map to current location
      _mapController.move(_selectedLatLng!, 15);

      // Get address from coordinates
      await _getAddressFromLatLng();

    } catch (e) {
      setState(() {
        _selectedAddress = "Could not get current location. Tap on map to select.";
        _isLoadingLocation = false;
      });
    }
  }

  Future<void> _getAddressFromLatLng() async {
    if (_selectedLatLng == null) return;

    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        _selectedLatLng!.latitude,
        _selectedLatLng!.longitude,
      );

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks.first;
        setState(() {
          _selectedAddress = "${place.street}, ${place.locality}, ${place.administrativeArea}, ${place.country}";
          _isLocationSelected = true;
          _isLoadingLocation = false;
        });
      }
    } catch (e) {
      setState(() {
        _selectedAddress = "Lat: ${_selectedLatLng!.latitude.toStringAsFixed(4)}, Lng: ${_selectedLatLng!.longitude.toStringAsFixed(4)}";
        _isLocationSelected = true;
        _isLoadingLocation = false;
      });
    }
  }

  void _onMapTap(TapPosition tapPosition, LatLng latLng) {
    setState(() {
      _selectedLatLng = latLng;
      _isLoadingLocation = true;
    });

    // Move map center (optional)
    _mapController.move(latLng, _mapController.camera.zoom);

    // Get address for tapped location
    _getAddressFromLatLng();
  }

  Future<void> _saveAndContinue() async {
    if (!_formKey.currentState!.validate()) return;

    if (!_isLocationSelected) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select a location on the map")),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final response = await _api.post(
        "/turfs",
        body: {
          "name": _nameController.text.trim(),
          "location": _selectedAddress,
          "price_per_hour": int.parse(_priceController.text.trim()),
          "image_url": "",
        },
      );

      _createdTurfId = response['id'];

      if (!mounted) return;

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => AddPhotosScreen(turfId: _createdTurfId!),
        ),
      );
    } catch (e) {
      String errorMessage = "Failed to create turf";
      if (e.toString().contains("400")) {
        errorMessage = "Server rejected the data. Check all fields.";
      }

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $errorMessage")),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.purpleBackground,
      appBar: AppBar(
        title: const Text("Add Turf Details"),
        backgroundColor: AppTheme.purplePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Progress Indicator
            Row(
              children: [
                _buildStepIndicator(1, true),
                Expanded(child: Divider(color: Colors.grey.shade300)),
                _buildStepIndicator(2, false),
                Expanded(child: Divider(color: Colors.grey.shade300)),
                _buildStepIndicator(3, false),
              ],
            ),

            SizedBox(height: 32),

            Text(
              "Tell us about your turf",
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),

            SizedBox(height: 24),

            Form(
              key: _formKey,
              child: Column(
                children: [
                  // Turf Name
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: "Turf Name",
                      hintText: "e.g., Greenfield Arena",
                      prefixIcon: Icon(Icons.sports_soccer),
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter turf name";
                      }
                      return null;
                    },
                  ),

                  SizedBox(height: 20),

                  // Price per hour
                  TextFormField(
                    controller: _priceController,
                    decoration: const InputDecoration(
                      labelText: "Price per hour (₹)",
                      hintText: "e.g., 500",
                      prefixIcon: Icon(Icons.currency_rupee),
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter price per hour";
                      }
                      if (int.tryParse(value) == null) {
                        return "Please enter a valid number";
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),

            SizedBox(height: 32),

            // Location Section
            Text(
              "Select Location",
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),

            SizedBox(height: 8),

            Text(
              "Tap on the map to set your turf location",
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 14,
              ),
            ),

            SizedBox(height: 16),

            // Map Container
            Container(
              height: 300,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: FlutterMap(
                  mapController: _mapController,
                  options: MapOptions(
                    initialCenter: _selectedLatLng ?? _defaultLocation,
                    initialZoom: 13,
                    onTap: _onMapTap,
                  ),
                  children: [
                    TileLayer(
                      urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      userAgentPackageName: 'com.example.myapp',
                    ),
                    if (_selectedLatLng != null)
                      MarkerLayer(
                        markers: [
                          Marker(
                            point: _selectedLatLng!,
                            width: 80,
                            height: 80,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.location_on,
                                color: Colors.white,
                                size: 40,
                              ),
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 16),

            // Location Status
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Row(
                children: [
                  Icon(
                    _isLocationSelected ? Icons.location_on : Icons.location_searching,
                    color: _isLocationSelected ? Colors.green : AppTheme.purplePrimary,
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: _isLoadingLocation
                        ? Text("Getting address...")
                        : Text(
                      _selectedAddress.isEmpty
                          ? "Tap on map to select location"
                          : _selectedAddress,
                      style: TextStyle(
                        color: _isLocationSelected ? Colors.black : Colors.grey.shade600,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Manual Address Input Option (Optional - can be used if geocoding fails)
            if (_isLocationSelected && _selectedAddress.startsWith("Lat:"))
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: TextFormField(
                  decoration: const InputDecoration(
                    labelText: "Enter Address Manually",
                    hintText: "Type the full address",
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _selectedAddress = value;
                    });
                  },
                ),
              ),

            SizedBox(height: 32),

            // Next Button
            SizedBox(
              width: double.infinity,
              height: 56,
              child: _isLoading
                  ? Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                onPressed: _saveAndContinue,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.purplePrimary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: Text(
                  "Next →",
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
    _mapController.dispose();
    super.dispose();
  }
}
