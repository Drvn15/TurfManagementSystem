import 'package:flutter/material.dart';
import '../../core/api/api_client.dart';
import 'add_turf_page.dart';

class AdminTurfListScreen extends StatefulWidget {
  const AdminTurfListScreen({super.key});

  @override
  State<AdminTurfListScreen> createState() => _AdminTurfListScreenState();
}

class _AdminTurfListScreenState extends State<AdminTurfListScreen> {
  late Future<List<dynamic>> turfFuture;
  final ApiClient _api = ApiClient();

  @override
  void initState() {
    super.initState();
    _fetchTurfs();
  }

  void _fetchTurfs() {
    setState(() {
      turfFuture = _api.get("/turfs").then((response) => response as List);
    });
  }

  Future<void> _deleteTurf(int id) async {
    try {
      await _api.delete("/turfs/$id");
      _fetchTurfs();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Turf deleted successfully")),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Delete failed: ${e.toString()}")),
      );
    }
  }

  void _refresh() {
    _fetchTurfs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Turfs'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AddTurfScreen()),
              );
              _refresh();
            },
          ),
        ],
      ),
      body: FutureBuilder<List<dynamic>>(
        future: turfFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error loading turfs: ${snapshot.error}'));
          }

          final turfs = snapshot.data ?? [];

          if (turfs.isEmpty) {
            return Center(child: Text('No turfs added yet'));
          }

          return ListView.builder(
            itemCount: turfs.length,
            itemBuilder: (context, index) {
              final turf = turfs[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  title: Text(turf['name'] ?? ''),
                  subtitle: Text("${turf['location'] ?? ''} • ₹${turf['price_per_hour'] ?? 0}"),
                  trailing: IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _deleteTurf(turf['id']),
                  ),
                  onTap: () {
                    // Navigate to sport list for this turf (we'll build this next)
                    // Navigator.push(...)
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
