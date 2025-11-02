import 'package:flutter/material.dart';
import 'package:sigma_note_app/presentation/settings_screen/widgets/setting_options.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/account_section.dart';
import './widgets/device_info_card.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: _buildAppBar(context),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 2.h),
              const DeviceInfoCard(),
              SizedBox(height: 1.h),
              const AccountSection(),
              SizedBox(height: 1.h),
              const SettingsOptionsSection(),
              SizedBox(height: 4.h),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(context),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      leading: Navigator.canPop(context)
          ? IconButton(
              icon: CustomIconWidget(
                iconName: 'arrow_back_ios',
                color: AppTheme.textPrimary,
                size: 6.w,
              ),
              onPressed: () => Navigator.of(context).pop(),
            )
          : null,
      title: Text(
        'Settings',
        style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w600,
          color: AppTheme.textPrimary,
        ),
      ),
      centerTitle: true,
      actions: [
        IconButton(
          icon: CustomIconWidget(
            iconName: 'help_outline',
            color: AppTheme.textSecondary,
            size: 6.w,
          ),
          onPressed: () => _showHelpDialog(context),
        ),
      ],
    );
  }

  Widget _buildBottomNavigationBar(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: AppTheme.shadowBase,
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.transparent,
        elevation: 0,
        selectedItemColor: AppTheme.accentCoral,
        unselectedItemColor: AppTheme.textSecondary,
        currentIndex: 1, // Settings tab is selected
        onTap: (index) => _handleBottomNavTap(context, index),
        items: [
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'note_outlined',
              color: AppTheme.textSecondary,
              size: 6.w,
            ),
            activeIcon: CustomIconWidget(
              iconName: 'note',
              color: AppTheme.accentCoral,
              size: 6.w,
            ),
            label: 'Notes',
          ),
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'settings_outlined',
              color: AppTheme.textSecondary,
              size: 6.w,
            ),
            activeIcon: CustomIconWidget(
              iconName: 'settings',
              color: AppTheme.accentCoral,
              size: 6.w,
            ),
            label: 'Settings',
          ),
        ],
      ),
    );
  }

  void _handleBottomNavTap(BuildContext context, int index) {
    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, '/notes-screen');
        break;
      case 1:
        // Already on settings screen
        break;
    }
  }

  void _showHelpDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: Row(
          children: [
            CustomIconWidget(
              iconName: 'help',
              color: AppTheme.accentCoral,
              size: 6.w,
            ),
            SizedBox(width: 3.w),
            Text(
              'Help & Support',
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Need assistance with Lao Note?',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.textPrimary,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              '• Visit our help center for detailed guides\n• Contact support at support@laonote.com\n• Check our FAQ section for common questions\n• Report bugs through the feedback option',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.textSecondary,
                height: 1.5,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Close',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.accentCoral,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Opening support center...',
                    style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                      color: AppTheme.primaryWhite,
                    ),
                  ),
                  backgroundColor: AppTheme.accentCoral,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.accentCoral,
              foregroundColor: AppTheme.primaryWhite,
            ),
            child: Text(
              'Get Help',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.primaryWhite,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
