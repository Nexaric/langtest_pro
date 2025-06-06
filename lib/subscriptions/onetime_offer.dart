import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:langtest_pro/payment/payment_screen.dart';
import 'offer_timer_manager.dart';

class OneTimeOfferPopup extends StatefulWidget {
  final VoidCallback onClose;

  const OneTimeOfferPopup({super.key, required this.onClose});

  @override
  State<OneTimeOfferPopup> createState() => _OneTimeOfferPopupState();
}

class _OneTimeOfferPopupState extends State<OneTimeOfferPopup>
    with TickerProviderStateMixin {
  late AnimationController _openAnimationController;
  late Animation<double> _scaleAnimation;
  final String _offerPrice = '₹49'; // Define the offer price
  bool _isTimerActive = false; // Track timer state to prevent recursion

  @override
  void initState() {
    super.initState();
    // Setup for popup opening animation
    _openAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(
        parent: _openAnimationController,
        curve: Curves.easeOutBack,
      ),
    );
    _openAnimationController.forward();

    // Start countdown only if not already active
    if (!_isTimerActive) {
      _isTimerActive = true;
      OfferTimerManager().startCountdown(
        onUpdate: () {
          if (mounted && _isTimerActive) {
            setState(() {}); // Update UI for timer changes
            if (OfferTimerManager().isOfferExpired) {
              _isTimerActive = false;
              widget.onClose(); // Notify parent when timer ends
              if (mounted && Navigator.of(context).canPop()) {
                Navigator.of(context).pop(); // Auto-dismiss popup
              }
            }
          }
        },
      );
    }
  }

  @override
  void dispose() {
    _isTimerActive = false; // Ensure timer stops on dispose
    OfferTimerManager().stopCountdown();
    _openAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    int minutes = (OfferTimerManager().remainingSeconds ~/ 60) % 60;
    int seconds = OfferTimerManager().remainingSeconds % 60;

    const List<Color> mainGradientColors = [
      Color(0xFF3E1E68),
      Color(0xFF6A5AE0),
    ];

    return Center(
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20.0),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
              child: Container(
                width: screenWidth * 0.9, // 90% of screen width
                constraints: BoxConstraints(
                  maxHeight: screenHeight * 0.6, // Max 60% of screen height
                  minHeight: 300, // Minimum height for content
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 25.0,
                  vertical: 20.0,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20.0),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.2),
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 10,
                      spreadRadius: 2,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    Positioned(
                      top: 0,
                      right: 0,
                      child: IconButton(
                        icon: const Icon(Icons.close, color: Colors.white70),
                        onPressed: () {
                          _isTimerActive = false;
                          OfferTimerManager().stopCountdown(); // Stop timer
                          widget.onClose(); // Notify parent
                          if (Navigator.of(context).canPop()) {
                            Navigator.of(context).pop(); // Dismiss dialog
                          }
                        },
                      ),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(height: 20),
                        const Text(
                          'One Time Offer',
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const Text(
                          '50% OFF',
                          style: TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'Limited Time Offer',
                          style: TextStyle(fontSize: 14, color: Colors.white70),
                        ),
                        const SizedBox(height: 10),
                        _buildTimerRow(minutes, seconds),
                        const SizedBox(height: 25),
                        _buildPriceComparison(),
                        const SizedBox(height: 30),
                        _buildClaimOfferButton(mainGradientColors, context),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTimerRow(int minutes, int seconds) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildTimerDigit((minutes ~/ 10).toString()),
        _buildTimerDigit((minutes % 10).toString()),
        const Text(':', style: TextStyle(fontSize: 24, color: Colors.white70)),
        _buildTimerDigit((seconds ~/ 10).toString()),
        _buildTimerDigit((seconds % 10).toString()),
      ],
    );
  }

  Widget _buildTimerDigit(String digit) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        digit,
        style: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildPriceComparison() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  'Original Price',
                  style: TextStyle(fontSize: 16, color: Colors.white70),
                ),
                const SizedBox(height: 5),
                Text(
                  '₹99',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    decoration: TextDecoration.lineThrough,
                    decorationColor: Colors.white,
                    decorationThickness: 2,
                  ),
                ),
                const Text(
                  'per month',
                  style: TextStyle(fontSize: 12, color: Colors.white54),
                ),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            child: Icon(Icons.arrow_forward, color: Colors.white70, size: 30),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  'Offer Price',
                  style: TextStyle(fontSize: 16, color: Colors.white70),
                ),
                const SizedBox(height: 5),
                Text(
                  _offerPrice,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const Text(
                  'per month',
                  style: TextStyle(fontSize: 12, color: Colors.white54),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildClaimOfferButton(
    List<Color> gradientColors,
    BuildContext context,
  ) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30.0),
        gradient: LinearGradient(
          colors: gradientColors,
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF6A5AE0).withOpacity(0.5),
            blurRadius: 10,
            spreadRadius: 1,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(30.0),
          onTap: () {
            _isTimerActive = false;
            OfferTimerManager().stopCountdown(); // Stop timer
            widget.onClose(); // Notify parent
            if (Navigator.of(context).canPop()) {
              Navigator.of(context).pop(); // Dismiss dialog
            }
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PaymentScreen(price: _offerPrice),
                ),
              );
            });
          },
          child: const Center(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 15.0),
              child: Text(
                'Buy Now',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
