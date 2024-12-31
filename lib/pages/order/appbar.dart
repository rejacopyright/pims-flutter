import 'package:flutter/material.dart';
import 'package:pims/pages/order/tabs.dart';

GlobalKey orderTabKey = GlobalKey();

class OrderAppBar extends StatelessWidget implements PreferredSizeWidget {
  const OrderAppBar({super.key});

  @override
  Size get preferredSize => Size.fromHeight(120);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      shadowColor: Colors.black.withValues(alpha: 0.25),
      elevation: 1,
      toolbarHeight: kToolbarHeight,
      automaticallyImplyLeading: false,
      surfaceTintColor: Colors.transparent,
      centerTitle: false,
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        centerTitle: false,
        background: HeaderBackgroundOrder(),
        title: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: EdgeInsets.only(top: 20, bottom: 10),
              child: Text(
                'Riwayat Pesanan',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
            ),
            OrderTabs(key: orderTabKey),
          ],
        ),
      ),
    );
  }
}

class HeaderBackgroundOrder extends StatelessWidget {
  const HeaderBackgroundOrder({super.key});

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    return Stack(
      fit: StackFit.expand,
      clipBehavior: Clip.antiAlias,
      children: [
        DecoratedBox(
          // decoration: BoxDecoration(
          //   color: Theme.of(context).primaryColor,
          // ),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                // primaryColor.withValues(alpha: 0),
                primaryColor.withValues(alpha: 0.5),
                primaryColor.withValues(alpha: 0.75),
                primaryColor.withValues(alpha: 0.85),
                primaryColor.withValues(alpha: 1),
              ],
            ),
          ),
        ),
        Positioned(
          right: -375,
          top: -50,
          bottom: -200,
          child: Transform.rotate(
            angle: 0.35,
            child: Image.asset(
              'assets/images/shape-2.png',
              fit: BoxFit.fitHeight,
              color: Colors.black,
              opacity: AlwaysStoppedAnimation(0.05),
            ),
          ),
        ),
        Positioned(
          right: -320,
          top: -30,
          bottom: -125,
          child: Transform.rotate(
            angle: 0.45,
            child: Image.asset(
              'assets/images/shape-2.png',
              fit: BoxFit.fitHeight,
              color: Colors.black,
              opacity: AlwaysStoppedAnimation(0.05),
            ),
          ),
        ),
      ],
    );
  }
}
