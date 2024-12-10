// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pims/_config/dio.dart';
import 'package:pims/_widgets/order_detail_cards.dart';
import 'package:pims/_widgets/order_item_card.dart';
import 'package:pims/pages/order/detail/appbar.dart';

class OrderDetailPageController extends GetxController {
  final data = Rxn<Map<String, dynamic>>();

  @override
  void onInit() {
    Future.delayed(Duration(milliseconds: 200), () async {
      final params = Get.rootDelegate.parameters;
      try {
        if (params['id'] != null) {
          final api = await API().get('order/${params['id']}/detail');
          data.value = api.data;
        }
      } catch (e) {
        //
      }
    });
    super.onInit();
  }

  @override
  void onClose() {
    final lastHistory =
        Get.rootDelegate.history[Get.rootDelegate.history.length - 1];
    final currentPageName = lastHistory.currentPage?.name;
    if (currentPageName == '/order/detail') {
      Get.rootDelegate.popRoute();
    }
    super.onClose();
  }
}

class OrderDetailPage extends StatelessWidget {
  const OrderDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final state = Get.put(OrderDetailPageController());
    state.onInit();
    final primaryColor = Theme.of(context).primaryColor;
    final params = Get.rootDelegate.parameters;
    final status = params['status'];

    // VERIFY
    final isUnpaid = status != null && status == 'unpaid';
    final isActive = status != null && status == 'active';
    final isDone = status != null && status == 'done';
    final isCancel = status != null && status == 'cancel';
    return Scaffold(
      appBar: OrderDetailAppBar(),
      body: RefreshIndicator(
        displacement: 30,
        color: primaryColor,
        onRefresh: () async {
          state.onInit();
        },
        child: Obx(() {
          final data = state.data.value;
          final provider = data?['payment_id'] ?? '';

          DateTime expired_at;
          String expired_date = '???', expired_time = '???';
          if (data != null && data['purchase_expired'] != null) {
            expired_at = DateTime.parse(data['purchase_expired']).toLocal();
            expired_date = DateFormat('EEEE, d MMMM yyyy').format(expired_at);
            expired_time = DateFormat('HH.mm').format(expired_at);
          }

          String start_date = '???', start_time = '???', end_time = '???';
          if (data?['start_date'] != null) {
            start_date = DateFormat('EEEE, dd MMMM yyyy')
                .format(DateTime.parse(data?['start_date']).toLocal());
            start_time = DateFormat('HH:mm')
                .format(DateTime.parse(data?['start_date']).toLocal());
            end_time = DateFormat('HH:mm')
                .format(DateTime.parse(data?['end_date']).toLocal());
          }

          String purchase_date = '???', purchase_time = '???';
          if (data?['purchased_at'] != null) {
            purchase_date = DateFormat('EEEE, dd MMMM yyyy')
                .format(DateTime.parse(data?['purchased_at']).toLocal());
            purchase_time = DateFormat('HH:mm')
                .format(DateTime.parse(data?['purchased_at']).toLocal());
          }

          String valid_from_date = '???',
              valid_from_time = '???',
              valid_to_date = '???',
              valid_to_time = '???';
          if (data?['valid_from'] != null && data?['valid_to'] != null) {
            valid_from_date = DateFormat('EEEE, dd MMMM yyyy')
                .format(DateTime.parse(data?['valid_from']).toLocal());
            valid_from_time = DateFormat('HH:mm')
                .format(DateTime.parse(data?['valid_from']).toLocal());
            valid_to_date = DateFormat('EEEE, dd MMMM yyyy')
                .format(DateTime.parse(data?['valid_to']).toLocal());
            valid_to_time = DateFormat('HH:mm')
                .format(DateTime.parse(data?['valid_to']).toLocal());
          }

          bool cancelable = false;
          String cancelable_date = '???', cancelable_time = '???';
          if (data?['cancelable_until'] != null) {
            cancelable_date = DateFormat('EEEE, dd MMMM yyyy')
                .format(DateTime.parse(data?['cancelable_until']).toLocal());
            cancelable_time = DateFormat('HH:mm')
                .format(DateTime.parse(data?['cancelable_until']).toLocal());

            cancelable = DateTime.parse(data?['cancelable_until'])
                .toLocal()
                .isAfter(DateTime.now());
          }

          String cancel_date = '???',
              cancel_time = '???',
              cancel_reason = '???';
          if (data?['canceled_at'] != null) {
            cancel_date = DateFormat('EEEE, dd MMMM yyyy')
                .format(DateTime.parse(data?['canceled_at']).toLocal());
            cancel_time = DateFormat('HH:mm')
                .format(DateTime.parse(data?['canceled_at']).toLocal());
            cancel_reason = data?['cancel_reason'];
          }

          final va_number = data?['payment']?['va_numbers']?[0]?['va_number'];
          final biller_code = data?['payment']?['biller_code'];
          final bill_key = data?['payment']?['bill_key'];
          final permata_va_number = data?['payment']?['permata_va_number'];

          return ListView.builder(
            itemCount: 1,
            itemBuilder: (BuildContext context, int index) {
              return Padding(
                padding: EdgeInsets.only(left: 20, right: 20),
                child: Column(
                  children: [
                    Column(
                      children: isUnpaid
                          ? [
                              ['bca', 'bni', 'bri', 'cimb', 'danamon']
                                      .contains(provider)
                                  ? OrderDetailPaymentBank(
                                      provider: provider,
                                      account_no: va_number ?? '???',
                                    )
                                  : ['permata'].contains(provider)
                                      ? OrderDetailPaymentBank(
                                          provider: 'permata',
                                          account_no:
                                              permata_va_number ?? '???',
                                        )
                                      : ['mandiri'].contains(provider)
                                          ? OrderDetailMandiriBank(
                                              biller_code: biller_code ?? '???',
                                              bill_key: bill_key ?? '???',
                                            )
                                          : SizedBox.shrink(),
                              OrderDetailPurchaseTime(
                                date: expired_date,
                                time: expired_time,
                              ),
                              OrderDetailPrice(
                                order_no: data?['order_no'] ?? '???',
                                product_fee: data?['product_fee'] ?? 0,
                                discount_fee: data?['discount_fee'] ?? 0,
                                service_fee: data?['service_fee'] ?? 0,
                                total_fee: data?['total_fee'] ?? 0,
                              ),
                            ]
                          : [SizedBox.shrink()],
                    ),
                    Container(
                      child: isActive
                          ? OrderDetailQR(
                              id: data?['id'] ?? '',
                              order_no: data?['order_no'] ?? '???',
                              valid_from_date: valid_from_date,
                              valid_from_time: valid_from_time,
                              valid_to_date: valid_to_date,
                              valid_to_time: valid_to_time,
                            )
                          : SizedBox.shrink(),
                    ),
                    Column(
                      children: isDone
                          ? [
                              OrderDetailPaymentMethod(
                                provider: provider,
                                purchase_date: purchase_date,
                                purchase_time: purchase_time,
                              ),
                              OrderDetailPrice(
                                order_no: data?['order_no'] ?? '???',
                                product_fee: data?['product_fee'] ?? 0,
                                discount_fee: data?['discount_fee'] ?? 0,
                                service_fee: data?['service_fee'] ?? 0,
                                total_fee: data?['total_fee'] ?? 0,
                              ),
                            ]
                          : [SizedBox.shrink()],
                    ),
                    Container(
                      child: isCancel
                          ? OrderDetailCancel(
                              cancel_date: cancel_date,
                              cancel_time: cancel_time,
                              cancel_reason: cancel_reason,
                            )
                          : SizedBox.shrink(),
                    ),
                    // CARD ITEM
                    Container(
                      constraints: BoxConstraints(minHeight: 25),
                      margin: EdgeInsets.symmetric(vertical: 15),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          width: 1,
                          color: Color(0xfffafafa),
                        ),
                      ),
                      child: Material(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        clipBehavior: Clip.antiAlias,
                        shadowColor: Colors.black.withOpacity(0.75),
                        elevation: 1,
                        child: data?['service_id'] == 1
                            ? VisitItem(
                                start_date: start_date,
                                start_time: start_time,
                                end_time: end_time,
                                fee: data?['total_fee'] ?? 0,
                              )
                            : [2, 3].contains(data?['service_id'])
                                ? ClassItem(data: data)
                                : SizedBox.shrink(),
                      ),
                    ),
                    Container(
                      child: isActive && cancelable
                          ? OrderDetailRefund(
                              cancelable: cancelable,
                              cancelable_date: cancelable_date,
                              cancelable_time: cancelable_time,
                            )
                          : SizedBox.shrink(),
                    ),
                    Padding(padding: EdgeInsets.only(bottom: 50))
                  ],
                ),
              );
            },
          );
        }),
      ),
    );
  }
}
