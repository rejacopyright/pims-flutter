import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:pims/_widgets/button.dart';
import 'package:pims/_widgets/navbar.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavbarWidget(name: '/profile'),
      extendBody: true,
      floatingActionButton: QRButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: Center(
        child: SizedBox(
          height: 50,
          width: 100,
          child: Material(
            color: Colors.red,
            child: InkWell(
              splashFactory: InkSplash.splashFactory,
              onTap: () {
                final box = GetStorage();
                box.remove('token');
              },
              child: Center(child: Text('Logout')),
            ),
          ),
        ),
      ),
    );
  }
}
