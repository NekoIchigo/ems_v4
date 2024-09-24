import 'dart:convert';
import 'dart:io';

import 'package:ems_v4/global/api.dart';
import 'package:ems_v4/global/constants.dart';
import 'package:ems_v4/global/controller/auth_controller.dart';
import 'package:ems_v4/global/controller/message_controller.dart';
import 'package:ems_v4/views/widgets/builder/column_builder.dart';
import 'package:ems_v4/views/widgets/buttons/rounded_custom_button.dart';
import 'package:ems_v4/views/widgets/no_result.dart';
import 'package:file_picker/file_picker.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:open_file/open_file.dart';

class MessageTab extends StatefulWidget {
  const MessageTab({super.key});

  @override
  State<MessageTab> createState() => _MessageTabState();
}

class _MessageTabState extends State<MessageTab>
    with AutomaticKeepAliveClientMixin {
  final MessageController _messaging = Get.find<MessageController>();
  final AuthController _auth = Get.find<AuthController>();
  final ApiCall _apiCall = ApiCall();
  final TextEditingController _messageController = TextEditingController();
  final _focusNode = FocusNode();
  late Size size;
  List<Map> files = [];
  List<bool> loadings = [false, false];

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _messaging.subscribeInChannel();
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
      _messaging.sendTypingStatusInChannel(true, _messaging.parentId.value);
    } else {
      _messaging.sendTypingStatusInChannel(false, _messaging.parentId.value);
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
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
            child: Obx(
              () => ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: _messaging.chatHistory.length,
                itemBuilder: (context, index) {
                  bool isReceiver = false;
                  final message = _messaging.chatHistory[index];

                  final List attachments = message["attachments"];
                  if (_messaging.chatHistory.isNotEmpty) {
                    isReceiver =
                        _auth.employee!.value.userId == message['user_id'];
                  }

                  return _messaging.chatHistory.isNotEmpty
                      ? Container(
                          margin: const EdgeInsets.symmetric(vertical: 5),
                          width: size.width,
                          child: Row(
                            mainAxisAlignment: isReceiver
                                ? MainAxisAlignment.end
                                : MainAxisAlignment.start,
                            children: [
                              Visibility(
                                visible: isReceiver,
                                child:
                                    chatBox(isReceiver, message, attachments),
                              ),
                              Visibility(
                                visible: isReceiver,
                                child: const SizedBox(width: 10),
                              ),
                              CircleAvatar(
                                radius: 16,
                                backgroundImage: AssetImage(isReceiver
                                    ? "assets/images/receiver_img.png"
                                    : "assets/images/sender_img.png"),
                              ),
                              Visibility(
                                visible: !isReceiver,
                                child: const SizedBox(width: 10),
                              ),
                              Visibility(
                                visible: !isReceiver,
                                child:
                                    chatBox(isReceiver, message, attachments),
                              ),
                            ],
                          ),
                        )
                      : const NoResult();
                },
              ),
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
          attachment(files),
          Obx(
            () => RoundedCustomButton(
              onPressed: () {
                _messaging.sendMessageInChannel(
                  message: _messageController.text,
                  parentId: _messaging.parentId.value,
                  type: _messaging.messagingType.value,
                  attachment: files,
                );
                setState(() {
                  _messageController.text = "";
                });
              },
              label: "Send",
              radius: 5,
              isLoading: _messaging.isLoading.isTrue,
              size: Size(size.width * .4, 20),
            ),
          ),
          const SizedBox(height: 10),
          Container(
            height: MediaQuery.of(context).viewInsets.bottom + 100,
          ),
        ],
      ),
    );
  }

  Widget attachment(List attachments) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.fromLTRB(0, 10, 0, 5),
          width: size.width * .45,
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () async {
                bool hasError = false;

                FilePickerResult? result = await FilePicker.platform.pickFiles(
                  allowMultiple: true,
                  type: FileType.custom,
                  allowedExtensions: ['jpg', 'pdf', 'jpeg', 'png'],
                );

                if (result != null) {
                  // files = result.paths.map((path) => File(path!)).toList();

                  if (result.files.length > 2) {
                    showMessage('You must select 2 files only.');
                    hasError = true;
                  }
                  for (PlatformFile file in result.files) {
                    if (file.size > 3000000) {
                      showMessage('File must not exceed 3MB');
                      hasError = true;
                    }
                  }
                  if (!hasError) {
                    for (PlatformFile file in result.files) {
                      if (file.path != null) {
                        final actualFile = File(file.path!);
                        List<int> bytes = await actualFile.readAsBytes();
                        files.add({
                          "index": files.length,
                          "file_name": file.name,
                          "file_path": file.path,
                          "base_64": base64Encode(bytes),
                        });
                      }
                    }
                    // widget.onSelectFile(files);
                  }
                } else {
                  showMessage(
                      'You did not select any file or something went bad.');
                }
                setState(() {});
              },
              child: const Row(
                children: [
                  Icon(
                    Icons.add_circle_outline,
                    size: 20,
                    color: primaryBlue,
                  ),
                  SizedBox(width: 5),
                  Text(
                    'Add attachment',
                    style: TextStyle(color: primaryBlue),
                  ),
                ],
              ),
            ),
          ),
        ),
        Visibility(
          visible: attachments.isEmpty,
          child: const Padding(
            padding: EdgeInsets.fromLTRB(5, 0, 0, 15),
            child: Text(
              "Upload up to 2 files (png, jpg, jpeg, pdf | 3 mb maximum size)",
              style: TextStyle(fontSize: 12, color: gray),
            ),
          ),
        ),
        Visibility(
          visible: attachments.isNotEmpty,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
            child: ColumnBuilder(
              itemCount: attachments.length,
              itemBuilder: (context, index) {
                String fileName = attachments[index] is String
                    ? attachments[index].substring(21)
                    : attachments[index]['file_name'];

                return Row(
                  children: [
                    const Icon(
                      Icons.attach_file_rounded,
                      size: 15,
                      color: bgPrimaryBlue,
                    ),
                    Material(
                      child: InkWell(
                        onTap: () {
                          if (attachments[index] is String) {
                            setState(() {
                              loadings[index] = true;
                            });
                            _apiCall.getRequest(
                                apiUrl: "/download",
                                isBlob: true,
                                parameters: {
                                  "path": attachments[index]
                                }).then((response) {
                              OpenFile.open(
                                response['path'],
                                type: response['type'],
                              );
                            }).whenComplete(() {
                              setState(() {
                                loadings[index] = false;
                              });
                            });
                          } else {
                            OpenFile.open(attachments[index]['file_path']);
                          }
                        },
                        child: Text(
                          fileName,
                          style: const TextStyle(
                              color: bgPrimaryBlue,
                              decoration: TextDecoration.underline),
                        ),
                      ),
                    ),
                    const SizedBox(width: 5),
                    InkWell(
                      onTap: () {
                        setState(() {
                          attachments.removeAt(index);
                        });
                      },
                      child: const Icon(
                        Icons.close,
                        size: 15,
                        color: colorError,
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  void showMessage(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.only(
          bottom: size.height - 130,
          right: 20,
          left: 20,
        ),
      ),
    );
  }

  Widget chatBox(bool isReceiver, message, List attachments) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      constraints: BoxConstraints(
        maxWidth: size.width * .5,
      ),
      decoration: BoxDecoration(
          color: isReceiver ? const Color(0xFFf8ffe8) : bgLightBlue,
          borderRadius: BorderRadius.circular(10)),
      child: Column(
        crossAxisAlignment:
            isReceiver ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text(
            message['employee_name'],
            style: const TextStyle(
              color: gray300,
              fontSize: 10,
            ),
          ),
          Text(
            message['message'],
            style: defaultStyle,
            softWrap: true,
          ),
          Visibility(
            visible: attachments.isNotEmpty,
            child: ColumnBuilder(
              itemCount: attachments.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    setState(() {
                      loadings[index] = true;
                    });
                    _apiCall.getRequest(
                        apiUrl: "/download",
                        isBlob: true,
                        parameters: {
                          "path": attachments[index]
                        }).then((response) {
                      OpenFile.open(
                        response['path'],
                        type: response['type'],
                      );
                    }).whenComplete(() {
                      setState(() {
                        loadings[index] = false;
                      });
                    });
                  },
                  child: Row(
                    mainAxisAlignment: isReceiver
                        ? MainAxisAlignment.end
                        : MainAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.attach_file,
                        size: 10,
                        color: bgSecondaryBlue,
                      ),
                      Expanded(
                        child: Text(
                          attachments[index].toString().substring(17),
                          softWrap: true,
                          style: const TextStyle(
                            color: gray400,
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Text(
            message['status'],
            style: const TextStyle(
              color: gray300,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }
}
