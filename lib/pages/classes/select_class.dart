import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pims/_widgets/program_booking_card.dart';

import 'main.dart';

class SelectClassController extends ClassAppController {}

class SelectClass extends StatelessWidget {
  const SelectClass({super.key, this.params});
  final Map<String, String>? params;

  final int crossAxisCount = 2;

  @override
  Widget build(BuildContext context) {
    final classController = Get.put(SelectClassController());
    List<ProgramBookingState> programData = [
      ProgramBookingState(
        title: 'Progressive Overload Strength & Conditioning by Reja Jamil',
        category: 'Fungsional',
        image: 'assets/images/sample/jujutsu.jpg',
        price: 100000,
        userImage: 'assets/avatar/1.png',
        userName: 'Reja Jamil',
      ),
      ProgramBookingState(
        title: 'Tai Chi',
        category: 'Studio',
        image: 'assets/images/sample/taichi.jpg',
        price: 150000,
        userImage: 'assets/avatar/2.png',
        userName: 'Reja Jamil',
      ),
      ProgramBookingState(
        title: 'Karate',
        category: 'Fungsional',
        image: 'assets/images/sample/karate.jpg',
        price: 100000,
        userImage: 'assets/avatar/3.png',
        userName: 'Reja Jamil',
      ),
      ProgramBookingState(
        title: 'Muay Thai',
        category: 'Studio',
        image: 'assets/images/sample/muaythai.jpg',
        price: 25000,
        userImage: 'assets/avatar/4.png',
        userName: 'Reja Jamil',
      ),
      ProgramBookingState(
        title: 'Kung Fu',
        category: 'Fungsional',
        image: 'assets/images/sample/kungfu.jpg',
        price: 35000,
        userImage: 'assets/avatar/5.png',
        userName: 'Reja Jamil',
      ),
      ProgramBookingState(
        title: 'Taekwondo',
        category: 'Studio',
        image: 'assets/images/sample/taekwondo.jpg',
        price: 3000000,
        userImage: 'assets/avatar/6.png',
        userName: 'Reja Jamil',
      ),
    ];

    return Obx(() {
      final pageIsReady = classController.pageIsReady.value;
      return GridView.count(
        clipBehavior: Clip.antiAlias,
        childAspectRatio: pageIsReady ? 0.65 : 1,
        crossAxisCount: crossAxisCount,
        padding: EdgeInsets.only(top: 0, bottom: 15, left: 15, right: 15),
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        // controller:
        //     ScrollController(keepScrollOffset: false),
        scrollDirection: Axis.vertical,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        children: pageIsReady
            ? programData.map((item) {
                return ProgramBookingCard(
                  to: '/services/class/detail',
                  params: params,
                  item: item,
                  crossAxisCount: crossAxisCount,
                );
              }).toList()
            : List.generate(
                4,
                (index) => Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(7.5),
                  ),
                ),
              ),
      );
    });
  }
}
