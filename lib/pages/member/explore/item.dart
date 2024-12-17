import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:pims/_router/main.dart';
import 'package:pims/_widgets/button.dart';
import 'package:pims/_widgets/helper.dart';

class MemberExploreItem extends StatelessWidget {
  const MemberExploreItem({super.key, this.detail});
  final Map<String, dynamic>? detail;

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    final durationInMonths = ((detail?['duration'] ?? 0) / 30).round();
    List features = detail?['member_features'] != null &&
            detail?['member_features']?.length > 0
        ? detail!['member_features'].toList()
        : [];
    final mapFeatures = features.map((item) {
      return {'value': item?['value'] ?? '', 'title': item?['title'] ?? ''};
    }).toList();

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
        child: LinkWell(
          to: '$homeRoute/member/explore/detail',
          params: detail?['id'] != null ? {'id': detail?['id']} : {},
          child: Padding(
            padding: EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: EdgeInsets.only(bottom: 7.5),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        // padding:
                        //     EdgeInsets.all(detail?['badge'] != null ? 2.5 : 5),
                        margin: EdgeInsets.only(right: 10, bottom: 2.5),
                        decoration: BoxDecoration(
                          // color: Colors.amberAccent.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(50),
                          // border: Border.all(color: Colors.amber),
                        ),
                        child: detail?['badge'] != null
                            ? Image(
                                width: 40,
                                image: NetworkImage(detail?['badge']),
                                errorBuilder: (context, error, stackTrace) {
                                  return Icon(
                                    Iconsax.crown5,
                                    size: 14,
                                    color: Colors.orange.shade900,
                                  );
                                },
                              )
                            : Icon(
                                Iconsax.crown5,
                                size: 30,
                                color: Colors.orange.shade900,
                              ),
                      ),
                      SizedBox(width: 5),
                      Expanded(
                        child: Text(
                          detail?['name'] ?? 'Member Package',
                          maxLines: 2,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                ListView.builder(
                  itemCount: mapFeatures.length,
                  shrinkWrap: true,
                  padding:
                      EdgeInsets.only(bottom: mapFeatures.isNotEmpty ? 10 : 5),
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return Wrap(
                      spacing: 5,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Container(
                          clipBehavior: Clip.none,
                          width: 15,
                          height: 20,
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              Positioned(
                                left: -15,
                                right: 0,
                                top: 0,
                                bottom: 0,
                                child: Icon(
                                  Iconsax.tick_circle5,
                                  size: 16,
                                  color: primaryColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          mapFeatures[index]['value'],
                          style: TextStyle(
                            color: Color(0xffaaaaaa),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          mapFeatures[index]['title'],
                          style: TextStyle(
                            color: Color(0xffaaaaaa),
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      ],
                    );
                  },
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 10),
                  child: Wrap(
                    spacing: 5,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Text('Masa Berlaku :'),
                      Text(
                        '$durationInMonths bulan',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                Wrap(
                  spacing: detail?['fee_before'] != null ? 10 : 0,
                  children: [
                    detail?['fee_before'] != null &&
                            detail?['fee_before'] > detail?['fee']
                        ? Text(
                            'Rp. ${currency.format(detail?['fee_before'] ?? 0)}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.black.withOpacity(0.25),
                              fontStyle: FontStyle.italic,
                              decoration: TextDecoration.lineThrough,
                            ),
                          )
                        : SizedBox.shrink(),
                    Text(
                      'Rp. ${currency.format(detail?['fee'] ?? 0)}',
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: primaryColor,
                      ),
                    ),
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

class MemberExploreItemLoader extends StatelessWidget {
  const MemberExploreItemLoader({super.key});

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
