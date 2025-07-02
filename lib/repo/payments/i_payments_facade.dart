import 'package:dartz/dartz.dart';
import 'package:langtest_pro/model/payments_model.dart';
import 'package:langtest_pro/utils/app_exceptions.dart';

abstract class IPaymentsfacade {
    Future<Either<AppExceptions, Unit>> makePayment({required PaymentModel data, required String period});
}