import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/api/api_client.dart';
import '../../core/theme/design_system.dart';

class AdminUsersScreen extends ConsumerStatefulWidget {
  const AdminUsersScreen({super.key});

  @override
  ConsumerState<AdminUsersScreen> createState() => _AdminUsersScreenState();
}

class _AdminUsersScreenState extends ConsumerState<AdminUsersScreen> with TickerProviderStateMixin {
  final ApiClient _api = ApiClient();
  List<dynamic> _users = [];
  bool _isLoading = true;
  String? _errorMessage;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: DesignSystem.animationNormal,
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );
    _fetchUsers();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  Future<void> _fetchUsers() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final response = await _api.get("/users");
      if (response is List) {
        setState(() {
          _users = response;
          _isLoading = false;
        });
        _fadeController.forward(from: 0.0);
      } else {
        setState(() {
          _users = [];
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = "Failed to load users: $e";
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DesignSystem.backgroundLavender,
      appBar: AppBar(
        title: const Text("Manage Users"),
        backgroundColor: DesignSystem.primaryIndigo,
        foregroundColor: DesignSystem.textWhite,
        elevation: DesignSystem.elevation0,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh, color: DesignSystem.textWhite),
            onPressed: _fetchUsers,
          ),
        ],
      ),
      body: _isLoading
          ? Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(DesignSystem.primaryIndigo),
        ),
      )
          : _errorMessage != null
          ? _buildErrorState()
          : _users.isEmpty
          ? _buildEmptyState()
          : _buildUsersList(),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Padding(
        padding: DesignSystem.paddingAll24,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: DesignSystem.paddingAll16,
              decoration: DesignSystem.whiteCardDecoration,
              child: Icon(
                Icons.error_outline,
                size: DesignSystem.iconXLarge,
                color: DesignSystem.error,
              ),
            ),
            DesignSystem.gap16,
            Text(
              _errorMessage!,
              style: DesignSystem.bodyMedium.copyWith(color: DesignSystem.textSecondary),
              textAlign: TextAlign.center,
            ),
            DesignSystem.gap24,
            ElevatedButton(
              onPressed: _fetchUsers,
              child: Text("Retry"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: DesignSystem.paddingAll24,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: DesignSystem.paddingAll16,
              decoration: DesignSystem.whiteCardDecoration,
              child: Icon(
                Icons.people_outline,
                size: DesignSystem.iconXLarge,
                color: DesignSystem.primaryIndigo,
              ),
            ),
            DesignSystem.gap16,
            Text(
              "No users found",
              style: DesignSystem.headline4,
              textAlign: TextAlign.center,
            ),
            DesignSystem.gap8,
            Text(
              "Users will appear here once they register",
              style: DesignSystem.bodyMedium.copyWith(color: DesignSystem.textSecondary),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUsersList() {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: ListView.builder(
        padding: DesignSystem.paddingAll16,
        itemCount: _users.length,
        itemBuilder: (context, index) {
          final user = _users[index];
          return Container(
            margin: DesignSystem.marginBottom12,
            decoration: DesignSystem.whiteCardDecoration,
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: DesignSystem.primaryIndigo,
                child: Text(
                  (user['name'] ?? 'U')[0].toUpperCase(),
                  style: DesignSystem.button.copyWith(color: DesignSystem.textWhite),
                ),
              ),
              title: Text(
                user['name'] ?? 'Unnamed User',
                style: DesignSystem.bodyLarge,
              ),
              subtitle: Text(
                user['phone'] ?? 'No phone',
                style: DesignSystem.bodySmall.copyWith(color: DesignSystem.textSecondary),
              ),
              trailing: Icon(
                Icons.person,
                color: DesignSystem.primaryIndigo,
              ),
            ),
          );
        },
      ),
    );
  }
}