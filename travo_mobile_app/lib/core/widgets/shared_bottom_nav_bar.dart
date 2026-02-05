import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class SharedBottomNavBar extends StatelessWidget {
  final String activeRoute;

  const SharedBottomNavBar({
    super.key,
    required this.activeRoute,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Bottom Bar Background
          Container(
            height: 60,
            margin: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _BottomNavItem(
                  icon: Icons.home,
                  label: "Home",
                  active: activeRoute == '/home',
                  route: '/home',
                ),
                _BottomNavItem(
                  icon: Icons.book,
                  label: "Story",
                  active: activeRoute == '/story',
                  route: '/story',
                ),
                const SizedBox(width: 60), // space for center button
                _BottomNavItem(
                  icon: Icons.explore,
                  label: "Map",
                  active: activeRoute == '/map',
                  route: '/map',
                ),
                _BottomNavItem(
                  icon: Icons.person,
                  label: "Profile",
                  active: activeRoute == '/profile',
                  route: '/profile',
                ),
              ],
            ),
          ),

          // Center Floating Button - AI Chat
          Positioned(
            top: -20,
            left: 0,
            right: 0,
            child: Center(
              child: GestureDetector(
                onTap: () {
                  if (activeRoute != '/ai-chat') {
                    Navigator.pushNamed(context, '/ai-chat');
                  }
                },
                child: Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: activeRoute == '/ai-chat'
                        ? AppColors.accent
                        : AppColors.primary,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: activeRoute == '/ai-chat'
                            ? AppColors.accentLight20
                            : AppColors.primaryLight20,
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.auto_awesome,
                    color: AppColors.textOnPrimary,
                    size: 32,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ===== NAV ITEM WIDGET =====
class _BottomNavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool active;
  final String route;

  const _BottomNavItem({
    required this.icon,
    required this.label,
    required this.active,
    required this.route,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (!active) {
          Navigator.pushNamed(context, route);
        }
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 28,
            color: active ? AppColors.primary : AppColors.textDisabled,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: active ? AppColors.primary : AppColors.textDisabled,
            ),
          ),
        ],
      ),
    );
  }
}
