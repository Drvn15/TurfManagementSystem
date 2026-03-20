import 'package:flutter/material.dart';
import '../../core/api/api_client.dart';
import '../../core/theme/app_theme.dart';

class EditTurfScreen extends StatefulWidget {
  final Map<String, dynamic> turf;

  const EditTurfScreen({super.key, required this.turf});

  @override
  State<EditTurfScreen> createState() => _EditTurfScreenState();
}

class _EditTurfScreenState extends State<EditTurfScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _locationController;
  late final TextEditingController _priceController;
  late final TextEditingController _descriptionController;

  bool _isLoading = false;
  final ApiClient _api = ApiClient();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.turf['name'] ?? '');
    _locationController = TextEditingController(text: widget.turf['location'] ?? '');
    _priceController = TextEditingController(
      text: widget.turf['price_per_hour']?.toString() ?? '',
    );
    _descriptionController = TextEditingController(
      text: widget.turf['description'] ?? '',
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _locationController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _updateTurf() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      await _api.put(
        "/turfs/${widget.turf['id']}",
        body: {
          "name": _nameController.text.trim(),
          "location": _locationController.text.trim(),
          "price_per_hour": int.parse(_priceController.text.trim()),
          "description": _descriptionController.text.trim(),
          "image_url": widget.turf['image_url'] ?? '',
        },
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Turf updated successfully"),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Failed to update turf: $e"),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Turf"),
        backgroundColor: AppTheme.purplePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Edit Turf Details",
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 24),

              // Turf Name
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: "Turf Name",
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
              SizedBox(height: 16),

              // Location
              TextFormField(
                controller: _locationController,
                decoration: const InputDecoration(
                  labelText: "Location",
                  prefixIcon: Icon(Icons.location_on),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter location";
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),

              // Price per hour
              TextFormField(
                controller: _priceController,
                decoration: const InputDecoration(
                  labelText: "Price per hour (₹)",
                  prefixIcon: Icon(Icons.currency_rupee),
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter price";
                  }
                  if (int.tryParse(value) == null) {
                    return "Please enter a valid number";
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),

              // Description (optional)
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: "Description (optional)",
                  prefixIcon: Icon(Icons.description),
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              SizedBox(height: 32),

              // Update Button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: _isLoading
                    ? Center(child: CircularProgressIndicator())
                    : ElevatedButton(
                  onPressed: _updateTurf,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.purplePrimary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Text(
                    "Update Turf",
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
