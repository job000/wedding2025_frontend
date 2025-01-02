// lib/main.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart' as provider;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/presentation/providers/auth_provider.dart';
import 'features/gallery/presentation/providers/gallery_provider.dart';
import 'features/auth/presentation/screens/login_screen.dart';
import 'features/auth/presentation/screens/register_screen.dart';
import 'features/home/presentation/screens/home_screen.dart';
import 'features/gallery/presentation/screens/gallery_screen.dart';
import 'shared/widgets/custom_bottom_nav_widget.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  runApp(
    ProviderScope(
      child: provider.MultiProvider(
        providers: [
          provider.ChangeNotifierProvider<AuthProvider>(
            create: (_) => AuthProvider(),
          ),
          provider.ChangeNotifierProxyProvider<AuthProvider, GalleryProvider>(
            create: (context) => GalleryProvider(
              authProvider: context.read<AuthProvider>(),
            ),
            update: (context, auth, previous) => previous ?? GalleryProvider(
              authProvider: auth,
            ),
          ),
        ],
        child: const MyApp(),
      ),
    ),
  );
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  int _currentIndex = 0;
  
  @override
  void initState() {
    super.initState();
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    await context.read<AuthProvider>().checkAuthStatus();
  }

  void _onNavItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  Widget _buildCurrentScreen(bool isAuthenticated) {
    if (!isAuthenticated) {
      switch (_currentIndex) {
        case 0:
          return const HomeScreen();
        case 1:
          return const Center(child: Text('Info Coming Soon'));
        case 2:
          return const LoginScreen();
        default:
          return const HomeScreen();
      }
    } else {
      switch (_currentIndex) {
        case 0:
          return const HomeScreen();
        case 1:
          return const GalleryScreen();
        case 2:
          return const Center(child: Text('Info Coming Soon')); 
        case 3:
          return const Center(child: Text('FAQ Coming Soon'));
        default:
          return const HomeScreen();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final isAuthenticated = authProvider.isAuthenticated;

    return MaterialApp(
      title: 'Frida & John Michael',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme(),
      darkTheme: AppTheme.darkTheme(),
      home: Scaffold(
        body: _buildCurrentScreen(isAuthenticated),
        bottomNavigationBar: CustomBottomNavWidget(
          currentIndex: _currentIndex,
          onTap: _onNavItemTapped,
          isPublic: !isAuthenticated,
        ),
      ),
      routes: {
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/home': (context) => const HomeScreen(),
        '/gallery': (context) => const GalleryScreen(),
      },
    );
  }
}