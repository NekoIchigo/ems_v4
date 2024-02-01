import 'package:ems_v4/controller/home_controller.dart';
import 'package:ems_v4/global/constants.dart';
import 'package:ems_v4/global/services/auth_service.dart';
import 'package:ems_v4/global/utils/json_utils.dart';
import 'package:ems_v4/views/widgets/builder/column_builder.dart';
import 'package:ems_v4/views/widgets/buttons/rounded_custom_button.dart';
import 'package:ems_v4/views/widgets/dialog/ems_dialog.dart';
import 'package:ems_v4/views/widgets/inputs/input.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class HealthDeclaration extends StatefulWidget {
  const HealthDeclaration({super.key});

  @override
  State<HealthDeclaration> createState() => _HealthDeclarationState();
}

class _HealthDeclarationState extends State<HealthDeclaration> {
  final HomeController _homeController = Get.find<HomeController>();
  final AuthService _authService = Get.find<AuthService>();
  final JsonUtils _jsonUtils = JsonUtils();

  List _symptoms = [];
  List checkedSymptoms = [];
  final TextEditingController _temperatureController = TextEditingController();
  final TextEditingController _otherSymptom = TextEditingController();
  bool isOthersCheck = false;
  @override
  void initState() {
    super.initState();
    _jsonUtils.readJson('assets/json/symptoms.json').then((value) {
      setState(() {
        // print(value);
        _symptoms = value['symptoms'];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Text("Health Declaration",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: primaryBlue,
                  )),
            ),
            const Row(
              children: [
                Flexible(
                  child: Text(
                    "Are you currently experiencing or have experienced any of these symptoms in the last 24 hours?",
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                      fontWeight: FontWeight.w300,
                      color: gray,
                    ),
                  ),
                ),
              ],
            ),
            _symptoms.isNotEmpty
                ? Padding(
                    padding: EdgeInsets.symmetric(vertical: Get.height * .01),
                    child: ColumnBuilder(
                      itemCount: _symptoms.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding:
                              EdgeInsets.symmetric(vertical: Get.width * .01),
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: const Color(0xFF2465C7),
                                style: BorderStyle.solid,
                                width: 0.5,
                              ),
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: CheckboxListTile(
                              activeColor: primaryBlue,
                              tileColor: lightGray,
                              contentPadding: const EdgeInsets.all(0),
                              controlAffinity: ListTileControlAffinity.leading,
                              title: Row(
                                children: [
                                  Image(
                                    height: Get.height * .05,
                                    image: AssetImage(_symptoms[index]["path"]),
                                  ),
                                  Flexible(
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                          left: Get.width * .02),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            _symptoms[index]
                                                ["descriptionEnglish"],
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: gray,
                                            ),
                                          ),
                                          const SizedBox(height: 2.5),
                                          Text(
                                            _symptoms[index]
                                                ["descriptionTagalog"],
                                            style: const TextStyle(
                                              fontSize: 14,
                                              color: gray,
                                            ),
                                            textWidthBasis:
                                                TextWidthBasis.longestLine,
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              value: _symptoms[index]["state"],
                              onChanged: (value) {
                                setState(() {
                                  if (checkedSymptoms.contains(
                                      _symptoms[index]["descriptionEnglish"])) {
                                    checkedSymptoms.remove((_symptoms[index]
                                        ["descriptionEnglish"]));
                                  } else {
                                    checkedSymptoms.add(
                                        _symptoms[index]["descriptionEnglish"]);
                                  }
                                  if (_symptoms[index]["descriptionEnglish"] ==
                                      "Others") {
                                    isOthersCheck = !isOthersCheck;
                                    print(isOthersCheck);
                                  }
                                  _symptoms[index]["state"] = value;
                                });
                              },
                            ),
                          ),
                        );
                      },
                    ),
                  )
                : Container(),
            Visibility(
              visible: isOthersCheck,
              child: Input(
                isPassword: false,
                textController: _otherSymptom,
                hintText: 'Other symptoms',
              ),
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _temperatureController,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(
                    RegExp(r'^\d{0,2}\.?\d{0,2}')),
              ],
              decoration: const InputDecoration(
                labelText: 'Enter temperature',
                labelStyle: TextStyle(color: lightGray),
                hintText: "--.--",
                prefixIcon: Icon(
                  Icons.thermostat_sharp,
                  color: gray,
                ),
                hintStyle: TextStyle(color: gray),
                contentPadding: EdgeInsets.all(0),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: lightGray),
                ),
                border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: primaryBlue),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Expanded(child: SizedBox()),
                RoundedCustomButton(
                  onPressed: () {
                    _homeController.isWhite.value = false;
                    _homeController.pageName.value = '/home';
                    // context.router.navigate(const HomepageRouter());
                  },
                  label: 'Close',
                  bgColor: darkGray,
                  radius: 8,
                  size: Size(Get.width * .4, 40),
                ),
                const Expanded(child: SizedBox()),
                RoundedCustomButton(
                  onPressed: () {
                    if (checkedSymptoms.isEmpty ||
                        _temperatureController.text == "") {
                      EMSDialog(
                        title: "Oopps",
                        hasMessage: true,
                        withCloseButton: true,
                        hasCustomWidget: false,
                        message:
                            "Check a symptoms and enter your current temperature",
                        type: "error",
                        buttonNumber: 0,
                      ).show(context);
                    } else {
                      checkedSymptoms.add(_otherSymptom.text);
                      _homeController
                          .clockIn(
                        employeeId: _authService.employee.value.id,
                        healthCheck: checkedSymptoms,
                        temperature: _temperatureController.text,
                      )
                          .then((value) {
                        _homeController.pageName.value = '/home/result';
                      });
                    }
                  },
                  label: 'Clock In',
                  bgColor: colorSuccess,
                  radius: 8,
                  size: Size(Get.width * .4, 40),
                ),
                const Expanded(child: SizedBox()),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
