import 'package:ems_v4/global/constants.dart';
import 'package:ems_v4/views/widgets/inputs/input.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile>
    with SingleTickerProviderStateMixin {
  bool _isExpanded = false;
  TextEditingController _contactNumber = TextEditingController();

  late AnimationController _animationController;
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        border: Border.all(color: gray),
        borderRadius: BorderRadius.circular(10),
      ),
      child: ExpansionPanelList(
        elevation: 0,
        expandedHeaderPadding: const EdgeInsets.all(0),
        expansionCallback: (int index, bool isExpanded) {
          setState(() {
            _isExpanded = !_isExpanded;
            if (_isExpanded) {
              _animationController.forward();
            } else {
              _animationController.reverse();
            }
          });
        },
        children: [
          ExpansionPanel(
            canTapOnHeader: true,
            headerBuilder: (BuildContext context, bool isExpanded) {
              return const ListTile(
                title: Text('Account Settings'),
              );
            },
            body: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, -1),
                end: const Offset(0, 0),
              ).animate(CurvedAnimation(
                parent: _animationController,
                curve: Curves.easeInOut,
              )),
              child: SizedBox(
                width: Get.width * .8,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Column(
                        children: [
                          Container(
                            height: 100,
                            width: 100,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: gray, width: 1.5),
                              shape: BoxShape.circle,
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.grey,
                                  // Offset of the shadow
                                  offset: Offset(0, 5),
                                  // Spread of the shadow
                                  blurRadius: 6,
                                  // How much the shadow should be spread
                                  spreadRadius: 0,
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.image_search,
                              size: 30,
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 10.0),
                            child: Text("Upload Photo"),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text('Personal Information'),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Input(
                            label: "Contact Number",
                            isPassword: false,
                            textController: _contactNumber,
                          ),
                          const SizedBox(height: 10),
                          Input(
                            label: "Email Address",
                            isPassword: false,
                            textController: _contactNumber,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text('Change Password'),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Input(
                            label: "Current Password",
                            isPassword: true,
                            textController: _contactNumber,
                          ),
                          const SizedBox(height: 10),
                          Input(
                            label: "New Password",
                            isPassword: true,
                            textController: _contactNumber,
                          ),
                          const SizedBox(height: 10),
                          Input(
                            label: "Re-enter Password",
                            isPassword: true,
                            textController: _contactNumber,
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            isExpanded: _isExpanded,
          ),
        ],
      ),
    );
  }
}
