import 'dart:convert';

import 'package:ems_v4/global/constants.dart';
import 'package:ems_v4/global/controller/auth_controller.dart';
import 'package:ems_v4/global/controller/message_controller.dart';
import 'package:ems_v4/global/utils/date_time_utils.dart';
import 'package:ems_v4/views/widgets/buttons/rounded_custom_button.dart';
import 'package:ems_v4/views/widgets/no_result.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MessageTab extends StatefulWidget {
  const MessageTab({super.key});

  @override
  State<MessageTab> createState() => _MessageTabState();
}

class _MessageTabState extends State<MessageTab>
    with AutomaticKeepAliveClientMixin {
  final MessageController _messaging = Get.find<MessageController>();
  final AuthController _auth = Get.find<AuthController>();
  final DateTimeUtils _dateTimeUtils = DateTimeUtils();
  final TextEditingController _messageController = TextEditingController();
  final _focusNode = FocusNode();

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_handleFocusChange);
  }

  @override
  void dispose() {
    _focusNode.removeListener(_handleFocusChange);
    _focusNode.dispose(); // Dispose of the FocusNode on widget disposal
    super.dispose();
  }

  void _handleFocusChange() {
    if (_focusNode.hasFocus) {
      _messaging.sendTypingStatusInChannel(
          true, _messaging.chatHistory.firstOrNull["parent_id"].toString());
    } else {
      _messaging.sendTypingStatusInChannel(
          false, _messaging.chatHistory.firstOrNull["parent_id"].toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    Size size = MediaQuery.of(context).size;
    return
        // const NoResult();

        Padding(
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
                    stream: _messaging.channel.value.stream,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        var data = snapshot.data;
                        bool? isTyping = false;
                        String? userFullName = '';
                        if (snapshot.data is String) {
                          data = jsonDecode(snapshot.data);
                          isTyping = data['message']['isTyping'];
                          userFullName = data['message']['user_fullname'];
                        }
                        //
                        return Obx(
                          () => Stack(
                            children: [
                              Visibility(
                                visible: _messaging.chatHistory.isNotEmpty,
                                child: ListView.builder(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 10),
                                  itemCount: _messaging.chatHistory.length,
                                  itemBuilder: (context, index) {
                                    bool isSameUser = false;
                                    bool isCurrentUser = _messaging
                                            .chatHistory[index]['user_id'] ==
                                        _auth.employee!.value.userId;
                                    DateTime createdAt = DateTime.parse(
                                        _messaging.chatHistory[index]
                                                ['created_at']
                                            .toString());
                                    if (index != 0) {
                                      isSameUser = _messaging.chatHistory[index]
                                              ['user_id'] ==
                                          _messaging.chatHistory[index - 1]
                                              ['user_id'];
                                    }
                                    return Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              bottom: 10.0),
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: isCurrentUser
                                                ? chatRow(isSameUser, size,
                                                        index, createdAt)
                                                    .reversed
                                                    .toList()
                                                : chatRow(isSameUser, size,
                                                    index, createdAt),
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                ),
                              ),
                              Visibility(
                                visible: _messaging.chatHistory.isEmpty,
                                child: const NoResult(),
                              ),
                              Positioned(
                                bottom: 0,
                                left: 0,
                                width: size.width,
                                child: Visibility(
                                  visible: (snapshot.connectionState ==
                                          ConnectionState.active &&
                                      (isTyping ?? false)),
                                  child: Container(
                                    color: Colors.white,
                                    child: Text(
                                      "$userFullName is typing...",
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
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
              focusNode: _focusNode,
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
                Obx(
                  () => RoundedCustomButton(
                    onPressed: () {
                      _messaging.sendMessageInChannel(
                        message: _messageController.text,
                        parentId: _messaging
                            .chatHistory.firstOrNull["parent_id"]
                            .toString(),
                        type: _messaging.messagingType.value,
                      );
                    },
                    label: "Send",
                    radius: 5,
                    isLoading: _messaging.isLoading.isTrue,
                    icon: const Icon(
                      Icons.send_rounded,
                      color: Colors.white,
                    ),
                    size: Size(size.width * .4, 20),
                  ),
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
                  _messaging.chatHistory[index]['message'].toString(),
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
