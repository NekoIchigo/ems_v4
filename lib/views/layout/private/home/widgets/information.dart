import 'package:ems_v4/global/controller/auth_controller.dart';
import 'package:ems_v4/global/controller/home_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:ems_v4/global/constants.dart';
import 'package:ems_v4/global/utils/map_launcher.dart';
import 'package:ems_v4/views/widgets/buttons/rounded_custom_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeInfoPage extends StatefulWidget {
  const HomeInfoPage({super.key});

  @override
  State<HomeInfoPage> createState() => _HomeInfoPageState();
}

class _HomeInfoPageState extends State<HomeInfoPage> {
  final AuthController _auth = Get.find<AuthController>();
  final HomeController _homeController = Get.find<HomeController>();
  final MapLauncher _mapLuncher = MapLauncher();
  final GlobalKey _homeInfoKey = GlobalKey();
  final List<bool> _isSelected = [false];
  bool _isNotButtonDisable = false;

  final List<String> _list = <String>[
    'Field work',
    'Office/site visit',
    'Work from home'
  ];

  String? reason, reasonError;

  @override
  void initState() {
    if (_homeController.isClockOut.isTrue) {
      _isNotButtonDisable = true;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String locationMeters =
        _auth.employee!.value.employeeDetails.location.radius % 1 == 0
            ? _auth.employee!.value.employeeDetails.location.radius
                .toInt()
                .toString()
            : _auth.employee!.value.employeeDetails.location.radius
                .toStringAsFixed(2);
    Size size = MediaQuery.of(context).size;
    bool cannotClock = _auth.employee?.value.allowedOutsideVicinity == 0 &&
        !_homeController.isInsideVicinity.value;
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SingleChildScrollView(
        key: _homeInfoKey,
        child: Obx(
          () => Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 10),
                Text(
                  _auth.employee!.value.employeeDetails.location.name,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: primaryBlue,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Center(
                    child: Image.asset(
                      _homeController.isInsideVicinity.value
                          ? "assets/images/current_location-pana.png"
                          : "assets/images/current_location-rafiki.png",
                      width: size.width * .75,
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                Visibility(
                  visible: cannotClock,
                  child: SizedBox(
                    width: size.width * .7,
                    child: Text(
                      "${_homeController.isClockOut.isFalse ? 'Clock-in' : 'Clock-out'} is not allowed!",
                      style: const TextStyle(color: colorError, fontSize: 14),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                Visibility(
                  visible: !cannotClock,
                  child: InkWell(
                    onTap: () {
                      _mapLuncher.launchMap(
                          message: _homeController.currentLocation.value);
                    },
                    child: const Text(
                      'View Map',
                      style: TextStyle(
                        decoration: TextDecoration.underline,
                        color: gray,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ),
                // const SizedBox(height: 8),
                // Visibility(
                //   visible: !cannotClock,
                //   child: Text(
                //     _homeController.currentLocation.value,
                //     style: const TextStyle(color: gray, fontSize: 14),
                //     textAlign: TextAlign.center,
                //   ),
                // ),
                const SizedBox(height: 20),
                Visibility(
                  visible: cannotClock,
                  child: Column(
                    children: [
                      SizedBox(
                        width: size.width * .7,
                        child: Text(
                          "You exceeded the required $locationMeters-meter radius.",
                          style: const TextStyle(color: gray, fontSize: 14),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Visibility(
                        visible: cannotClock,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "To view the details, click on ",
                              style: TextStyle(color: gray),
                            ),
                            InkWell(
                              onTap: () {
                                _mapLuncher.launchMap();
                              },
                              child: const Text(
                                "View Map",
                                style: TextStyle(
                                  decoration: TextDecoration.underline,
                                  color: primaryBlue,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 30),
                      SizedBox(
                        width: size.width * .8,
                        child: const Text(
                          "For attendance concerns, contact the HR Department.",
                          style: TextStyle(color: gray, fontSize: 12),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(height: 20),
                      RoundedCustomButton(
                        onPressed: () {
                          _homeInfoKey.currentContext?.pop();
                        },
                        label: 'Close',
                        radius: 8,
                        bgColor: gray,
                        size: Size(size.width * .4, 40),
                      ),
                    ],
                  ),
                ),
                Visibility(
                  visible: _auth.employee?.value.allowedOutsideVicinity == 1 ||
                      !cannotClock,
                  child: Column(
                    children: [
                      Visibility(
                        visible: _homeController.isInsideVicinity.isFalse,
                        child: DropdownMenu<String>(
                          width: size.width * .710,
                          hintText: "Select your reason/purpose here",
                          errorText: reasonError,
                          textStyle:
                              const TextStyle(color: primaryBlue, fontSize: 13),
                          inputDecorationTheme: const InputDecorationTheme(
                            hintStyle:
                                TextStyle(color: primaryBlue, fontSize: 13),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                          ),
                          onSelected: (String? value) {
                            reason = value;
                            if (_homeController.isClockOut.isFalse) {
                              _homeController.attendance.value
                                  .clockedInLocationSetting = value!;
                            } else {
                              _homeController.attendance.value
                                  .clockedOutLocationSetting = value!;
                            }
                            reasonError = null;
                            setState(() {});
                          },
                          menuStyle: const MenuStyle(
                            surfaceTintColor:
                                MaterialStatePropertyAll(Colors.white),
                            backgroundColor:
                                MaterialStatePropertyAll(Colors.white),
                          ),
                          dropdownMenuEntries: _list
                              .map<DropdownMenuEntry<String>>((String value) {
                            return DropdownMenuEntry<String>(
                              value: value,
                              label: value,
                              labelWidget: Text(
                                value,
                                style: const TextStyle(fontSize: 14),
                              ),
                              style: const ButtonStyle(
                                foregroundColor:
                                    MaterialStatePropertyAll(primaryBlue),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                      const SizedBox(height: 10),
                      howAreYouFeeling(),
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 0, horizontal: 15.0),
                        child: Text.rich(
                          TextSpan(
                            children: [
                              const TextSpan(
                                text: 'By clicking ',
                              ),
                              TextSpan(
                                  text: _homeController.isClockOut.isFalse
                                      ? 'Clock In'
                                      : 'Clock Out'),
                              TextSpan(
                                  text: _homeController.isClockOut.isFalse
                                      ? ', you confirm your location and affirm your health condition.'
                                      : ', you confirm your location.'),
                            ],
                          ),
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: gray, fontSize: 13),
                        ),
                      ),
                      bottomButtons(size),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget howAreYouFeeling() {
    return Visibility(
      visible: _homeController.isClockOut.isFalse,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(bottom: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'How are you feeling today?',
                    style: TextStyle(
                      color: gray,
                      fontSize: 14,
                      // fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ToggleButtons(
                  borderRadius: BorderRadius.circular(10),
                  fillColor: Colors.white,
                  borderColor: lightGray,
                  selectedBorderColor: primaryBlue,
                  onPressed: (int index) {
                    setState(() {
                      _isSelected[index] = !_isSelected[index];
                      _isNotButtonDisable = !_isNotButtonDisable;
                    });
                  },
                  isSelected: _isSelected,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 2.5),
                      width: 100,
                      child: const Column(
                        children: [
                          Image(
                            image: AssetImage('assets/images/happy.png'),
                            width: 25,
                            height: 25,
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 10),
                            child: Text(
                              "Healthy",
                              style: TextStyle(
                                fontSize: 13,
                                color: gray,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 15),
                OutlinedButton(
                  onPressed: () {
                    if (_homeController.isInsideVicinity.isTrue) {
                      context.push('/health_declaration');
                    } else {
                      if (reason != null) {
                        context.push('/health_declaration');
                      } else {
                        reasonError = "Reason/purpose field is required";
                      }
                    }
                    setState(() {});
                  },
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    side: const BorderSide(color: lightGray),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Column(
                    children: [
                      Image(
                        image: AssetImage('assets/images/sad.png'),
                        width: 25,
                        height: 25,
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 10),
                        child: SizedBox(
                          width: 100,
                          child: Text(
                            "Sick",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 13,
                              color: gray,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget bottomButtons(Size size) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        RoundedCustomButton(
          onPressed: () {
            _homeInfoKey.currentContext?.pop();
          },
          label: 'Close',
          radius: 8,
          bgColor: gray,
          size: Size(size.width * .4, 40),
        ),
        Obx(
          () => RoundedCustomButton(
            onPressed: () {
              if (_isNotButtonDisable) {
                if (_homeController.isInsideVicinity.isTrue) {
                  clockInOut();
                } else {
                  if (reason != null) {
                    clockInOut();
                  } else {
                    reasonError = "Reason/purpose field is required";
                  }
                }
              }
              setState(() {});
            },
            isLoading: _homeController.isLoading.isTrue,
            label: _homeController.isClockOut.isTrue ? 'Clock out' : 'Clock in',
            radius: 8,
            bgColor: _homeController.isClockOut.isTrue
                ? colorError
                : _isNotButtonDisable
                    ? colorSuccess
                    : lightGray,
            size: Size(size.width * .4, 40),
          ),
        ),
      ],
    );
  }

  void clockInOut() {
    if (_homeController.isClockOut.isFalse) {
      _homeController.clockIn().then((value) {
        _homeController.isLoading.value = false;
        context.go('/result');
      });
    } else if (_homeController.isClockOut.isTrue) {
      _homeController.clockOut(context: context).then((value) {
        _homeController.isLoading.value = false;
        context.go('/result');
      });
    }
  }
}
