import 'package:ems_v4/global/constants.dart';
import 'package:ems_v4/views/widgets/buttons/rounded_custom_button.dart';
import 'package:flutter/material.dart';

class MessageTab extends StatelessWidget {
  const MessageTab({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            Container(
              height: size.height * .35,
              width: size.width,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
              decoration: BoxDecoration(
                border: Border.all(color: gray),
                borderRadius: BorderRadius.circular(5),
              ),
              child: const Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Message"),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text("Message"),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            TextFormField(
              maxLines: 3,
              decoration: const InputDecoration(
                hintText: "Enter your message here...",
                hintStyle: TextStyle(color: lightGray),
                isDense: true,
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: gray,
                  ),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () {},
                  child: const Row(
                    children: [
                      Icon(Icons.attach_file_rounded),
                      Text("Attach file"),
                    ],
                  ),
                ),
                RoundedCustomButton(
                  onPressed: () {},
                  label: "Send",
                  radius: 5,
                  icon: const Icon(
                    Icons.send_rounded,
                    color: Colors.white,
                  ),
                  size: Size(size.width * .3, 20),
                )
              ],
            ),
            const SizedBox(height: 10),
            Container(
              height: MediaQuery.of(context).viewInsets.bottom + 250,
            ),
          ],
        ),
      ),
    );
  }
}


/*
Positioned(
                    bottom: 0,
                    left: 0,
                    child: Container(
                      width: size.width * .9,
                      decoration: const BoxDecoration(
                        border: Border(top: BorderSide(color: gray)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            IconButton(
                              onPressed: () {},
                              style: const ButtonStyle(
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                              icon: const Icon(
                                Icons.attach_file_rounded,
                                color: primaryBlue,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: TextFormField(
                                decoration: const InputDecoration(
                                  isDense: true,
                                  contentPadding:
                                      EdgeInsetsDirectional.symmetric(
                                    vertical: 8,
                                    horizontal: 15,
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    gapPadding: 0,
                                    borderSide: BorderSide(color: lightGray),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(50),
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    gapPadding: 0,
                                    borderSide: BorderSide(color: lightGray),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(50),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            IconButton(
                              onPressed: () {},
                              style: const ButtonStyle(
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                              icon: const Icon(
                                Icons.send_rounded,
                                color: primaryBlue,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

 */