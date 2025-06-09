import 'package:flutter/material.dart';
import 'package:langtest_pro/view/home/home_screen.dart';
import 'package:langtest_pro/view/payment/payment_screen.dart';
import 'package:langtest_pro/view/subscriptions/onetime_offer.dart';
import 'offer_timer_manager.dart';

class SubscriptionScreen extends StatefulWidget {
  const SubscriptionScreen({super.key});

  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen>
    with RouteAware {
  int _selectedPlanIndex = 1; // Default to Monthly plan

  @override
  void initState() {
    super.initState();
    // Defer popup display to after initial build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showOfferPopup();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final ModalRoute? route = ModalRoute.of(context);
    if (route is PageRoute) {
      routeObserver.subscribe(this, route);
    }
    // Defer popup display on each navigation
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showOfferPopup();
    });
  }

  void _showOfferPopup() {
    if (OfferTimerManager().isOfferExpired) return; // Skip if expired
    OfferTimerManager().startCountdown(
      onUpdate: () {
        if (mounted) {
          setState(() {}); // Update UI if needed
        }
      },
    );
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent dismissal by tapping outside
      builder: (BuildContext context) {
        return OneTimeOfferPopup(
          onClose: () {
            OfferTimerManager().stopCountdown(); // Mark as expired when closed
          },
        );
      },
    );
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF3E1E68), Color(0xFF6A5AE0)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: 20.0, left: 16.0, right: 16.0),
                ),
                const SizedBox(height: 20),
                Icon(
                  Icons.card_giftcard,
                  color: Colors.white.withOpacity(0.8),
                  size: 80,
                ),
                const SizedBox(height: 20),
                Text(
                  'Choose your plan',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Montserrat',
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '3 DAY FREE TRIAL',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 16,
                    fontFamily: 'Montserrat',
                  ),
                ),
                const SizedBox(height: 40),
                _buildPlanOption(
                  context,
                  index: 0,
                  title: '3 days',
                  description: 'Billed monthly no trial',
                  price: '₹FREE',
                  pricePeriod: '/Trial',
                  isRecommended: false,
                ),
                const SizedBox(height: 16),
                _buildPlanOption(
                  context,
                  index: 1,
                  title: 'Monthly',
                  description: 'Billed monthly no trial',
                  price: '₹99',
                  pricePeriod: '/month',
                  isRecommended: true,
                ),
                const SizedBox(height: 16),
                _buildPlanOption(
                  context,
                  index: 2,
                  title: 'Yearly',
                  description: 'Billed yearly no trial',
                  price: '₹599',
                  pricePeriod: '/year',
                  isRecommended: false,
                ),
                const SizedBox(height: 20),
                Text(
                  'Cancel anytime in the App store',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.6),
                    fontSize: 14,
                    fontFamily: 'Montserrat',
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      onPressed: () {
                        switch (_selectedPlanIndex) {
                          case 0:
                            break;
                          case 1:
                            break;
                          case 2:
                            break;
                          default:
                        }
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PaymentScreen(price: '99'),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF6B48EE),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        _selectedPlanIndex == 0
                            ? 'Continue with FREE trial'
                            : 'Continue with ${_getPlanPriceText(_selectedPlanIndex)}',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Montserrat',
                        ),
                      ),
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

  String _getPlanPriceText(int index) {
    switch (index) {
      case 0:
        return 'FREE trial';
      case 1:
        return '₹99/month';
      case 2:
        return '₹599/year';
      default:
        return '';
    }
  }

  Widget _buildPlanOption(
    BuildContext context, {
    required int index,
    required String title,
    required String description,
    required String price,
    required String pricePeriod,
    required bool isRecommended,
  }) {
    final bool isSelected = _selectedPlanIndex == index;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedPlanIndex = index;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          decoration: BoxDecoration(
            color:
                isSelected ? const Color(0xFF4A2F7C) : const Color(0xFF2A1C49),
            borderRadius: BorderRadius.circular(15),
            border:
                isSelected
                    ? Border.all(color: const Color(0xFF6B48EE), width: 3)
                    : Border.all(color: Colors.transparent),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Montserrat',
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.7),
                        fontSize: 14,
                        fontFamily: 'Montserrat',
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  if (isRecommended)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF6B48EE),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'RECOMMENDED',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Montserrat',
                        ),
                      ),
                    ),
                  if (isRecommended) const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        price,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Montserrat',
                        ),
                      ),
                      Text(
                        pricePeriod,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.7),
                          fontSize: 18,
                          fontFamily: 'Montserrat',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
