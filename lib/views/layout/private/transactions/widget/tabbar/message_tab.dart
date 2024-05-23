import 'dart:convert';

import 'package:ems_v4/global/constants.dart';
import 'package:ems_v4/global/controller/auth_controller.dart';
import 'package:ems_v4/global/controller/message_controller.dart';
import 'package:ems_v4/global/utils/date_time_utils.dart';
import 'package:ems_v4/views/widgets/buttons/rounded_custom_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class MessageTab extends StatefulWidget {
  const MessageTab({super.key});

  @override
  State<MessageTab> createState() => _MessageTabState();
}

class _MessageTabState extends State<MessageTab> {
  final MessageController _messaging = Get.find<MessageController>();
  final AuthController _auth = Get.find<AuthController>();
  final DateTimeUtils _dateTimeUtils = DateTimeUtils();
  final TextEditingController _messageController = TextEditingController();

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
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                border: Border.all(color: gray),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Stack(
                children: [
                  StreamBuilder(
                    initialData: _messaging.chatHistory,
                    stream: _messaging.channel.stream,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        final data = jsonDecode(snapshot.data);
                        print(data);
                        return Stack(
                          children: [
                            ListView.builder(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              itemCount: _messaging.chatHistory.length,
                              itemBuilder: (context, index) {
                                bool isSameUser = false;
                                bool isCurrentUser =
                                    _messaging.chatHistory[index]['user_id'] ==
                                        _auth.employee!.value.userId;
                                DateTime createdAt = DateTime.parse(_messaging
                                    .chatHistory[index]['created_at']
                                    .toString());
                                if (index != 0) {
                                  isSameUser = _messaging.chatHistory[index]
                                          ['user_id'] ==
                                      _messaging.chatHistory[index - 1]
                                          ['user_id'];
                                }
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 10.0),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: isCurrentUser
                                            ? chatRow(isSameUser, size, index,
                                                    createdAt)
                                                .reversed
                                                .toList()
                                            : chatRow(isSameUser, size, index,
                                                createdAt),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                            Positioned(
                                bottom: 0,
                                left: 0,
                                width: size.width,
                                child: Visibility(
                                  visible: (snapshot.connectionState ==
                                          ConnectionState.active &&
                                      data['message']['isTyping']),
                                  child: Container(
                                    color: Colors.white,
                                    child: Text(
                                      "${data['message']['user_fullname']} is typing...",
                                    ),
                                  ),
                                ))
                          ],
                        );
                      } else {
                        return const CircularProgressIndicator();
                      }
                    },
                  ),
                ],
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
              controller: _messageController,
              decoration: const InputDecoration(
                hintText: "Enter your message here...",
                hintStyle: TextStyle(color: lightGray),
                isDense: true,
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: gray,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
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
                  onPressed: () {
                    _messaging.chatHistory.add("element");
                    _messaging.sendMessageInChannel(
                      message: _messageController.text,
                      parentId: _messaging.chatHistory.firstOrNull["parent_id"]
                          .toString(),
                    );
                  },
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

  List<Widget> chatRow(isSameUser, size, index, createdAt) {
    return [
      CircleAvatar(
        radius: 16,
        backgroundImage: NetworkImage(
          isSameUser
              ? "https://images.unsplash.com/photo-1502685104226-ee32379fefbe?ixlib=rb-=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=facearea&facepad=8&w=256&h=256&q=80"
              : "https://images.unsplash.com/photo-1500648767791-00dcc994a43e?ixlib=rb-=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=facearea&facepad=8&w=256&h=256&q=80",
        ),
      ),
      const SizedBox(width: 15),
      Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            constraints: BoxConstraints(
              maxWidth: size.width * .6,
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: 15,
              vertical: 5,
            ),
            decoration: BoxDecoration(
              color: bgSky,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _messaging.chatHistory[index].toString(),
                  softWrap: true,
                ),
                Row(
                  children: [
                    Text(
                      _dateTimeUtils.formatTime(
                        dateTime: createdAt,
                      ),
                      style: const TextStyle(
                        fontSize: 12,
                        color: bgPrimaryBlue,
                      ),
                      softWrap: true,
                    ),
                    const SizedBox(width: 5),
                    Icon(
                      _messaging.chatHistory[index]['status'] == "Seen"
                          ? Icons.visibility_outlined
                          : Icons.check_circle_outline,
                      size: 12,
                      color: bgPrimaryBlue,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    ];
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