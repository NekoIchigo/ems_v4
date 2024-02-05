import 'package:ems_v4/global/constants.dart';
import 'package:ems_v4/global/utils/json_utils.dart';
import 'package:ems_v4/models/attendance_record.dart';
import 'package:ems_v4/views/widgets/builder/column_builder.dart';
import 'package:ems_v4/views/widgets/builder/ems_container.dart';
import 'package:ems_v4/views/widgets/buttons/rounded_custom_button.dart';
import 'package:ems_v4/views/widgets/inputs/input.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';

class TimeEntriesHealthDeclaration extends StatefulWidget {
  const TimeEntriesHealthDeclaration(
      {super.key, required this.attendanceRecord});
  final AttendanceRecord attendanceRecord;

  @override
  State<TimeEntriesHealthDeclaration> createState() =>
      _TimeEntriesHealthDeclarationState();
}

class _TimeEntriesHealthDeclarationState
    extends State<TimeEntriesHealthDeclaration> {
  final JsonUtils _jsonUtils = JsonUtils();

  List _symptoms = [];
  List checkedSymptoms = [];
  final TextEditingController temperatureController = TextEditingController();
  final TextEditingController _otherSymptom = TextEditingController();

  @override
  void initState() {
    super.initState();

    _jsonUtils.readJson('assets/json/symptoms.json').then((value) {
      setState(() {
        _symptoms = value['symptoms'];
        if (widget.attendanceRecord.healthCheck != null) {
          _symptoms.asMap().forEach(
            (index, element) {
              if (widget.attendanceRecord.healthCheck!
                  .contains(_symptoms[index]['descriptionEnglish'])) {
                checkedSymptoms.add(_symptoms[index]['descriptionEnglish']);
                _symptoms[index]['state'] = true;
              }
            },
          );
          if (widget.attendanceRecord.healthCheck!.contains("Others")) {
            List tempArr = widget.attendanceRecord.healthCheck!.split(', ');

            _otherSymptom.setText(tempArr[tempArr.length - 1]);
          }
        }
        temperatureController
            .setText(widget.attendanceRecord.healthTemperature ?? "37.0");
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return EMSContainer(
      child: SingleChildScrollView(
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
                        Get.back();
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
                                enabled: false,
                                contentPadding: const EdgeInsets.all(0),
                                controlAffinity:
                                    ListTileControlAffinity.leading,
                                title: Row(
                                  children: [
                                    Image(
                                      height: Get.height * .05,
                                      image:
                                          AssetImage(_symptoms[index]["path"]),
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
                                        _symptoms[index]
                                            ["descriptionEnglish"])) {
                                      checkedSymptoms.remove((_symptoms[index]
                                          ["descriptionEnglish"]));
                                    } else {
                                      checkedSymptoms.add(_symptoms[index]
                                          ["descriptionEnglish"]);
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
                visible: true,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 15.0),
                  child: Input(
                    disabled: true,
                    validator: (p0) {},
                    isPassword: false,
                    textController: _otherSymptom,
                    hintText: 'Other symptoms',
                  ),
                ),
              ),
              Input(
                isPassword: false,
                disabled: true,
                textController: temperatureController,
                validator: (p0) {},
                prefixIcon: const Icon(
                  Icons.thermostat_rounded,
                  color: gray,
                ),
              ),
              // TextFormField(
              //   controller: temperatureController,
              //   readOnly: true,
              //   keyboardType:
              //       const TextInputType.numberWithOptions(decimal: true),
              //   inputFormatters: [
              //     FilteringTextInputFormatter.allow(
              //         RegExp(r'^\d{0,2}\.?\d{0,2}')),
              //   ],
              //   decoration: const InputDecoration(
              //     labelText: 'Enter temperature in °C',
              //     labelStyle: TextStyle(color: gray),
              //     hintText: "--.--",
              //     fillColor: gray,
              //     prefixIcon: Icon(
              //       Icons.thermostat_sharp,
              //       color: gray,
              //     ),
              //     hintStyle: TextStyle(color: gray),
              //     contentPadding: EdgeInsets.all(0),
              //     enabledBorder: OutlineInputBorder(
              //       borderSide: BorderSide(color: lightGray),
              //     ),
              //     border: OutlineInputBorder(
              //       borderSide: BorderSide(color: gray),
              //     ),
              //     focusedBorder: OutlineInputBorder(
              //       gapPadding: 0.0,
              //       borderSide: BorderSide(color: primaryBlue),
              //     ),
              //   ),
              // ),
              Center(
                child: RoundedCustomButton(
                  onPressed: () {
                    Get.back();
                    // context.router.navigate(const HomepageRouter());
                  },
                  label: 'Close',
                  bgColor: gray,
                  radius: 8,
                  size: Size(Get.width * .4, 40),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
