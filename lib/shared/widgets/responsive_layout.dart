import 'package:flutter/material.dart';

class AppLayout extends StatelessWidget {
  final Widget child;
  final Color? backgroundColor;
  final bool showAppBar;
  final bool showBottomNav;
  final String? title;
  final List<Widget>? actions;
  final Widget? bottomNavigationBar;

  const AppLayout({
    super.key,
    required this.child,
    this.backgroundColor,
    this.showAppBar = false,
    this.showBottomNav = false,
    this.title,
    this.actions,
    this.bottomNavigationBar,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 1024;
    final isTablet = screenWidth > 768 && screenWidth <= 1024;

    return Scaffold(
      backgroundColor: backgroundColor ?? Theme.of(context).scaffoldBackgroundColor,
      appBar: showAppBar
          ? AppBar(
              title: title != null ? Text(title!) : null,
              actions: actions,
              backgroundColor: Colors.transparent,
              elevation: 0,
            )
          : null,
      body: SafeArea(
        child: Center(
          child: Container(
            constraints: BoxConstraints(
              maxWidth: isDesktop
                  ? 1200
                  : isTablet
                      ? 900
                      : double.infinity,
            ),
            child: child,
          ),
        ),
      ),
      bottomNavigationBar: bottomNavigationBar,
    );
  }
}