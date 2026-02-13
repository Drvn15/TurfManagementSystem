import 'package:flutter/material.dart';
import '../../services/api_services.dart';

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

  Future<void> saveTurf() async {
    setState(() => isLoading = true);

    bool success = await ApiService.createTurf(
      nameCtrl.text.trim(),
      locationCtrl.text.trim(),
      int.parse(priceCtrl.text.trim()),
      imageCtrl.text.trim(),
    );

    setState(() => isLoading = false);

    if (!mounted) return;

    if (success) {
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to create turf")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Turf')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: nameCtrl,
                decoration: const InputDecoration(labelText: 'Turf Name'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: locationCtrl,
                decoration: const InputDecoration(labelText: 'Location'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: priceCtrl,
                keyboardType: TextInputType.number,
                decoration:
                const InputDecoration(labelText: 'Price per hour'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: imageCtrl,
                decoration:
                const InputDecoration(labelText: 'Image URL (optional)'),
              ),
              const SizedBox(height: 24),
              isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                onPressed: saveTurf,
                child: const Text('Save Turf'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
