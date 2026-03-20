import 'package:flutter/material.dart';
import '../../core/api/api_client.dart';
import '../../core/theme/app_theme.dart';

class AddEditSportScreen extends StatefulWidget {
  final int turfId;
  final Map<String, dynamic>? sport;

  const AddEditSportScreen({
    super.key,
    required this.turfId,
    this.sport,
  });

  @override
  State<AddEditSportScreen> createState() => _AddEditSportScreenState();
}

class _AddEditSportScreenState extends State<AddEditSportScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  bool _isLoading = false;
  final ApiClient _api = ApiClient();

  @override
  void initState() {
    super.initState();
    if (widget.sport != null) {
      _nameController.text = widget.sport!['name'] ?? '';
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      if (widget.sport == null) {
        // Create
        await _api.post(
          "/sports",
          body: {
            "turf_id": widget.turfId,
            "name": _nameController.text.trim(),
          },
        );
      } else {
        // Update
        await _api.put(
          "/sports/${widget.sport!['id']}",
          body: {
            "name": _nameController.text.trim(),
          },
        );
      }

      if (!mounted) return;
      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error: ${e.toString()}"),
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
        title: Text(widget.sport == null ? 'Add Sport' : 'Edit Sport'),
        backgroundColor: AppTheme.purplePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Sport Name',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.sports_tennis),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter sport name';
                  }
                  return null;
                },
              ),
              SizedBox(height: 24),
              _isLoading
                  ? const CircularProgressIndicator()
                  : SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _save,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.purplePrimary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Text(
                    widget.sport == null ? 'Create Sport' : 'Update Sport',
                    style: const TextStyle(
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
