import 'dart:async';
import 'dart:convert';

import 'package:ems_v4/global/api.dart';
import 'package:ems_v4/global/controller/auth_controller.dart';
import 'package:ems_v4/router/router.dart';
import 'package:ems_v4/views/widgets/dialog/gems_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
// import 'package:web_socket_channel/status.dart' as status;

class MessageController extends GetxController {
  final AuthController _auth = Get.find<AuthController>();
  late StreamSubscription subscription;
  final ApiCall _apiCall = ApiCall();
  late Rx<WebSocketChannel> channel;
  String? currentChannel;
  RxBool isLoading = false.obs, isListening = false.obs, isSending = false.obs;
  RxString messagingType = "".obs, parentId = "".obs;
  RxMap channelData = {"message": null}.obs;
  RxList chatHistory = [].obs;

  Future<void> subscribeInChannel({String channelName = "ems-chat"}) async {
    try {
      final wsUrl = Uri.parse('wss://dev-api.globallandexchange.com.ph');
      channel = WebSocketChannel.connect(wsUrl).obs;

      await channel.value.ready;

      // Subscribe to a channel
      channel.value.sink.add(
        jsonEncode({
          "action": "subscribe",
          "channel": channelName,
        }),
      );
      channel.value.stream.listen((message) {
        fetchChatHistory(parentId.value, messagingType.value);
      });
      currentChannel = channelName;
    } catch (error) {
      // showDialog(
      //   context: navigatorKey.currentContext!,
      //   builder: (context) {
      //     return GemsDialog(
      //       title: "",
      //       hasMessage: true,
      //       hasLottie: false,
      //       withCloseButton: true,
      //       hasCustomWidget: true,
      //       customWidget: Column(
      //         children: [
      //           Image.asset('assets/images/no_data.png', width: 400),
      //         ],
      //       ),
      //       message: "Channel subscription: $error",
      //       type: "error",
      //       buttonNumber: 0,
      //     );
      //   },
      // );
    }
  }

  Future fetchChatHistory(String parentId, String type) async {
    isLoading.value = true;
    var response = await _apiCall.getRequest(
      apiUrl: '/fetch-chats',
      parameters: {
        "parent_id": parentId,
        "type": type,
      },
      catchError: () {
        isLoading.value = false;
      },
    );
    isLoading.value = false;
    chatHistory.value = response["data"];
  }

  void unsubscribeInChannel() {
    if (currentChannel != null) {
      channel.value.sink.add(
        jsonEncode({
          "action": "unsubscribe",
          "channel": currentChannel,
        }),
      );
      subscription.cancel();
    }
  }

  Future<void> sendMessageInChannel({
    String? message,
    required List attachment,
    required String type,
    required String parentId,
  }) async {
    isSending.value = true;
    var response = await _apiCall.postRequest(
        apiUrl: '/send-chat',
        data: {
          "company_id": _auth.company.value.id,
          "parent_id": parentId,
          "type": type,
          "employee_id": _auth.employee?.value.id,
          "message": message ?? " ",
          "attachments": attachment,
        },
        catchError: () {
          isSending.value = false;
        });
    if (response.containsKey('success') && response['success']) {
      final payloadMessage = {
        'type': 'chat',
        'user_id': _auth.employee?.value.userId,
        'employee_id': _auth.employee?.value.id,
        'company_id': _auth.company.value.id,
        'parent_id': parentId,
        'message': message ?? "",
        'attachments': attachment,
        'employee_name': _auth.employee?.value.fullName(),
        'status': 'Delivered',
        'created_at': 'none',
      };
      final payload = jsonEncode({
        'action': 'message',
        'channel': 'ems-chat',
        // currentChannel,
        'message': payloadMessage,
      });
      channel.value.sink.add(payload);
      await fetchChatHistory(parentId, type);
    }
    isSending.value = false;
  }

  void sendTypingStatusInChannel(bool isTyping, String parentId) {
    final payloadMessage = {
      // "channel": "${messagingType.value}-$parentId",
      // "message": {
      "type": "leave-request-chat",
      "parent_id": 1,
      "user_id": _auth.employee?.value.userId,
      "user_fullname": _auth.employee?.value.fullName(),
      "isTyping": isTyping,
      // }
    };
    final payload = jsonEncode({
      'action': 'message',
      'channel': currentChannel,
      'message': payloadMessage,
    });
    channel.value.sink.add(payload);
  }
}
