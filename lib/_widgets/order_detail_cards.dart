// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:pims/_controller/payment_controller.dart';
import 'package:pims/_widgets/helper.dart';

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
  const OrderDetailQR({super.key});

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
                  '0-241109-AGWRYDL',
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
            child: Image.asset(
              'assets/images/sample/qrcode.png',
              fit: BoxFit.cover,
              opacity: AlwaysStoppedAnimation(1),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: Text(
              'US7264HFHFD7746634HDBFH',
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
                            '13:00',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                            textAlign: TextAlign.end,
                          ),
                          Text(
                            '(18 Mei, 1992)',
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
                            '15:00',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Colors.red,
                            ),
                            textAlign: TextAlign.end,
                          ),
                          Text(
                            '(18 Mei, 1992)',
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
  const OrderDetailRefund({super.key});

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
              onTap: () async {},
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
              '18 Mei, 1992 (15:00)',
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

class OrderDetailPaymentMethod extends StatelessWidget {
  const OrderDetailPaymentMethod({
    super.key,
    required this.provider,
  });

  final String provider;

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
                      '18 Mei, 1992',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xffaaaaaa),
                      ),
                    ),
                    Text(
                      '(19:00)',
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
