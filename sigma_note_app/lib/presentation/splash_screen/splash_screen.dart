import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoAnimationController;
  late AnimationController _loadingAnimationController;
  late Animation<double> _logoFadeAnimation;
  late Animation<double> _logoScaleAnimation;
  late Animation<double> _loadingOpacityAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startSplashSequence();
  }

  void _initializeAnimations() {
    // Logo animation controller
    _logoAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    // Loading animation controller
    _loadingAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    // Logo fade animation
    _logoFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _logoAnimationController,
        curve: const Interval(0.0, 0.8, curve: Curves.easeOut),
      ),
    );

    // Logo scale animation
    _logoScaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _logoAnimationController,
        curve: const Interval(0.2, 1.0, curve: Curves.elasticOut),
      ),
    );

    // Loading opacity animation
    _loadingOpacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _loadingAnimationController,
        curve: Curves.easeIn,
      ),
    );
  }

  void _startSplashSequence() async {
    // Start logo animation
    _logoAnimationController.forward();

    // Wait for logo animation to complete, then start loading animation
    await Future.delayed(const Duration(milliseconds: 800));
    _loadingAnimationController.forward();

    // Perform background initialization tasks
    await _performInitializationTasks();

    // Navigate to appropriate screen after splash duration
    await Future.delayed(const Duration(milliseconds: 1200));
    _navigateToNextScreen();
  }

  Future<void> _performInitializationTasks() async {
    try {
      // Simulate checking secure token storage
      await Future.delayed(const Duration(milliseconds: 500));

      // Simulate validating authentication status
      await Future.delayed(const Duration(milliseconds: 300));

      // Simulate initializing flutter_secure_storage
      await Future.delayed(const Duration(milliseconds: 200));

      // Simulate preparing Riverpod providers
      await Future.delayed(const Duration(milliseconds: 400));
    } catch (e) {
      // Handle initialization failures gracefully
      debugPrint('Initialization error: $e');
    }
  }

  void _navigateToNextScreen() {
    // Check authentication status and navigate accordingly
    final bool isAuthenticated = _checkAuthenticationStatus();

    if (mounted) {
      if (isAuthenticated) {
        // Navigate to Notes screen for authenticated users
        Navigator.pushReplacementNamed(context, '/notes-screen');
      } else {
        // Navigate to Login screen for unauthenticated users
        Navigator.pushReplacementNamed(context, '/login-screen');
      }
    }
  }

  bool _checkAuthenticationStatus() {
    // Mock authentication check - in real app, this would check secure storage
    // For now, return false to always show login screen first
    return false;
  }

  @override
  void dispose() {
    _logoAnimationController.dispose();
    _loadingAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryBlack,
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light.copyWith(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
        ),
        child: SafeArea(
          child: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: _buildBackgroundDecoration(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Center(
                    child: AnimatedBuilder(
                      animation: Listenable.merge([
                        _logoAnimationController,
                        _loadingAnimationController,
                      ]),
                      builder: (context, child) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _buildAnimatedLogo(),
                            SizedBox(height: 8.h),
                            _buildLoadingIndicator(),
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  BoxDecoration _buildBackgroundDecoration() {
    return BoxDecoration(
      color: AppTheme.primaryBlack,
      image: DecorationImage(
        image: const AssetImage('assets/images/no-image.jpg'),
        fit: BoxFit.cover,
        opacity: 0.1,
        onError: (exception, stackTrace) {},
      ),
    );
  }

  Widget _buildAnimatedLogo() {
    return Transform.scale(
      scale: _logoScaleAnimation.value,
      child: Opacity(
        opacity: _logoFadeAnimation.value,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Feather icon
            CustomIconWidget(
              iconName: 'edit',
              color: AppTheme.primaryWhite,
              size: 12.w,
            ),
            SizedBox(height: 3.h),
            // LAO NOTE text
            Text(
              'SIGMA NOTE APP',
              style: AppTheme.lightTheme.textTheme.headlineLarge?.copyWith(
                color: AppTheme.primaryWhite,
                fontWeight: FontWeight.w700,
                letterSpacing: 4.0,
                fontSize: 24.sp,
              ),
            ),
            SizedBox(height: 1.h),
            // Subtitle
            Text(
              'Secure Notes Management',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.primaryWhite.withValues(alpha: 0.7),
                letterSpacing: 1.2,
                fontSize: 12.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return Opacity(
      opacity: _loadingOpacityAnimation.value,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 8.w,
            height: 8.w,
            child: CircularProgressIndicator(
              strokeWidth: 2.0,
              valueColor: AlwaysStoppedAnimation<Color>(
                AppTheme.primaryWhite.withValues(alpha: 0.8),
              ),
            ),
          ),
          SizedBox(height: 2.h),
          Text(
            'Initializing...',
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.primaryWhite.withValues(alpha: 0.6),
              fontSize: 10.sp,
              letterSpacing: 0.8,
            ),
          ),
        ],
      ),
    );
  }
}
