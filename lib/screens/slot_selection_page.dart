import 'package:flutter/material.dart';

class SlotSelectionScreen extends StatelessWidget {
  final Map<String, dynamic> turf;

  const SlotSelectionScreen({super.key, required this.turf});

  @override
  Widget build(BuildContext context) {
    final slots = [
      '06:00 - 07:00',
      '07:00 - 08:00',
      '08:00 - 09:00',
      '09:00 - 10:00',
      '10:00 - 11:00',
      '11:00 - 12:00',
    ];

    return Scaffold(
      appBar: AppBar(title: Text(turf['name'])),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Select a Slot',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            Expanded(
              child: GridView.builder(
                itemCount: slots.length,
                gridDelegate:
                const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 3,
                ),
                itemBuilder: (context, index) {
                  return OutlinedButton(
                    onPressed: () {
                      // will navigate to booking confirmation
                    },
                    child: Text(slots[index]),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
