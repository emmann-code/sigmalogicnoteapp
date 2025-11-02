import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sigma_note_app/presentation/login_screen/widgets/login_header.dart';
import 'package:sizer/sizer.dart';
import '../../core/app_export.dart';
import '../../theme/app_theme.dart';
import './widgets/login_footer_widget.dart';
import './widgets/login_form_widget.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with TickerProviderStateMixin {
  bool _isLoading = false;
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  // Mock credentials
  static const String _validEmail = 'test@sigma-logic.gr';
  static const String _validPassword = 'password123';

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _checkExistingToken();
  }

  void _initializeAnimations() {
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _slideController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
          CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic),
        );

    // Start animations
    _fadeController.forward();
    Future.delayed(const Duration(milliseconds: 200), () {
      _slideController.forward();
    });
  }

  Future<void> _checkExistingToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');

      if (token != null && token.isNotEmpty && mounted) {
        // Token exists, navigate to notes screen
        Navigator.pushReplacementNamed(context, '/notes-screen');
      }
    } catch (e) {
      // Handle error silently
    }
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin(String email, String password) async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    try {
      // Simulate authentication delay
      await Future.delayed(const Duration(seconds: 2));

      // Validate credentials
      if (email.trim().toLowerCase() == _validEmail.toLowerCase() &&
          password == _validPassword) {
        // Store authentication token
        await _storeAuthToken();

        if (mounted) {
          // Show success message
          _showSuccessToast();

          // Navigate to notes screen with smooth transition
          await Future.delayed(const Duration(milliseconds: 500));
          Navigator.pushReplacementNamed(context, '/notes-screen');
        }
      } else {
        // Invalid credentials
        if (mounted) {
          _showErrorToast(
            'Invalid credentials. Please check your email and password.',
          );
        }
      }
    } catch (e) {
      if (mounted) {
        _showErrorToast('Login failed. Please try again.');
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _storeAuthToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = 'auth_token_${DateTime.now().millisecondsSinceEpoch}';
      await prefs.setString('auth_token', token);
      await prefs.setString('user_email', _validEmail);
      await prefs.setInt(
        'login_timestamp',
        DateTime.now().millisecondsSinceEpoch,
      );
    } catch (e) {
      // Handle storage error
      throw Exception('Failed to store authentication token');
    }
  }

  void _showSuccessToast() {
    Fluttertoast.showToast(
      msg: "Login successful! Welcome back.",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 2,
      backgroundColor: AppTheme.statusSuccess,
      textColor: AppTheme.primaryWhite,
      fontSize: 14,
    );
  }

  void _showErrorToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 3,
      backgroundColor: AppTheme.errorColor,
      textColor: AppTheme.primaryWhite,
      fontSize: 14,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryWhite,
      body: SafeArea(
        child: GestureDetector(
          onTap: () {
            // Dismiss keyboard when tapping outside
            FocusScope.of(context).unfocus();
          },
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight:
                    MediaQuery.of(context).size.height -
                    MediaQuery.of(context).padding.top -
                    MediaQuery.of(context).padding.bottom,
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 6.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(height: 6.h),

                    // Header with logo and welcome text
                    FadeTransition(
                      opacity: _fadeAnimation,
                      child: const LoginHeaderWidget(),
                    ),

                    SizedBox(height: 6.h),

                    // Login form
                    SlideTransition(
                      position: _slideAnimation,
                      child: FadeTransition(
                        opacity: _fadeAnimation,
                        child: LoginFormWidget(
                          onLogin: _handleLogin,
                          isLoading: _isLoading,
                        ),
                      ),
                    ),

                    SizedBox(height: 4.h),

                    // Footer with demo credentials and security badge
                    FadeTransition(
                      opacity: _fadeAnimation,
                      child: const LoginFooterWidget(),
                    ),

                    SizedBox(height: 4.h),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
