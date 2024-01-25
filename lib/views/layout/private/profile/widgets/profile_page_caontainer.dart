import 'package:ems_v4/global/constants.dart';
import 'package:ems_v4/views/widgets/builder/ems_container.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfilePageContainer extends StatefulWidget {
  final String title;
  final Widget child;
  const ProfilePageContainer(
      {super.key, required this.title, required this.child});

  @override
  State<ProfilePageContainer> createState() => _ProfilePageContainerState();
}

class _ProfilePageContainerState extends State<ProfilePageContainer> {
  @override
  Widget build(BuildContext context) {
    return EMSContainer(
      child: SizedBox(
        width: Get.width,
        child: Stack(
          children: [
            Positioned(
              right: 10,
              top: 5,
              child: IconButton(
                onPressed: () {
                  Get.back();
                },
                icon: const Icon(Icons.close),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 50),
                  Center(
                    child: Text(
                      widget.title,
                      style: const TextStyle(
                        color: darkGray,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  widget.child,
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
