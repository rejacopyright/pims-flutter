// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:pims/_controller/payment_controller.dart';
import 'package:pims/_widgets/button.dart';
// import 'package:pims/_widgets/payment/voucher_section.dart';
import 'package:pims/pages/classes/detail/payment.dart';

import 'main.dart';

class BottomSheet {
  static void showPayment(context) {
    // Size size = MediaQuery.of(context).size;
    showModalBottomSheet(
      useSafeArea: true,
      isScrollControlled: true,
      constraints: BoxConstraints(
        minHeight: 100,
        maxHeight: Get.height * 0.9,
      ),
      context: context,
      builder: (context) {
        return BookingClassPaymentCard();
      },
    );
  }
}

class ClassBottomNavController extends GetxController {
  RxBool submitMemberButtonIsLoading = false.obs;
  setSubmitMemberButtonIsLoading(e) => submitMemberButtonIsLoading.value = e;
}

class ClassBottomNav extends StatelessWidget {
  ClassBottomNav({super.key});

  final textFieldFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    final classDetailController = Get.put(ClassDetailController());
    final state = Get.put(ClassBottomNavController());
    return Obx(() {
      final detailClass = classDetailController.detailClass.value;
      final isMember = detailClass?['isMember'];
      final member_class = detailClass?['member_class'];
      final member_class_fee = member_class?['fee'] ?? 0;

      final submitMemberButtonIsLoading =
          state.submitMemberButtonIsLoading.value;
      return Container(
        width: Get.width,
        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              offset: Offset(0, -5),
              blurRadius: 5,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Container(
            //   margin: EdgeInsets.only(bottom: 15),
            //   decoration: BoxDecoration(
            //     border: Border(
            //       bottom: BorderSide(width: 1, color: Color(0xffeeeeee)),
            //     ),
            //   ),
            //   child: VoucherSection(),
            // ),
            Row(
              children: [
                Expanded(
                  child: Material(
                    borderRadius: BorderRadius.circular(10),
                    clipBehavior: Clip.antiAlias,
                    color: Colors.white,
                    child: BackWell(
                      child: Container(
                        alignment: Alignment.center,
                        height: 50,
                        child: Wrap(
                          crossAxisAlignment: WrapCrossAlignment.center,
                          spacing: 10,
                          children: [
                            Icon(
                              Iconsax.arrow_left,
                              color: Color(0xffaaaaaa),
                              size: 20,
                            ),
                            Text(
                              'Kembali',
                              style: TextStyle(
                                fontSize: 16,
                                color: Color(0xffaaaaaa),
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 15),
                Expanded(
                  child: Material(
                    borderRadius: BorderRadius.circular(10),
                    clipBehavior: Clip.antiAlias,
                    color: primaryColor,
                    child: InkWell(
                      splashFactory: InkSplash.splashFactory,
                      highlightColor: Colors.transparent,
                      onTap: isMember && member_class_fee == 0
                          ? () {
                              showDialog(
                                context: context,
                                useSafeArea: true,
                                barrierDismissible: true,
                                builder: (context) {
                                  return Center(
                                    child: ConfirmBooking(
                                      submitIsLoading:
                                          submitMemberButtonIsLoading,
                                      onSubmit: () async {
                                        if (!submitMemberButtonIsLoading) {
                                          state.setSubmitMemberButtonIsLoading(
                                              true);
                                          await classTransaction(detailClass);
                                          state.setSubmitMemberButtonIsLoading(
                                              false);
                                        }
                                      },
                                    ),
                                  );
                                },
                              );
                            }
                          : () {
                              BottomSheet.showPayment(context);
                            },
                      child: Container(
                        alignment: Alignment.center,
                        height: 50,
                        child: Text(
                          'Booking',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    });
  }
}

class ConfirmBooking extends StatelessWidget {
  const ConfirmBooking(
      {super.key, this.submitIsLoading = false, this.onSubmit});
  final bool submitIsLoading;
  final Function()? onSubmit;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width - 120,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 25),
            child: Icon(
              Iconsax.tick_circle,
              color: Theme.of(context).primaryColor,
              size: 35,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            margin: EdgeInsets.only(top: 10, bottom: 20),
            child: Text(
              'Klik tombol booking untuk melanjutkan',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
          ),
          Container(
            // padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              border: Border(top: BorderSide(color: Color(0xffdddddd))),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => Get.rootDelegate.popRoute(),
                    style: TextButton.styleFrom(
                      elevation: 0,
                      overlayColor: Colors.black.withOpacity(0.25),
                      padding: EdgeInsets.symmetric(vertical: 20),
                      shape: RoundedRectangleBorder(),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: Text(
                      'Tutup',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 30,
                  child: VerticalDivider(
                    width: 1,
                    indent: 0,
                    endIndent: 0,
                    color: Color(0xffdddddd),
                  ),
                ),
                Expanded(
                  child: TextButton(
                    onPressed: () {
                      onSubmit!();
                    },
                    style: TextButton.styleFrom(
                      elevation: 0,
                      overlayColor: Colors.black.withOpacity(0.25),
                      padding: EdgeInsets.symmetric(vertical: 20),
                      shape: RoundedRectangleBorder(),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: Text(
                      submitIsLoading ? 'Waiting...' : 'Booking',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color:
                            submitIsLoading ? Color(0xffaaaaaa) : Colors.black,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class ClassBottomNavFullQuota extends StatelessWidget {
  const ClassBottomNavFullQuota({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width,
      padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            offset: Offset(0, -5),
            blurRadius: 5,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Wrap(
            alignment: WrapAlignment.center,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 5,
            children: [
              Icon(
                Iconsax.info_circle5,
                color: Color(0xffdddddd),
              ),
              Text(
                'Kuota sudah penuh',
                style: TextStyle(
                  fontSize: 16,
                  height: 3,
                  color: Color(0xffaaaaaa),
                ),
              ),
            ],
          ),
          Material(
            borderRadius: BorderRadius.circular(10),
            clipBehavior: Clip.antiAlias,
            color: Colors.white,
            child: BackWell(
              child: Container(
                alignment: Alignment.center,
                height: 50,
                width: Get.width / 2,
                child: Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 10,
                  children: [
                    Icon(
                      Iconsax.arrow_left,
                      color: Color(0xffaaaaaa),
                      size: 20,
                    ),
                    Text(
                      'Kembali',
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xffaaaaaa),
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ClassBottomNavIsBookedByMe extends StatelessWidget {
  const ClassBottomNavIsBookedByMe({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width,
      padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            offset: Offset(0, -5),
            blurRadius: 5,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Wrap(
            alignment: WrapAlignment.center,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 5,
            children: [
              Icon(
                Iconsax.info_circle5,
                color: Color(0xffdddddd),
              ),
              Text(
                'Kamu sudah booking kelas ini',
                style: TextStyle(
                  fontSize: 16,
                  height: 3,
                  color: Color(0xffaaaaaa),
                ),
              ),
            ],
          ),
          Material(
            borderRadius: BorderRadius.circular(10),
            clipBehavior: Clip.antiAlias,
            color: Colors.white,
            child: BackWell(
              child: Container(
                alignment: Alignment.center,
                height: 50,
                width: Get.width / 2,
                child: Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 10,
                  children: [
                    Icon(
                      Iconsax.arrow_left,
                      color: Color(0xffaaaaaa),
                      size: 20,
                    ),
                    Text(
                      'Kembali',
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xffaaaaaa),
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
