import 'package:ems_v4/global/constants.dart';
import 'package:ems_v4/global/utils/json_utils.dart';
import 'package:ems_v4/models/attendance_record.dart';
import 'package:ems_v4/views/widgets/builder/column_builder.dart';
import 'package:ems_v4/views/widgets/builder/ems_container.dart';
import 'package:ems_v4/views/widgets/buttons/rounded_custom_button.dart';
import 'package:ems_v4/views/widgets/inputs/input.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pinput/pinput.dart';

class TimeEntriesHealthDeclaration extends StatefulWidget {
  const TimeEntriesHealthDeclaration({super.key});

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
  late AttendanceRecord attendanceRecord;

  @override
  void initState() {
    super.initState();

    loadData();
  }

  void loadData() {
    _jsonUtils.readJson('assets/json/symptoms.json').then((value) {
      setState(() {
        _symptoms = value['symptoms'];
        if (attendanceRecord.healthCheck != null) {
          _symptoms.asMap().forEach(
            (index, element) {
              if (attendanceRecord.healthCheck!
                  .contains(_symptoms[index]['descriptionEnglish'])) {
                checkedSymptoms.add(_symptoms[index]['descriptionEnglish']);
                _symptoms[index]['state'] = true;
              }
            },
          );
          if (attendanceRecord.healthCheck!.contains("Others")) {
            List tempArr = attendanceRecord.healthCheck!.split(', ');

            _otherSymptom.setText(tempArr[tempArr.length - 1]);
          }
        }
        temperatureController
            .setText(attendanceRecord.healthTemperature ?? "37.0");
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    attendanceRecord = GoRouterState.of(context).extra! as AttendanceRecord;
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
                        context.pop();
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
                      padding:
                          EdgeInsets.symmetric(vertical: size.height * .01),
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
                                      height: size.height * .05,
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
                                    _symptoms[index]["state"] = value;
                                  });
                                },
                              ),
                            );
                          },
                        ),
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
              Center(
                child: RoundedCustomButton(
                  onPressed: () {
                    context.pop();
                  },
                  label: 'Close',
                  bgColor: gray,
                  radius: 8,
                  size: Size(size.width * .4, 40),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
