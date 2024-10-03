import 'package:ems_v4/global/constants.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

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
    Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        // Unfocus any text field when tapping outside of them
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        width: size.width,
        child: Stack(
          children: [
            Positioned(
              right: 10,
              top: 5,
              child: IconButton(
                onPressed: () {
                  context.pop();
                },
                icon: const Icon(Icons.close),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40.0),
              child: SizedBox(
                height: size.height * .9,
                child: SingleChildScrollView(
                  padding: EdgeInsetsDirectional.zero,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 50),
                      Center(
                        child: Text(
                          widget.title,
                          style: const TextStyle(
                            color: bgSecondaryBlue,
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
              ),
            ),
          ],
        ),
      ),
    );
  }
}
