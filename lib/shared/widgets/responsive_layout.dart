// lib/shared/widgets/responsive_layout.dart

import 'package:flutter/material.dart';
import '../../core/theme/custom_colors.dart';

class AppLayout extends StatelessWidget {
  final Widget child;
  final Color? backgroundColor;
  final bool showAppBar;
  final bool showBottomNav;
  final bool isPublic;
  final bool hideBackButton;
  final bool hideAuthButton;
  final String? title;
  final List<Widget>? actions;
  final Widget? bottomNavigationBar;
  final FloatingActionButton? floatingActionButton;
  final FloatingActionButtonLocation? floatingActionButtonLocation;

  const AppLayout({
    super.key,
    required this.child,
    this.backgroundColor,
    this.showAppBar = false,
    this.showBottomNav = false,
    this.isPublic = false,
    this.hideBackButton = false,
    this.hideAuthButton = false,
    this.title,
    this.actions,
    this.bottomNavigationBar,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
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
              automaticallyImplyLeading: !hideBackButton,
              title: title != null 
                  ? Text(
                      title!,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                    )
                  : null,
              actions: hideAuthButton ? null : actions,
              backgroundColor: Colors.transparent,
              elevation: 0,
              flexibleSpace: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      CustomColors.primary.withOpacity(0.8),
                      CustomColors.secondary.withOpacity(0.8),
                    ],
                  ),
                ),
              ),
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
      floatingActionButton: floatingActionButton,
      floatingActionButtonLocation: floatingActionButtonLocation ?? FloatingActionButtonLocation.endFloat,
    );
  }
}