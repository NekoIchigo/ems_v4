import 'package:ems_v4/controller/home_controller.dart';
import 'package:ems_v4/global/constants.dart';
import 'package:ems_v4/global/services/auth_service.dart';
import 'package:ems_v4/views/widgets/buttons/rounded_custom_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AdditionalShiftInfo extends StatefulWidget {
  final bool isClockin;
  const AdditionalShiftInfo({super.key, required this.isClockin});

  @override
  State<AdditionalShiftInfo> createState() => _AdditionalShiftInfoState();
}

class _AdditionalShiftInfoState extends State<AdditionalShiftInfo> {
  final AuthService _authViewService = Get.find<AuthService>();
  final HomeController _homeController = Get.find<HomeController>();

  bool _isNotButtonDisable = false;

  final List<String> _list = <String>[
    'Render Service to other Location',
    'Other Reasons',
  ];

  String? selectedReason;

  final List<String> _location_list = <String>[
    'EDSA Starmall Shaw',
    'WCC Bldg, Shaw Blvd Cor Edsa',
    'Test Building',
  ];

  String? selectedLocation;

  @override
  void initState() {
    super.initState();
    selectedReason = _list[0];
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Obx(
        () => Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 80),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 40),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Center(
                  child: Image.asset(
                    "assets/images/additional_shift.png",
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
              const Text(
                'View Map',
                style: TextStyle(
                  decoration: TextDecoration.underline,
                  color: darkGray,
                  fontSize: 12,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: DropdownMenu<String>(
                  width: Get.width * .9,
                  initialSelection: _list[0],
                  textStyle: const TextStyle(color: darkGray),
                  onSelected: (String? value) {
                    setState(() {
                      selectedReason = value;
                    });
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
              Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child: DropdownMenu<String>(
                  width: Get.width * .9,
                  hintText: "Select Location",
                  textStyle: const TextStyle(color: darkGray),
                  onSelected: (String? value) {
                    setState(() {
                      selectedLocation = value;
                      if (selectedLocation != null && selectedReason != null) {
                        _isNotButtonDisable = true;
                      }
                    });
                  },
                  dropdownMenuEntries: _location_list
                      .map<DropdownMenuEntry<String>>((String value) {
                    return DropdownMenuEntry<String>(
                      value: value,
                      label: value,
                    );
                  }).toList(),
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
                          text: widget.isClockin ? 'Clock In ' : 'Clock Out '),
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
                        _homeController
                            .additionalShiftClockin(
                          selectedReason!,
                          selectedLocation!,
                        )
                            .then((value) {
                          _homeController.pageName.value = '/home/result';
                        });
                      } else if (!widget.isClockin) {
                        _homeController
                            .additionalShiftClockout(
                          selectedReason!,
                          selectedLocation!,
                        )
                            .then((value) {
                          _homeController.pageName.value = '/home/result';
                        });
                      }
                    },
                    label: !widget.isClockin ? 'Clock out' : 'Clock in',
                    radius: 8,
                    bgColor: !widget.isClockin
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
