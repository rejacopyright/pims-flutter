import 'package:flutter/material.dart';

class NoData extends StatelessWidget {
  const NoData({super.key, this.text = 'Tidak ada data'});
  final String text;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.only(bottom: kBottomNavigationBarHeight * 2),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          // mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 75,
              height: 75,
              child: Image.asset(
                'assets/icons/package.png',
                opacity: AlwaysStoppedAnimation(0.5),
              ),
            ),
            SizedBox(height: 15),
            Text(
              text,
              style: TextStyle(
                color: Color(
                  0xffaaaaaa,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
