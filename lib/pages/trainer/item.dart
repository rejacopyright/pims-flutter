// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:pims/pages/classes/detail/description.dart';

class TrainerScheduleItem extends StatelessWidget {
  const TrainerScheduleItem({super.key, this.detail});
  final Map<String, dynamic>? detail;

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    final className = detail?['class']?['name'];
    // final className = 'Lorem Ipsum';
    final classImage = detail?['class']?['image'];
    List participant =
        ((detail?['transaction'] != null ? detail!['transaction'] : []) as List)
            .toList();
    final participantCount = participant.length;
    int quota = detail?['quota'] ?? 0;
    DateTime? start_date, end_date;
    String? startDate = '???', startTime = '???';
    int? duration = 0;
    if (detail?['start_date'] != null) {
      start_date = DateTime.parse(detail?['start_date']).toLocal();
      startDate = DateFormat('EEEE, dd MMMM yyyy').format(start_date);
      startTime = DateFormat('HH:mm').format(start_date);
    }
    if (detail?['end_date'] != null) {
      end_date = DateTime.parse(detail?['end_date']).toLocal();
    }
    if (start_date != null && end_date != null) {
      duration = end_date.difference(start_date).inMinutes;
    }

    return Container(
      width: double.infinity,
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
        shadowColor: Colors.black.withOpacity(0.75),
        elevation: 1,
        child: InkWell(
          splashFactory: InkSplash.splashFactory,
          highlightColor: Colors.transparent,
          onTap: participant.isNotEmpty
              ? () {
                  Modal.showListParticipant(context, participant);
                }
              : null,
          child: Padding(
            padding: EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: EdgeInsets.only(bottom: 7.5),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        margin: EdgeInsets.only(right: 10, top: 2.5),
                        clipBehavior: Clip.antiAlias,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Color(0xffdddddd)),
                        ),
                        child: classImage != null
                            ? Image(
                                fit: BoxFit.cover,
                                image: NetworkImage(classImage),
                                errorBuilder: (context, error, stackTrace) {
                                  return Icon(
                                    Iconsax.crown5,
                                    size: 14,
                                    color: Colors.orange.shade900,
                                  );
                                },
                              )
                            : Icon(
                                Iconsax.image,
                                size: 25,
                                color: Color(0xffaaaaaa),
                              ),
                      ),
                      SizedBox(width: 5),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(bottom: 5),
                              child: Text(
                                className ?? '???',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            Wrap(
                              spacing: 5,
                              crossAxisAlignment: WrapCrossAlignment.end,
                              children: [
                                Text(
                                  'Partisipan :',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xff777777),
                                  ),
                                ),
                                Wrap(
                                  spacing: 2.5,
                                  crossAxisAlignment: WrapCrossAlignment.end,
                                  children: [
                                    Text(
                                      participantCount.toString(),
                                      style: TextStyle(
                                        height: 1.2,
                                        fontWeight: FontWeight.bold,
                                        color: primaryColor,
                                        fontSize: 18,
                                      ),
                                    ),
                                    Text('/'),
                                    Text(
                                      quota.toString(),
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Wrap(
                              spacing: 5,
                              crossAxisAlignment: WrapCrossAlignment.end,
                              children: [
                                Text('Durasi :'),
                                Text(
                                  '$duration menit',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                Wrap(
                  spacing: 5,
                  crossAxisAlignment: WrapCrossAlignment.end,
                  children: [
                    Text('Tanggal :'),
                    Text(
                      startDate,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Wrap(
                  spacing: 5,
                  crossAxisAlignment: WrapCrossAlignment.end,
                  children: [
                    Text('Pukul :'),
                    Text(
                      startTime,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        height: 1.2,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: primaryColor,
                      ),
                    ),
                    Text('WIB', style: TextStyle(fontSize: 12, height: 1.75)),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class TrainerScheduleItemLoader extends StatelessWidget {
  const TrainerScheduleItemLoader({super.key});

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
