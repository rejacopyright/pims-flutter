import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pims/pages/classes/main.dart';
import 'package:pims/pages/classes/select_class.dart';

class SelectDaysController extends GetxController {
  RxBool pageIsReady = false.obs;

  @override
  void onReady() {
    pageIsReady.value = true;
    super.onReady();
  }

  @override
  void refresh() {
    pageIsReady.value = false;
    Future.delayed(Duration(milliseconds: 100), () {
      onReady();
    });
    super.refresh();
  }
}

class SelectDays extends StatelessWidget {
  const SelectDays({super.key, this.isCollapsed = false});
  final bool isCollapsed;

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    final selectDaysController = Get.put(SelectDaysController());
    final selectClassController = Get.put(SelectClassController());
    final classController = Get.put(ClassAppController());
    final days = List.generate(30, (i) {
      return DateTime.now().add(Duration(days: i));
    });
    return Obx(() {
      final pageIsReady = selectDaysController.pageIsReady.value;
      final selectedDate = classController.selectedDate.value;
      if (pageIsReady) {
        return Container(
          constraints: BoxConstraints(maxHeight: 100),
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: 10),
            scrollDirection: Axis.horizontal,
            children: days.map((e) {
              final thisDate = DateTime(e.year, e.month, e.day);
              final selected = DateTime(
                  selectedDate.year, selectedDate.month, selectedDate.day);
              final isSelected = selected == thisDate;
              final now = DateTime.now();
              final isToday =
                  DateTime(now.year, now.month, now.day) == thisDate;
              return Column(
                children: [
                  Container(
                    padding: EdgeInsets.only(top: 5),
                    child: Text(
                      isToday ? 'Today' : DateFormat('E').format(e),
                      style: TextStyle(
                        color: isSelected
                            ? isCollapsed
                                ? primaryColor
                                : Colors.white
                            : isCollapsed
                                ? Colors.black
                                : Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 11,
                      ),
                    ),
                  ),
                  Container(
                    width: 52.5,
                    height: 52.5,
                    padding:
                        EdgeInsets.symmetric(horizontal: 7.5, vertical: 7.5),
                    child: Material(
                      color: isSelected ? primaryColor : Colors.white,
                      clipBehavior: Clip.antiAlias,
                      shadowColor: Colors.black.withValues(alpha: 0.25),
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                        side: BorderSide(
                          color: isCollapsed
                              ? Colors.black.withValues(alpha: 0.1)
                              : Colors.white,
                          width: 0.75,
                        ),
                      ),
                      child: InkWell(
                        splashFactory: InkSplash.splashFactory,
                        highlightColor: Colors.transparent,
                        onTap: () {
                          if (!isSelected) {
                            selectClassController.onInit();
                            classController.setSelectedDate(e);
                          }
                        },
                        child: Center(
                          child: Text(
                            DateFormat('dd').format(e),
                            style: TextStyle(
                              color: isSelected ? Colors.white : primaryColor,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Text(
                    DateFormat('MMM').format(e),
                    style: TextStyle(
                      color: isSelected
                          ? isCollapsed
                              ? primaryColor
                              : Colors.white
                          : isCollapsed
                              ? Colors.black
                              : Colors.white,
                      fontSize: 10,
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
        );
      }
      return Container(
        margin: EdgeInsets.symmetric(horizontal: 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(
            5,
            (index) => Container(
              width: 65,
              height: 65,
              margin: EdgeInsets.symmetric(vertical: 30),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(50),
              ),
            ),
          ),
        ),
      );
    });
  }
}
