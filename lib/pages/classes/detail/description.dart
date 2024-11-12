import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:pims/_config/services.dart';
import 'package:pims/pages/classes/detail/main.dart';

class ClassDetailDescriptionController extends ClassDetailController {}

class ClassDetailDescription extends StatelessWidget {
  ClassDetailDescription({super.key, this.thisClass});
  final ClassItem? thisClass;

  final store = Get.put(ClassDetailDescriptionController());

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    final fullWidth = MediaQuery.of(context).size.width;
    return Obx(() {
      final pageIsReady = store.pageIsReady.value;
      if (pageIsReady) {
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
                        'Senin, 18 Mei 1992',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
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
                        '06:00 - 7:30',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
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
                    child: Image.asset(
                      'assets/avatar/5.png',
                      fit: BoxFit.cover,
                      opacity: AlwaysStoppedAnimation(1),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Reja Jamil',
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          'Instruktur balap renang',
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
              padding: const EdgeInsets.only(top: 10, bottom: 10),
              child: ClassDesciptionBadges(thisClass: thisClass),
            ),
            Container(
              margin: EdgeInsets.only(top: 15, bottom: 15),
              // padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              // decoration: BoxDecoration(
              //   color: Color(0xfff5f5f5),
              //   borderRadius: BorderRadius.circular(5),
              // ),
              child: Text(
                'Progressive Overload Strength & Conditioning (Not Air Conditioner) by Reja Jamil',
                textAlign: TextAlign.justify,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
            Text(
              'Karate adalah seni bela diri yang berasal dari Jepang. Seni bela diri ini sedikit dipengaruhi oleh seni bela diri Cina, Kempo. Karate dibawa masuk ke Jepang lewat Okinawa dan mulai berkembang di Ryukyu Islands. Seni bela diri ini pertama kali disebut Tote yang berarti seperti Tinju China. Ketika karate masuk ke Jepang, nasionalisme Jepang pada saat itu sedang tinggi-tingginya, sehingga Sensei Gichin Funakoshi mengubah kanji Okinawa (Tote: Tinju China) dalam kanji Jepang menjadi karate (tangan kosong) agar lebih mudah diterima oleh masyarakat Jepang. Karate terdiri dari atas dua kanji. Yang pertama adalah Kara dan berarti kosong. Dan yang kedua, te, berarti tangan. Yang dua kanji bersama artinya tangan kosong',
              textAlign: TextAlign.justify,
              style: TextStyle(
                height: 2,
                fontSize: 15,
              ),
            ),
          ],
        );
      }
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
  });

  final ClassItem? thisClass;

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
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
                'assets/icons/gender.png',
                height: 18,
                fit: BoxFit.contain,
              ),
              Text(
                'Campuran',
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
