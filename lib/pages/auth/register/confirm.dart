import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RegisterConfirmPage extends StatelessWidget {
  const RegisterConfirmPage({super.key});
  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    return Scaffold(
      // backgroundColor: Colors.white,
      appBar: AppBar(
        toolbarHeight: 0,
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                children: [
                  SizedBox(height: constraints.maxHeight * 0.05),
                  // Image.network(
                  //   "https://i.postimg.cc/nz0YBQcH/Logo-light.png",
                  //   height: 100,
                  // ),
                  Image.asset(
                    'assets/icons/logo.png',
                    height: 150,
                  ),
                  Text(
                    'PIMS',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                      color: primaryColor,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 75, left: 25, right: 25),
                    child: Text(
                      'Selamat datang di PIMS. Kami senang Anda telah memilih untuk bergabung dengan kami.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 30, horizontal: 25),
                    child: Text(
                      'Silahkan klik tombol LOGIN untuk menjelajahi penawaran eksklusif yang menarik.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                  // Padding(padding: EdgeInsets.only(bottom: 15)),
                  Container(
                    margin: EdgeInsets.only(top: 35),
                    padding: EdgeInsets.symmetric(horizontal: 50),
                    child: ElevatedButton(
                      onPressed: () {
                        Future.delayed(Duration(microseconds: 300), () {
                          Get.rootDelegate.offNamed('/login');
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        backgroundColor: primaryColor,
                        foregroundColor: Colors.white,
                        minimumSize: Size(double.infinity, 48),
                        shape: StadiumBorder(),
                      ),
                      child: Text(
                        'Ke Halaman Login',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
