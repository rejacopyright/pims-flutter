import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pims/pages/visit/main.dart';
import 'package:pims/pages/visit/select_days.dart';

class SelectTimesController extends VisitAppController {}

class SelectTimes extends StatelessWidget {
  const SelectTimes({
    super.key,
    this.pageIsReady,
  });

  final dynamic pageIsReady;

  @override
  Widget build(BuildContext context) {
    final selectTimesController = Get.put(SelectTimesController());
    final selectDaysController = Get.put(SelectDaysController());
    final primaryColor = Theme.of(context).primaryColor;

    return Obx(() {
      final selectedDay = selectDaysController.selectedDate.value;
      final openHours = selectedDay.copyWith(hour: 6, minute: 0);
      final times = List.generate(32, (i) {
        return openHours.add(Duration(minutes: 30 * i));
      });
      final selectedValue = selectTimesController.selectedTime.value;
      final selectedTime = selectedValue != null
          ? DateTime(selectedValue.year, selectedValue.month, selectedValue.day,
              selectedValue.hour, selectedValue.minute)
          : null;
      final now = DateTime.now();
      return GridView.count(
        clipBehavior: Clip.antiAlias,
        childAspectRatio: 10 / 5,
        crossAxisCount: 4,
        padding: EdgeInsets.only(top: 0, bottom: 15, left: 0, right: 0),
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        // controller:
        //     ScrollController(keepScrollOffset: false),
        scrollDirection: Axis.vertical,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        children: times.map((item) {
          final thisTime =
              DateTime(item.year, item.month, item.day, item.hour, item.minute);
          final isSelected = selectedTime == thisTime;
          final isPastTime = now.isAfter(thisTime);
          return Material(
            color: isPastTime
                ? Color(0xfff5f5f5)
                : isSelected
                    ? primaryColor
                    : Colors.white,
            clipBehavior: Clip.antiAlias,
            shadowColor: Colors.black.withOpacity(0.25),
            elevation: isPastTime || !pageIsReady ? 0 : 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              side: BorderSide(
                color: Colors.black.withOpacity(0.1),
                width: isPastTime ? 0.5 : 0.75,
              ),
            ),
            child: pageIsReady
                ? InkWell(
                    splashFactory: InkSplash.splashFactory,
                    highlightColor: Colors.transparent,
                    onTap: () {
                      if (!isPastTime) {
                        selectTimesController
                            .setSelectedTime(isSelected ? null : item);
                      }
                    },
                    child: Center(
                      child: Text(
                        DateFormat('HH:mm').format(item),
                        style: TextStyle(
                          color: isPastTime
                              ? Colors.black.withOpacity(0.25)
                              : isSelected
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
