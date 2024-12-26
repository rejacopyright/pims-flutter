// ignore_for_file: non_constant_identifier_names

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pims/_config/dio.dart';
import 'package:pims/_config/services.dart';
import 'package:pims/_router/main.dart';
import 'package:pims/pages/member/explore/detail/main.dart';
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
    description: 'Bill Payment',
    icon: 'assets/icons/mandiri.png',
    fee: 7000,
  ),
  PaymentData(
    id: 'bri',
    type: 'bank_transfer',
    name: 'bri',
    label: 'BRI',
    description: 'Virtual account',
    icon: 'assets/icons/bri.png',
    fee: 7000,
  ),
  PaymentData(
    id: 'permata',
    type: 'bank_transfer',
    name: 'permata',
    label: 'Permata',
    description: 'Virtual account',
    icon: 'assets/icons/permata.png',
    fee: 7000,
  ),
  PaymentData(
    id: 'cimb',
    type: 'bank_transfer',
    name: 'cimb',
    label: 'CIMB',
    description: 'Virtual account',
    icon: 'assets/icons/cimb.png',
    fee: 7000,
  ),
  PaymentData(
    id: 'danamon',
    type: 'bank_transfer',
    name: 'danamon',
    label: 'Danamon',
    description: 'Virtual account',
    icon: 'assets/icons/danamon.png',
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

Future memberTransaction() async {
  final paymentController = Get.put(PaymentController());
  final detailMemberController = Get.put(MemberExploreDetailController());
  final selectedPayment = paymentController.selectedPayment.value;
  final detailMember = detailMemberController.detailPackage.value;

  final params = {
    'member_id': detailMember?['id'],
    'payment_id': selectedPayment?.name,
    'total_fee': detailMember?['fee'],
    'duration': detailMember?['duration'],
  };

  try {
    final api = await API().post('transaction/member', data: params);
    if (api.data?['status'] == 'success') {
      Future.delayed(Duration(milliseconds: 200), () {
        final redirectParams = {
          'id': api.data?['data']?['id'].toString() ?? '',
          // 'status': 'unpaid',
          'origin': 'confirm',
        };
        Get.rootDelegate.toNamed(
          '$homeRoute/member/detail',
          parameters: redirectParams,
        );
      });
    }
  } catch (e) {
    //
  }
}

Future visitTransaction() async {
  final paymentController = Get.put(PaymentController());
  final visitController = Get.put(VisitAppController());

  final config = await API().get('/global/config');
  final memberAPI = await API().get('order/check/member/visit');
  final membership = memberAPI.data;
  final isMember = membership?['isMember'] ?? false;

  final visit_fee = membership?['visit'] != null
      ? (membership?['visit']?['fee'] ?? 0)
      : config.data?['visit_fee'];

  final selectedVoucher = paymentController.selectedVoucher.value;
  final selectedPayment = paymentController.selectedPayment.value;
  final app_fee = isMember ? 0 : (config.data?['app_fee'] ?? 0);
  final visitTime = visitController.selectedTime.value;
  final visitTimeInterval = config.data?['visit_time_interval'] ?? 0;
  final end_date = visitTime?.add(Duration(minutes: visitTimeInterval));

  final service_fee = isMember ? 0 : (selectedPayment?.fee ?? 0);
  final total_fee =
      (visit_fee + service_fee + app_fee) - (selectedVoucher?['value'] ?? 0);

  bool memberBypass = isMember && total_fee == 0;

  final params = {
    'user_type': isMember ? 2 : 1,
    'payment_id': selectedPayment?.name,
    'service_id': 1,
    'product_fee': visit_fee,
    'service_fee': service_fee,
    'app_fee': app_fee,
    'discount_fee': selectedVoucher?['value'] ?? 0,
    'voucher_id': selectedVoucher?['id'],
    'total_fee': total_fee,
    'start_date': visitTime?.toString(),
    'end_date': end_date?.toString(),
    'status': memberBypass ? 2 : 1,
  };

  // await Future.delayed(Duration(seconds: 1));

  // visitTime?.toUtc().toString()
  // if (false) {
  try {
    final api = await API().post('transaction/visit', data: params);
    if (api.data?['status'] == 'success') {
      await Future.delayed(Duration(milliseconds: 200), () {
        final redirectParams = {
          'id': api.data?['data']?['id'].toString() ?? '',
          'status': memberBypass ? 'active' : 'unpaid',
          'provider': (selectedPayment?.name).toString(),
          'origin': 'confirm',
        };
        Get.rootDelegate.toNamed('/order/detail', parameters: redirectParams);
      });
    }
  } catch (e) {
    //
  }
  // }
}

Future classTransaction(dynamic detailClass) async {
  final paymentController = Get.put(PaymentController());
  final config = await API().get('/global/config');
  final memberAPI = await API().get('order/check/member/visit');
  final membership = memberAPI.data;
  final isMember = membership?['isMember'] ?? false;

  final member_class = detailClass?['member_class'];

  final selectedVoucher = paymentController.selectedVoucher.value;
  final selectedPayment = paymentController.selectedPayment.value;
  final app_fee = isMember ? 0 : (config.data?['app_fee'] ?? 0);
  final thisService = classesList.firstWhereOrNull(
      (item) => item.name == Get.rootDelegate.parameters['type']);

  final product_fee =
      isMember ? (member_class?['fee'] ?? 0) : (detailClass?['fee'] ?? 0);
  String? start_date, end_date;
  if (detailClass?['start_date'] != null) {
    start_date = DateFormat('yyyy-MM-dd HH:mm')
        .format(DateTime.parse(detailClass?['start_date']).toLocal());
  }
  if (detailClass?['end_date'] != null) {
    end_date = DateFormat('yyyy-MM-dd HH:mm')
        .format(DateTime.parse(detailClass?['end_date']).toLocal());
  }

  final service_fee = isMember ? 0 : (selectedPayment?.fee ?? 0);
  final total_fee =
      (product_fee + service_fee + app_fee) - (selectedVoucher?['value'] ?? 0);

  bool memberBypass = isMember && total_fee == 0;

  final params = {
    'class_schedule_id': detailClass?['id'],
    'user_type': isMember ? 2 : 1,
    'payment_id': selectedPayment?.name,
    'service_id': thisService?.type ?? 2,
    'product_fee': product_fee,
    'service_fee': service_fee,
    'app_fee': app_fee,
    'discount_fee': selectedVoucher?['value'] ?? 0,
    'voucher_id': selectedVoucher?['id'],
    'total_fee': total_fee,
    'start_date': start_date,
    'end_date': end_date,
    'status': memberBypass ? 2 : 1,
  };

  // await Future.delayed(Duration(seconds: 1));

  // if (false) {
  try {
    final api = await API().post('transaction/class', data: params);
    if (api.data?['status'] == 'success') {
      await Future.delayed(Duration(milliseconds: 200), () {
        final redirectParams = {
          'id': api.data?['data']?['id'].toString() ?? '',
          'status': memberBypass ? 'active' : 'unpaid',
          'provider': (selectedPayment?.name).toString(),
          'origin': 'confirm',
        };
        Get.rootDelegate.toNamed('/order/detail', parameters: redirectParams);
      });
    }
  } catch (e) {
    //
  }
  // }
}
