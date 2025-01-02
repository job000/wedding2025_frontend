import 'package:flutter/material.dart';
import '../../../core/theme/custom_colors.dart';

class CustomBottomNavWidget extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;
  final bool isPublic;

  const CustomBottomNavWidget({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.isPublic,
  });

  List<BottomNavigationBarItem> _getNavigationItems(bool isPublic) {
    if (isPublic) {
      return const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Hjem',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.event),
          label: 'Program',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.info),
          label: 'Info',
        ),
      ];
    } else {
      return const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Hjem',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.photo_library),
          label: 'Galleri',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.info),
          label: 'Info',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.help),
          label: 'FAQ',
        ),
      ];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).canvasColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: onTap,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.transparent,
        elevation: 0,
        selectedItemColor: CustomColors.primary,
        unselectedItemColor: Colors.grey,
        items: _getNavigationItems(isPublic),
        showSelectedLabels: true,
        showUnselectedLabels: true,
        selectedIconTheme: const IconThemeData(size: 28),
        unselectedIconTheme: const IconThemeData(size: 24),
        selectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
        unselectedLabelStyle: const TextStyle(
          fontSize: 12,
        ),
      ),
    );
  }
}