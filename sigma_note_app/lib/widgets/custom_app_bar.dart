import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Custom AppBar widget implementing Contemporary Minimal Sophistication
/// with intelligent search integration and contextual actions
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final CustomAppBarVariant variant;
  final List<Widget>? actions;
  final Widget? leading;
  final bool showSearch;
  final VoidCallback? onSearchTap;
  final bool centerTitle;
  final double? elevation;
  final Color? backgroundColor;
  final Color? foregroundColor;

  const CustomAppBar({
    super.key,
    required this.title,
    this.variant = CustomAppBarVariant.standard,
    this.actions,
    this.leading,
    this.showSearch = false,
    this.onSearchTap,
    this.centerTitle = true,
    this.elevation,
    this.backgroundColor,
    this.foregroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AppBar(
      title: _buildTitle(context),
      centerTitle: centerTitle,
      elevation: elevation ?? _getElevationForVariant(),
      backgroundColor: backgroundColor ?? _getBackgroundColor(colorScheme),
      foregroundColor: foregroundColor ?? _getForegroundColor(colorScheme),
      surfaceTintColor: Colors.transparent,
      leading: leading ?? _buildLeading(context),
      actions: _buildActions(context),
      titleTextStyle: _getTitleStyle(context),
      iconTheme: IconThemeData(
        color: foregroundColor ?? _getForegroundColor(colorScheme),
        size: 24,
      ),
      actionsIconTheme: IconThemeData(
        color: foregroundColor ?? _getForegroundColor(colorScheme),
        size: 24,
      ),
    );
  }

  Widget _buildTitle(BuildContext context) {
    switch (variant) {
      case CustomAppBarVariant.search:
        return _buildSearchTitle(context);
      case CustomAppBarVariant.minimal:
        return Text(title);
      case CustomAppBarVariant.standard:
      default:
        return Text(title);
    }
  }

  Widget _buildSearchTitle(BuildContext context) {
    return GestureDetector(
      onTap: onSearchTap ?? () => _showSearchDelegate(context),
      child: Container(
        height: 40,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            const SizedBox(width: 16),
            Icon(
              Icons.search,
              size: 20,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Search notes...',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ),
            const SizedBox(width: 16),
          ],
        ),
      ),
    );
  }

  Widget? _buildLeading(BuildContext context) {
    if (leading != null) return leading;

    switch (variant) {
      case CustomAppBarVariant.minimal:
        return null;
      case CustomAppBarVariant.standard:
      case CustomAppBarVariant.search:
      default:
        if (Navigator.of(context).canPop()) {
          return IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () => Navigator.of(context).pop(),
            tooltip: 'Back',
          );
        }
        return null;
    }
  }

  List<Widget>? _buildActions(BuildContext context) {
    List<Widget> actionsList = [];

    // Add search action if enabled and not in search variant
    if (showSearch && variant != CustomAppBarVariant.search) {
      actionsList.add(
        IconButton(
          icon: const Icon(Icons.search),
          onPressed: onSearchTap ?? () => _showSearchDelegate(context),
          tooltip: 'Search',
        ),
      );
    }

    // Add default actions based on current route
    final currentRoute = ModalRoute.of(context)?.settings.name;

    switch (currentRoute) {
      case '/notes-screen':
        actionsList.addAll([
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _handleNewNote(context),
            tooltip: 'New Note',
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),
            onSelected: (value) => _handleMenuAction(context, value),
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'sort',
                child: Row(
                  children: [
                    Icon(Icons.sort),
                    SizedBox(width: 12),
                    Text('Sort'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'settings',
                child: Row(
                  children: [
                    Icon(Icons.settings),
                    SizedBox(width: 12),
                    Text('Settings'),
                  ],
                ),
              ),
            ],
          ),
        ]);
        break;
      case '/settings-screen':
        actionsList.add(
          IconButton(
            icon: const Icon(Icons.help_outline),
            onPressed: () => _showHelpDialog(context),
            tooltip: 'Help',
          ),
        );
        break;
    }

    // Add custom actions
    if (actions != null) {
      actionsList.addAll(actions!);
    }

    return actionsList.isNotEmpty ? actionsList : null;
  }

  TextStyle _getTitleStyle(BuildContext context) {
    final theme = Theme.of(context);

    switch (variant) {
      case CustomAppBarVariant.minimal:
        return GoogleFonts.inter(
          fontSize: 18,
          fontWeight: FontWeight.w500,
          color: foregroundColor ?? _getForegroundColor(theme.colorScheme),
          letterSpacing: -0.1,
        );
      case CustomAppBarVariant.search:
        return GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: foregroundColor ?? _getForegroundColor(theme.colorScheme),
        );
      case CustomAppBarVariant.standard:
      default:
        return GoogleFonts.inter(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: foregroundColor ?? _getForegroundColor(theme.colorScheme),
          letterSpacing: -0.2,
        );
    }
  }

  double _getElevationForVariant() {
    switch (variant) {
      case CustomAppBarVariant.minimal:
        return 0;
      case CustomAppBarVariant.search:
        return 1;
      case CustomAppBarVariant.standard:
      default:
        return 0;
    }
  }

  Color _getBackgroundColor(ColorScheme colorScheme) {
    switch (variant) {
      case CustomAppBarVariant.minimal:
        return Colors.transparent;
      case CustomAppBarVariant.search:
      case CustomAppBarVariant.standard:
      default:
        return colorScheme.surface;
    }
  }

  Color _getForegroundColor(ColorScheme colorScheme) {
    return colorScheme.onSurface;
  }

  void _showSearchDelegate(BuildContext context) {
    showSearch;
  }

  void _handleNewNote(BuildContext context) {
    // Handle new note creation
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('New note functionality'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _handleMenuAction(BuildContext context, String action) {
    switch (action) {
      case 'sort':
        _showSortOptions(context);
        break;
      case 'settings':
        Navigator.pushNamed(context, '/settings-screen');
        break;
    }
  }

  void _showSortOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Sort Notes',
              style: GoogleFonts.inter(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.access_time),
              title: const Text('Recent'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.sort_by_alpha),
              title: const Text('Alphabetical'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.star),
              title: const Text('Favorites'),
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }

  void _showHelpDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Help & Support'),
        content: const Text(
          'For assistance, please contact our support team or visit our help center.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

/// Search delegate for notes search functionality
class _NotesSearchDelegate extends SearchDelegate<String> {
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, '');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.search, size: 64, color: Colors.grey),
          const SizedBox(height: 16),
          Text(
            'Search results for "$query"',
            style: GoogleFonts.inter(fontSize: 16, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = query.isEmpty
        ? ['Recent searches', 'Meeting notes', 'Project ideas']
        : ['Search for "$query"'];

    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        return ListTile(
          leading: const Icon(Icons.history),
          title: Text(suggestions[index]),
          onTap: () {
            query = suggestions[index];
            showResults(context);
          },
        );
      },
    );
  }
}

/// Enum defining different AppBar variants
enum CustomAppBarVariant { standard, minimal, search }
