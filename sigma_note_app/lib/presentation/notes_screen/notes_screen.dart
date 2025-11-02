import 'package:flutter/material.dart';
import 'package:sigma_note_app/presentation/notes_screen/widgets/notes_tab_bar.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/empty_notes_widget.dart';
import './widgets/note_card_widget.dart';
import './widgets/notes_filter_widget.dart';
import './widgets/notes_header_widget.dart';

class NotesScreen extends StatefulWidget {
  const NotesScreen({super.key});

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  String _selectedFilter = 'All Notes';
  bool _isLoading = false;
  final List<String> _tabs = ['Notes', 'Highlights', 'Favorite Notes'];
  final List<String> _filterOptions = [
    'All Notes',
    'Work',
    'Personal',
    'Learning',
    'Favorites',
  ];

  // Mock notes data
  final List<Map<String, dynamic>> _mockNotes = [
    {
      "id": 1,
      "title": "Meeting Notes - Q4 Planning",
      "content":
          "Discussed quarterly goals and budget allocation for the upcoming quarter. Key points include team expansion, new project initiatives, and resource optimization strategies for maximum efficiency.",
      "category": "Work",
      "createdAt": DateTime.now().subtract(const Duration(hours: 2)),
      "updatedAt": DateTime.now().subtract(const Duration(hours: 1)),
      "isFavorite": true,
      "isHighlighted": false,
    },
    {
      "id": 2,
      "title": "Recipe Ideas for Healthy Living",
      "content":
          "Collection of healthy dinner recipes to try this week. Focus on Mediterranean cuisine with fresh vegetables, lean proteins, and whole grains. Include quinoa salads and grilled fish options.",
      "category": "Personal",
      "createdAt": DateTime.now().subtract(const Duration(days: 1)),
      "updatedAt": DateTime.now().subtract(const Duration(hours: 3)),
      "isFavorite": false,
      "isHighlighted": true,
    },
    {
      "id": 3,
      "title": "Book Recommendations - Professional Development",
      "content":
          "List of books recommended by colleagues and friends. Includes fiction, non-fiction, and professional development titles. Focus on leadership, innovation, and personal growth topics.",
      "category": "Learning",
      "createdAt": DateTime.now().subtract(const Duration(days: 2)),
      "updatedAt": DateTime.now().subtract(const Duration(days: 1)),
      "isFavorite": false,
      "isHighlighted": false,
    },
    {
      "id": 4,
      "title": "Travel Planning - Summer Vacation",
      "content":
          "Planning details for summer vacation including destinations, budget considerations, accommodation options, and activity preferences. Research on local attractions and cultural experiences.",
      "category": "Personal",
      "createdAt": DateTime.now().subtract(const Duration(days: 3)),
      "updatedAt": DateTime.now().subtract(const Duration(days: 2)),
      "isFavorite": true,
      "isHighlighted": false,
    },
    {
      "id": 5,
      "title": "Project Milestone Review",
      "content":
          "Review of current project milestones and upcoming deadlines. Assessment of team performance, resource allocation, and potential risks that need to be addressed in the next sprint.",
      "category": "Work",
      "createdAt": DateTime.now().subtract(const Duration(days: 4)),
      "updatedAt": DateTime.now().subtract(const Duration(days: 3)),
      "isFavorite": false,
      "isHighlighted": true,
    },
    {
      "id": 6,
      "title": "Learning Goals - Flutter Development",
      "content":
          "Personal learning objectives for Flutter development including advanced state management, custom animations, and performance optimization techniques. Include practice projects and timeline.",
      "category": "Learning",
      "createdAt": DateTime.now().subtract(const Duration(days: 5)),
      "updatedAt": DateTime.now().subtract(const Duration(days: 4)),
      "isFavorite": true,
      "isHighlighted": false,
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
    _loadNotes();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadNotes() async {
    setState(() {
      _isLoading = true;
    });

    // Simulate API call with Future.delayed
    await Future.delayed(const Duration(milliseconds: 800));

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _refreshNotes() async {
    await _loadNotes();
  }

  List<Map<String, dynamic>> _getFilteredNotes() {
    List<Map<String, dynamic>> filteredNotes = List.from(_mockNotes);

    // Apply category filter
    if (_selectedFilter != 'All Notes') {
      if (_selectedFilter == 'Favorites') {
        filteredNotes = filteredNotes
            .where((note) => note["isFavorite"] as bool? ?? false)
            .toList();
      } else {
        filteredNotes = filteredNotes
            .where((note) => note["category"] == _selectedFilter)
            .toList();
      }
    }

    // Apply tab filter
    switch (_tabController.index) {
      case 1: // Highlights
        filteredNotes = filteredNotes
            .where((note) => note["isHighlighted"] as bool? ?? false)
            .toList();
        break;
      case 2: // Favorite Notes
        filteredNotes = filteredNotes
            .where((note) => note["isFavorite"] as bool? ?? false)
            .toList();
        break;
      default: // Notes (all)
        break;
    }

    // Sort by updated date (most recent first)
    filteredNotes.sort((a, b) {
      final dateA = a["updatedAt"] as DateTime? ?? DateTime.now();
      final dateB = b["updatedAt"] as DateTime? ?? DateTime.now();
      return dateB.compareTo(dateA);
    });

    return filteredNotes;
  }

  void _handleNoteCardTap(Map<String, dynamic> note) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Opening note: ${note["title"]}'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _handleNoteCardLongPress(Map<String, dynamic> note) {
    _showNoteOptionsBottomSheet(note);
  }

  void _showNoteOptionsBottomSheet(Map<String, dynamic> note) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Note Options',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 2.h),
            ListTile(
              leading: CustomIconWidget(
                iconName: (note["isFavorite"] as bool? ?? false)
                    ? 'favorite'
                    : 'favorite_border',
                color: AppTheme.accentCoral,
                size: 24,
              ),
              title: Text(
                (note["isFavorite"] as bool? ?? false)
                    ? 'Remove from Favorites'
                    : 'Add to Favorites',
              ),
              onTap: () {
                Navigator.pop(context);
                _toggleFavorite(note);
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'highlight',
                color: AppTheme.accentCoral,
                size: 24,
              ),
              title: Text(
                (note["isHighlighted"] as bool? ?? false)
                    ? 'Remove Highlight'
                    : 'Highlight Note',
              ),
              onTap: () {
                Navigator.pop(context);
                _toggleHighlight(note);
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'edit',
                color: AppTheme.textSecondary,
                size: 24,
              ),
              title: const Text('Edit Note'),
              onTap: () {
                Navigator.pop(context);
                _editNote(note);
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'delete',
                color: AppTheme.errorColor,
                size: 24,
              ),
              title: const Text('Delete Note'),
              onTap: () {
                Navigator.pop(context);
                _deleteNote(note);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _toggleFavorite(Map<String, dynamic> note) {
    setState(() {
      note["isFavorite"] = !(note["isFavorite"] as bool? ?? false);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          (note["isFavorite"] as bool)
              ? 'Added to favorites'
              : 'Removed from favorites',
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _toggleHighlight(Map<String, dynamic> note) {
    setState(() {
      note["isHighlighted"] = !(note["isHighlighted"] as bool? ?? false);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          (note["isHighlighted"] as bool)
              ? 'Note highlighted'
              : 'Highlight removed',
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _editNote(Map<String, dynamic> note) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Edit note: ${note["title"]}'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _deleteNote(Map<String, dynamic> note) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Note'),
        content: Text('Are you sure you want to delete "${note["title"]}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _mockNotes.removeWhere((n) => n["id"] == note["id"]);
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Note deleted'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _handleSearchTap() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Search functionality activated'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _handleProfileTap() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Profile menu opened'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _handleCreateNote() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Create new note'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filteredNotes = _getFilteredNotes();

    return Scaffold(
      backgroundColor: AppTheme.primaryWhite,
      body: Column(
        children: [
          NotesHeaderWidget(
            onSearchTap: _handleSearchTap,
            onProfileTap: _handleProfileTap,
          ),
          NotesTabBarWidget(tabController: _tabController, tabs: _tabs),
          NotesFilterWidget(
            selectedFilter: _selectedFilter,
            onFilterChanged: (filter) {
              setState(() {
                _selectedFilter = filter;
              });
            },
            filterOptions: _filterOptions,
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: _tabs
                  .map((tab) => _buildNotesContent(filteredNotes))
                  .toList(),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppTheme.textPrimary,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildBottomNavItem('home', 'Home', true),
                _buildBottomNavItem('settings', 'Settings', false),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _handleCreateNote,
        backgroundColor: AppTheme.accentCoral,
        child: CustomIconWidget(
          iconName: 'add',
          color: AppTheme.primaryWhite,
          size: 28,
        ),
      ),
    );
  }

  Widget _buildNotesContent(List<Map<String, dynamic>> notes) {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: AppTheme.accentCoral),
      );
    }

    if (notes.isEmpty) {
      return EmptyNotesWidget(onCreateNote: _handleCreateNote);
    }

    return RefreshIndicator(
      onRefresh: _refreshNotes,
      color: AppTheme.accentCoral,
      child: ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
        itemCount: notes.length,
        itemBuilder: (context, index) {
          final note = notes[index];
          return NoteCardWidget(
            note: note,
            onTap: () => _handleNoteCardTap(note),
            onLongPress: () => _handleNoteCardLongPress(note),
          );
        },
      ),
    );
  }

  Widget _buildBottomNavItem(String iconName, String label, bool isActive) {
    return GestureDetector(
      onTap: () {
        if (iconName == 'settings') {
          Navigator.pushNamed(context, '/settings-screen');
        }
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomIconWidget(
            iconName: iconName,
            color: isActive
                ? AppTheme.primaryWhite
                : AppTheme.primaryWhite.withValues(alpha: 0.6),
            size: 24,
          ),
          SizedBox(height: 0.5.h),
          Text(
            label,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: isActive
                  ? AppTheme.primaryWhite
                  : AppTheme.primaryWhite.withValues(alpha: 0.6),
              fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
