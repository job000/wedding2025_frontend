import 'package:flutter/material.dart';
import 'package:provider/provider.dart' as provider;
import 'package:weddingapp_frontend_v2/core/theme/custom_colors.dart';
import '../../../../shared/widgets/responsive_layout.dart';

import '../widgets/feature_grid_widget.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Color _getRoleColor(String role) {
    switch (role) {
      case 'admin':
        return CustomColors.burgundy;
      case 'editor':
        return CustomColors.sage;
      default:
        return CustomColors.navy;
    }
  }

  Future<void> _showLogoutDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: CustomColors.neutral50,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Logg ut',
          style: TextStyle(color: CustomColors.textPrimary),
        ),
        content: Text(
          'Er du sikker på at du vil logge ut?',
          style: TextStyle(color: CustomColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Avbryt',
              style: TextStyle(color: CustomColors.neutral600),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              provider.Provider.of<AuthProvider>(context, listen: false).logout();
              Navigator.pushReplacementNamed(context, '/login');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: CustomColors.primary,
              foregroundColor: Colors.white,
            ),
            child: const Text('Logg ut'),
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentScreen(bool isAuthenticated) {
    if (!isAuthenticated) {
      return _buildPublicContent();
    }
    return _buildAuthenticatedContent();
  }

  Widget _buildPublicContent() {
    return FeatureGrid(
      onFeatureSelected: (index) {
        switch (index) {
          case 0:
            Navigator.pushNamed(context, '/rsvp-public');
            break;
          case 1:
            Navigator.pushNamed(context, '/program-public');
            break;
          case 2:
            Navigator.pushNamed(context, '/login');
            break;
          case 3:
            Navigator.pushNamed(context, '/register');
            break;
        }
      },
      isPublic: true,
    );
  }

  Widget _buildAuthenticatedContent() {
    final userRole = provider.Provider.of<AuthProvider>(context).currentUser?.role ?? 'user';
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Text(
            'Velkommen til vårt bryllup!',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: CustomColors.textPrimary,
                  fontWeight: FontWeight.bold,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          FeatureGrid(
            onFeatureSelected: (index) {
              switch (index) {
                case 0:
                  if (userRole == 'admin' || userRole == 'editor') {
                    Navigator.pushNamed(context, '/rsvp-form');
                  } else {
                    _showUnauthorizedDialog('RSVP-administrasjon');
                  }
                  break;
                case 1:
                  Navigator.pushNamed(context, '/gallery');
                  break;
                case 2:
                  Navigator.pushNamed(context, '/info-public');
                  break;
                case 3:
                  Navigator.pushNamed(context, '/program-public');
                  break;
                case 4:
                  Navigator.pushNamed(
                    context,
                    userRole == 'admin' ? '/faq' : '/faq-public',
                  );
                  break;
              }
            },
            isPublic: false,
          ),
        ],
      ),
    );
  }

  void _showUnauthorizedDialog(String feature) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: CustomColors.neutral50,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Ingen tilgang',
          style: TextStyle(color: CustomColors.error),
        ),
        content: Text(
          'Du har ikke tilgang til $feature.',
          style: TextStyle(color: CustomColors.textSecondary),
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: CustomColors.primary,
              foregroundColor: Colors.white,
            ),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = provider.Provider.of<AuthProvider>(context);
    final isAuthenticated = authProvider.isAuthenticated;
    final userRole = authProvider.currentUser?.role ?? 'user';

    return AppLayout(
      showAppBar: true,
      backgroundColor: CustomColors.background,
      actions: isAuthenticated
          ? [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                margin: const EdgeInsets.only(right: 8),
                decoration: BoxDecoration(
                  color: _getRoleColor(userRole),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: _getRoleColor(userRole).withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Text(
                  userRole.toUpperCase(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(
                  Icons.logout_rounded,
                  color: Colors.white,
                ),
                onPressed: () => _showLogoutDialog(context),
              ),
              const SizedBox(width: 8),
            ]
          : [
              TextButton(
                onPressed: () => Navigator.pushNamed(context, '/login'),
                child: const Text(
                  'Logg inn',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ],
      child: _buildCurrentScreen(isAuthenticated),
    );
  }
}