import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:pims/_widgets/button.dart';

class ProfileEditAppBar extends StatelessWidget implements PreferredSizeWidget {
  const ProfileEditAppBar({super.key});

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.transparent,
      shadowColor: Colors.black.withOpacity(0.25),
      elevation: 1,
      // automaticallyImplyLeading: false,
      // leadingWidth: 75,
      titleSpacing: 0,
      leading: Padding(
        padding: EdgeInsets.symmetric(horizontal: 7.5, vertical: 7.5),
        child: Material(
          color: Colors.white,
          borderRadius: BorderRadius.circular(50),
          clipBehavior: Clip.antiAlias,
          child: BackWell(child: Icon(Iconsax.arrow_left)),
        ),
      ),
      title: Text(
        'Update Profile',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
