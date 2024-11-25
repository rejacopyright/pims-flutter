// ignore_for_file: non_constant_identifier_names

import 'dart:developer';

import 'package:get/get.dart';
import 'package:pims/_config/dio.dart';
import 'package:pims/_controller/config_controller.dart';
import 'package:pims/pages/visit/main.dart';

class PaymentData {
  String id;
  dynamic type;
  String name;
  String? label;
  String? description;
  String? how_to;
  int? deadline;
  String? icon;
  num? fee;
  PaymentData({
    required this.id,
    required this.type,
    required this.name,
    this.label,
    this.description,
    this.how_to,
    this.deadline,
    this.icon,
    this.fee,
  });
  factory PaymentData.fromJson(Map<String, dynamic> item) => PaymentData(
        id: item['id'],
        type: item['type'],
        name: item['name'],
        label: item['label'],
        description: item['description'],
        how_to: item['how_to'],
        deadline: item['deadline'],
        icon: item['icon'],
        fee: item['fee'],
      );
}

List<PaymentData> defaultPayments = [
  PaymentData(
    id: 'bca',
    type: 'bank_transfer',
    name: 'bca',
    label: 'BCA',
    description: 'Virtual account',
    icon: 'assets/icons/bca.png',
    fee: 7000,
  ),
  PaymentData(
    id: 'bni',
    type: 'bank_transfer',
    name: 'bni',
    label: 'BNI',
    description: 'Virtual account',
    icon: 'assets/icons/bni.png',
    fee: 7000,
  ),
  PaymentData(
    id: 'mandiri',
    type: 'bank_transfer',
    name: 'mandiri',
    label: 'Mandiri',
    description: 'Virtual account',
    icon: 'assets/icons/mandiri.png',
    fee: 7000,
  ),
  PaymentData(
    id: 'gopay',
    type: 'e_wallet',
    name: 'gopay',
    label: 'Gopay',
    icon: 'assets/icons/gopay.png',
    fee: 5000,
  ),
  PaymentData(
    id: 'shopee_pay',
    type: 'e_wallet',
    name: 'shopee_pay',
    label: 'Shopee Pay',
    icon: 'assets/icons/shopeepay.png',
    fee: 5000,
  ),
  PaymentData(
    id: 'alfamaret',
    type: 'counter',
    name: 'alfamaret',
    label: 'Alfamaret',
    icon: 'assets/icons/alfamaret.png',
    fee: 4000,
  ),
  PaymentData(
    id: 'indomaret',
    type: 'counter',
    name: 'indomaret',
    label: 'Indomaret',
    icon: 'assets/icons/indomaret.png',
    fee: 4000,
  ),
  PaymentData(
    id: 'qris',
    type: 'other',
    name: 'qris',
    label: 'QRIS',
    icon: 'assets/icons/qris.png',
    fee: 3000,
  ),
  PaymentData(
    id: 'cod',
    type: 'other',
    name: 'cod',
    label: 'COD',
    description: 'Bayar di tempat',
    icon: 'assets/icons/cod.png',
  ),
];

class PaymentController extends GetxController {
  // STATES
  RxList paymentMethod = [].obs;
  final paymentData = Rxn<List<PaymentData>>();

  final selectedVoucher = Rxn<Map<String, dynamic>>(null);
  final selectedPayment = Rxn<PaymentData>(null);

  // SET STATE
  void setSelectedVoucher(e) => selectedVoucher.value = e;
  void setSelectedPayment(e) => selectedPayment.value = e;

  @override
  void onInit() async {
    try {
      final api = await API().get('/global/payment_method');
      final result = (api.data as List).map((item) {
        final thisItem =
            defaultPayments.firstWhereOrNull((x) => x.name == item?['name']);
        item['icon'] = thisItem?.icon ?? '';
        return PaymentData.fromJson(item);
      }).toList();
      paymentData.value = result;
    } catch (e) {
      //
    }
    super.onInit();
  }
}

void visitTransaction() {
  final paymentController = Get.put(PaymentController());
  final visitController = Get.put(VisitAppController());
  final configController = Get.put(ConfigController());
  final selectedVoucher = paymentController.selectedVoucher.value;
  final selectedPayment = paymentController.selectedPayment.value;
  final visit_fee = configController.visit_fee.value;
  final app_fee = configController.app_fee.value;
  final visitTime = visitController.selectedTime.value;
  final visitTimeInterval = configController.visit_time_interval.value;
  final end_date = visitTime?.add(Duration(minutes: visitTimeInterval));

  final params = {
    'payment_id': selectedPayment?.name,
    'service_id': 1,
    'product_fee': visit_fee,
    'service_fee': selectedPayment?.fee ?? 0,
    'app_fee': app_fee,
    'discount_fee': selectedVoucher?['value'] ?? 0,
    'voucher_id': selectedVoucher?['id'],
    'total_fee': (visit_fee + (selectedPayment?.fee ?? 0) + app_fee) -
        (selectedVoucher?['value'] ?? 0),
    'start_date': visitTime,
    'end_date': end_date,
    'status': 1,
  };

  inspect(params);
}
