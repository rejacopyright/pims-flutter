import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:pims/_widgets/button.dart';

GlobalKey memberExploreTabKey = GlobalKey();

class TrainerAppBar extends StatelessWidget implements PreferredSizeWidget {
  const TrainerAppBar({super.key});

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      shadowColor: Colors.black.withOpacity(0.25),
      elevation: 1,
      toolbarHeight: kToolbarHeight,
      automaticallyImplyLeading: false,
      surfaceTintColor: Colors.transparent,
      centerTitle: false,
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        centerTitle: false,
        background: HeaderBackgroundTrainer(),
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(bottom: 0),
                child: BackWell(
                  child: Wrap(
                    crossAxisAlignment: WrapCrossAlignment.start,
                    spacing: 10,
                    children: [
                      Material(
                        // color: Theme.of(context).primaryColor.withOpacity(0.1),
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(50),
                        clipBehavior: Clip.antiAlias,
                        child: Icon(
                          Iconsax.arrow_left,
                          color: Colors.white,
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Jadwal Saya',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 20,
                            ),
                          ),
                          Text(
                            'Dalam 30 hari yang akan datang',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class HeaderBackgroundTrainer extends StatelessWidget {
  const HeaderBackgroundTrainer({super.key});

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
                // primaryColor.withOpacity(0),
                primaryColor.withOpacity(0.5),
                primaryColor.withOpacity(0.75),
                primaryColor.withOpacity(0.85),
                primaryColor.withOpacity(1),
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