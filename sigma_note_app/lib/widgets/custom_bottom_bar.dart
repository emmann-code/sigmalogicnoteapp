import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Custom BottomNavigationBar widget implementing adaptive platform behavior
/// with gesture-responsive feedback and contextual navigation
class CustomBottomBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int>? onTap;
  final CustomBottomBarVariant variant;
  final bool showLabels;
  final double? elevation;
  final Color? backgroundColor;
  final Color? selectedItemColor;
  final Color? unselectedItemColor;

  const CustomBottomBar({
    super.key,
    required this.currentIndex,
    this.onTap,
    this.variant = CustomBottomBarVariant.standard,
    this.showLabels = true,
    this.elevation,
    this.backgroundColor,
    this.selectedItemColor,
    this.unselectedItemColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    switch (variant) {
      case CustomBottomBarVariant.floating:
        return _buildFloatingBottomBar(context, colorScheme);
      case CustomBottomBarVariant.minimal:
        return _buildMinimalBottomBar(context, colorScheme);
      case CustomBottomBarVariant.standard:
      default:
        return _buildStandardBottomBar(context, colorScheme);
    }
  }

  Widget _buildStandardBottomBar(
    BuildContext context,
    ColorScheme colorScheme,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor ?? colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: _handleTap,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.transparent,
        elevation: 0,
        selectedItemColor: selectedItemColor ?? colorScheme.primary,
        unselectedItemColor:
            unselectedItemColor ?? colorScheme.onSurfaceVariant,
        showSelectedLabels: showLabels,
        showUnselectedLabels: showLabels,
        selectedLabelStyle: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.4,
        ),
        unselectedLabelStyle: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          letterSpacing: 0.4,
        ),
        items: _getNavigationItems(context),
      ),
    );
  }

  Widget _buildFloatingBottomBar(
    BuildContext context,
    ColorScheme colorScheme,
  ) {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: backgroundColor ?? colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.15),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BottomNavigationBar(
          currentIndex: currentIndex,
          onTap: _handleTap,
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.transparent,
          elevation: 0,
          selectedItemColor: selectedItemColor ?? colorScheme.primary,
          unselectedItemColor:
              unselectedItemColor ?? colorScheme.onSurfaceVariant,
          showSelectedLabels: showLabels,
          showUnselectedLabels: showLabels,
          selectedLabelStyle: GoogleFonts.inter(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.4,
          ),
          unselectedLabelStyle: GoogleFonts.inter(
            fontSize: 12,
            fontWeight: FontWeight.w400,
            letterSpacing: 0.4,
          ),
          items: _getNavigationItems(context),
        ),
      ),
    );
  }

  Widget _buildMinimalBottomBar(BuildContext context, ColorScheme colorScheme) {
    return Container(
      height: 60,
      decoration: BoxDecoration(
        color: backgroundColor ?? colorScheme.surface,
        border: Border(
          top: BorderSide(
            color: colorScheme.outline.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: _buildMinimalItems(context, colorScheme),
      ),
    );
  }

  List<Widget> _buildMinimalItems(
    BuildContext context,
    ColorScheme colorScheme,
  ) {
    final items = _getNavigationItemsData();

    return items.asMap().entries.map((entry) {
      final index = entry.key;
      final item = entry.value;
      final isSelected = index == currentIndex;

      return Expanded(
        child: GestureDetector(
          onTap: () => _handleTap(index),
          child: Container(
            height: 60,
            decoration: BoxDecoration(
              color: isSelected
                  ? (selectedItemColor ?? colorScheme.primary).withValues(
                      alpha: 0.1,
                    )
                  : Colors.transparent,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  item.icon,
                  size: 24,
                  color: isSelected
                      ? selectedItemColor ?? colorScheme.primary
                      : unselectedItemColor ?? colorScheme.onSurfaceVariant,
                ),
                if (showLabels) ...[
                  const SizedBox(height: 4),
                  Text(
                    item.label,
                    style: GoogleFonts.inter(
                      fontSize: 10,
                      fontWeight: isSelected
                          ? FontWeight.w500
                          : FontWeight.w400,
                      color: isSelected
                          ? selectedItemColor ?? colorScheme.primary
                          : unselectedItemColor ?? colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      );
    }).toList();
  }

  List<BottomNavigationBarItem> _getNavigationItems(BuildContext context) {
    final items = _getNavigationItemsData();

    return items
        .map(
          (item) => BottomNavigationBarItem(
            icon: Icon(item.icon),
            activeIcon: Icon(item.activeIcon ?? item.icon),
            label: item.label,
            tooltip: item.tooltip,
          ),
        )
        .toList();
  }

  List<_NavigationItemData> _getNavigationItemsData() {
    return [
      _NavigationItemData(
        icon: Icons.note_outlined,
        activeIcon: Icons.note,
        label: 'Notes',
        tooltip: 'My Notes',
        route: '/notes-screen',
      ),
      _NavigationItemData(
        icon: Icons.search_outlined,
        activeIcon: Icons.search,
        label: 'Search',
        tooltip: 'Search Notes',
        route: '/notes-screen', // Navigate to notes with search
      ),
      _NavigationItemData(
        icon: Icons.add_circle_outline,
        activeIcon: Icons.add_circle,
        label: 'Add',
        tooltip: 'New Note',
        route: '/notes-screen', // Navigate to notes to add new
      ),
      _NavigationItemData(
        icon: Icons.settings_outlined,
        activeIcon: Icons.settings,
        label: 'Settings',
        tooltip: 'Settings',
        route: '/settings-screen',
      ),
    ];
  }

  void _handleTap(int index) {
    if (onTap != null) {
      onTap!(index);
    } else {
      _navigateToRoute(index);
    }
  }

  void _navigateToRoute(int index) {
    final items = _getNavigationItemsData();
    if (index < items.length) {
      final route = items[index].route;

      // Get the current context from the widget tree
      final context = _getCurrentContext();
      if (context != null) {
        // Handle special navigation cases
        switch (index) {
          case 1: // Search
            Navigator.pushNamed(context, route);
            // Could trigger search functionality here
            break;
          case 2: // Add
            Navigator.pushNamed(context, route);
            // Could trigger add note functionality here
            break;
          default:
            Navigator.pushNamed(context, route);
        }
      }
    }
  }

  BuildContext? _getCurrentContext() {
    // This is a simplified approach - in a real app, you'd want to pass
    // the context or use a navigation service
    return null;
  }
}

/// Data class for navigation items
class _NavigationItemData {
  final IconData icon;
  final IconData? activeIcon;
  final String label;
  final String tooltip;
  final String route;

  const _NavigationItemData({
    required this.icon,
    this.activeIcon,
    required this.label,
    required this.tooltip,
    required this.route,
  });
}

/// Enum defining different BottomBar variants
enum CustomBottomBarVariant { standard, floating, minimal }

/// Extension to provide easy navigation integration
extension CustomBottomBarNavigation on CustomBottomBar {
  /// Creates a CustomBottomBar with automatic navigation handling
  static Widget withNavigation({
    Key? key,
    required BuildContext context,
    required int currentIndex,
    CustomBottomBarVariant variant = CustomBottomBarVariant.standard,
    bool showLabels = true,
    double? elevation,
    Color? backgroundColor,
    Color? selectedItemColor,
    Color? unselectedItemColor,
  }) {
    return CustomBottomBar(
      key: key,
      currentIndex: currentIndex,
      variant: variant,
      showLabels: showLabels,
      elevation: elevation,
      backgroundColor: backgroundColor,
      selectedItemColor: selectedItemColor,
      unselectedItemColor: unselectedItemColor,
      onTap: (index) {
        final routes = [
          '/notes-screen',
          '/notes-screen',
          '/notes-screen',
          '/settings-screen',
        ];
        if (index < routes.length) {
          Navigator.pushNamed(context, routes[index]);
        }
      },
    );
  }
}
