import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:pims/_widgets/button.dart';
import 'package:pims/_widgets/helper.dart';

import 'main.dart';
import 'payment.dart';

class MemberExploreDetailBottomNavController extends GetxController {
  RxBool tncIsChecked = false.obs;
  setTncIsChecked(e) => tncIsChecked.value = e;
}

class MemberExploreDetailBottomNav extends StatelessWidget {
  MemberExploreDetailBottomNav({super.key});

  final textFieldFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    final state = Get.put(MemberExploreDetailBottomNavController());
    final detailController = Get.put(MemberExploreDetailController());
    return Obx(() {
      final tncIsChecked = state.tncIsChecked.value;
      final detail = detailController.detailPackage.value;
      final fee = detail?['fee'] ?? 0;
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              alignment: Alignment.centerRight,
              margin: EdgeInsets.only(bottom: 5),
              child: ListTileTheme(
                horizontalTitleGap: 5,
                child: CheckboxListTile(
                  activeColor: primaryColor,
                  controlAffinity: ListTileControlAffinity.leading,
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    'Dengan membeli, kamu menyetujui Syarat & Ketentuan Member',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  value: tncIsChecked,
                  onChanged: (e) => state.setTncIsChecked(e),
                ),
              ),
            ),
            Container(
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.all(5),
              margin: EdgeInsets.only(bottom: 5),
              child: Text(
                'Rp. ${currency.format(fee)}',
                style: TextStyle(
                  color: primaryColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
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
                  child: ElevatedButton(
                    clipBehavior: Clip.antiAlias,
                    onPressed: tncIsChecked
                        ? () {
                            showModalBottomSheet(
                              useSafeArea: true,
                              isScrollControlled: true,
                              constraints: BoxConstraints(
                                minHeight: 100,
                                maxHeight: Get.height * 0.9,
                              ),
                              context: context,
                              builder: (context) {
                                return MemberExploreDetailPaymentCard();
                              },
                            );
                          }
                        : null,
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      backgroundColor: primaryColor,
                      disabledBackgroundColor: primaryColor.withOpacity(0.25),
                      foregroundColor: Colors.white,
                      shadowColor: Colors.transparent,
                      minimumSize: Size(double.infinity, 48),
                      shape: StadiumBorder(),
                    ),
                    child: Container(
                      alignment: Alignment.center,
                      height: 50,
                      child: Text(
                        'Beli Sekarang',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
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
