// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:pims/_config/dio.dart';
import 'package:pims/_widgets/button.dart';
import 'package:pims/_widgets/helper.dart';

import 'main.dart';
import 'payment.dart';

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
        return MemberExploreDetailPaymentCard();
      },
    );
  }
}

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
                        ? () async {
                            final api = await API().get('me');
                            final me = api.data;
                            final membership = me?['membership'];
                            bool isActiveMember = false;
                            if (membership?['end_date'] != null) {
                              final end_date =
                                  DateTime.parse(membership['end_date'])
                                      .toLocal();
                              isActiveMember = end_date.isAfter(DateTime.now());
                            }
                            if (context.mounted) {
                              if ([me?['nik'], me?['nik_file']]
                                  .contains(null)) {
                                showDialog(
                                  context: context,
                                  useSafeArea: true,
                                  barrierDismissible: true,
                                  builder: (context) {
                                    return Center(
                                      child: ModalRequiredNIK(),
                                    );
                                  },
                                );
                              } else if (isActiveMember) {
                                showDialog(
                                  context: context,
                                  useSafeArea: true,
                                  barrierDismissible: true,
                                  builder: (context) {
                                    return Center(
                                      child: ConfirmReplaceMember(
                                        onSubmit: () {
                                          BottomSheet.showPayment(context);
                                        },
                                      ),
                                    );
                                  },
                                );
                              } else {
                                BottomSheet.showPayment(context);
                              }
                            }
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

class ModalRequiredNIK extends StatelessWidget {
  const ModalRequiredNIK({super.key});

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
              Iconsax.info_circle5,
              color: Colors.orange,
              size: 35,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            margin: EdgeInsets.only(top: 10, bottom: 20),
            child: Text(
              'Untuk membeli member, kamu wajib mengisi NIK dan Upload KTP',
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
                    onPressed: () {
                      Get.rootDelegate.toNamed('/profile/edit');
                    },
                    style: TextButton.styleFrom(
                      elevation: 0,
                      overlayColor: Colors.black.withOpacity(0.25),
                      padding: EdgeInsets.symmetric(vertical: 20),
                      shape: RoundedRectangleBorder(),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: Text(
                      'Lengkapi Persyaratan',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.black,
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

class ConfirmReplaceMember extends StatelessWidget {
  const ConfirmReplaceMember({super.key, this.onSubmit});
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
              Iconsax.info_circle5,
              color: Colors.orange,
              size: 35,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            margin: EdgeInsets.only(top: 10, bottom: 20),
            child: Text(
              'Saat ini anda memiliki member yang aktif. Jika anda melakukan pembelian member baru, maka member yang sedang aktif akan terganti',
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
                      'Lanjutkan',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.black,
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
