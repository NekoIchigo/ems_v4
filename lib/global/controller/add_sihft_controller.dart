import 'package:ems_v4/global/controller/auth_controller.dart';
import 'package:ems_v4/models/transaction_logs.dart';
import 'package:get/get.dart';

class AddShiftController extends GetxController {
  final AuthController _authController = Get.find<AuthController>();
  RxBool isLoading = false.obs,
      isSubmitting = false.obs,
      isLogsLoading = false.obs;
  Rx<TransactionLogs> selectedTransactionLogs = TransactionLogs().obs;
}
