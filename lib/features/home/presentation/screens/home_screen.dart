import 'package:flutter/material.dart';
import 'package:provider/provider.dart' as provider;
import 'package:weddingapp_frontend_v2/shared/widgets/responsive_layout.dart';
import '../widgets/feature_grid_widget.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../../shared/widgets/custom_bottom_nav_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  Color _getRoleColor(String role) {
    switch (role) {
      case 'admin':
        return Colors.red;
      case 'editor':
        return Colors.green;
      default:
        return Colors.blue;
    }
  }

  Future<void> _showLogoutDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logg ut'),
        content: const Text('Er du sikker på at du vil logge ut?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Avbryt'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              provider.Provider.of<AuthProvider>(context, listen: false).logout();
              Navigator.pushReplacementNamed(context, '/login');
            },
            child: const Text('Logg ut'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = provider.Provider.of<AuthProvider>(context);
    final userRole = authProvider.currentUser?.role ?? 'user';

    return AppLayout(
      showAppBar: true,
      actions: [
        // Role indicator
        Center(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            margin: const EdgeInsets.only(right: 8),
            decoration: BoxDecoration(
              color: _getRoleColor(userRole),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              userRole.toUpperCase(),
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.logout),
          onPressed: () => _showLogoutDialog(context),
        ),
        const SizedBox(width: 8),
      ],
      showBottomNav: true,
      bottomNavigationBar: CustomBottomNavWidget(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: FeatureGrid(
              onFeatureSelected: (index) {
                switch (index) {
                  case 0: // RSVP
                    if (userRole == 'admin' || userRole == 'editor') {
                      Navigator.pushNamed(context, '/rsvp-form');
                    } else {
                      // Vis dialog om manglende tilgang
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Ingen tilgang'),
                          content: const Text('Du har ikke tilgang til denne funksjonen.'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('OK'),
                            ),
                          ],
                        ),
                      );
                    }
                    break;
                  case 1: // Bildegalleri
                    Navigator.pushNamed(context, '/gallery');
                    break;
                  case 2: // Informasjon
                    Navigator.pushNamed(context, '/info');
                    break;
                  case 3: // FAQ
                    if (userRole == 'admin') {
                      Navigator.pushNamed(context, '/faq');
                    } else {
                      // Vis dialog om manglende tilgang
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Ingen tilgang'),
                          content: const Text('Kun administratorer har tilgang til denne funksjonen.'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('OK'),
                            ),
                          ],
                        ),
                      );
                    }
                    break;
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}