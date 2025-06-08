// lib/auth/login_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:langtest_pro/profile/user_info_screen.dart'; // Import the user info screen
import 'package:google_sign_in/google_sign_in.dart'; // Required for Google Sign-In

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  // Set system UI overlay style for a clean, modern look
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent, // Transparent status bar
      statusBarBrightness: Brightness.light, // Light icons on status bar
      statusBarIconBrightness: Brightness.light, // Light icons on status bar
      systemNavigationBarColor: Color(0xFF3E1E68), // Navigation bar color
      systemNavigationBarIconBrightness:
          Brightness.light, // Light icons on navigation bar
    ),
  );
  runApp(const LangtestApp());
}

class LangtestApp extends StatelessWidget {
  const LangtestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Langtest',
      // Define a custom theme for a consistent modern look, adhering to Material 3 principles
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6A5AE0), // Primary seed color
          brightness: Brightness.light,
          primary: const Color(0xFF6A5AE0), // Main primary color
          onPrimary: Colors.white,
          secondary: const Color(0xFF3E1E68), // Secondary color for accents
          onSecondary: Colors.white,
          surface: Colors.white, // Surface color for general UI elements
          onSurface: const Color(0xFF1A1D21), // Text on surface
          background: Colors.white, // Background color
          onBackground: const Color(0xFF1A1D21), // Text on background
          error: const Color(0xFFEF4444), // Error color
          onError: Colors.white,
        ),
        scaffoldBackgroundColor: Colors.white,
        fontFamily: 'Inter', // Custom font for modern typography
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          titleTextStyle: TextStyle(
            color: Color(0xFF1A1D21),
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        // Define custom text themes for different elements
        textTheme: const TextTheme(
          displayLarge: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w800,
            color: Colors.white,
            height: 1.2,
          ),
          displayMedium: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
          bodyLarge: TextStyle(
            fontSize: 16,
            color: Color(0xFFE2E8F0),
            height: 1.5,
          ),
          labelLarge: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        // Custom ElevatedButton theme for consistent button styling
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: const Color(0xFF3E1E68),
            padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 24),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                16,
              ), // More rounded corners for buttons
            ),
            elevation: 4, // Subtle elevation for Soft UI feel
            shadowColor: Colors.black.withOpacity(0.1), // Soft shadow
          ),
        ),
        // Custom TextButton theme
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: Colors.white.withOpacity(
              0.8,
            ), // Slightly transparent for subtle look
            textStyle: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              decoration: TextDecoration.underline,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),
      home: const LoginScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  bool _isLoading = false; // State to manage loading indicator
  late AnimationController _controller; // Controller for button animation
  late Animation<double> _scaleAnimation; // Scale animation for button press

  // Initialize GoogleSignIn instance
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'email', // Request email scope
    ],
  );

  @override
  void initState() {
    super.initState();
    // Setup animation controller for the button's press effect
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    // Define the scale animation for the button
    _scaleAnimation = Tween<double>(
      begin: 0.95, // Button shrinks slightly on press
      end: 1.0, // Returns to normal size
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _controller.dispose(); // Dispose the animation controller
    super.dispose();
  }

  // Handles the Google Sign-In process
  Future<void> _handleGoogleSignIn() async {
    if (_isLoading) return; // Prevent multiple taps while loading

    setState(() => _isLoading = true); // Show loading indicator
    _controller.forward(); // Start button animation (shrink effect)

    try {
      // Attempt to sign in with Google
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        // User cancelled the sign-in flow
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Google Sign-In cancelled.'),
              backgroundColor:
                  Theme.of(context).colorScheme.error, // Use theme error color
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          );
        }
        return; // Exit if sign-in was cancelled
      }

      print(
        'Signed in with Google: ${googleUser.displayName ?? 'No display name'}',
      );

      // Simulate a backend authentication delay (for demonstration)
      await Future.delayed(const Duration(seconds: 1));

      // After successful (simulated) authentication, navigate to UserInfoScreen
      if (mounted) {
        Navigator.pushReplacement(
          context,
          // Use PageRouteBuilder for custom animated slide transitions
          PageRouteBuilder(
            pageBuilder:
                (context, animation, secondaryAnimation) =>
                    const UserInfoScreen(),
            transitionsBuilder: (
              context,
              animation,
              secondaryAnimation,
              child,
            ) {
              const begin = Offset(
                1.0,
                0.0,
              ); // Start the new screen from the right
              const end = Offset.zero; // Slide to the center
              const curve = Curves.easeInOutQuad; // A smooth easing curve

              var tween = Tween(
                begin: begin,
                end: end,
              ).chain(CurveTween(curve: curve));

              return SlideTransition(
                position: animation.drive(tween), // Apply slide transition
                child: child,
              );
            },
          ),
        );
      }
    } catch (e) {
      // Handle any errors during the sign-in process
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Sign-in failed: ${e.toString()}'),
            backgroundColor:
                Theme.of(context).colorScheme.error, // Use theme error color
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
      }
    } finally {
      // Ensure loading state is reset and animation reversed
      if (mounted) {
        setState(() => _isLoading = false);
        _controller
            .reverse(); // Reverse button animation (return to normal size)
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Container(
        // Background with a soft, appealing gradient
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF3E1E68), Color(0xFF6A5AE0)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.08,
              ), // Responsive padding
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: screenHeight * 0.05), // Top spacing
                  // Animated App Icon with enhanced Glassmorphism/Soft UI effect
                  TweenAnimationBuilder<double>(
                    tween: Tween<double>(begin: 0.0, end: 1.0),
                    duration: const Duration(milliseconds: 700),
                    curve: Curves.easeOutCubic,
                    builder: (context, value, child) {
                      return Transform.scale(
                        scale: value, // Scale in the icon
                        child: Opacity(
                          opacity: value, // Fade in the icon
                          child: Container(
                            padding: const EdgeInsets.all(
                              28,
                            ), // Slightly larger padding
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              // Gradient for the glassmorphism effect
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  Colors.white.withOpacity(
                                    0.25 * value,
                                  ), // More prominent glassmorphism
                                  Colors.white.withOpacity(0.08 * value),
                                ],
                              ),
                              // Enhanced soft shadows for depth and modern feel
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.15 * value),
                                  blurRadius: 35 * value,
                                  spreadRadius: 3 * value,
                                  offset: const Offset(0, 15), // Main shadow
                                ),
                                BoxShadow(
                                  color: Theme.of(context).colorScheme.primary
                                      .withOpacity(0.3 * value),
                                  blurRadius: 20 * value,
                                  spreadRadius: 1 * value,
                                  offset: const Offset(0, 5), // Accent shadow
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.translate_rounded, // App icon
                              size: 72, // Larger icon
                              color: Colors.white,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  SizedBox(height: screenHeight * 0.06), // Spacing below icon
                  // Animated Welcome Text with slide-up and fade-in
                  TweenAnimationBuilder<double>(
                    tween: Tween<double>(begin: 0.0, end: 1.0),
                    duration: const Duration(milliseconds: 800),
                    curve: Curves.easeOutCubic,
                    builder: (context, value, child) {
                      return Opacity(
                        opacity: value,
                        child: Transform.translate(
                          offset: Offset(
                            0,
                            50 * (1 - value),
                          ), // Slide up effect
                          child: Text(
                            'Welcome to Langtest',
                            style: Theme.of(
                              context,
                            ).textTheme.displayLarge?.copyWith(
                              fontSize: 36, // Slightly larger font size
                              shadows: [
                                Shadow(
                                  offset: const Offset(2, 2),
                                  blurRadius: 4.0,
                                  color: Colors.black.withOpacity(0.2),
                                ),
                              ],
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      );
                    },
                  ),
                  SizedBox(
                    height: screenHeight * 0.02,
                  ), // Spacing between title and tagline
                  // Animated Tagline with slide-up and fade-in
                  TweenAnimationBuilder<double>(
                    tween: Tween<double>(begin: 0.0, end: 1.0),
                    duration: const Duration(milliseconds: 900),
                    curve: Curves.easeOutCubic,
                    builder: (context, value, child) {
                      return Opacity(
                        opacity: value,
                        child: Transform.translate(
                          offset: Offset(
                            0,
                            30 * (1 - value),
                          ), // Slide up effect
                          child: Text(
                            'The smart way to learn languages',
                            style: Theme.of(
                              context,
                            ).textTheme.bodyLarge?.copyWith(
                              fontSize: 18, // Slightly larger tagline font size
                              fontWeight: FontWeight.w400,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      );
                    },
                  ),
                  SizedBox(height: screenHeight * 0.1), // Spacing above buttons
                  // Google Sign-In Button with animation and loading state
                  AnimatedBuilder(
                    animation: _scaleAnimation,
                    builder: (context, child) {
                      return Transform.scale(
                        scale:
                            _scaleAnimation
                                .value, // Apply scale animation on press
                        child: child,
                      );
                    },
                    child:
                        _isLoading
                            ? const SizedBox(
                              width: 56, // Larger loading indicator
                              height: 56,
                              child: CircularProgressIndicator(
                                strokeWidth: 4, // Thicker stroke for visibility
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white, // White loading indicator
                                ),
                              ),
                            )
                            : Container(
                              // Container for Soft UI effect around button
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(
                                  16,
                                ), // Rounded corners
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 10,
                                    offset: const Offset(0, 5),
                                  ),
                                  BoxShadow(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.primary.withOpacity(0.1),
                                    blurRadius: 20,
                                    offset: const Offset(0, 10),
                                  ),
                                ],
                              ),
                              child: ElevatedButton(
                                onPressed:
                                    _handleGoogleSignIn, // Call sign-in method
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      Colors.white, // Button background
                                  foregroundColor:
                                      Theme.of(
                                        context,
                                      ).colorScheme.secondary, // Text color
                                  padding: EdgeInsets.symmetric(
                                    vertical:
                                        screenHeight *
                                        0.02, // Responsive vertical padding
                                    horizontal:
                                        screenWidth *
                                        0.06, // Responsive horizontal padding
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                      16,
                                    ), // Match container's rounded corners
                                  ),
                                  elevation:
                                      0, // Remove default elevation as container has shadow
                                  tapTargetSize:
                                      MaterialTapTargetSize
                                          .shrinkWrap, // Reduce extra space
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    // Google Logo - ensure you have 'assets/images/google_logo.png'
                                    Image.asset(
                                      'assets/images/google_logo.png',
                                      height: 28, // Slightly larger Google logo
                                      width: 28,
                                      errorBuilder: (
                                        context,
                                        error,
                                        stackTrace,
                                      ) {
                                        // Fallback icon if image asset is not found
                                        return Icon(
                                          Icons.g_mobiledata,
                                          size: 28,
                                          color:
                                              Theme.of(
                                                context,
                                              ).colorScheme.secondary,
                                        );
                                      },
                                    ),
                                    const SizedBox(width: 16), // More spacing
                                    const Text(
                                      'Continue with Google',
                                      style: TextStyle(
                                        fontSize:
                                            18, // Larger font size for button text
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                  ),
                  SizedBox(
                    height: screenHeight * 0.1,
                  ), // Increased bottom spacing
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
