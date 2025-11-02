import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class NoteCardWidget extends StatelessWidget {
  final Map<String, dynamic> note;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  const NoteCardWidget({
    super.key,
    required this.note,
    this.onTap,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
        decoration: BoxDecoration(
          color: _getCardColor(),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: AppTheme.shadowBase,
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.all(4.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(theme),
              SizedBox(height: 1.h),
              _buildTitle(theme),
              SizedBox(height: 0.5.h),
              _buildPreview(theme),
              SizedBox(height: 1.5.h),
              _buildFooter(theme),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(ThemeData theme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildCategoryTag(theme),
        CustomIconWidget(
          iconName: (note["isFavorite"] as bool? ?? false)
              ? 'favorite'
              : 'favorite_border',
          color: (note["isFavorite"] as bool? ?? false)
              ? AppTheme.accentCoral
              : AppTheme.textSecondary,
          size: 20,
        ),
      ],
    );
  }

  Widget _buildCategoryTag(ThemeData theme) {
    final category = note["category"] as String? ?? "General";

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
      decoration: BoxDecoration(
        color: AppTheme.primaryWhite.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.borderSubtle, width: 1),
      ),
      child: Text(
        category,
        style: theme.textTheme.labelSmall?.copyWith(
          color: AppTheme.textSecondary,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildTitle(ThemeData theme) {
    final title = note["title"] as String? ?? "Untitled";

    return Text(
      title,
      style: theme.textTheme.titleMedium?.copyWith(
        color: AppTheme.textPrimary,
        fontWeight: FontWeight.w600,
      ),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildPreview(ThemeData theme) {
    final content = note["content"] as String? ?? "";

    return Text(
      content,
      style: theme.textTheme.bodySmall?.copyWith(
        color: AppTheme.textSecondary,
        height: 1.4,
      ),
      maxLines: 3,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildFooter(ThemeData theme) {
    final updatedAt = note["updatedAt"] as DateTime?;
    final formattedDate = updatedAt != null
        ? _formatDate(updatedAt)
        : "No date";

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            CustomIconWidget(
              iconName: 'access_time',
              color: AppTheme.textSecondary,
              size: 14,
            ),
            SizedBox(width: 1.w),
            Text(
              formattedDate,
              style: theme.textTheme.labelSmall?.copyWith(
                color: AppTheme.textSecondary,
              ),
            ),
          ],
        ),
        if (note["isHighlighted"] as bool? ?? false)
          Container(
            padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
            decoration: BoxDecoration(
              color: AppTheme.accentCoral.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              "Highlighted",
              style: theme.textTheme.labelSmall?.copyWith(
                color: AppTheme.accentCoral,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
      ],
    );
  }

  Color _getCardColor() {
    final colorIndex = (note["id"] as int? ?? 0) % 3;
    switch (colorIndex) {
      case 0:
        return AppTheme.accentCoral.withValues(alpha: 0.1);
      case 1:
        return AppTheme.accentCream;
      case 2:
        return AppTheme.accentMint;
      default:
        return AppTheme.primaryWhite;
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      if (difference.inHours == 0) {
        return "${difference.inMinutes}m ago";
      }
      return "${difference.inHours}h ago";
    } else if (difference.inDays == 1) {
      return "Yesterday";
    } else if (difference.inDays < 7) {
      return "${difference.inDays}d ago";
    } else {
      return "${date.month}/${date.day}/${date.year}";
    }
  }
}
