import 'package:flutter/material.dart';
import '../../services/api_services.dart';
import 'add_turf_page.dart';

class AdminTurfListScreen extends StatelessWidget {
  const AdminTurfListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Turfs'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const AddTurfScreen(),
                ),
              );

              // Force rebuild after returning from Add Turf
              (context as Element).markNeedsBuild();
            },
          ),
        ],
      ),
      body: FutureBuilder<List<dynamic>>(
        future: ApiService.fetchTurfs(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text('Error loading turfs'));
          }

          final turfs = snapshot.data ?? [];

          if (turfs.isEmpty) {
            return const Center(child: Text('No turfs added yet'));
          }

          return ListView.builder(
            itemCount: turfs.length,
            itemBuilder: (context, index) {
              final turf = turfs[index];
              return ListTile(
                title: Text(turf['name']),
                subtitle: Text(turf['location']),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    // delete turf (already working, optional)
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
