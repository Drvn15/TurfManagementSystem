import 'package:flutter/material.dart';
import 'slot_selection_page.dart';

class TurfDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> turf;

  const TurfDetailsScreen({super.key, required this.turf});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(turf['name'])),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              turf['location'],
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text('₹${turf['price_per_hour']} per hour'),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          SlotSelectionScreen(turf: turf),
                    ),
                  );
                },
                child: const Text('Select Slot'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
