import 'package:flutter/material.dart';
import 'package:pims/_widgets/button.dart';
import 'package:pims/_widgets/helper.dart';

class ProgramBookingState {
  String title;
  String? category;
  String? image;
  int? price;
  String? userImage;
  String userName;
  ProgramBookingState({
    required this.title,
    this.category,
    this.image,
    this.price,
    this.userImage,
    required this.userName,
  });
}

class ProgramBookingCard extends StatelessWidget {
  const ProgramBookingCard({
    super.key,
    required this.crossAxisCount,
    required this.item,
  });

  final int crossAxisCount;
  final ProgramBookingState item;

  @override
  Widget build(BuildContext context) {
    late Color primaryColor = Theme.of(context).primaryColor;
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(7.5),
      clipBehavior: Clip.antiAlias,
      shadowColor: Colors.black.withOpacity(0.5),
      elevation: 3.5,
      child: LinkWell(
        to: '/product/detail',
        params: {'satu': 'Hello 1', 'dua': 'Hello 2'},
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
                        image: AssetImage(
                          item.image ?? 'assets/images/no-image.png',
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                    const Positioned(
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
                        padding: const EdgeInsets.only(
                          left: 7.5,
                          right: 7.5,
                          top: 1.5,
                          bottom: 0,
                        ),
                        decoration: BoxDecoration(
                          color: primaryColor,
                          borderRadius: BorderRadius.circular(3.5),
                        ),
                        child: Text(
                          '2/10',
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: const TextStyle(
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
                  padding: const EdgeInsets.only(
                      left: 10, right: 5, top: 2.5, bottom: 5),
                  child: Text(
                    item.title,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(left: 10, right: 5),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        clipBehavior: Clip.antiAlias,
                        margin: const EdgeInsets.only(right: 7),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                        ),
                        width: 17.5,
                        height: 17.5,
                        child: Image.asset(
                          item.userImage ?? 'assets/avatar/user.png',
                          fit: BoxFit.cover,
                          opacity: AlwaysStoppedAnimation(
                              item.userImage != null ? 1 : 0.25),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          item.userName,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: const TextStyle(
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
            item.price != null
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.symmetric(
                          vertical: 5,
                          horizontal: 10,
                        ),
                        child: Row(
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
                                              fontSize: 16,
                                            ),
                                          )
                                        : const SizedBox.shrink(),
                                  ],
                                ),
                              ),
                              Container(
                                constraints: BoxConstraints(
                                  maxWidth: (MediaQuery.of(context).size.width /
                                          crossAxisCount) -
                                      50,
                                ),
                                padding: const EdgeInsets.only(
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
                                  'assets/icons/gender.png',
                                  height: 17.5,
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ]),
                      ),
                    ],
                  )
                : const SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}