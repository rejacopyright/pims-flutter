// ignore_for_file: non_constant_identifier_names

import 'package:coupon_uikit/coupon_uikit.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:pims/_config/dio.dart';
import 'package:pims/_controller/payment_controller.dart';
import 'package:pims/_widgets/helper.dart';

class VoucherCardController extends GetxController {
  RxBool pageIsReady = true.obs;
  final data = Rxn<List>(null);
  RxInt count = 0.obs;
  setPageIsReady(e) => pageIsReady.value = e;

  @override
  void onInit() async {
    try {
      final api = await API().get('/voucher');
      data.value = api.data['data'] as List;
      count.value = api.data['total'];
    } catch (e) {
      // data.value = null;
    }
    pageIsReady.value = true;
    super.onInit();
  }

  @override
  void refresh() {
    pageIsReady.value = false;
    Future.delayed(Duration(milliseconds: 400), () {
      onInit();
    });
    super.refresh();
  }
}

class VoucherCard extends StatelessWidget {
  const VoucherCard({super.key});

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    final paymentController = Get.put(PaymentController());
    final state = Get.put(VoucherCardController());
    return Obx(() {
      final pageIsReady = state.pageIsReady.value;
      final dataIsNull = state.data.value == null;
      final data = state.data.value;
      return RefreshIndicator(
        color: Theme.of(context).primaryColor,
        displacement: 15,
        onRefresh: () async {
          state.refresh();
        },
        child: pageIsReady
            ? SizedBox(
                height: double.infinity,
                child: ListView(
                  // physics: ClampingScrollPhysics(),
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  shrinkWrap: true,
                  children: !dataIsNull
                      ? data!.map((item) {
                          final thisVoucherIsChecked = item?['id'] ==
                              paymentController.selectedVoucher.value?['id'];
                          final exp =
                              DateTime.parse(item['expired_at']).toLocal();
                          final diff = exp.difference(DateTime.now());
                          return InkWell(
                            splashColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            onTap: () {
                              paymentController.setSelectedVoucher(
                                  thisVoucherIsChecked ? null : item);
                            },
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 7.5),
                              child: CouponCard(
                                border: BorderSide(
                                  width: 1.5,
                                  color: thisVoucherIsChecked
                                      ? primaryColor
                                      : Color(0xffcccccc),
                                ),
                                height: 120,
                                curveAxis: Axis.vertical,
                                backgroundColor: Colors.white,
                                firstChild: Container(
                                  color: primaryColor.withValues(alpha: 0.5),
                                  child: DecoratedBox(
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.centerLeft,
                                        end: Alignment.centerRight,
                                        colors: [
                                          primaryColor.withValues(alpha: 1),
                                          primaryColor.withValues(alpha: 0.75),
                                          primaryColor.withValues(alpha: 0.25),
                                          // primaryColor.withValues(alpha: 0),
                                        ],
                                      ),
                                    ),
                                    child: Center(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            Iconsax.discount_shape5,
                                            color: Colors.amber.shade400,
                                            size: 30,
                                          ),
                                          Text(
                                            item['name'] ?? '',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                secondChild: Container(
                                  height: double.infinity,
                                  color: thisVoucherIsChecked
                                      ? primaryColor.withValues(alpha: 0.1)
                                      : Colors.white,
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Diskon',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(
                                              'Rp. ${currency.format(item['value'] ?? 0)}',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20,
                                              ),
                                            ),
                                            Text(
                                              item['title'] ?? '',
                                              style: TextStyle(fontSize: 12),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.only(top: 5),
                                              child: Wrap(
                                                children: [
                                                  Text(
                                                    'Sisa : ',
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                  Text(
                                                    '${diff.inDays} hari',
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 12,
                                                      color: Colors.red,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 15),
                                        child: Icon(
                                          Iconsax.tick_circle5,
                                          color: thisVoucherIsChecked
                                              ? primaryColor
                                              : Color(0xffdddddd),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        }).toList()
                      : [SizedBox.shrink()],
                ),
              )
            : Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                child: ListView.separated(
                    itemCount: 3,
                    shrinkWrap: true,
                    separatorBuilder: (ctx, index) =>
                        Padding(padding: EdgeInsets.only(bottom: 20)),
                    itemBuilder: (ctx, index) {
                      return Container(
                        height: 120,
                        decoration: BoxDecoration(
                          color: Color(0xfff5f5f5),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      );
                    }),
              ),
      );
    });
  }
}
