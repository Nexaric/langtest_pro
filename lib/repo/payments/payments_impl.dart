import 'dart:async';
import 'package:dartz/dartz.dart';
import 'package:langtest_pro/model/payments_model.dart';
import 'package:langtest_pro/repo/payments/i_payments_facade.dart';
import 'package:langtest_pro/utils/app_exceptions.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:langtest_pro/utils/utils.dart';

class PaymentsImpl implements IPaymentsfacade {
  final Razorpay _razorpay = Razorpay();
  late String _paymentPeriod;
  late Completer<Either<AppExceptions, Unit>> _paymentCompleter;

  PaymentsImpl() {
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccessResponse);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentErrorResponse);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWalletSelected);
  }

  @override
  Future<Either<AppExceptions, Unit>> makePayment({
    required PaymentModel data,
    required String period,
  }) {
    _paymentCompleter = Completer<Either<AppExceptions, Unit>>();
    _paymentPeriod = period;

    try {
      _razorpay.open(data.toJson());
    } catch (e) {
      return Future.value(left(AppExceptions("Unable to open Razorpay: $e")));
    }

    return _paymentCompleter.future;
  }

  void _handlePaymentSuccessResponse(PaymentSuccessResponse response) async {
    if (_paymentCompleter.isCompleted) return;

    try {
      final paymentId = response.paymentId ?? '';
      final uid = Supabase.instance.client.auth.currentUser?.id ?? '';
      print("uid is : $uid");
      if (uid.isEmpty) {
        _paymentCompleter.complete(left(AppExceptions("User not authenticated")));
        return;
      }

      final phone = await Utils.getString('phone') ?? '';
      final email = await Utils.getString('email') ?? '';

      final reso = await Supabase.instance.client.rpc('get_server_timestamp');
      final serverTime = DateTime.parse(reso.toString());

      final expiryDate = _paymentPeriod == "yearly"
          ? serverTime.add(const Duration(days: 365))
          : serverTime.add(const Duration(days: 30));

          

      final orderData = {
        'payment_id': paymentId,
        'uid': uid,
        'phone': phone,
        'email': email,
        'period': _paymentPeriod,
        'expiry_date': expiryDate.toIso8601String(),
      };

      await Supabase.instance.client
          .from('orders_duplicate')
        .upsert(orderData,onConflict: 'uid');

      print('✅ Order stored in Supabase');
      _paymentCompleter.complete(right(unit));
    } catch (e) {
      print('❌ Error saving order to Supabase: $e');
      if (!_paymentCompleter.isCompleted) {
        _paymentCompleter.complete(
          left(AppExceptions("Payment succeeded but saving to Supabase failed.")),
        );
      }
    }
  }

  void _handlePaymentErrorResponse(PaymentFailureResponse response) {
    if (!_paymentCompleter.isCompleted) {
      _paymentCompleter.complete(
        left(AppExceptions("Payment failed: ${response.message}")),
      );
    }
  }

  void _handleExternalWalletSelected(ExternalWalletResponse response) {
    if (!_paymentCompleter.isCompleted) {
      _paymentCompleter.complete(
        left(AppExceptions("External Wallet selected: ${response.walletName}")),
      );
    }
  }
}
