import 'package:ems_v4/controller/home_controller.dart';
import 'package:ems_v4/global/constants.dart';
import 'package:ems_v4/global/services/auth_service.dart';
import 'package:ems_v4/views/widgets/buttons/rounded_custom_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeInfoPage extends StatefulWidget {
  const HomeInfoPage({super.key});

  @override
  State<HomeInfoPage> createState() => _HomeInfoPageState();
}

class _HomeInfoPageState extends State<HomeInfoPage> {
  final AuthService _authViewService = Get.find<AuthService>();
  final HomeController _homeController = Get.find<HomeController>();
  final List<bool> _isSelected = [false];
  bool _isNotButtonDisable = false;

  final List<String> _list = <String>[
    'Field work',
    'Office/site visit',
    'Work from home'
  ];

  Future<void> _launchInBrowser() async {
    // const String baseUrl = 'http://10.10.10.221:8000/mobile-map-view';
    const String baseUrl = "https://stg-ems.globalland.com.ph/mobile-map-view";
    String latLong = _homeController.isClockOut.isTrue
        ? "?latitude=${_homeController.attendance.value.clockedOutLatitude}&longitude=${_homeController.attendance.value.clockedOutLongitude}"
        : "?latitude=${_homeController.attendance.value.clockedInLatitude}&longitude=${_homeController.attendance.value.clockedInLongitude}";
    if (!await launchUrl(Uri.parse("$baseUrl$latLong"))) {
      throw Exception('Could not launch $baseUrl$latLong');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Obx(
        () => Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 50),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Center(
                  child: Image.asset(
                    _homeController.isInsideVicinity.value
                        ? "assets/images/current_location-pana.png"
                        : "assets/images/current_location-rafiki.png",
                    width: Get.width * .70,
                  ),
                ),
              ),
              Text(
                _authViewService.company.value.name,
                style: const TextStyle(
                  color: primaryBlue,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                _homeController.currentLocation.value,
                style: const TextStyle(color: darkGray),
                textAlign: TextAlign.center,
              ),
              InkWell(
                onTap: () {
                  _launchInBrowser();
                  // Get.to(() => const PlaceMap());
                },
                child: const Text(
                  'View Map',
                  style: TextStyle(
                    decoration: TextDecoration.underline,
                    color: darkGray,
                    fontSize: 12,
                  ),
                ),
              ),
              Visibility(
                visible: _homeController.isInsideVicinity.isFalse,
                child: Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: DropdownMenu<String>(
                    width: Get.width * .9,
                    hintText: "Select your reason/purpose here",
                    textStyle: const TextStyle(color: darkGray),
                    onSelected: (String? value) {
                      if (_homeController.isClockOut.isFalse) {
                        _homeController
                            .attendance.value.clockedInLocationSetting = value!;
                      } else {
                        _homeController
                            .attendance.value.clockedOutLocationType = value!;
                      }
                    },
                    dropdownMenuEntries:
                        _list.map<DropdownMenuEntry<String>>((String value) {
                      return DropdownMenuEntry<String>(
                        value: value,
                        label: value,
                      );
                    }).toList(),
                  ),
                ),
              ),
              Visibility(
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
                                color: darkGray,
                                fontWeight: FontWeight.w600,
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
                            borderWidth: 2,
                            selectedBorderColor: primaryBlue,
                            onPressed: (int index) {
                              setState(() {
                                _isSelected[index] = !_isSelected[index];
                                _isNotButtonDisable = !_isNotButtonDisable;
                              });
                            },
                            isSelected: _isSelected,
                            children: const [
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 14),
                                child: Column(
                                  children: [
                                    Image(
                                      image:
                                          AssetImage('assets/images/happy.png'),
                                      width: 25,
                                      height: 25,
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(top: 10),
                                      child: Text(
                                        "I am perfectly fine",
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: darkGray,
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
                              _homeController.pageName.value =
                                  '/home/health_declaration';
                            },
                            style: OutlinedButton.styleFrom(
                              side:
                                  const BorderSide(width: 2, color: lightGray),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                            ),
                            child: const Padding(
                              padding: EdgeInsets.symmetric(vertical: 10),
                              child: Column(
                                children: [
                                  Image(
                                    image: AssetImage('assets/images/sad.png'),
                                    width: 25,
                                    height: 25,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(top: 10),
                                    child: Text(
                                      "I feel unwell today",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: darkGray,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 0, horizontal: 5.0),
                child: Text.rich(
                  TextSpan(
                    children: [
                      const TextSpan(
                        text: 'By clicking ',
                      ),
                      TextSpan(
                          text: _homeController.isClockOut.isFalse
                              ? 'Clock In '
                              : 'Clock Out '),
                      const TextSpan(
                          text:
                              ', you confirm your location and affirm your health condition.')
                    ],
                  ),
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: darkGray, fontSize: 12),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  RoundedCustomButton(
                    onPressed: () {
                      _homeController.isWhite.value = false;
                      _homeController.pageName.value = '/home';
                      // Get.back(id: _homeController.routerKey);
                    },
                    label: 'Close',
                    radius: 8,
                    bgColor: darkGray,
                    size: Size(Get.width * .4, 40),
                  ),
                  RoundedCustomButton(
                    onPressed: () {
                      if (_isNotButtonDisable) {
                        if (_homeController.isClockOut.isFalse) {
                          _homeController
                              .clockIn(
                            employeeId: _authViewService.employee.value.id,
                          )
                              .then((value) {
                            _homeController.pageName.value = '/home/result';
                          });
                        }
                      } else if (_homeController.isClockOut.isTrue) {
                        _homeController
                            .clockOut(context: context)
                            .then((value) {
                          _homeController.pageName.value = '/home/result';
                        });
                      }
                    },
                    label: _homeController.isClockOut.isTrue
                        ? 'Clock out'
                        : 'Clock in',
                    radius: 8,
                    bgColor: _homeController.isClockOut.isTrue
                        ? colorError
                        : _isNotButtonDisable
                            ? colorSuccess
                            : lightGray,
                    size: Size(Get.width * .4, 40),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
