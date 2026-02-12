import 'package:flutter/material.dart';
import 'users_screen.dart';
import 'turf_list_page.dart';
import 'admin/admin_dashboard_page.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          /// HERO IMAGE (placeholder)
          Container(
            height: MediaQuery.of(context).size.height * 0.6,
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Colors.black12,
            ),
            child: const Center(
              child: Icon(
                Icons.sports_soccer,
                size: 120,
                color: Colors.black38,
              ),
            ),
          ),

          /// CONTENT OVERLAY
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Spacer(),

                /// APP TITLE
                const Text(
                  'Turf Booking',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 12),

                /// TAGLINE
                const Text(
                  'Reserve your turf in seconds',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black54,
                  ),
                ),

                const SizedBox(height: 32),

                /// PRIMARY CTA — USER FLOW
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const UsersScreen(),
                          ),
                        );
                      },
                      child: const Text(
                        'Get Started',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                /// SECONDARY CTA — USER BROWSING
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const TurfListScreen(),
                      ),
                    );
                  },
                  child: const Text('Explore Turfs'),
                ),

                const SizedBox(height: 24),

                /// TEMP ADMIN ENTRY (DEV ONLY)
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const AdminDashboardScreen(),
                      ),
                    );
                  },
                  child: const Text(
                    'Admin Panel',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                ),

                const SizedBox(height: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
