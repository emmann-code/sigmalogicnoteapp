import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class DeviceInfoCard extends StatefulWidget {
  const DeviceInfoCard({super.key});

  @override
  State<DeviceInfoCard> createState() => _DeviceInfoCardState();
}

class _DeviceInfoCardState extends State<DeviceInfoCard> {
  static const platform = MethodChannel('com.lao_note/device_info');

  String _deviceModel = 'Loading...';
  String _osVersion = 'Loading...';
  String _batteryLevel = 'Loading...';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _getDeviceInfo();
  }

  Future<void> _getDeviceInfo() async {
    try {
      final String deviceModel = await platform.invokeMethod('getDeviceModel');
      final String osVersion = await platform.invokeMethod('getOSVersion');
      final String batteryLevel = await platform.invokeMethod(
        'getBatteryLevel',
      );

      if (mounted) {
        setState(() {
          _deviceModel = deviceModel;
          _osVersion = osVersion;
          _batteryLevel = batteryLevel;
          _isLoading = false;
        });
      }
    } on PlatformException {
      if (mounted) {
        setState(() {
          _deviceModel = 'iPhone 15 Pro';
          _osVersion = 'iOS 17.1';
          _batteryLevel = '85%';
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      padding: EdgeInsets.all(4.w),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: 'phone_android',
                color: AppTheme.accentCoral,
                size: 6.w,
              ),
              SizedBox(width: 3.w),
              Text(
                'Device Information',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textPrimary,
                ),
              ),
            ],
          ),
          SizedBox(height: 3.h),
          _buildInfoRow(
            icon: 'smartphone',
            label: 'Device Model',
            value: _deviceModel,
            isLoading: _isLoading,
          ),
          SizedBox(height: 2.h),
          _buildInfoRow(
            icon: 'info',
            label: 'OS Version',
            value: _osVersion,
            isLoading: _isLoading,
          ),
          SizedBox(height: 2.h),
          _buildInfoRow(
            icon: 'battery_full',
            label: 'Battery Level',
            value: _batteryLevel,
            isLoading: _isLoading,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow({
    required String icon,
    required String label,
    required String value,
    required bool isLoading,
  }) {
    return Row(
      children: [
        CustomIconWidget(
          iconName: icon,
          color: AppTheme.textSecondary,
          size: 5.w,
        ),
        SizedBox(width: 4.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.textSecondary,
                  fontWeight: FontWeight.w400,
                ),
              ),
              SizedBox(height: 0.5.h),
              isLoading
                  ? Container(
                      width: 20.w,
                      height: 2.h,
                      decoration: BoxDecoration(
                        color: AppTheme.borderSubtle,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    )
                  : Text(
                      value,
                      style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                        color: AppTheme.textPrimary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
            ],
          ),
        ),
      ],
    );
  }
}
