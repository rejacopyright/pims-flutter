import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:pims/_widgets/button.dart';
import 'package:pims/_widgets/helper.dart';

class ProgramBookingState {
  String title;
  String? category;
  String? image;
  int? price;
  String? time;
  int? gender;
  int quota;
  int booked;
  String? trainerImage;
  String trainerName;
  ProgramBookingState({
    required this.title,
    this.category,
    this.image,
    this.price,
    this.time,
    this.gender,
    this.trainerImage,
    this.quota = 0,
    this.booked = 0,
    required this.trainerName,
  });
}

class ProgramBookingCard extends StatelessWidget {
  const ProgramBookingCard({
    super.key,
    required this.crossAxisCount,
    required this.item,
    required this.to,
    this.params,
  });

  final int crossAxisCount;
  final ProgramBookingState item;
  final String to;
  final Map<String, String>? params;

  @override
  Widget build(BuildContext context) {
    late Color primaryColor = Theme.of(context).primaryColor;

    final genders = {1: 'male', 2: 'female', 3: 'gender'};
    final gender = genders[item.gender];

    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(7.5),
      clipBehavior: Clip.antiAlias,
      shadowColor: Colors.black.withOpacity(0.5),
      elevation: 3.5,
      child: LinkWell(
        to: to,
        params: params,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      // height: (MediaQuery.of(context).size.width / crossAxisCount) - 40,
                      height: 135,
                      child: Ink.image(
                        image: item.image != null
                            ? NetworkImage(item.image as String)
                            : AssetImage('assets/images/no-image.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                      top: 5,
                      right: 5,
                      child: Icon(
                        Icons.photo_library,
                        size: 20,
                        color: Colors.white,
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        height: 75,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.white.withOpacity(0),
                              Colors.white.withOpacity(0.75),
                              Colors.white.withOpacity(1),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 5,
                      // left: 5,
                      right: 5,
                      child: Container(
                        constraints: BoxConstraints(
                          maxWidth: (MediaQuery.of(context).size.width /
                                  crossAxisCount) -
                              50,
                        ),
                        padding: EdgeInsets.only(
                          left: 7.5,
                          right: 7.5,
                          top: 1.5,
                          bottom: 0,
                        ),
                        decoration: BoxDecoration(
                          color: item.booked >= item.quota
                              ? Colors.red
                              : primaryColor,
                          borderRadius: BorderRadius.circular(3.5),
                        ),
                        child: Text(
                          '${item.booked}/${item.quota}',
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Container(
                  padding:
                      EdgeInsets.only(left: 10, right: 5, top: 2.5, bottom: 5),
                  child: Text(
                    item.title,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(left: 10, right: 5),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        clipBehavior: Clip.antiAlias,
                        margin: EdgeInsets.only(right: 7),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                        ),
                        width: 17.5,
                        height: 17.5,
                        child: Ink.image(
                          image: item.trainerImage != null
                              ? NetworkImage(item.trainerImage as String)
                              : AssetImage('assets/avatar/user.png'),
                          fit: BoxFit.cover,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          item.trainerName,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 7.5,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                        color: Color(0xfff5f5f5),
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(width: 1, color: Color(0xffdddddd))),
                    child: Wrap(
                      spacing: 5,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Icon(
                          Iconsax.clock5,
                          size: 14,
                          color: primaryColor,
                        ),
                        Text(
                          item.time ?? '',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.symmetric(
                    vertical: 5,
                    horizontal: 10,
                  ),
                  child: item.price != null
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                              FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Row(
                                  children: [
                                    Text(
                                      'Rp. ',
                                      style: TextStyle(
                                        color: primaryColor,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                      ),
                                    ),
                                    item.price != null
                                        ? Text(
                                            currency.format(item.price),
                                            style: TextStyle(
                                              color: primaryColor,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                            ),
                                          )
                                        : SizedBox.shrink(),
                                  ],
                                ),
                              ),
                              Container(
                                constraints: BoxConstraints(
                                  maxWidth: (MediaQuery.of(context).size.width /
                                          crossAxisCount) -
                                      50,
                                ),
                                padding: EdgeInsets.only(
                                  left: 7.5,
                                  right: 7.5,
                                  top: 1.5,
                                  bottom: 5,
                                ),
                                decoration: BoxDecoration(
                                  color: primaryColor.withOpacity(0.05),
                                  borderRadius: BorderRadius.circular(3.5),
                                ),
                                child: Image.asset(
                                  'assets/icons/$gender.png',
                                  height: 15,
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ])
                      : SizedBox.shrink(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
