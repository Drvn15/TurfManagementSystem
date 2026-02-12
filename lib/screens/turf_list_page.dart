import 'package:flutter/material.dart';
import '../services/api_services.dart';
import 'turf_details_page.dart';

class TurfListScreen extends StatelessWidget {
  const TurfListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Turfs')),
      body: FutureBuilder(
        future: ApiService.fetchTurfs(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text('Error loading turfs'));
          }

          final turfs = snapshot.data as List<dynamic>;

          if (turfs.isEmpty) {
            return const Center(child: Text('No turfs available'));
          }

          return ListView.builder(
            itemCount: turfs.length,
            itemBuilder: (context, index) {
              final turf = turfs[index];

              return Card(
                margin: const EdgeInsets.symmetric(
                    horizontal: 12, vertical: 8),
                child: ListTile(
                  title: Text(turf['name']),
                  subtitle: Text(
                      '${turf['location']} • ₹${turf['price_per_hour']}/hr'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            TurfDetailsScreen(turf: turf),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
