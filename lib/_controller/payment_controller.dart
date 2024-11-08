import 'package:get/get.dart';

class PaymentController extends GetxController {
  // STATES
  final selectedVoucher = Rxn<String>(null);
  final selectedPayment = Rxn<String>(null);

  // SET STATE
  void setSelectedVoucher(e) => selectedVoucher.value = e;
  void setSelectedPayment(e) => selectedPayment.value = e;
}
