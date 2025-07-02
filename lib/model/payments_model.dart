class PaymentModel {
  final String key;
  final int amount;
  final String name;
  final String description;
  final Map<String, dynamic> retry;
  final bool sendSmsHash;
  final Map<String, String> prefill;
  final Map<String, dynamic> paymentModelExternal;

  PaymentModel({
    required this.key,
    required this.amount,
    required this.name,
    required this.description,
    required this.retry,
    required this.sendSmsHash,
    required this.prefill,
    required this.paymentModelExternal,
  });

  Map<String, dynamic> toJson() {
    return {
      'key': key,
      'amount': amount,
      'name': name,
      'description': description,
      'retry': retry,
      'send_sms_hash': sendSmsHash,
      'prefill': prefill,
      'external': paymentModelExternal,
    };
  }
}
