// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pims/_config/dio.dart';
import 'package:pims/_widgets/helper.dart';
import 'package:pims/_widgets/select/select_data.dart';

import 'appbar.dart';
import 'bottom_nav.dart';
import 'take_nik.dart';

getReligion() async {
  try {
    final api =
        await API().get('$SERVER_URL/religion', queryParameters: {'limit': 50});
    final result = List.generate(api.data?['data']?.length ?? 0, (i) {
      final item = api.data?['data']?[i];
      return {'value': item?['id'], 'label': item?['name']};
    });
    return result;
  } catch (e) {
    return [];
  }
}

getOccupation() async {
  try {
    final api = await API()
        .get('$SERVER_URL/occupation', queryParameters: {'limit': 50});
    final result = List.generate(api.data?['data']?.length ?? 0, (i) {
      final item = api.data?['data']?[i];
      return {'value': item?['id'], 'label': item?['name']};
    });
    return result;
  } catch (e) {
    return [];
  }
}

getProvince() async {
  try {
    final api = await API()
        .get('$SERVER_URL/province', queryParameters: {'limit': 100});
    final result = List.generate(api.data?['data']?.length ?? 0, (i) {
      final item = api.data?['data']?[i];
      return {'value': item?['id'], 'label': item?['name']};
    });
    return result;
  } catch (e) {
    return [];
  }
}

getCity(province_id) async {
  try {
    final api = await API().get('$SERVER_URL/city', queryParameters: {
      'limit': 1000,
      ...(![null, ''].contains(province_id) ? {'province_id': province_id} : {})
    });
    final result = List.generate(api.data?['data']?.length ?? 0, (i) {
      final item = api.data?['data']?[i];
      return {'value': item?['id'], 'label': item?['name']};
    });
    return result;
  } catch (e) {
    return [];
  }
}

class ProfileEditController extends GetxController {
  final formKey = GlobalKey<FormState>();
  RxBool pageIsReady = true.obs;
  final dataReligion = Rxn<List<Map<String, dynamic>>>([]);
  final dataProvince = Rxn<List<Map<String, dynamic>>>([]);
  final dataCity = Rxn<List<Map<String, dynamic>>>([]);
  final dataOccupation = Rxn<List<Map<String, dynamic>>>([]);

  RxString email = ''.obs;
  RxString first_name = ''.obs;
  RxString last_name = ''.obs;
  RxString phone = ''.obs;
  RxString nik = ''.obs;
  RxString nik_file = ''.obs;
  RxString nik_url = ''.obs;
  RxString birth = ''.obs;
  final gender = Rxn<int>();
  final marital = Rxn<int>();
  final religion_id = Rxn<int>();
  final occupation_id = Rxn<int>();
  final province_id = Rxn<int>();
  final city_id = Rxn<int>();
  RxString address = ''.obs;
  final social = Rxn<Map<String, dynamic>>();

  final errorMessage = Rxn<dynamic>(null);
  RxBool submitBtnIsLoading = false.obs;

  setCity(e) => dataCity.value = e;
  setProvince(e) => dataProvince.value = e;

  setEmail(e) => email.value = e;
  setFirstName(e) => first_name.value = e;
  setLastName(e) => last_name.value = e;
  setPhone(e) => phone.value = e;
  setNIK(e) => nik.value = e;
  setNIKUrl(e) => nik_url.value = e;
  setNIKFile(e) => nik_file.value = e;
  setBirth(e) => birth.value = e;
  setGender(e) => gender.value = e;
  setMarital(e) => marital.value = e;
  setReligionID(e) => religion_id.value = e;
  setOccupationID(e) => occupation_id.value = e;
  setProvinceID(e) => province_id.value = e;
  setCityID(e) => city_id.value = e;
  setAddress(e) => address.value = e;
  setSocial(e) => social.value = e;

  @override
  void onInit() async {
    pageIsReady.value = false;
    try {
      final api = await API().get('/me');
      final res = api.data;

      final religion = await getReligion();
      dataReligion.value = religion;

      // final province = await getProvince();
      // dataProvince.value = province;

      final occupation = await getOccupation();
      dataOccupation.value = occupation;

      setEmail(res?['email'] ?? '');
      setFirstName(res?['first_name'] ?? '');
      setLastName(res?['last_name'] ?? '');
      setPhone(res?['phone'] ?? '');
      setNIK(res?['nik'] ?? '');
      final nikFilename = res?['nik_file'];
      if (nikFilename != null) {
        final nikUrl = '$SERVER_URL/static/images/nik/$nikFilename';
        final base64NIK = await urlToBase64(nikUrl);
        setNIKUrl(nikUrl);
        setNIKFile(base64NIK ?? '');
      } else {
        setNIKUrl('');
        setNIKFile('');
      }
      if (![null, ''].contains(res?['birth'])) {
        final birthToDate = DateFormat('yyyy-MM-dd')
            .format(DateTime.parse(res['birth']).toLocal());
        setBirth(birthToDate);
      }
      setGender(res?['gender']);
      setMarital(res?['marital']);
      setReligionID(res?['religion_id']);
      setOccupationID(res?['occupation_id']);
      if (![null, ''].contains(res?['province_id'])) {
        setProvince([
          {'value': res?['province']?['id'], 'label': res?['province']?['name']}
        ]);
        setProvinceID(res['province_id']);
        if (![null, ''].contains(res?['city_id'])) {
          setCity([
            {'value': res?['city']?['id'], 'label': res?['city']?['name']}
          ]);
        }
      }
      setCityID(res?['city_id']);
      setAddress(res?['address'] ?? '');
    } finally {
      pageIsReady.value = true;
    }
    super.onInit();
  }

