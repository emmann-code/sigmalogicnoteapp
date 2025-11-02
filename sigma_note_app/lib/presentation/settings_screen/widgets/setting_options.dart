import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class SettingsOptionsSection extends StatelessWidget {
  const SettingsOptionsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppTheme.shadowBase,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildSettingsItem(
            context,
            icon: 'notifications',
            title: 'Notifications',
            subtitle: 'Manage your notification preferences',
            onTap: () => _showNotificationSettings(context),
          ),
          _buildDivider(),
          _buildSettingsItem(
            context,
            icon: 'security',
            title: 'Security',
            subtitle: 'Privacy and security settings',
            onTap: () => _showSecuritySettings(context),
          ),
          _buildDivider(),
          _buildSettingsItem(
            context,
            icon: 'info',
            title: 'App Information',
            subtitle: 'Version 1.0.0 (Build 1)',
            onTap: () => _showAppInfo(context),
            showArrow: false,
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsItem(
    BuildContext context, {
    required String icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    bool showArrow = true,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      leading: Container(
        width: 10.w,
        height: 10.w,
        decoration: BoxDecoration(
          color: AppTheme.accentMint.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(5.w),
        ),
        child: Center(
          child: CustomIconWidget(
            iconName: icon,
            color: AppTheme.accentCoral,
            size: 5.w,
          ),
        ),
      ),
      title: Text(
        title,
        style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
          color: AppTheme.textPrimary,
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
          color: AppTheme.textSecondary,
        ),
      ),
      trailing: showArrow
          ? CustomIconWidget(
              iconName: 'chevron_right',
              color: AppTheme.textSecondary,
              size: 5.w,
            )
          : null,
      onTap: onTap,
    );
  }

  Widget _buildDivider() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      height: 1,
      color: AppTheme.borderSubtle,
    );
  }

  void _showNotificationSettings(BuildContext context) {
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
            Row(
              children: [
                CustomIconWidget(
                  iconName: 'notifications',
                  color: AppTheme.accentCoral,
                  size: 6.w,
                ),
                SizedBox(width: 3.w),
                Text(
                  'Notification Settings',
                  style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            SizedBox(height: 3.h),
            _buildSwitchTile(
              'Push Notifications',
              'Receive notifications for new notes and reminders',
              true,
              (value) {},
            ),
            _buildSwitchTile(
              'Email Notifications',
              'Get email updates about your notes',
              false,
              (value) {},
            ),
            _buildSwitchTile(
              'Sound',
              'Play sound for notifications',
              true,
              (value) {},
            ),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }

  void _showSecuritySettings(BuildContext context) {
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
            Row(
              children: [
                CustomIconWidget(
                  iconName: 'security',
                  color: AppTheme.accentCoral,
                  size: 6.w,
                ),
                SizedBox(width: 3.w),
                Text(
                  'Security Settings',
                  style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            SizedBox(height: 3.h),
            _buildSwitchTile(
              'Biometric Lock',
              'Use fingerprint or face ID to unlock',
              true,
              (value) {},
            ),
            _buildSwitchTile(
              'Auto-lock',
              'Automatically lock app when inactive',
              true,
              (value) {},
            ),
            _buildSwitchTile(
              'Encrypted Storage',
              'Encrypt notes on device',
              true,
              (value) {},
            ),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }

  void _showAppInfo(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: Row(
          children: [
            CustomIconWidget(
              iconName: 'info',
              color: AppTheme.accentCoral,
              size: 6.w,
            ),
            SizedBox(width: 3.w),
            Text(
              'Lao Note',
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
              'Version: 1.0.0 (Build 1)',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.textSecondary,
              ),
            ),
            SizedBox(height: 1.h),
            Text(
              'A premium secure notes management application with elegant minimal design.',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.textSecondary,
                height: 1.5,
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              '© 2024 Lao Note. All rights reserved.',
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.textDisabled,
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
        ],
      ),
    );
  }

  Widget _buildSwitchTile(
    String title,
    String subtitle,
    bool value,
    ValueChanged<bool> onChanged,
  ) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 1.h),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    color: AppTheme.textPrimary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 0.5.h),
                Text(
                  subtitle,
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: AppTheme.accentCoral,
            inactiveThumbColor: AppTheme.borderSubtle,
            inactiveTrackColor: AppTheme.borderSubtle.withValues(alpha: 0.5),
          ),
        ],
      ),
    );
  }
}
