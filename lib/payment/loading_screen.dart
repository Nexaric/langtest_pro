import 'package:flutter/material.dart';
import 'package:langtest_pro/payment/payment_successful.dart';
// Adjust import based on your project structure

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2), // Adjust animation duration
      vsync: this,
    )..repeat(reverse: true);

    _animation = Tween<double>(
      begin: 0.8,
      end: 1.2,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    // Simulate network delay and navigate to success screen
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const PaymentSuccessfulScreen(),
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Background of the original payment screen (partially visible)
          // This creates the effect of a modal popping up
          // You might need to pass the parent widget's content here if you want it to be truly dynamic
          // For simplicity, we are just showing a white background.
          Container(color: Colors.white),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ScaleTransition(
                  scale: _animation,
                  child: Image.asset(
                    'assets/shopping_cart_animation.png', // Placeholder for shopping cart
                    height: 150,
                    width: 150,
                  ),
                ),
                const SizedBox(height: 30),
                const Text(
                  'Confirming Payment',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                const Text(
                  'This will only take a few seconds.',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                const SizedBox(height: 50),
                Image.asset(
                  'assets/razorpay_logo.png', // Placeholder for Razorpay logo
                  height: 30,
                ),
                const SizedBox(height: 5),
                const Text(
                  'Secured by Razorpay',
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
