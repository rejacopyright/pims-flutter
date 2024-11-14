import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:iconsax/iconsax.dart';
import 'package:pims/_widgets/button.dart';
import 'package:pims/_widgets/helper.dart';

class PostState {
  String title;
  String? category;
  String? image;
  int? priceFrom;
  int? priceTo;
  String? duration;
  String? userImage;
  String userName;
  PostState({
    required this.title,
    this.category,
    this.image,
    this.priceFrom,
    this.priceTo,
    this.duration,
    this.userImage,
    required this.userName,
  });
}

class PostCard extends StatelessWidget {
  const PostCard({
    super.key,
    required this.crossAxisCount,
    required this.item,
  });

  final int crossAxisCount;
  final PostState item;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(7.5),
      clipBehavior: Clip.antiAlias,
      shadowColor: Colors.black.withOpacity(0.5),
      elevation: 3.5,
      child: LinkWell(
        to: '/home/product/detail',
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      height:
                          (MediaQuery.of(context).size.width / crossAxisCount) -
                              40,
                      child: Ink.image(
                        image: AssetImage(
                          item.image ?? 'assets/images/no-image.png',
                        ),
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
                          color: Colors.white.withOpacity(0.9),
                          borderRadius: BorderRadius.circular(3.5),
                        ),
                        child: Text(
                          item.category ?? 'Lainnya',
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: EdgeInsets.all(5),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        clipBehavior: Clip.antiAlias,
                        margin: EdgeInsets.only(right: 5),
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
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 5),
                  child: Text(
                    item.title,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    style: TextStyle(fontSize: 12),
                  ),
                ),
              ],
            ),
            item.priceFrom != null || item.priceTo != null
                ? Positioned(
                    left: 0,
                    right: 0,
                    bottom: 25,
                    child: Container(
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.only(left: 5, right: 10, top: 5),
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Row(
                          children: [
                            Text(
                              'Rp. ',
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                            item.priceFrom != null
                                ? Text(
                                    currency.format(item.priceFrom),
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                    ),
                                  )
                                : SizedBox.shrink(),
                            item.priceFrom != null && item.priceTo != null
                                ? Text(
                                    ' - ',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                    ),
                                  )
                                : SizedBox.shrink(),
                            item.priceTo != null
                                ? Text(
                                    currency.format(item.priceTo),
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                    ),
                                  )
                                : SizedBox.shrink(),
                            item.duration != null
                                ? Text(
                                    ' / ${item.duration}',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 11,
                                    ),
                                  )
                                : SizedBox.shrink(),
                          ],
                        ),
                      ),
                    ),
                  )
                : SizedBox.shrink(),
            Positioned(
              bottom: 5,
              left: 0,
              right: 5,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 5),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: RatingBarIndicator(
                        rating: Random().nextInt(5) + 2,
                        unratedColor: Color(0xffdddddd),
                        itemBuilder: (context, index) => Icon(
                          Icons.star,
                          color: Colors.amber,
                        ),
                        itemCount: 5,
                        itemSize: 12,
                        direction: Axis.horizontal,
                      ),
                    ),
                    Wrap(
                      spacing: 2,
                      children: [
                        Icon(Iconsax.heart5, size: 12, color: Colors.red),
                        Text(
                          '${((Random().nextDouble() * 9) + 1).toStringAsFixed(1)}K',
                          style: TextStyle(
                              fontSize: 10, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    Padding(padding: EdgeInsets.only(right: 10)),
                    Wrap(
                      spacing: 2,
                      children: [
                        Icon(Icons.check_circle, size: 12, color: Colors.green),
                        Text(
                          '${((Random().nextDouble() * 9) + 1).toStringAsFixed(1)}K',
                          style: TextStyle(
                              fontSize: 10, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
