import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:pims/_widgets/button.dart';
import 'package:pims/_widgets/payment/voucher_section.dart';
import 'package:pims/pages/classes/detail/payment.dart';

class ClassBottomNav extends StatelessWidget {
  ClassBottomNav({super.key});

  final textFieldFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
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
          Container(
            margin: EdgeInsets.only(bottom: 15),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(width: 1, color: Color(0xffeeeeee)),
              ),
            ),
            child: VoucherSection(),
          ),
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
                    onTap: () {
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
