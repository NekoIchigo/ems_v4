import 'package:ems_v4/global/constants.dart';
import 'package:ems_v4/views/widgets/buttons/rounded_custom_button.dart';
import 'package:flutter/material.dart';

class MessageTab extends StatefulWidget {
  const MessageTab({super.key});

  @override
  State<MessageTab> createState() => _MessageTabState();
}

class _MessageTabState extends State<MessageTab> {
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
              child: StreamBuilder(
                initialData: const [
                  {"id": 1, "message": "Hi"},
                  {"id": 2, "message": "Hello"},
                ],
                stream: const Stream.empty(),
                builder: (context, snapshot) {
                  return Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const CircleAvatar(
                            radius: 18,
                            backgroundImage: NetworkImage(
                              'https://firebasestorage.googleapis.com/v0/b/agap-f4c32.appspot.com/o/profile%2Fperson.png?alt=media&token=947f5244-0157-43ab-8c3e-349ae9699415',
                              scale: 0.1,
                            ),
                          ),
                          Container(
                            width: size.width * .72,
                            padding: const EdgeInsets.symmetric(
                              vertical: 10,
                              horizontal: 20,
                            ),
                            decoration: BoxDecoration(
                              color: bgSky,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(snapshot.data.first["message"]),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: size.width * .72,
                            padding: const EdgeInsets.symmetric(
                              vertical: 10,
                              horizontal: 20,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.green[200],
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              snapshot.data[1]["message"],
                              textAlign: TextAlign.right,
                            ),
                          ),
                          const CircleAvatar(
                            radius: 18,
                            backgroundImage: NetworkImage(
                              'https://firebasestorage.googleapis.com/v0/b/agap-f4c32.appspot.com/o/profile%2Fperson.png?alt=media&token=947f5244-0157-43ab-8c3e-349ae9699415',
                              scale: 0.1,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: size.width * .72,
                            padding: const EdgeInsets.symmetric(
                              vertical: 10,
                              horizontal: 20,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.green[200],
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Text(
                              "User sent an attachment.",
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                          const CircleAvatar(
                            radius: 18,
                            backgroundImage: NetworkImage(
                              'https://firebasestorage.googleapis.com/v0/b/agap-f4c32.appspot.com/o/profile%2Fperson.png?alt=media&token=947f5244-0157-43ab-8c3e-349ae9699415',
                              scale: 0.1,
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text("Message"),
            ),
            const SizedBox(height: 10),
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
                      Icon(Icons.add_circle_outline_sharp),
                      SizedBox(width: 10),
                      Text("Add attachment"),
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
              height: MediaQuery.of(context).viewInsets.bottom + 100,
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