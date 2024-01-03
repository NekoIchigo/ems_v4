import 'package:ems_v4/controller/home_controller.dart';
import 'package:ems_v4/global/constants.dart';
import 'package:ems_v4/global/services/auth_service.dart';
import 'package:ems_v4/views/widgets/buttons/rounded_custom_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
  String? _dropdownValue;
  final List<String> _list = <String>[
    'Field work',
    'Office/site visit',
    'Work from home'
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Obx(
        () => Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Padding(
              //   padding: const EdgeInsets.symmetric(vertical: 8.0),
              //   child: Center(
              //     child: Column(
              //       children: [
              //         Padding(
              //           padding: const EdgeInsets.symmetric(vertical: 8.0),
              //           child: Text(
              //             _homeController.isClockOut.isTrue
              //                 ? 'CLOCK-OUT'
              //                 : 'CLOCK-IN',
              //             style: const TextStyle(
              //                 color: darkGray,
              //                 fontSize: 24,
              //                 fontWeight: FontWeight.w600),
              //           ),
              //         ),
              //         Text(
              //           _authViewService.company.value.name,
              //           style: const TextStyle(
              //               color: primaryBlue, fontWeight: FontWeight.bold),
              //         ),
              //       ],
              //     ),
              //   ),
              // ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Center(
                  child: Image.asset(
                    _homeController.isOustideVicinity.isFalse
                        ? "assets/images/current_location-pana.png"
                        : "assets/images/current_location-rafiki.png",
                    width: Get.width * .70,
                  ),
                ),
              ),
              // Row(
              //   children: [
              //     const Icon(
              //       Icons.thumb_up_alt_outlined,
              //       color: primaryBlue,
              //     ),
              //     const SizedBox(width: 10),
              //     Text(
              //       _homeController.isOustideVicinity.isFalse
              //           ? 'You are within the vicinity!'
              //           : 'You are outside the vicinity!',
              //       style: const TextStyle(
              //         color: darkGray,
              //         fontWeight: FontWeight.w600,
              //       ),
              //     ),
              //   ],
              // ),
              Text(
                _authViewService.company.value.name,
                style: const TextStyle(
                  color: primaryBlue,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: InkWell(
                  onTap: () {},
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // const Icon(
                          //   Icons.location_on,
                          //   color: darkGray,
                          // ),
                          // const SizedBox(width: 10),
                          Flexible(
                            child: Text(
                              // "${_homeController.isClockOut.isTrue ? _homeController.attendance.value.clockedInLocation ?? 'Location' : _homeController.attendance.value.clockedOutLocation ?? 'Location'} - View Map",
                              _homeController.currentLocation.value,
                              style: const TextStyle(color: darkGray),
                            ),
                          ),
                        ],
                      ),
                      const Text(
                        'View Map',
                        style: TextStyle(
                          decoration: TextDecoration.underline,
                          color: darkGray,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Visibility(
                visible: _homeController.isOustideVicinity.value,
                child: Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 10.0),
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                            color: const Color(0xFFC4C4C4),
                            style: BorderStyle.solid,
                            width: 0.80),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          hint: const Text(
                            "Select your reason/purpose here",
                            style: TextStyle(color: gray),
                          ),
                          value: _dropdownValue,
                          dropdownColor: Colors.white,
                          elevation: 16,
                          isExpanded: true,
                          style: const TextStyle(color: darkGray),
                          onChanged: (String? value) {
                            // This is called when the user selects an item.
                            setState(() {
                              _dropdownValue = value!;
                            });
                          },
                          items: _list
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ],
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
                            // Icon(
                            //   CupertinoIcons.heart_circle,
                            //   color: primaryBlue,
                            // ),
                            // SizedBox(width: 10),
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
                                // isFine = !isFine;
                                // isHealthCheck = !isHealthCheck;
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
              Visibility(
                visible: _homeController.isClockOut.isTrue,
                child: const SizedBox(height: 10),
              ),
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
                          text: _homeController.isOustideVicinity.isFalse
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
                            context: context,
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
