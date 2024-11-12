import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:pims/_widgets/button.dart';

class ClassPaymentBottomNav extends StatelessWidget {
  ClassPaymentBottomNav({super.key});

  final textFieldFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    return SafeArea(
      child: Container(
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
        child: Row(
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
                child: LinkWell(
                  to: '/services/class/detail/payment',
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
      ),
    );
  }
}
