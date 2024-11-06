import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:pims/_widgets/button.dart';

class VisitHeader extends StatelessWidget {
  const VisitHeader({super.key, required this.pageIsReady});
  final bool pageIsReady;

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      backgroundColor: Colors.white,
      shadowColor: Colors.black.withOpacity(0.25),
      elevation: 1,
      forceElevated: true,
      pinned: true,
      stretch: false,
      automaticallyImplyLeading: false,
      surfaceTintColor: Colors.transparent,
      centerTitle: false,
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(5),
        child: SizedBox.shrink(),
      ),
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: EdgeInsets.zero,
        centerTitle: false,
        title: Container(
          margin: const EdgeInsetsDirectional.only(bottom: 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Material(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                    side: BorderSide(
                      color: Colors.black.withOpacity(0),
                      width: 1,
                    ),
                  ),
                  color: Colors.black.withOpacity(0.05),
                  clipBehavior: Clip.antiAlias,
                  child: BackWell(
                    child: Container(
                      margin: EdgeInsets.only(bottom: 1),
                      width: 40,
                      height: 40,
                      child: Icon(
                        Iconsax.arrow_left_2,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 10),
                child: Text(
                  'Gym Visit',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class VisitAppBar extends StatelessWidget implements PreferredSizeWidget {
  const VisitAppBar({
    super.key,
  });

  @override
  Size get preferredSize => const Size.fromHeight(60);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leadingWidth: 65,
      titleSpacing: 5,
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.transparent,
      shadowColor: Colors.black.withOpacity(0.5),
      elevation: 1,
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(5),
        child: SizedBox.shrink(),
      ),
      leading: Container(
        padding: const EdgeInsets.all(7.5),
        margin: EdgeInsets.only(left: 10),
        child: Material(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
            side: BorderSide(
              color: Colors.black.withOpacity(0),
              width: 1,
            ),
          ),
          color: Colors.black.withOpacity(0.05),
          clipBehavior: Clip.antiAlias,
          child: BackWell(
            child: Container(
              margin: EdgeInsets.only(bottom: 1),
              width: 40,
              height: 40,
              child: Icon(
                Iconsax.arrow_left_2,
                color: Colors.black,
              ),
            ),
          ),
        ),
      ),
      title: Text(
        'Gym Visit',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
          color: Theme.of(context).primaryColor,
        ),
      ),
    );
  }
}
