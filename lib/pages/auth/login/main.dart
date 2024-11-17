import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:pims/_widgets/button.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 50,
              width: 100,
              child: Material(
                color: Colors.green,
                child: InkWell(
                  splashFactory: InkSplash.splashFactory,
                  onTap: () {
                    final box = GetStorage();
                    box.write('token', 'abcEFG');
                  },
                  child: Center(child: Text('Login')),
                ),
              ),
            ),
            Padding(padding: EdgeInsets.only(bottom: 10)),
            SizedBox(
              height: 50,
              width: 100,
              child: Material(
                color: Colors.blue,
                child: LinkWell(
                  to: '/order',
                  child: Center(child: Text('Pesanan')),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
