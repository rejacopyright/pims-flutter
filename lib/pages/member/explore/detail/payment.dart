import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pims/_controller/payment_controller.dart';
import 'package:pims/_widgets/helper.dart';
import 'package:pims/_widgets/payment/payment_card.dart';

import 'main.dart';

class MemberExploreDetailPaymentController extends GetxController {
  RxBool submitButtonIsLoading = false.obs;
  setSubmitButtonIsLoading(e) => submitButtonIsLoading.value = e;
}

class MemberExploreDetailPaymentCard extends StatelessWidget {
  const MemberExploreDetailPaymentCard({super.key});

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    final paymentController = Get.put(PaymentController());
    final state = Get.put(MemberExploreDetailPaymentController());
    final detailController = Get.put(MemberExploreDetailController());
    return Obx(() {
      final selectedPayment = paymentController.selectedPayment.value;
      final paymentIsSelected = selectedPayment != null;
      final submitButtonIsLoading = state.submitButtonIsLoading.value;
      final detail = detailController.detailPackage.value;
      final fee = detail?['fee'] ?? 0;
      return Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        clipBehavior: Clip.antiAlias,
        child: Ink(
          width: Get.width,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            children: [
              Container(
                height: 7.5,
                width: 75,
                margin: EdgeInsets.symmetric(
                  vertical: 20,
                ),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10,
                  ),
                  child: PaymentCard(),
                ),
              ),
              SafeArea(
                child: Container(
                  padding: EdgeInsets.only(
                    top: 20,
                    bottom: 15,
                    left: 20,
                    right: 20,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        offset: Offset(0, -5),
                        blurRadius: 5,
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        alignment: Alignment.center,
                        margin: EdgeInsets.only(bottom: 10),
                        child: Text(
                          'Rp. ${currency.format(fee)}',
                          style: TextStyle(
                            color: primaryColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: paymentIsSelected && !submitButtonIsLoading
                            ? () async {
                                state.setSubmitButtonIsLoading(true);
                                await memberTransaction();
                                state.setSubmitButtonIsLoading(false);
                              }
                            : null,
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          backgroundColor: primaryColor,
                          disabledBackgroundColor:
                              primaryColor.withValues(alpha: 0.25),
                          foregroundColor: Colors.white,
                          shadowColor: Colors.transparent,
                          minimumSize: Size(double.infinity, 48),
                          shape: StadiumBorder(),
                        ),
                        child: Container(
                          height: 50,
                          alignment: Alignment.center,
                          padding: EdgeInsets.symmetric(
                            horizontal: 10,
                          ),
                          child: Text(
                            submitButtonIsLoading ? 'Waiting...' : 'Bayar',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
