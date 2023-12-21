import 'package:ems_v3/View/widgets/Builder/column_builder.dart';
import 'package:ems_v3/View/widgets/Buttons/rounded_custom_button.dart';
import 'package:ems_v3/View/widgets/Dialog/ems_dialog.dart';
import 'package:ems_v3/ViewModel/home_controller.dart';
import 'package:ems_v3/Services/auth_service.dart';
import 'package:ems_v3/Global/constants.dart';
import 'package:ems_v3/Utils/json_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class LogHealthDeclaration extends StatefulWidget {
  const LogHealthDeclaration({super.key});

  @override
  State<LogHealthDeclaration> createState() => _LogHealthDeclarationState();
}

class _LogHealthDeclarationState extends State<LogHealthDeclaration> {
  final HomeController _homeController = Get.find<HomeController>();
  final AuthService _authService = Get.find<AuthService>();
  final JsonUtils _jsonUtil = JsonUtils();

  List _symptoms = [];
  List checkedSymptoms = [];
  TextEditingController temperatureController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _jsonUtil.readJson('assets/json/symptoms.json').then((value) {
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
                              tileColor: darkGray,
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
            TextFormField(
              controller: temperatureController,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(
                    RegExp(r'^\d{0,2}\.?\d{0,2}')),
              ],
              decoration: const InputDecoration(
                labelText: 'Enter your body temperature in degree celsius',
                labelStyle: TextStyle(color: gray),
                hintText: "--.--",
                prefixIcon: Icon(
                  Icons.thermostat_sharp,
                  color: darkGray,
                ),
                hintStyle: TextStyle(color: gray),
                contentPadding: EdgeInsets.all(0),
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: gray),
                ),
                focusedBorder: OutlineInputBorder(
                  gapPadding: 0.0,
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
                        temperatureController.text == "") {
                      EMSDialog(
                        title: "Opps!",
                        hasMessage: true,
                        withCloseButton: true,
                        hasCustomWidget: false,
                        message:
                            "Check a symptoms and enter your current temperature",
                        type: "error",
                        buttonNumber: 0,
                      ).show(context);
                    } else {
                      debugPrint(checkedSymptoms.join(", "));
                      debugPrint(temperatureController.text);
                      _homeController
                          .clockIn(
                        employeeId: _authService.employee.value.id,
                        context: context,
                        healthCheck: checkedSymptoms,
                        temperature: temperatureController.text,
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