  @override
  void refresh() {
    pageIsReady.value = false;
    Future.delayed(Duration(milliseconds: 400), () {
      onInit();
    });
    super.refresh();
  }

  submitFn() async {
    submitBtnIsLoading.value = true;
    final params = {
      'email': email.value,
      'first_name': first_name.value,
      'last_name': last_name.value,
      'phone': phone.value,
      'nik': nik.value,
      'nik_file': nik_file.value,
      'birth': birth.value,
      'gender': gender.value,
      'marital': marital.value,
      'religion_id': religion_id.value,
      'occupation_id': occupation_id.value,
      'province_id': province_id.value,
      'city_id': city_id.value,
      'address': address.value,
      'social': social.value,
    };
    try {
      final api = await API().post('update/profile', data: params);
      errorMessage.value = null;
      if (api.data['status'] == 'success') {
        Get.rootDelegate.offNamed('/profile');
      }
    } catch (e) {
      dynamic err = e;
      // dynamic error = err?.response?.data['message'];
      dynamic error = err?.response?.data['message'] ?? err?.error?.message;
      errorMessage.value = error;
    } finally {
      submitBtnIsLoading.value = false;
    }
  }
}

class ProfileEditPage extends StatelessWidget {
  ProfileEditPage({super.key});
  final state = Get.put(ProfileEditController());

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    // state.onInit();
    final outlineInputBorder = OutlineInputBorder(
      borderSide: BorderSide(color: Color(0xffdddddd)),
      borderRadius: BorderRadius.all(Radius.circular(100)),
    );
    final focusedBorder = outlineInputBorder.copyWith(
      borderSide: BorderSide(color: primaryColor),
    );
    final labelStyle = TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.bold,
    );
    final dataGenders = [
      {'value': 1, 'label': 'Pria'},
      {'value': 2, 'label': 'Wanita'},
      {'value': 3, 'label': 'Lainnya'},
    ];
    final dataMarital = [
      {'value': 1, 'label': 'Kawin'},
      {'value': 0, 'label': 'Tidak Kawin'},
    ];
    inputDecoration(String? text) {
      return InputDecoration(
        hintText: 'Masukan ${text ?? ''}',
        labelText: text ?? 'Label',
        labelStyle: labelStyle,
        // floatingLabelBehavior: FloatingLabelBehavior.always,
        hintStyle: TextStyle(color: Color(0xff777777)),
        contentPadding: EdgeInsets.symmetric(
          horizontal: 24,
        ),
        border: outlineInputBorder,
        enabledBorder: outlineInputBorder,
        focusedBorder: focusedBorder,
      );
    }

    textAreaDecoration(String? text) {
      return InputDecoration(
        hintText: 'Masukan ${text ?? ''}',
        labelText: text ?? 'Label',
        labelStyle: labelStyle,
        // floatingLabelBehavior: FloatingLabelBehavior.always,
        hintStyle: TextStyle(color: Color(0xff777777)),
        contentPadding: EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 10,
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xffdddddd)),
          borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xffdddddd)),
          borderRadius: BorderRadius.all(Radius.circular(50)),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: primaryColor),
          borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
      );
    }

    return Scaffold(
      // backgroundColor: Colors.white,
      appBar: ProfileEditAppBar(),
      bottomNavigationBar: ProfileEditBottomNav(),
      body: Obx(() {
        final formKey = state.formKey;
        onTapOutside(e) {
          formKey.currentState?.validate();
          FocusManager.instance.primaryFocus?.unfocus();
        }

        final pageIsReady = state.pageIsReady.value;
        final dataReligion = state.dataReligion.value ?? [];
        final dataProvince = state.dataProvince.value ?? [];
        final dataCity = state.dataCity.value ?? [];
        final dataOccupation = state.dataOccupation.value ?? [];
        final errorMessage = state.errorMessage.value.toString();

        final email = state.email.value;
        final first_name = state.first_name.value;
        final last_name = state.last_name.value;
        final phone = state.phone.value;
        final nik = state.nik.value;
        final nik_url = state.nik_url.value;
        final birth = state.birth.value;
        final gender = state.gender.value;
        final marital = state.marital.value;
        final religion_id = state.religion_id.value;
        final province_id = state.province_id.value;
        final city_id = state.city_id.value;
        final occupation_id = state.occupation_id.value;
        final address = state.address.value;

        return SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return RefreshIndicator(
                color: primaryColor,
                displacement: 50,
                onRefresh: () async {
                  state.refresh();
                },
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 30),
                  child: pageIsReady
                      ? Column(
                          children: [
                            SizedBox(height: 35),
                            errorMessage != '' && errorMessage != 'null'
                                ? Container(
                                    width: double.infinity,
                                    alignment: Alignment.center,
                                    margin: EdgeInsets.only(
                                      top: 15,
                                      bottom: 25,
                                    ),
                                    padding: EdgeInsets.symmetric(vertical: 15),
                                    decoration: BoxDecoration(
                                      color:
                                          Colors.red.withValues(alpha: 0.025),
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                        width: 1,
                                        color:
                                            Colors.red.withValues(alpha: 0.25),
                                      ),
                                    ),
                                    child: Text(
                                      errorMessage,
                                      style: TextStyle(
                                        color: Colors.red,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  )
                                : SizedBox.shrink(),
                            Form(
                              key: formKey,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // ========= EMAIL =========
                                  TextFormField(
                                    initialValue: email,
                                    textInputAction: TextInputAction.next,
                                    decoration: inputDecoration('Email'),
                                    keyboardType: TextInputType.emailAddress,
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'Email wajib diisi';
                                      }
                                      const pattern =
                                          r"^([\w.%+-]+)@([\w-]+\.)+([\w]{2,})$";
                                      final regex = RegExp(pattern);
                                      if (!regex.hasMatch(value)) {
                                        return 'Mohon masukan format email yang benar';
                                      }
                                      return null;
                                    },
                                    onTapOutside: (e) => onTapOutside(e),
                                    onChanged: (val) => state.setEmail(val),
                                  ),
                                  SizedBox(height: 25),
                                  // ========= FIRST NAME =========
                                  TextFormField(
                                    initialValue: first_name,
                                    textInputAction: TextInputAction.next,
                                    decoration: inputDecoration('Nama Depan'),
                                    // keyboardType: TextInputType.name,
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'Nama depan wajib diisi';
                                      }
                                      return null;
                                    },
                                    onTapOutside: (e) => onTapOutside(e),
                                    onChanged: (val) => state.setFirstName(val),
                                  ),
                                  SizedBox(height: 25),
                                  // ========= LAST NAME =========
                                  TextFormField(
                                    initialValue: last_name,
                                    textInputAction: TextInputAction.next,
                                    decoration:
                                        inputDecoration('Nama Belakang'),
                                    // keyboardType: TextInputType.name,
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'Nama belakang wajib diisi';
                                      }
                                      return null;
                                    },
                                    onTapOutside: (e) => onTapOutside(e),
                                    onChanged: (val) => state.setLastName(val),
                                  ),
                                  SizedBox(height: 25),
                                  // ========= PHONE =========
                                  TextFormField(
                                    initialValue: phone,
                                    textInputAction: TextInputAction.next,
                                    decoration: inputDecoration('No. Hanphone'),
                                    keyboardType: TextInputType.phone,
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'No. Handphone wajib diisi';
                                      }
                                      return null;
                                    },
                                    onTapOutside: (e) => onTapOutside(e),
                                    onChanged: (val) => state.setPhone(val),
                                  ),
                                  SizedBox(height: 25),
                                  // ========= NIK =========
                                  TextFormField(
                                    initialValue: nik,
                                    textInputAction: TextInputAction.next,
                                    decoration: inputDecoration('NIK'),
                                    keyboardType: TextInputType.number,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly,
                                    ],
                                    validator: (value) {
                                      const pattern = r"^([0-9])+([\d]{15})";
                                      final regex = RegExp(pattern);
                                      if (value != '' &&
                                          !regex.hasMatch(value ?? '')) {
                                        return 'Mohon masukan format NIK yang benar';
                                      }
                                      return null;
                                    },
                                    onTapOutside: (e) => onTapOutside(e),
                                    onChanged: (val) => state.setNIK(val),
                                  ),
                                  SizedBox(height: 20),
                                  // ========= NIK FILE =========
                                  Center(
                                    child: Container(
                                      margin: const EdgeInsets.only(bottom: 20),
                                      child: nik_url != ''
                                          ? NIKImage()
                                          : UploadNIKButton(),
                                    ),
                                  ),
                                  SizedBox(height: 20),
                                  // ========= BIRTH =========
                                  TextFormField(
                                    controller:
                                        TextEditingController(text: birth),
                                    // initialValue: birth,
                                    textInputAction: TextInputAction.next,
                                    decoration: inputDecoration('Tgl Lahir'),
                                    onTapOutside: (e) => onTapOutside(e),
                                    // onChanged: (val) => state.setFirstName(val),
                                    readOnly: true,
                                    onTap: () async {
                                      final datePicker = await showDatePicker(
                                        context: context,
                                        locale: Locale('id'),
                                        initialDate: birth != ''
                                            ? DateTime.parse(birth)
                                            : DateTime.now(),
                                        firstDate:
                                            DateTime(DateTime.now().year - 70),
                                        lastDate: DateTime.now(),
                                      );
                                      if (datePicker != null) {
                                        final res = DateFormat('yyyy-MM-dd')
                                            .format(datePicker);
                                        state.setBirth(res);
                                      }
                                    },
                                  ),
                                  SizedBox(height: 25),
                                  // ========= GENDER =========
                                  DropdownData(
                                    title: 'Jenis Kelamin',
                                    items: dataGenders,
                                    initialValue: gender,
                                    onChange: (e) =>
                                        state.setGender(e?['value']),
                                  ),
                                  SizedBox(height: 25),
                                  // ========= MARITAL =========
                                  DropdownData(
                                    title: 'Status',
                                    items: dataMarital,
                                    initialValue: marital,
                                    onChange: (e) =>
                                        state.setMarital(e?['value']),
                                  ),
                                  SizedBox(height: 25),
                                  // ========= RELIGION =========
                                  DropdownData(
                                    title: 'Agama',
                                    items: dataReligion,
                                    initialValue: religion_id,
                                    onChange: (e) =>
                                        state.setReligionID(e?['value']),
                                  ),
                                  SizedBox(height: 25),
                                  // ========= OCCUPATION =========
                                  DropdownData(
                                    title: 'Pekerjaan',
                                    items: dataOccupation,
                                    initialValue: occupation_id,
                                    onChange: (e) =>
                                        state.setOccupationID(e?['value']),
                                  ),
                                  SizedBox(height: 25),
                                  // ========= PROVINCE =========
                                  DropdownData(
                                    title: 'Provinsi',
                                    items: dataProvince,
                                    initialValue: province_id,
                                    onOpen: (value) async {
                                      try {
                                        final provinces = await getProvince();
                                        state.setProvince(provinces);
                                        return true;
                                      } catch (e) {
                                        return false;
                                      }
                                    },
                                    onChange: (e) async {
                                      state.setProvinceID(e?['value']);
                                      state.setCityID(null);
                                      try {
                                        final apiCity =
                                            await getCity(e?['value']);
                                        state.setCity(apiCity);
                                      } catch (e) {
                                        //
                                      }
                                    },
                                  ),
                                  SizedBox(height: 25),
                                  // ========= CITY =========
                                  DropdownData(
                                    title: 'Kota',
                                    items: dataCity,
                                    initialValue: city_id,
                                    onOpen: province_id != null
                                        ? (value) async {
                                            try {
                                              final cities =
                                                  await getCity(province_id);
                                              state.setCity(cities);
                                              return true;
                                            } catch (e) {
                                              return false;
                                            }
                                          }
                                        : null,
                                    onChange: (e) =>
                                        state.setCityID(e?['value']),
                                  ),
                                  SizedBox(height: 25),
                                  // ========= ADDRESS =========
                                  TextFormField(
                                    initialValue: address,
                                    textInputAction: TextInputAction.next,
                                    keyboardType: TextInputType.multiline,
                                    minLines: 1,
                                    maxLines: 2,
                                    decoration:
                                        textAreaDecoration('Alamat/Jl.'),
                                    onTapOutside: (e) => onTapOutside(e),
                                    onChanged: (val) => state.setAddress(val),
                                  ),
                                  SizedBox(height: 25),
                                  // ========= END BOTTOM =========
                                  SizedBox(height: 25),
                                ],
                              ),
                            ),
                          ],
                        )
                      : ProfileEditLoader(),
                ),
              );
            },
          ),
        );
      }),
    );
  }
}

class ProfileEditLoader extends StatelessWidget {
  const ProfileEditLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 25),
      child: ListView.separated(
        shrinkWrap: true,
        itemBuilder: (ctx, index) => Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.only(bottom: 10),
              width: Get.width / 3,
              height: 15,
              decoration: BoxDecoration(
                color: Color(0xfff5f5f5),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            Container(
              height: 45,
              decoration: BoxDecoration(
                color: Color(0xfff5f5f5),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ],
        ),
        separatorBuilder: (ctx, index) => SizedBox(height: 25),
        itemCount: 3,
      ),
    );
  }
}
