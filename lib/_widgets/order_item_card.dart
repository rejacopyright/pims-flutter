// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:pims/_config/dio.dart';
import 'package:pims/_config/services.dart';
import 'package:pims/_widgets/button.dart';
import 'package:pims/_widgets/helper.dart';

class OrderItem extends StatelessWidget {
  const OrderItem({super.key, this.params, this.data});
  final Map<String, String>? params;
  final Map<String, dynamic>? data;

  @override
  Widget build(BuildContext context) {
    String start_date = '???', start_time = '???', end_time = '???';
    if (data?['start_date'] != null) {
      start_date = DateFormat('EEEE, dd MMMM yyyy')
          .format(DateTime.parse(data?['start_date']).toLocal());
      start_time = DateFormat('HH:mm')
          .format(DateTime.parse(data?['start_date']).toLocal());
      end_time = DateFormat('HH:mm')
          .format(DateTime.parse(data?['end_date']).toLocal());
    }
    return Container(
      constraints: BoxConstraints(minHeight: 25),
      margin: EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          width: 1,
          color: Color(0xfffafafa),
        ),
      ),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        clipBehavior: Clip.antiAlias,
        shadowColor: Colors.black.withValues(alpha: 0.75),
        elevation: 1,
        child: LinkWell(
          to: '/order/detail',
          params: {
            ...(params ?? {}),
            'id': data?['id'] ?? '',
            'provider': data?['payment_id'] ?? '',
          },
          child: data?['service_id'] == 1
              ? VisitItem(
                  start_date: start_date,
                  start_time: start_time,
                  end_time: end_time,
                  fee: data?['total_fee'] ?? 0,
                )
              : ClassItem(data: data),
        ),
      ),
    );
  }
}

class ClassItem extends StatelessWidget {
  const ClassItem({super.key, this.data});
  final dynamic data;

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    final classType = classesList
        .firstWhere((item) => item.type == (data?['service_id'] ?? 2));
    String? image, trainerImage;
    final gallery = data?['class_schedule']?['class']?['class_gallery'];
    final trainer = data?['class_schedule']?['trainer'];
    if (gallery != null && gallery?.length > 0) {
      image = '$SERVER_URL/static/images/class/${gallery?[0]?['filename']}';
    }
    if (trainer?['avatar'] != null) {
      trainerImage = '$SERVER_URL/static/images/user/${trainer?['avatar']}';
    }

    final programName = data?['class_schedule']?['class']?['name'] ?? '-';
    final trainerName = trainer?['full_name'] ?? trainer?['username'] ?? '-';
    final fee = data?['total_fee'] ?? 0;

    String start_date = '???', start_time = '???', end_time = '???';
    if (data?['start_date'] != null) {
      start_date = DateFormat('EEEE, dd MMMM yyyy')
          .format(DateTime.parse(data?['start_date']).toLocal());
      start_time = DateFormat('HH:mm')
          .format(DateTime.parse(data?['start_date']).toLocal());
      end_time = DateFormat('HH:mm')
          .format(DateTime.parse(data?['end_date']).toLocal());
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          clipBehavior: Clip.antiAlias,
          margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
          ),
          width: 75,
          height: 75,
          child: Image(
            image: image != null
                ? NetworkImage(image)
                : AssetImage('assets/images/no-image.png'),
            fit: BoxFit.cover,
          ),
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(
              vertical: 10,
              horizontal: 5,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                    vertical: 5,
                    horizontal: 10,
                  ),
                  margin: EdgeInsets.only(bottom: 5),
                  decoration: BoxDecoration(
                    color: primaryColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Text(
                    'Kelas ${classType.label}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
                      fontSize: 11,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 5),
                  child: Text(
                    programName,
                    maxLines: 2,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 15),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        clipBehavior: Clip.antiAlias,
                        margin: EdgeInsets.only(right: 7),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                        ),
                        width: 16,
                        height: 16,
                        child: Image(
                          image: trainerImage != null
                              ? NetworkImage(trainerImage)
                              : AssetImage('assets/avatar/user.png'),
                          fit: BoxFit.cover,
                        ),
                      ),
                      Text(
                        trainerName,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 5),
                  child: Wrap(
                    spacing: 5,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Icon(
                        Iconsax.calendar5,
                        size: 13,
                        color: primaryColor,
                      ),
                      Text(
                        start_date,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: fee > 0 ? 10 : 0),
                  child: Wrap(
                    spacing: 5,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Icon(
                        Iconsax.clock5,
                        size: 13,
                        color: Theme.of(context).primaryColor,
                      ),
                      Text(
                        '$start_time - $end_time',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xff777777),
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
                fee > 0
                    ? Text(
                        'Rp. ${currency.format(fee)}',
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      )
                    : SizedBox.shrink(),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class VisitItem extends StatelessWidget {
  const VisitItem({
    super.key,
    this.start_date = '???',
    this.start_time = '???',
    this.end_time = '???',
    this.fee = 0,
  });
  final String start_date;
  final String start_time;
  final String end_time;
  final int fee;

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 50,
            height: 50,
            alignment: Alignment.center,
            padding: EdgeInsets.all(0),
            decoration: BoxDecoration(
              color: primaryColor.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(50),
              border: Border.all(
                width: 1,
                color: primaryColor.withValues(alpha: 0.5),
              ),
            ),
            child: Text(
              'VISIT',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: primaryColor,
                fontSize: 12,
              ),
            ),
          ),
          SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: EdgeInsets.only(bottom: 5),
                  child: Wrap(
                    spacing: 5,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Icon(
                        Iconsax.calendar5,
                        size: 14,
                        color: primaryColor,
                      ),
                      Text(
                        start_date,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                Wrap(
                  spacing: 5,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Icon(
                      Iconsax.clock5,
                      size: 14,
                      color: Color(0xffdddddd),
                    ),
                    Text(
                      '$start_time - $end_time',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xff777777),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: fee > 0 ? 10 : 0),
                fee > 0
                    ? Text(
                        'Rp. ${currency.format(fee)}',
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      )
                    : SizedBox.shrink(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class OrderItemLoader extends StatelessWidget {
  const OrderItemLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 100,
            width: 100,
            margin: EdgeInsets.only(right: 20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Color(0xfff5f5f5),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 10,
                  width: 100,
                  margin: EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Color(0xfff5f5f5),
                  ),
                ),
                Container(
                  height: 10,
                  width: 150,
                  margin: EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Color(0xfff5f5f5),
                  ),
                ),
                Container(
                  height: 35,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Color(0xfff5f5f5),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
