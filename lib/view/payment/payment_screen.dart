import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:langtest_pro/view/payment/loading_screen.dart';

class PaymentScreen extends StatefulWidget {
  final String price; // Add price parameter to receive subscription amount
  const PaymentScreen({super.key, required this.price, required paymentData});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final TextEditingController _upiIdController = TextEditingController(
    text: 'gauravkumar@okhdfcbank',
  );
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Full white screen as requested
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'UPI',
                    style: GoogleFonts.poppins(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 30),
                  Text(
                    'UPI Apps',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 10),
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final itemWidth = (constraints.maxWidth / 2) - 10;
                      return Wrap(
                        spacing: 20,
                        runSpacing: 10,
                        children: [
                          _buildUpiAppButton(
                            'Google Pay',
                            'assets/google_pay_logo.png',
                            itemWidth,
                          ),
                          _buildUpiAppButton(
                            'PhonePe',
                            'assets/phonepe_logo.png',
                            itemWidth,
                          ),
                          _buildUpiAppButton(
                            'PayTM',
                            'assets/paytm_logo.png',
                            itemWidth,
                          ),
                          _buildUpiAppButton(
                            'BHIM',
                            'assets/bhim_logo.png',
                            itemWidth,
                          ),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 30),
                  Text(
                    'UPI ID / Number',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: TextField(
                      controller: _upiIdController,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        suffixIcon: Icon(Icons.copy, color: Colors.grey),
                      ),
                      style: GoogleFonts.poppins(color: Colors.black),
                    ),
                  ),
                ],
              ),
            ),
          ),
          _buildBottomBar(context),
        ],
      ),
    );
  }

  Widget _buildUpiAppButton(String title, String imagePath, double itemWidth) {
    return SizedBox(
      width: itemWidth,
      child: OutlinedButton(
        onPressed: () {
          debugPrint('$title clicked!');
        },
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 15),
          side: const BorderSide(color: Colors.grey),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(imagePath, height: 24, width: 24),
            const SizedBox(width: 8),
            Text(title, style: GoogleFonts.poppins(color: Colors.black)),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.price == 'FREE'
                    ? '₹0'
                    : widget.price, // Display passed amount
                style: GoogleFonts.poppins(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              GestureDetector(
                onTap: () {},
                child: Row(
                  children: [
                    Text(
                      'View Details',
                      style: GoogleFonts.poppins(
                        color: Colors.grey,
                        fontSize: 14,
                      ),
                    ),
                    const Icon(
                      Icons.keyboard_arrow_up,
                      color: Colors.grey,
                      size: 16,
                    ),
                  ],
                ),
              ),
            ],
          ),
          ElevatedButton(
            onPressed:
                _isLoading
                    ? null
                    : () async {
                      setState(() {
                        _isLoading = true;
                      });
                      await Future.delayed(const Duration(seconds: 2));
                      if (mounted) {
                        setState(() {
                          _isLoading = false;
                        });
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoadingScreen(),
                          ),
                        );
                      }
                    },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0D47A1),
              padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.15,
                vertical: 15,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child:
                _isLoading
                    ? const SizedBox(
                      width: 40,
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [_Dot(), _Dot(), _Dot()],
                        ),
                      ),
                    )
                    : Text(
                      'Continue',
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
          ),
        ],
      ),
    );
  }
}

class _Dot extends StatefulWidget {
  const _Dot();

  @override
  State<_Dot> createState() => _DotState();
}

class _DotState extends State<_Dot> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Opacity(
          opacity: _animation.value,
          child: Container(
            width: 8.0,
            height: 8.0,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
          ),
        );
      },
    );
  }
}
