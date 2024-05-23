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
  late WebSocketChannel channel;
  late StreamSubscription subscription;
  final AuthController _auth = Get.find<AuthController>();
  String? currentChannel;
  RxBool isLoading = false.obs;
  RxMap channelData = {"message": null}.obs;
  RxList chatHistory = [].obs;
  ApiCall _apiCall = ApiCall();

  Future<void> subscribeInChannel({String channelName = "ems-chat"}) async {
    try {
      final wsUrl = Uri.parse('wss://dev-api.globallandexchange.com.ph');
      channel = WebSocketChannel.connect(wsUrl);

      await channel.ready;

      // Subscribe to a channel
      channel.sink.add(
        jsonEncode({
          "action": "subscribe",
          "channel": channelName,
        }),
      );
      print("listening");
      currentChannel = channelName;
      // subscription = channel.stream.listen((message) {
      //   channelData.value = message;
      // });
    } catch (error) {
      showDialog(
        context: navigatorKey.currentContext!,
        builder: (context) {
          return GemsDialog(
            title: "",
            hasMessage: true,
            hasLottie: false,
            withCloseButton: true,
            hasCustomWidget: true,
            customWidget: Column(
              children: [
                Image.asset('assets/images/no_data.png', width: 400),
              ],
            ),
            message: "Channel subscription: $error",
            type: "error",
            buttonNumber: 0,
          );
        },
      );
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
    print(response);
    chatHistory.value = response["data"];
  }

  void unsubscribeInChannel() {
    if (currentChannel != null) {
      channel.sink.add(
        jsonEncode({
          "action": "unsubscribe",
          "channel": currentChannel,
        }),
      );
      subscription.cancel();
    }
  }

  void sendMessageInChannel({
    String? message,
    required String parentId,
  }) {
    final payloadMessage = {
      'type': 'chat',
      'user_id': _auth.employee?.value.userId,
      'employee_id': _auth.employee?.value.id,
      'company_id': _auth.company.value.id,
      'parent_id': parentId,
      'message': message,
      'attachments': [],
      'employee_name': _auth.employee?.value.fullName(),
      'status': 'Delivered',
      'created_at': 'none',
    };

    final payload = jsonEncode({
      'action': 'message',
      'channel': currentChannel,
      'message': payloadMessage,
    });

    channel.sink.add(payload);
  }
}
