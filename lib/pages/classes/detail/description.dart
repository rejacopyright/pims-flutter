// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:pims/_config/services.dart';

class ClassDetailDescriptionController extends GetxController {
  RxBool pageIsReady = true.obs;

  @override
  void onInit() {
    Future.delayed(Duration(milliseconds: 100), () async {
      pageIsReady.value = true;
    });
    super.onInit();
  }

  @override
  void refresh() {
    pageIsReady.value = false;
    Future.delayed(Duration(milliseconds: 200), () {
      onInit();
    });
    super.refresh();
  }
}

class ClassDetailDescription extends StatelessWidget {
  ClassDetailDescription({
    super.key,
    this.thisClass,
    required this.dataIsReady,
    this.start_date = '',
    this.start_time = '',
    this.end_time = '',
    this.trainer,
    this.gender = 3,
    this.title = '-',
    this.description = '-',
  });
  final ClassItem? thisClass;
  final bool dataIsReady;
  final String? start_date;
  final String? start_time;
  final String? end_time;
  final dynamic trainer;
  final int gender;
  final String title;
  final String description;

  final store = Get.put(ClassDetailDescriptionController());

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    final fullWidth = MediaQuery.of(context).size.width;
    final replacedImageFromDescription = description.replaceAllMapped(
      RegExp(r'(<img[^>]+)(height=)', caseSensitive: false),
      (match) => '${match.group(1)}_${match.group(1)}',
    );
    return Obx(() {
      final pageIsReady = store.pageIsReady.value;
      if (pageIsReady && dataIsReady) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 0, vertical: 15),
              decoration: BoxDecoration(
                // color: primaryColor.withOpacity(0.075),
                borderRadius: BorderRadius.circular(10),
              ),
              margin: EdgeInsets.only(bottom: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Wrap(
                    spacing: 5,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Icon(
                        Iconsax.calendar5,
                        size: 20,
                        color: primaryColor,
                      ),
                      Text(
                        start_date ?? '',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  Wrap(
                    spacing: 5,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Icon(
                        Iconsax.clock5,
                        size: 20,
                        color: Theme.of(context).primaryColor,
                      ),
                      Text(
                        '$start_time - $end_time',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(bottom: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    clipBehavior: Clip.antiAlias,
                    margin: EdgeInsets.only(right: 7.5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                    ),
                    width: 50,
                    height: 50,
                    child: Ink.image(
                      image: trainer?['avatar'] != null
                          ? NetworkImage(trainer['avatar'] as String)
                          : AssetImage('assets/avatar/user.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          trainer?['full_name'] ?? trainer?['username'] ?? '',
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          '${trainer?['username'] ?? ''} | ${trainer?['email'] ?? ''}',
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                              color: Color(0xff777777)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 10, bottom: 10),
              child:
                  ClassDesciptionBadges(thisClass: thisClass, gender: gender),
            ),
            Container(
              margin: EdgeInsets.only(top: 15, bottom: 15),
              // padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              // decoration: BoxDecoration(
              //   color: Color(0xfff5f5f5),
              //   borderRadius: BorderRadius.circular(5),
              // ),
              child: Text(
                title,
                textAlign: TextAlign.justify,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
            HtmlWidget(replacedImageFromDescription),
          ],
        );
      }
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(padding: EdgeInsets.only(top: 20)),
          Container(
            height: 15,
            width: fullWidth / 2,
            margin: EdgeInsets.only(bottom: 5),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.05),
              borderRadius: BorderRadius.circular(7.5),
            ),
          ),
          Container(
            height: 15,
            width: fullWidth / 3,
            margin: EdgeInsets.only(bottom: 5),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.05),
              borderRadius: BorderRadius.circular(7.5),
            ),
          ),
          Container(
            height: 50,
            width: fullWidth,
            margin: EdgeInsets.only(bottom: 5),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.05),
              borderRadius: BorderRadius.circular(7.5),
            ),
          ),
        ],
      );
    });
  }
}

class ClassDesciptionBadges extends StatelessWidget {
  const ClassDesciptionBadges({
    super.key,
    required this.thisClass,
    this.gender = 3,
  });

  final ClassItem? thisClass;
  final int gender;

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    final gendersIcon = {1: 'male', 2: 'female', 3: 'gender'};
    final gendersLabel = {1: 'Pria', 2: 'Wanita', 3: 'Campuran'};
    final genderIcon = gendersIcon[gender];
    final genderLabel = gendersLabel[gender];
    return Wrap(
      spacing: 10,
      children: [
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: 7.5,
            vertical: 5,
          ),
          // margin: EdgeInsets.only(top: 15, bottom: 20),
          decoration: BoxDecoration(
            color: primaryColor,
            borderRadius: BorderRadius.circular(5),
            border: Border.all(width: 1, color: primaryColor),
          ),
          child: Text(
            thisClass != null ? 'Kelas ${thisClass?.label}' : '',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: 7.5,
            vertical: 5,
          ),
          // margin: EdgeInsets.only(top: 15, bottom: 20),
          decoration: BoxDecoration(
            color: primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(5),
            border: Border.all(width: 1, color: primaryColor),
          ),
          child: Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 5,
            children: [
              Image.asset(
                'assets/icons/$genderIcon.png',
                height: 18,
                fit: BoxFit.contain,
              ),
              Text(
                genderLabel ?? 'Campuran',
                style: TextStyle(
                  color: primaryColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: 7.5,
            vertical: 5,
          ),
          // margin: EdgeInsets.only(top: 15, bottom: 20),
          decoration: BoxDecoration(
            color: primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(5),
            border: Border.all(width: 1, color: primaryColor),
          ),
          child: Text(
            '2/10',
            style: TextStyle(
              color: primaryColor,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ),
      ],
    );
  }
}
