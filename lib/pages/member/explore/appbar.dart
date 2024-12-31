import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:pims/_widgets/button.dart';
import 'package:pims/_widgets/form.dart';

GlobalKey memberExploreTabKey = GlobalKey();

class MemberExploreAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const MemberExploreAppBar({super.key});

  @override
  Size get preferredSize => Size.fromHeight(100);

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
        background: HeaderBackgroundMemberExplore(),
        title: Padding(
          padding: EdgeInsets.only(bottom: 5),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(bottom: 15),
                  child: BackWell(
                    child: Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: 10,
                      children: [
                        Material(
                          // color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(50),
                          clipBehavior: Clip.antiAlias,
                          child: Icon(
                            Iconsax.arrow_left,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          'Jelajahi Member',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 20,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                SearchField(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class HeaderBackgroundMemberExplore extends StatelessWidget {
  const HeaderBackgroundMemberExplore({super.key});

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
