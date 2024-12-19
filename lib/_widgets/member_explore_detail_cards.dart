import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

class MemberExploreDetailFeatures extends StatelessWidget {
  const MemberExploreDetailFeatures({super.key, this.features = const []});
  final List features;

  @override
  Widget build(BuildContext context) {
    final headerColor = Color(0xfff5f5f5);
    final primaryColor = Theme.of(context).primaryColor;

    return features.isNotEmpty
        ? Container(
            width: double.infinity,
            margin: EdgeInsets.only(top: 10),
            child: Column(
              children: [
                Material(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                    side: const BorderSide(
                      color: Color(0xffeeeeee),
                      width: 1,
                    ),
                  ),
                  shadowColor: Colors.black.withOpacity(0.25),
                  elevation: 1,
                  clipBehavior: Clip.antiAlias,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: double.infinity,
                        alignment: Alignment.center,
                        height: 35,
                        decoration: BoxDecoration(color: Color(0xffeaeaea)),
                        child: Text(
                          'Fitur Member',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 0,
                          horizontal: 0,
                        ),
                        child: Table(
                          border: TableBorder.all(
                              width: 1, color: Color(0xffe5e5e5)),
                          defaultColumnWidth: FlexColumnWidth(),
                          columnWidths: {
                            0: IntrinsicColumnWidth(),
                          },
                          defaultVerticalAlignment:
                              TableCellVerticalAlignment.middle,
                          children: [
                            TableRow(
                              decoration: BoxDecoration(color: headerColor),
                              children: [
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                    vertical: 10,
                                    horizontal: 15,
                                  ),
                                  child: Text(
                                    'Fitur',
                                    softWrap: false,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                    vertical: 10,
                                    horizontal: 15,
                                  ),
                                  child: Text(
                                    'Kuota',
                                    // textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            ...features.map((item) {
                              return TableRow(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                      vertical: 10,
                                      horizontal: 15,
                                    ),
                                    child: Wrap(
                                      direction: Axis.vertical,
                                      children: [
                                        Text(
                                          item?['title'] ?? '',
                                          softWrap: false,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          item?['value'] ?? '',
                                          softWrap: false,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                            color: primaryColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                      vertical: 10,
                                      horizontal: 15,
                                    ),
                                    child: Text(
                                      item?['sub_title'] ?? '',
                                      // textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        // fontSize: 12,
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            }),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
        : SizedBox.shrink();
  }
}

class MemberExploreDetailDescription extends StatelessWidget {
  const MemberExploreDetailDescription({
    super.key,
    this.text,
    this.headerText,
    this.headerBackgroundColor = const Color(0xffeeeeee),
    this.headerTextColor = Colors.black,
  });
  final String? text;
  final String? headerText;
  final Color? headerBackgroundColor;
  final Color? headerTextColor;

  @override
  Widget build(BuildContext context) {
    final replacedImageFromDescription = (text ?? '').replaceAllMapped(
      RegExp(r'(<img[^>]+)(height=)', caseSensitive: false),
      (match) => '${match.group(1)}_${match.group(1)}',
    );
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(top: 15),
      child: Material(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
          side: const BorderSide(
            color: Color(0xffeeeeee),
            width: 1,
          ),
        ),
        shadowColor: Colors.black.withOpacity(0.25),
        elevation: 1,
        clipBehavior: Clip.antiAlias,
        child: Column(
          children: [
            Container(
              width: double.infinity,
              alignment: Alignment.center,
              height: 35,
              decoration: BoxDecoration(color: headerBackgroundColor),
              child: Text(
                headerText ?? 'Title',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: headerTextColor,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(15),
              child: Container(
                alignment: Alignment.topLeft,
                // child: Text(
                //   text ?? '',
                //   textAlign: TextAlign.justify,
                //   style: TextStyle(
                //     height: 1.75,
                //     fontSize: 16,
                //   ),
                // ),
                child: HtmlWidget(replacedImageFromDescription),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
