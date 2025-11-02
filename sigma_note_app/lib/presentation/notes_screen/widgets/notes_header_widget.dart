import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class NotesHeaderWidget extends StatelessWidget {
  final VoidCallback? onSearchTap;
  final VoidCallback? onProfileTap;

  const NotesHeaderWidget({super.key, this.onSearchTap, this.onProfileTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: AppTheme.primaryWhite,
        boxShadow: [
          BoxShadow(
            color: AppTheme.shadowBase,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: SafeArea(
        bottom: false,
        child: Row(
          children: [
            Expanded(child: _buildSearchBar(context, theme)),
            SizedBox(width: 3.w),
            _buildProfileButton(theme),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context, ThemeData theme) {
    return GestureDetector(
      onTap: onSearchTap ?? () => _showSearchDelegate(context),
      child: Container(
        height: 6.h,
        decoration: BoxDecoration(
          color: AppTheme.surfaceElevated,
          borderRadius: BorderRadius.circular(25),
          border: Border.all(color: AppTheme.borderSubtle, width: 1),
        ),
        child: Row(
          children: [
            SizedBox(width: 4.w),
            CustomIconWidget(
              iconName: 'search',
              color: AppTheme.textSecondary,
              size: 20,
            ),
            SizedBox(width: 3.w),
            Expanded(
              child: Text(
                'Search notes...',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: AppTheme.textSecondary,
                ),
              ),
            ),
            SizedBox(width: 4.w),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileButton(ThemeData theme) {
    return GestureDetector(
      onTap: onProfileTap ?? () => _showProfileMenu,
      child: Container(
        width: 6.h,
        height: 6.h,
        decoration: BoxDecoration(
          color: AppTheme.accentCoral,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: AppTheme.shadowBase,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: CustomIconWidget(
          iconName: 'person',
          color: AppTheme.primaryWhite,
          size: 24,
        ),
      ),
    );
  }

  void _showSearchDelegate(BuildContext context) {
    showSearch(context: context, delegate: _NotesSearchDelegate());
  }

  void _showProfileMenu() {
    // Profile menu functionality
  }
}

class _NotesSearchDelegate extends SearchDelegate<String> {
  final List<Map<String, dynamic>> _mockNotes = [
    {
      "id": 1,
      "title": "Meeting Notes - Q4 Planning",
      "content":
          "Discussed quarterly goals and budget allocation for the upcoming quarter. Key points include team expansion and new project initiatives.",
      "category": "Work",
      "createdAt": DateTime.now().subtract(const Duration(hours: 2)),
      "updatedAt": DateTime.now().subtract(const Duration(hours: 1)),
      "isFavorite": true,
      "isHighlighted": false,
    },
    {
      "id": 2,
      "title": "Recipe Ideas",
      "content":
          "Collection of healthy dinner recipes to try this week. Focus on Mediterranean cuisine with fresh vegetables and lean proteins.",
      "category": "Personal",
      "createdAt": DateTime.now().subtract(const Duration(days: 1)),
      "updatedAt": DateTime.now().subtract(const Duration(hours: 3)),
      "isFavorite": false,
      "isHighlighted": true,
    },
    {
      "id": 3,
      "title": "Book Recommendations",
      "content":
          "List of books recommended by colleagues and friends. Includes fiction, non-fiction, and professional development titles.",
      "category": "Learning",
      "createdAt": DateTime.now().subtract(const Duration(days: 2)),
      "updatedAt": DateTime.now().subtract(const Duration(days: 1)),
      "isFavorite": false,
      "isHighlighted": false,
    },
  ];

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: CustomIconWidget(
          iconName: 'clear',
          color: AppTheme.textSecondary,
          size: 24,
        ),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: CustomIconWidget(
        iconName: 'arrow_back',
        color: AppTheme.textPrimary,
        size: 24,
      ),
      onPressed: () {
        close(context, '');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final filteredNotes = _mockNotes.where((note) {
      final title = (note["title"] as String).toLowerCase();
      final content = (note["content"] as String).toLowerCase();
      final searchQuery = query.toLowerCase();

      return title.contains(searchQuery) || content.contains(searchQuery);
    }).toList();

    return ListView.builder(
      padding: EdgeInsets.all(2.w),
      itemCount: filteredNotes.length,
      itemBuilder: (context, index) {
        final note = filteredNotes[index];
        return Card(
          margin: EdgeInsets.symmetric(vertical: 1.h),
          child: ListTile(
            title: Text(
              note["title"] as String,
              style: Theme.of(context).textTheme.titleSmall,
            ),
            subtitle: Text(
              note["content"] as String,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            onTap: () {
              close(context, note["title"] as String);
            },
          ),
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = query.isEmpty
        ? [
            'Meeting notes',
            'Recipe ideas',
            'Book recommendations',
            'Project planning',
          ]
        : _mockNotes
              .where(
                (note) => (note["title"] as String).toLowerCase().contains(
                  query.toLowerCase(),
                ),
              )
              .map((note) => note["title"] as String)
              .toList();

    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        return ListTile(
          leading: CustomIconWidget(
            iconName: query.isEmpty ? 'history' : 'search',
            color: AppTheme.textSecondary,
            size: 20,
          ),
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
