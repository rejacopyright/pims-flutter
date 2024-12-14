import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class TitleShowAll extends StatelessWidget {
  final String? title;
  final String? showMore;
  final String? path;
  final EdgeInsetsGeometry? margin;

  const TitleShowAll({
    super.key,
    this.title,
    this.showMore,
    this.path,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    final Color primary = Theme.of(context).primaryColor;
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.only(left: 15, right: 10),
      margin: margin ?? EdgeInsets.symmetric(vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title ?? 'Title',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          InkWell(
            onTap: () {},
            borderRadius: BorderRadius.circular(5),
            child: Container(
              padding: EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 5),
              // margin: EdgeInsets.only(top: 3),
              child: Wrap(
                spacing: 2,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Text(
                    showMore ?? 'Selengkapnya',
                    style: TextStyle(
                      color: primary,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  Icon(Iconsax.arrow_right_3, size: 12, color: primary),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
