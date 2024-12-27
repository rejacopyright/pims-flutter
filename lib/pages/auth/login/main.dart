import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:iconsax/iconsax.dart';
import 'package:pims/_config/dio.dart';
import 'package:pims/_router/main.dart';

class LoginController extends GetxController {
  RxString username = ''.obs;
  RxString password = ''.obs;
  final errorMessage = Rxn<String>();
  RxBool showPassword = false.obs;
  RxBool signinBtnIsLoading = false.obs;

  setUsername(e) => username.value = e;
  setPassword(e) => password.value = e;
  setShowPassword(e) => showPassword.value = e;

  loginFn() async {
    signinBtnIsLoading.value = true;
    try {
      final api = await API().post('auth/login',
          data: {'username': username.value, 'password': password.value});
      final box = GetStorage();
      await box.write('token', api.data['token']);
      await box.write('refresh_token', api.data['refresh_token']);
      await box.write('user', api.data['user']);
      await box.write('exp', api.data['exp']);
      errorMessage.value = '';
      Get.rootDelegate.toNamed(homeRoute);
    } catch (e) {
      dynamic err = e;
      // dynamic error = err?.response?.data['message'];
      dynamic error = err?.response?.data?['message'];
      errorMessage.value = error;
    } finally {
      signinBtnIsLoading.value = false;
    }
  }
}

class LoginPage extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();

  LoginPage({super.key});
  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    final state = Get.put(LoginController());
    return Scaffold(
      // backgroundColor: Colors.white,
      appBar: AppBar(
        toolbarHeight: 0,
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
      ),
      body: Obx(() {
        final errorMessage = state.errorMessage.value;
        final signinBtnIsLoading = state.signinBtnIsLoading.value;
        final showPassword = state.showPassword.value;
        return SafeArea(
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
                    Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Text(
                          'PIMS',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 30,
                            color: primaryColor,
                          ),
                        ),
                        SizedBox(
                          height: 15,
                          child: VerticalDivider(
                            color: Color(0xffcccccc),
                            indent: 1,
                            endIndent: 1,
                          ),
                        ),
                        Text(
                          'Login',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                    errorMessage != null
                        ? Container(
                            width: double.infinity,
                            alignment: Alignment.center,
                            margin: EdgeInsets.only(top: 15),
                            padding: EdgeInsets.symmetric(vertical: 15),
                            decoration: BoxDecoration(
                              color: Colors.red.withOpacity(0.025),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                width: 1,
                                color: Colors.red.withOpacity(0.25),
                              ),
                            ),
                            child: Text(
                              errorMessage.toString(),
                              style: TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          )
                        : SizedBox.shrink(),
                    Padding(padding: EdgeInsets.only(bottom: 15)),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            decoration: InputDecoration(
                              hintText: 'Username / Email',
                              filled: true,
                              fillColor: primaryColor.withOpacity(0.05),
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 16.0 * 1.5, vertical: 16.0),
                              border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(50)),
                              ),
                            ),
                            // keyboardType: TextInputType.name,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Username / Email Wajib diisi';
                              }
                              return null;
                            },
                            onTapOutside: (e) {
                              _formKey.currentState!.validate();
                              FocusManager.instance.primaryFocus?.unfocus();
                            },
                            onChanged: (val) {
                              state.setUsername(val);
                            },
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 16.0),
                            child: TextFormField(
                              obscureText: !showPassword,
                              decoration: InputDecoration(
                                hintText: 'Password',
                                filled: true,
                                fillColor: primaryColor.withOpacity(0.05),
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 16.0 * 1.5, vertical: 16.0),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(50)),
                                ),
                                suffixIcon: GestureDetector(
                                  onTap: () {
                                    state.setShowPassword(!showPassword);
                                  },
                                  child: Icon(
                                    showPassword
                                        ? Iconsax.eye_slash
                                        : Iconsax.eye,
                                  ),
                                ),
                              ),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Kata Sandi Wajib diisi';
                                }
                                return null;
                              },
                              onTapOutside: (e) {
                                _formKey.currentState!.validate();
                                FocusManager.instance.primaryFocus?.unfocus();
                              },
                              onChanged: (val) {
                                state.setPassword(val);
                              },
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate() &&
                                  !signinBtnIsLoading) {
                                _formKey.currentState!.save();
                                state.loginFn();
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              elevation: 0,
                              backgroundColor: primaryColor
                                  .withOpacity(signinBtnIsLoading ? 0.5 : 1),
                              foregroundColor: Colors.white,
                              minimumSize: Size(double.infinity, 48),
                              shape: StadiumBorder(),
                            ),
                            child: Text(
                              signinBtnIsLoading ? 'Waiting...' : 'Sign in',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                          ),
                          SizedBox(height: 16.0),
                          TextButton(
                            onPressed: () {},
                            child: Text(
                              'Lupa Kata Sandi?',
                              style: TextStyle(color: Color(0xff777777)),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Get.rootDelegate.toNamed('/register');
                            },
                            child: Text.rich(
                              TextSpan(
                                text: 'Belum Punya Akun? ',
                                children: [
                                  TextSpan(
                                    text: 'Daftar',
                                    style: TextStyle(
                                      color: primaryColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                              style: TextStyle(color: Color(0xff777777)),
                            ),
                          ),
                          Text(
                            'v1.0.7',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      }),
    );
  }
}
