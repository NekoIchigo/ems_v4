import 'package:ems_v4/global/controller/home_controller.dart';
import 'package:ems_v4/global/constants.dart';
import 'package:ems_v4/global/utils/json_utils.dart';
import 'package:ems_v4/views/widgets/builder/column_builder.dart';
import 'package:ems_v4/views/widgets/buttons/rounded_custom_button.dart';
import 'package:ems_v4/views/widgets/dialog/ems_dialog.dart';
import 'package:ems_v4/views/widgets/inputs/input.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

class HealthDeclaration extends StatefulWidget {
  const HealthDeclaration({super.key});

  @override
  State<HealthDeclaration> createState() => _HealthDeclarationState();
}

class _HealthDeclarationState extends State<HealthDeclaration> {
  final HomeController _homeController = Get.find<HomeController>();
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
    Size size = MediaQuery.of(context).size;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Stack(
              alignment: Alignment.center,
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
                Align(
                  alignment: Alignment.centerRight,
                  child: IconButton(
                    onPressed: () {
                      _homeController.pageName.value = '/home/info';
                    },
                    icon: const Icon(Icons.close),
                  ),
                ),
              ],
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
                    padding: EdgeInsets.symmetric(vertical: size.height * .01),
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: lightGray,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ColumnBuilder(
                        itemCount: _symptoms.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: size.width * .01),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.transparent,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: CheckboxListTile(
                                activeColor: primaryBlue,
                                side: const BorderSide(color: gray, width: 1),
                                contentPadding: const EdgeInsets.all(0),
                                controlAffinity:
                                    ListTileControlAffinity.leading,
                                title: Row(
                                  children: [
                                    Image(
                                      height: 40,
                                      image:
                                          AssetImage(_symptoms[index]["path"]),
                                    ),
                                    Flexible(
                                      child: Padding(
                                        padding: EdgeInsets.only(
                                            left: size.width * .02),
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
                                        _symptoms[index]
                                            ["descriptionEnglish"])) {
                                      checkedSymptoms.remove((_symptoms[index]
                                          ["descriptionEnglish"]));
                                    } else {
                                      checkedSymptoms.add(_symptoms[index]
                                          ["descriptionEnglish"]);
                                    }
                                    if (_symptoms[index]
                                            ["descriptionEnglish"] ==
                                        "Others") {
                                      isOthersCheck = !isOthersCheck;
                                    }
                                    _symptoms[index]["state"] = value;
                                  });
                                },
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  )
                : Container(),
            Visibility(
              visible: isOthersCheck,
              child: Input(
                validator: (p0) {},
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
                labelText: 'Enter temperature in °C',
                labelStyle: TextStyle(color: lightGray, fontSize: 13),
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
                    context.pop();
                  },
                  label: 'Close',
                  bgColor: gray,
                  radius: 8,
                  size: Size(size.width * .4, 40),
                ),
                const Expanded(child: SizedBox()),
                Obx(
                  () => RoundedCustomButton(
                    onPressed: () {
                      if (checkedSymptoms.isEmpty ||
                          _temperatureController.text == "") {
                        EMSDialog(
                          title: "Oops",
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
                          healthCheck: checkedSymptoms,
                          temperature: _temperatureController.text,
                        )
                            .then((value) {
                          context.go('/result');
                        });
                      }
                    },
                    isLoading: _homeController.isLoading.isTrue,
                    label: 'Clock In',
                    bgColor: colorSuccess,
                    radius: 8,
                    size: Size(size.width * .4, 40),
                  ),
                ),
                const Expanded(child: SizedBox()),
              ],
            ),
            Container(
              height: MediaQuery.of(context).viewInsets.bottom + 80,
            ),
          ],
        ),
      ),
    );
  }
}
