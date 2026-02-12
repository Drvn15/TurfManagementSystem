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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Turf')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: 'Turf Name')),
            TextField(controller: locationCtrl, decoration: const InputDecoration(labelText: 'Location')),
            TextField(controller: priceCtrl, decoration: const InputDecoration(labelText: 'Price per hour'), keyboardType: TextInputType.number),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () async {
                await ApiService.createTurf(
                  name: nameCtrl.text,
                  location: locationCtrl.text,
                  pricePerHour: int.parse(priceCtrl.text),
                );

                if (!context.mounted) return;
                Navigator.pop(context);
              },

              child: const Text('Save Turf'),
            ),
          ],
        ),
      ),
    );
  }
}
