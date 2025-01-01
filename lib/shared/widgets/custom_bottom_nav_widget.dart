import 'package:flutter/material.dart';
import '../../../core/theme/custom_colors.dart';

class CustomBottomNavWidget extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNavWidget({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).canvasColor, // Legg til bakgrunnsfarge
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
        items: const [
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
        ],
        type: BottomNavigationBarType.fixed,
        selectedItemColor: CustomColors.primary,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        backgroundColor: Colors.transparent, // Legg til transparent bakgrunn
        elevation: 0, // Fjern standard skygge
      ),
    );
  }
}