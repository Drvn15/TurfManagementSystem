import 'package:flutter/material.dart';
import '../../core/api/api_client.dart';
import '../../core/theme/design_system.dart';

class AddEditCourtScreen extends StatefulWidget {
  final int sportId;
  final Map<String, dynamic>? court;

  const AddEditCourtScreen({
    super.key,
    required this.sportId,
    this.court,
  });

  @override
  State<AddEditCourtScreen> createState() => _AddEditCourtScreenState();
}

class _AddEditCourtScreenState extends State<AddEditCourtScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();

  String _slotType = 'hourly';
  TimeOfDay _morningStart = const TimeOfDay(hour: 6, minute: 0);
  TimeOfDay _morningEnd = const TimeOfDay(hour: 12, minute: 0);
  TimeOfDay _eveningStart = const TimeOfDay(hour: 16, minute: 0);
  TimeOfDay _eveningEnd = const TimeOfDay(hour: 22, minute: 0);

  bool _isLoading = false;
  final ApiClient _api = ApiClient();

  @override
  void initState() {
    super.initState();
    if (widget.court != null) {
      _nameController.text = widget.court!['name'] ?? '';
      _priceController.text = (widget.court!['price'] ?? 0).toString();
      _slotType = widget.court!['slot_type'] ?? 'hourly';

      if (widget.court!['morning_start'] != null) {
        _morningStart = _parseTime(widget.court!['morning_start']);
      }
      if (widget.court!['morning_end'] != null) {
        _morningEnd = _parseTime(widget.court!['morning_end']);
      }
      if (widget.court!['evening_start'] != null) {
        _eveningStart = _parseTime(widget.court!['evening_start']);
      }
      if (widget.court!['evening_end'] != null) {
        _eveningEnd = _parseTime(widget.court!['evening_end']);
      }
    }
  }

  TimeOfDay _parseTime(String time) {
    final parts = time.split(':');
    return TimeOfDay(
      hour: int.parse(parts[0]),
      minute: int.parse(parts[1]),
    );
  }

  String _formatTimeOfDay(TimeOfDay time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}:00';
  }

  Future<void> _selectTime(BuildContext context, TimeOfDay initialTime,
      Function(TimeOfDay) onSelected) async {
    final selected = await showTimePicker(
      context: context,
      initialTime: initialTime,
    );
    if (selected != null) {
      onSelected(selected);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final body = {
        "sport_id": widget.sportId,
        "name": _nameController.text.trim(),
        "slot_type": _slotType,
        "price": double.parse(_priceController.text.trim()),
        "morning_start": _formatTimeOfDay(_morningStart),
        "morning_end": _formatTimeOfDay(_morningEnd),
        "evening_start": _formatTimeOfDay(_eveningStart),
        "evening_end": _formatTimeOfDay(_eveningEnd),
      };

      if (widget.court == null) {
        await _api.post("/courts", body: body);
      } else {
        await _api.put("/courts/${widget.court!['id']}", body: body);
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
      backgroundColor: DesignSystem.backgroundLavender,
      appBar: AppBar(
        title: Text(widget.court == null ? 'Add Court' : 'Edit Court'),
        backgroundColor: DesignSystem.primaryIndigo,
        foregroundColor: DesignSystem.textWhite,
        elevation: DesignSystem.elevation0,
      ),
      body: SingleChildScrollView(
        padding: DesignSystem.paddingAll16,
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Court Name/Number',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.sports_tennis),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter court name';
                  }
                  return null;
                },
              ),
              DesignSystem.gap16,

              TextFormField(
                controller: _priceController,
                decoration: const InputDecoration(
                  labelText: 'Price per slot',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.currency_rupee),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter price';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
              DesignSystem.gap16,

              DropdownButtonFormField<String>(
                initialValue: _slotType,
                decoration: const InputDecoration(
                  labelText: 'Slot Type',
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(value: 'hourly', child: Text('Hourly (1 hour)')),
                  DropdownMenuItem(value: 'half-hourly', child: Text('Half-Hourly (30 min)')),
                ],
                onChanged: (value) {
                  setState(() {
                    _slotType = value!;
                  });
                },
              ),
              DesignSystem.gap16,

              Text(
                'Morning Session',
                style: DesignSystem.headline5,
              ),
              DesignSystem.gap8,

              ListTile(
                title: Text('Start Time'),
                subtitle: Text(_morningStart.format(context)),
                trailing: Icon(Icons.access_time),
                onTap: () => _selectTime(context, _morningStart, (time) {
                  setState(() => _morningStart = time);
                }),
              ),
              ListTile(
                title: Text('End Time'),
                subtitle: Text(_morningEnd.format(context)),
                trailing: Icon(Icons.access_time),
                onTap: () => _selectTime(context, _morningEnd, (time) {
                  setState(() => _morningEnd = time);
                }),
              ),
              DesignSystem.gap16,

              Text(
                'Evening Session',
                style: DesignSystem.headline5,
              ),
              DesignSystem.gap8,

              ListTile(
                title: Text('Start Time'),
                subtitle: Text(_eveningStart.format(context)),
                trailing: Icon(Icons.access_time),
                onTap: () => _selectTime(context, _eveningStart, (time) {
                  setState(() => _eveningStart = time);
                }),
              ),
              ListTile(
                title: Text('End Time'),
                subtitle: Text(_eveningEnd.format(context)),
                trailing: Icon(Icons.access_time),
                onTap: () => _selectTime(context, _eveningEnd, (time) {
                  setState(() => _eveningEnd = time);
                }),
              ),
              DesignSystem.gap24,

              _isLoading
                  ? CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(DesignSystem.primaryIndigo),
              )
                  : SizedBox(
                width: double.infinity,
                height: DesignSystem.spacing56,
                child: ElevatedButton(
                  onPressed: _save,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: DesignSystem.primaryIndigo,
                    shape: DesignSystem.buttonShape,
                  ),
                  child: Text(
                    widget.court == null ? 'Add Court' : 'Update Court',
                    style: DesignSystem.button,
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
