import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'main.dart';

class SelectClassController extends ClassAppController {}

class SelectClass extends StatelessWidget {
  const SelectClass({
    super.key,
    this.pageIsReady,
  });

  final dynamic pageIsReady;

  @override
  Widget build(BuildContext context) {
    final selectClassController = Get.put(SelectClassController());
    final primaryColor = Theme.of(context).primaryColor;

    return Obx(() {
      final classes = List.generate(32, (i) {
        return i.toString();
      });
      final selectedClass = selectClassController.selectedClass.value;
      return GridView.count(
        clipBehavior: Clip.antiAlias,
        childAspectRatio: 10 / 5,
        crossAxisCount: 4,
        padding: const EdgeInsets.only(top: 0, bottom: 15, left: 0, right: 0),
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        // controller: ScrollController(keepScrollOffset: false),
        scrollDirection: Axis.vertical,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        children: classes.map((item) {
          final isSelected = selectedClass == item;
          return Material(
            color: isSelected ? primaryColor : Colors.white,
            clipBehavior: Clip.antiAlias,
            shadowColor: Colors.black.withOpacity(0.25),
            elevation: !pageIsReady ? 0 : 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              side: BorderSide(
                color: Colors.black.withOpacity(0.1),
                width: 0.75,
              ),
            ),
            child: pageIsReady
                ? InkWell(
                    splashFactory: InkSplash.splashFactory,
                    highlightColor: Colors.transparent,
                    onTap: () {
                      selectClassController
                          .setSelectedClass(isSelected ? null : item);
                    },
                    child: Center(
                      child: Text(
                        'Kelas $item',
                        style: TextStyle(
                          color: isSelected
                              ? Colors.white
                              : Colors.black.withOpacity(0.5),
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  )
                : Container(color: Color(0xfffafafa)),
          );
        }).toList(),
      );
    });
  }
}
