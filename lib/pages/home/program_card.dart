import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pims/_widgets/program_card.dart';
import 'package:pims/pages/home/main.dart';

class ProgramSectionController extends HomepageController {}

class ProgramSection extends StatelessWidget {
  const ProgramSection({super.key});

  final int crossAxisCount = 2;

  @override
  Widget build(BuildContext context) {
    final store = Get.put(ProgramSectionController());
    List<ProgramState> programData = [
      ProgramState(
        title: 'Jiu Jitsu',
        category: 'Fungsional',
        image: 'assets/images/sample/jujutsu.jpg',
        price: 100000,
        userImage: 'assets/avatar/1.png',
        userName: 'Reja Jamil',
      ),
      ProgramState(
        title: 'Tai Chi',
        category: 'Studio',
        image: 'assets/images/sample/taichi.jpg',
        price: 150000,
        userImage: 'assets/avatar/2.png',
        userName: 'Reja Jamil',
      ),
      ProgramState(
        title: 'Karate',
        category: 'Fungsional',
        image: 'assets/images/sample/karate.jpg',
        price: 100000,
        userImage: 'assets/avatar/3.png',
        userName: 'Reja Jamil',
      ),
      ProgramState(
        title: 'Muay Thai',
        category: 'Studio',
        image: 'assets/images/sample/muaythai.jpg',
        price: 25000,
        userImage: 'assets/avatar/4.png',
        userName: 'Reja Jamil',
      ),
      ProgramState(
        title: 'Kung Fu',
        category: 'Fungsional',
        image: 'assets/images/sample/kungfu.jpg',
        price: 35000,
        userImage: 'assets/avatar/5.png',
        userName: 'Reja Jamil',
      ),
      ProgramState(
        title: 'Taekwondo',
        category: 'Studio',
        image: 'assets/images/sample/taekwondo.jpg',
        price: 3000000,
        userImage: 'assets/avatar/6.png',
        userName: 'Reja Jamil',
      ),
    ];

    return Obx(() {
      final pageIsReady = store.loadingPage.value;
      if (pageIsReady) {
        return NotificationListener<ScrollNotification>(
          onNotification: (e) {
            return true;
          },
          child: GridView.count(
            clipBehavior: Clip.antiAlias,
            childAspectRatio: 5 / 6,
            crossAxisCount: crossAxisCount,
            padding:
                const EdgeInsets.only(top: 0, bottom: 15, left: 15, right: 15),
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            // controller:
            //     ScrollController(keepScrollOffset: false),
            scrollDirection: Axis.vertical,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            children: programData.map((item) {
              return ProgramCard(item: item, crossAxisCount: crossAxisCount);
            }).toList(),
          ),
        );
      }
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          children: List.generate(
            2,
            (index) => Container(
              width: (MediaQuery.of(context).size.width / 2) - 20,
              height: 175,
              margin: const EdgeInsets.symmetric(horizontal: 5),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.05),
                borderRadius: BorderRadius.circular(7.5),
              ),
            ),
          ),
        ),
      );
    });
  }
}