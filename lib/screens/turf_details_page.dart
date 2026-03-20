import 'package:flutter/material.dart';

import '../features/turf/turf_detail_screen.dart';

class TurfDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> turf;

  const TurfDetailsScreen({super.key, required this.turf});

  @override
  Widget build(BuildContext context) {
    return TurfDetailScreen(turf: turf);
  }
}
