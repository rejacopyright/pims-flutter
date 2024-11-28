// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:pims/_config/dio.dart';
import 'package:pims/_controller/payment_controller.dart';
import 'package:pims/_widgets/helper.dart';
import 'package:pims/pages/order/tabs.dart';
import 'package:qr_flutter/qr_flutter.dart';

class OrderDetailCardController extends GetxController {
  RxBool isCopied = false.obs;
  setCopied(e) => isCopied.value = e;
}

class OrderDetailPaymentBank extends StatelessWidget {
  const OrderDetailPaymentBank({
    super.key,
    required this.provider,
    required this.account_no,
  });
  final String provider;
  final String account_no;

  @override
  Widget build(BuildContext context) {
    final state = Get.put(OrderDetailCardController());
    final paymentController = Get.put(PaymentController());
    final primaryColor = Theme.of(context).primaryColor;
    return Obx(() {
      final paymentData = paymentController.paymentData.value;
      final payment =
          paymentData?.firstWhereOrNull((item) => item.name == provider);
      final isPayment = payment != null;
      final isCopied = state.isCopied.value;
      return Column(
        children: [
          Container(
            margin: EdgeInsets.only(top: 25),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
            ),
            height: isPayment ? 35 : 75,
            child: Image.asset(
              payment?.icon ?? 'assets/icons/no-image.png',
              fit: BoxFit.contain,
              opacity: AlwaysStoppedAnimation(1),
            ),
          ),
          Container(
            margin: EdgeInsetsDirectional.only(top: 10),
            alignment: Alignment.center,
            child: Text(
              'No. Virtual Account :',
              style: TextStyle(fontSize: 14),
            ),
          ),
          Container(
            margin: EdgeInsetsDirectional.only(top: 10),
            alignment: Alignment.center,
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                account_no,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Container(
            alignment: Alignment.center,
            margin: EdgeInsets.only(top: 15),
            child: Material(
              color: isCopied ? primaryColor : Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(7.5),
                side: const BorderSide(
                  color: Color(0xffdddddd),
                  width: 1,
                ),
              ),
              // elevation: 1,
              clipBehavior: Clip.antiAlias,
              child: InkWell(
                splashFactory: InkSplash.splashFactory,
                highlightColor: Colors.transparent,
                onTap: () async {
                  await state.setCopied(true);
                  await Clipboard.setData(
                    ClipboardData(text: account_no),
                  );
                  Future.delayed(Duration(milliseconds: 1500), () {
                    state.setCopied(false);
                  });
                },
                child: Padding(
                  padding: EdgeInsets.only(
                    top: 10,
                    bottom: 10,
                    left: 15,
                    right: 25,
                  ),
                  child: Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 10,
                    children: [
                      Icon(
                        Iconsax.copy5,
                        size: 18,
                        color: isCopied ? Colors.white : Colors.black,
                      ),
                      Text(
                        isCopied ? 'Tersalin' : 'Salin',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: isCopied ? Colors.white : Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    });
  }
}

class OrderDetailPurchaseTime extends StatelessWidget {
  const OrderDetailPurchaseTime(
      {super.key, this.date = '???', this.time = '???'});
  final String date;
  final String time;

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(top: 25),
      child: Material(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
          side: const BorderSide(
            color: Color(0xffeeeeee),
            width: 1,
          ),
        ),
        shadowColor: Colors.black.withOpacity(0.25),
        elevation: 1,
        clipBehavior: Clip.antiAlias,
        child: Column(
          children: [
            Container(
              width: double.infinity,
              alignment: Alignment.center,
              height: 35,
              decoration: BoxDecoration(
                color: Color(0xfff7f7f7),
                border: Border(
                  bottom: BorderSide(
                    width: 1,
                    color: Color(0xffdddddd),
                  ),
                ),
              ),
              child: Text(
                'Transfer Sebelum :',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsetsDirectional.only(
                top: 15,
                bottom: 15,
              ),
              child: Icon(
                Iconsax.clock,
                size: 35,
                color: primaryColor,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 5),
              child: Text(
                'Pukul $time WIB',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 15),
              child: Text(
                date,
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xff777777),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class OrderDetailPrice extends StatelessWidget {
  const OrderDetailPrice({
    super.key,
    this.order_no = '???',
    this.product_fee = 0,
    this.discount_fee = 0,
    this.service_fee = 0,
    this.total_fee = 0,
  });
  final String order_no;
  final int product_fee;
  final int discount_fee;
  final int service_fee;
  final int total_fee;

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(top: 25),
      child: Material(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
          side: const BorderSide(
            color: Color(0xffeeeeee),
            width: 1,
          ),
        ),
        shadowColor: Colors.black.withOpacity(0.25),
        elevation: 5,
        clipBehavior: Clip.antiAlias,
        child: Column(
          children: [
            Container(
              width: double.infinity,
              alignment: Alignment.center,
              height: 35,
              decoration: BoxDecoration(color: primaryColor),
              child: Text(
                'No. Pesanan: $order_no',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15, right: 15, top: 15),
              child: Table(
                // border: TableBorder.all(width: 1),
                // defaultColumnWidth: IntrinsicColumnWidth(),
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                children: [
                  TableRow(
                    children: [
                      Text(
                        'Sub Total :',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Rp. ${currency.format(product_fee)}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          height: 2,
                        ),
                        textAlign: TextAlign.end,
                      ),
                    ],
                  ),
                  TableRow(
                    children: discount_fee > 0
                        ? [
                            Text(
                              'Diskon :',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              '- Rp. ${currency.format(discount_fee)}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                height: 2,
                                color: Colors.red,
                              ),
                              textAlign: TextAlign.end,
                            ),
                          ]
                        : List.generate(2, (i) => SizedBox.shrink()),
                  ),
                  TableRow(
                    children: [
                      Text(
                        'Biaya layanan :',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Rp. ${currency.format(service_fee)}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          height: 2,
                        ),
                        textAlign: TextAlign.end,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Divider(height: 30, color: Color(0xffeeeeee)),
            Padding(
              padding: const EdgeInsets.only(left: 15, right: 15, bottom: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total :',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  Text(
                    'Rp. ${currency.format(total_fee)}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      height: 2,
                      color: primaryColor,
                    ),
                    textAlign: TextAlign.end,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class OrderDetailQR extends StatelessWidget {
  const OrderDetailQR({
    super.key,
    this.id = '',
    this.order_no = '???',
    this.valid_from_date = '???',
    this.valid_from_time = '???',
    this.valid_to_date = '???',
    this.valid_to_time = '???',
  });
  final String id;
  final String order_no;
  final String valid_from_date;
  final String valid_from_time;
  final String valid_to_date;
  final String valid_to_time;

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(top: 25),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 0),
            child: Column(
              children: [
                Text(
                  'No. Pesanan:',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                  ),
                ),
                Text(
                  order_no,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
          Container(
            clipBehavior: Clip.antiAlias,
            margin: EdgeInsets.only(left: 10, right: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
            ),
            width: Get.width * 0.75,
            height: Get.width * 0.75,
            child: QrImageView(
              data: id,
              version: QrVersions.auto,
              size: 100,
              gapless: true,
              embeddedImage: AssetImage('assets/icons/logo.png'),
              embeddedImageStyle: QrEmbeddedImageStyle(
                size: Size(Get.width * 0.2, Get.width * 0.2),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: Text(
              id,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          Material(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
              side: const BorderSide(
                color: Color(0xffeeeeee),
                width: 1,
              ),
            ),
            shadowColor: Colors.black.withOpacity(0.25),
            elevation: 5,
            clipBehavior: Clip.antiAlias,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  alignment: Alignment.center,
                  height: 35,
                  decoration: BoxDecoration(color: primaryColor),
                  child: Text(
                    'Masa Berlaku',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 15,
                    horizontal: 15,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Dapat digunakan pada :',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      Padding(padding: EdgeInsets.only(bottom: 5)),
                      Wrap(
                        spacing: 5,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          Text(
                            'Pukul:',
                            style: TextStyle(fontSize: 14),
                            textAlign: TextAlign.end,
                          ),
                          Text(
                            valid_from_time,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                            textAlign: TextAlign.end,
                          ),
                          Text(
                            '($valid_from_date)',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.end,
                          ),
                        ],
                      ),
                      Padding(padding: EdgeInsets.only(bottom: 20)),
                      Text(
                        'Berakhir pada :',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      Padding(padding: EdgeInsets.only(bottom: 5)),
                      Wrap(
                        spacing: 5,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          Text(
                            'Pukul:',
                            style: TextStyle(fontSize: 14),
                            textAlign: TextAlign.end,
                          ),
                          Text(
                            valid_to_time,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Colors.red,
                            ),
                            textAlign: TextAlign.end,
                          ),
                          Text(
                            '($valid_to_date)',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.red,
                            ),
                            textAlign: TextAlign.end,
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class OrderDetailRefund extends StatelessWidget {
  const OrderDetailRefund({
    super.key,
    this.cancelable = false,
    this.cancelable_date = '???',
    this.cancelable_time = '???',
  });
  final bool cancelable;
  final String cancelable_date;
  final String cancelable_time;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.only(top: 20, bottom: 10),
          width: double.infinity,
          height: 60,
          child: Material(
            color: Color(0xffeeeeee),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(7.5),
              side: const BorderSide(
                color: Color(0xffdddddd),
                width: 1,
              ),
            ),
            // elevation: 1,
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              splashFactory: InkSplash.splashFactory,
              highlightColor: Colors.transparent,
              onTap: () async {
                Get.dialog(
                  CancelFormWidget(),
                  useSafeArea: true,
                  barrierDismissible: true,
                );
              },
              child: Padding(
                padding: EdgeInsets.only(
                  top: 10,
                  bottom: 10,
                  left: 15,
                  right: 25,
                ),
                child: Wrap(
                  runAlignment: WrapAlignment.center,
                  alignment: WrapAlignment.center,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 10,
                  children: [
                    Icon(
                      Iconsax.close_circle5,
                      size: 20,
                      color: Color(0xffaaaaaa),
                    ),
                    Text(
                      'Batalkan Booking',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff777777),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        Column(
          children: [
            Text(
              'Pembatalan dapat dilakukan sampai',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Color(0xff999999),
              ),
              textAlign: TextAlign.center,
            ),
            Text(
              '$cancelable_date ($cancelable_time)',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                height: 2,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ],
    );
  }
}

class CancelFormController extends GetxController {
  RxString cancel_reason = ''.obs;
  RxBool cancelBtnIsLoading = false.obs;
  final errorMessage = Rxn<dynamic>(null);

  setCancelReason(e) => cancel_reason.value = e;

  registerFn() async {
    cancelBtnIsLoading.value = true;

    try {
      final thisGetParams = Get.rootDelegate.parameters;
      final id = thisGetParams['id'];
      final params = {
        'canceled_by': 2,
        'cancel_reason': cancel_reason.value,
      };

      final api =
          await API().post('order/${id.toString()}/cancel', data: params);
      errorMessage.value = null;
      if (api.data['status'] == 'success') {
        Future.delayed(Duration(milliseconds: 100), () {
          Get.rootDelegate.popRoute();
          final orderTabsController = Get.put(OrderTabsController());
          orderTabsController.controller.animateTo(3);
          // Get.rootDelegate.toNamed('/order', parameters: {'order_tab': 'cancel'});
          Get.rootDelegate.toNamed('/order');
        });
      }
    } catch (e) {
      dynamic err = e;
      // dynamic error = err?.response?.data['message'];
      dynamic error = err?.response?.data?['message']?['cancel_reason'] ??
          err?.error?.message;
      errorMessage.value = error;
    } finally {
      cancelBtnIsLoading.value = false;
    }
  }
}

class CancelFormWidget extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  CancelFormWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    final state = Get.put(CancelFormController());

    final outlineInputBorder = OutlineInputBorder(
      borderSide: BorderSide(color: Color(0xffdddddd)),
      borderRadius: BorderRadius.all(Radius.circular(7.5)),
    );
    final focusedBorder = outlineInputBorder.copyWith(
      borderSide: BorderSide(color: primaryColor),
    );
    final labelStyle = TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.bold,
    );
    return Obx(() {
      final cancelBtnIsLoading = state.cancelBtnIsLoading.value;
      final errorMessage = state.errorMessage.value.toString();
      return Center(
        child: Container(
          // height: 300,
          width: Get.width * 0.9,
          padding: EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 10),
                errorMessage != '' && errorMessage != 'null'
                    ? Container(
                        width: double.infinity,
                        alignment: Alignment.center,
                        margin: EdgeInsets.only(bottom: 15),
                        padding: EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: Colors.red.withOpacity(0.025),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            width: 1,
                            color: Colors.red.withOpacity(0.25),
                          ),
                        ),
                        child: Text(
                          errorMessage,
                          style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    : SizedBox.shrink(),
                TextFormField(
                  autofocus: true,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    hintText: 'Cth: Berubah pikiran',
                    labelText: 'Alasan Pembatalan',
                    labelStyle: labelStyle,
                    // floatingLabelBehavior: FloatingLabelBehavior.always,
                    hintStyle: TextStyle(color: Color(0xff777777)),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 24,
                    ),
                    border: outlineInputBorder,
                    enabledBorder: outlineInputBorder,
                    focusedBorder: focusedBorder,
                  ),
                  // keyboardType: TextInputType.name,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Alasan pembatalan wajib diisi';
                    }
                    return null;
                  },
                  onTapOutside: (e) {
                    _formKey.currentState!.validate();
                    FocusManager.instance.primaryFocus?.unfocus();
                  },
                  onChanged: (val) {
                    state.setCancelReason(val);
                  },
                ),
                Padding(padding: EdgeInsets.symmetric(vertical: 20)),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      state.registerFn();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    backgroundColor:
                        primaryColor.withOpacity(cancelBtnIsLoading ? 0.5 : 1),
                    foregroundColor: Colors.white,
                    minimumSize: Size(double.infinity, 48),
                    shape: StadiumBorder(),
                  ),
                  child: Text(
                    cancelBtnIsLoading ? 'Waiting...' : 'Batalkan Booking',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Get.rootDelegate.popRoute();
                  },
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    backgroundColor: Colors.white,
                    overlayColor: Color(0xffaaaaaa),
                    foregroundColor: Colors.black,
                    shadowColor: Colors.black.withOpacity(0.25),
                    minimumSize: Size(double.infinity, 48),
                    shape: StadiumBorder(
                      side: BorderSide(
                        width: 1,
                        color: Color(0xffdddddd),
                      ),
                    ),
                  ),
                  child: Text(
                    'Tutup',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}

class OrderDetailPaymentMethod extends StatelessWidget {
  const OrderDetailPaymentMethod({
    super.key,
    required this.provider,
    this.purchase_date = '???',
    this.purchase_time = '???',
  });

  final String provider;
  final String purchase_date;
  final String purchase_time;

  @override
  Widget build(BuildContext context) {
    final paymentController = Get.put(PaymentController());
    return Obx(() {
      final paymentData = paymentController.paymentData.value;
      final payment =
          paymentData?.firstWhereOrNull((item) => item.name == provider);
      final isPayment = payment != null;
      return Container(
        width: double.infinity,
        margin: EdgeInsets.only(top: 25),
        child: Material(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
            side: const BorderSide(
              color: Color(0xffeeeeee),
              width: 1,
            ),
          ),
          shadowColor: Colors.black.withOpacity(0.25),
          elevation: 1,
          clipBehavior: Clip.antiAlias,
          child: Column(
            children: [
              Container(
                width: double.infinity,
                alignment: Alignment.center,
                height: 35,
                decoration: BoxDecoration(
                  color: Color(0xfff7f7f7),
                  border: Border(
                    bottom: BorderSide(
                      width: 1,
                      color: Color(0xffdddddd),
                    ),
                  ),
                ),
                child: Text(
                  'Dibayar Melalui :',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 15),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                ),
                height: isPayment ? 35 : 75,
                child: Image.asset(
                  payment?.icon ?? 'assets/icons/no-image.png',
                  fit: BoxFit.contain,
                  opacity: AlwaysStoppedAnimation(1),
                ),
              ),
              Container(
                margin: EdgeInsetsDirectional.only(top: 10, bottom: 5),
                alignment: Alignment.center,
                child: Text(
                  'Virtual Account',
                  style: TextStyle(fontSize: 14),
                ),
              ),
              Divider(height: 15, color: Color(0xffeeeeee)),
              Padding(
                padding: const EdgeInsets.only(left: 15, right: 15, bottom: 10),
                child: Wrap(
                  spacing: 5,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text(
                      purchase_date,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xffaaaaaa),
                      ),
                    ),
                    Text(
                      '($purchase_time)',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xffaaaaaa),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      );
    });
  }
}

class OrderDetailCancel extends StatelessWidget {
  const OrderDetailCancel({
    super.key,
    this.cancel_date = '???',
    this.cancel_time = '???',
    this.cancel_reason = '???',
  });
  final String cancel_date;
  final String cancel_time;
  final String cancel_reason;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(top: 25),
      child: Material(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
          side: const BorderSide(
            color: Color(0xffeeeeee),
            width: 1,
          ),
        ),
        shadowColor: Colors.black.withOpacity(0.25),
        elevation: 5,
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              alignment: Alignment.center,
              height: 35,
              decoration: BoxDecoration(color: Color(0xffeaeaea)),
              child: Text(
                'Dibatalkan',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xffaaaaaa),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 15,
                horizontal: 15,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Dibatalkan pada :',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  Padding(padding: EdgeInsets.only(bottom: 5)),
                  Wrap(
                    spacing: 5,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Text(
                        'Pukul:',
                        style: TextStyle(fontSize: 14),
                        textAlign: TextAlign.end,
                      ),
                      Text(
                        cancel_time,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                        textAlign: TextAlign.end,
                      ),
                      Text(
                        '($cancel_date)',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.end,
                      ),
                    ],
                  ),
                  Padding(padding: EdgeInsets.only(bottom: 20)),
                  Text(
                    'Alasan pembatalan :',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  Padding(padding: EdgeInsets.only(bottom: 5)),
                  Text(
                    cancel_reason,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
