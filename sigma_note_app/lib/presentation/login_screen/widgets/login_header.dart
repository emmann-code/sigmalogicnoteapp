import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class LoginHeaderWidget extends StatelessWidget {
  const LoginHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLogo(),
        SizedBox(height: 4.h),
        _buildWelcomeText(),
        SizedBox(height: 1.h),
        _buildSubtitleText(),
      ],
    );
  }

  Widget _buildLogo() {
    return Row(
      children: [
        Container(
          width: 12.w,
          height: 12.w,
          decoration: BoxDecoration(
            color: AppTheme.accentCoral,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: AppTheme.accentCoral.withValues(alpha: 0.3),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Center(
            child: CustomIconWidget(
              iconName: 'edit_note',
              color: AppTheme.primaryWhite,
              size: 24,
            ),
          ),
        ),
        SizedBox(width: 3.w),
        Text(
          'SIGMA NOTE APP',
          style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
            color: AppTheme.textPrimary,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.2,
          ),
        ),
      ],
    );
  }

  Widget _buildWelcomeText() {
    return Text(
      'Welcome Back',
      style: AppTheme.lightTheme.textTheme.headlineMedium?.copyWith(
        color: AppTheme.textPrimary,
        fontWeight: FontWeight.w600,
        height: 1.2,
      ),
    );
  }

  Widget _buildSubtitleText() {
    return Text(
      'Sign in to access your secure notes',
      style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
        color: AppTheme.textSecondary,
        height: 1.4,
      ),
    );
  }
}
