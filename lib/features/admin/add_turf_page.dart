import 'package:flutter/material.dart';
import '../../core/api/api_client.dart';

class AddTurfScreen extends StatefulWidget {
  const AddTurfScreen({super.key});

  @override
  State<AddTurfScreen> createState() => _AddTurfScreenState();
}

class _AddTurfScreenState extends State<AddTurfScreen> {
  final nameCtrl = TextEditingController();
  final locationCtrl = TextEditingController();
  final priceCtrl = TextEditingController();
  final imageCtrl = TextEditingController();

  bool isLoading = false;
  final ApiClient _api = ApiClient();

  Future<void> saveTurf() async {
    setState(() => isLoading = true);

    try {
      await _api.post(
        "/turfs",
        body: {
          "name": nameCtrl.text.trim(),
          "location": locationCtrl.text.trim(),
          "price_per_hour": int.parse(priceCtrl.text.trim()),
          "image_url": imageCtrl.text.trim(),
        },
      );

      if (!mounted) return;
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to create turf: ${e.toString()}")),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Turf')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: nameCtrl,
                decoration: const InputDecoration(labelText: 'Turf Name'),
              ),
              SizedBox(height: 12),
              TextField(
                controller: locationCtrl,
                decoration: const InputDecoration(labelText: 'Location'),
              ),
              SizedBox(height: 12),
              TextField(
                controller: priceCtrl,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Price per hour'),
              ),
              SizedBox(height: 12),
              TextField(
                controller: imageCtrl,
                decoration: const InputDecoration(labelText: 'Image URL (optional)'),
              ),
              SizedBox(height: 24),
              isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                onPressed: saveTurf,
                child: Text('Save Turf'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
