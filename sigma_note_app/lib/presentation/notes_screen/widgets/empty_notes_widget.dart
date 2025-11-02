import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class EmptyNotesWidget extends StatelessWidget {
  final VoidCallback? onCreateNote;

  const EmptyNotesWidget({super.key, this.onCreateNote});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: EdgeInsets.all(8.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildIllustration(),
            SizedBox(height: 4.h),
            _buildTitle(theme),
            SizedBox(height: 2.h),
            _buildDescription(theme),
            SizedBox(height: 4.h),
            _buildCreateButton(theme),
          ],
        ),
      ),
    );
  }

  Widget _buildIllustration() {
    return Container(
      width: 40.w,
      height: 40.w,
      decoration: BoxDecoration(
        color: AppTheme.accentMint.withValues(alpha: 0.3),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: CustomIconWidget(
          iconName: 'note_add',
          color: AppTheme.accentCoral,
          size: 60,
        ),
      ),
    );
  }

  Widget _buildTitle(ThemeData theme) {
    return Text(
      'No Notes Yet',
      style: theme.textTheme.headlineSmall?.copyWith(
        color: AppTheme.textPrimary,
        fontWeight: FontWeight.w600,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildDescription(ThemeData theme) {
    return Text(
      'Start capturing your thoughts and ideas.\nYour first note is just a tap away!',
      style: theme.textTheme.bodyMedium?.copyWith(
        color: AppTheme.textSecondary,
        height: 1.5,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildCreateButton(ThemeData theme) {
    return ElevatedButton.icon(
      onPressed: onCreateNote ?? () => _handleCreateNote(),
      icon: CustomIconWidget(
        iconName: 'add',
        color: AppTheme.primaryWhite,
        size: 20,
      ),
      label: Text(
        'Create First Note',
        style: theme.textTheme.labelLarge?.copyWith(
          color: AppTheme.primaryWhite,
          fontWeight: FontWeight.w600,
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: AppTheme.accentCoral,
        foregroundColor: AppTheme.primaryWhite,
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        elevation: 4,
        shadowColor: AppTheme.shadowBase,
      ),
    );
  }

  void _handleCreateNote() {
    // Handle create note action
  }
}
