import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class NotesFilterWidget extends StatelessWidget {
  final String selectedFilter;
  final ValueChanged<String> onFilterChanged;
  final List<String> filterOptions;

  const NotesFilterWidget({
    super.key,
    required this.selectedFilter,
    required this.onFilterChanged,
    required this.filterOptions,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      child: Row(
        children: [
          Text(
            'Filter:',
            style: theme.textTheme.labelMedium?.copyWith(
              color: AppTheme.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 3.w),
              decoration: BoxDecoration(
                color: AppTheme.primaryWhite,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppTheme.borderSubtle, width: 1),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.shadowBase,
                    blurRadius: 2,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: selectedFilter,
                  isExpanded: true,
                  icon: CustomIconWidget(
                    iconName: 'keyboard_arrow_down',
                    color: AppTheme.textSecondary,
                    size: 20,
                  ),
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: AppTheme.textPrimary,
                  ),
                  dropdownColor: AppTheme.primaryWhite,
                  items: filterOptions.map((String option) {
                    return DropdownMenuItem<String>(
                      value: option,
                      child: Row(
                        children: [
                          _getFilterIcon(option),
                          SizedBox(width: 2.w),
                          Text(option),
                        ],
                      ),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      onFilterChanged(newValue);
                    }
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _getFilterIcon(String filter) {
    String iconName;
    Color iconColor = AppTheme.textSecondary;

    switch (filter.toLowerCase()) {
      case 'all notes':
        iconName = 'note';
        break;
      case 'work':
        iconName = 'work';
        iconColor = AppTheme.accentCoral;
        break;
      case 'personal':
        iconName = 'person';
        iconColor = AppTheme.accentMint.withValues(alpha: 0.8);
        break;
      case 'learning':
        iconName = 'school';
        iconColor = AppTheme.accentCream.withValues(alpha: 0.8);
        break;
      case 'favorites':
        iconName = 'favorite';
        iconColor = AppTheme.accentCoral;
        break;
      default:
        iconName = 'folder';
        break;
    }

    return CustomIconWidget(iconName: iconName, color: iconColor, size: 16);
  }
}
