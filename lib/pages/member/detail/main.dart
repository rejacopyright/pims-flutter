// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pims/_config/dio.dart';
import 'package:pims/_widgets/member_detail_cards.dart';
import 'package:pims/_widgets/order_detail_cards.dart';

import '../explore/item.dart';
import '../main.dart';
import 'appbar.dart';

class MemberDetailController extends GetxController {
  RxBool pageIsReady = false.obs;
  final data = Rxn<Map<String, dynamic>>();

  @override
  void onInit() {
    pageIsReady.value = false;
    Future.delayed(Duration(milliseconds: 200), () async {
      final params = Get.rootDelegate.parameters;
      try {
        if (params['id'] != null) {
          final api =
              await API().get('member/transaction/${params['id']}/detail');
          data.value = api.data;
        }
      } finally {
        pageIsReady.value = true;
      }
    });
    super.onInit();
  }

  @override
  void refresh() {
    pageIsReady.value = false;
    Future.delayed(Duration(milliseconds: 200), () {
      onInit();
    });
    super.refresh();
  }
}

class MemberDetailPage extends StatelessWidget {
  const MemberDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final state = Get.put(MemberDetailController());
    final memberController = Get.put(MemberController());
    memberController.onInit();
    final primaryColor = Theme.of(context).primaryColor;
    return Scaffold(
      appBar: MemberDetailAppBar(),
      body: RefreshIndicator(
        displacement: 30,
        color: primaryColor,
        onRefresh: () async {
          state.refresh();
        },
        child: Obx(() {
          final data = state.data.value;
          // VERIFY
          final status = data?['status'];
          final isUnpaid = status == 1;
          final isActive = status == 2;
          final isDone = status == 3;
          final isCancel = status == 4;

          final provider = data?['payment_id'] ?? '';

          DateTime expired_at;
          String expired_date = '???', expired_time = '???';
          if (data != null && data['purchase_expired'] != null) {
            expired_at = DateTime.parse(data['purchase_expired']).toLocal();
            expired_date = DateFormat('EEEE, d MMMM yyyy').format(expired_at);
            expired_time = DateFormat('HH.mm').format(expired_at);
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
                              MemberDetailPrice(
                                order_no: data?['order_no'] ?? '???',
                                total_fee: data?['fee'] ?? 0,
                              ),
                              OrderDetailPurchaseTime(
                                date: expired_date,
                                time: expired_time,
                              ),
                            ]
                          : [SizedBox.shrink()],
                    ),
                    Column(
                      children: isActive
                          ? [MemberDetailQR(), MemberDetailQuota()]
                          : [SizedBox.shrink()],
                    ),
                    Column(
                      children: isDone
                          ? [
                              MemberDetailPaymentMethod(provider: provider),
                              MemberDetailPrice(),
                            ]
                          : [SizedBox.shrink()],
                    ),
                    Container(
                      child:
                          isCancel ? MemberDetailCancel() : SizedBox.shrink(),
                    ),
                    MemberExploreItem(detail: data?['member']),
                    Container(
                      child:
                          isActive ? MemberDetailRefund() : SizedBox.shrink(),
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
