import 'dart:convert';

import 'package:ems_v4/global/api.dart';
import 'package:flutter/material.dart';

class HomeViewModel extends ChangeNotifier {
  final ApiCall _apiCall = ApiCall();
  DateTime _workStart = DateTime.now(), _workEnd = DateTime.now();
  bool _isLoading = false;

  Future<void> checkNewShift() async {
    _isLoading = true;
    try {
      var response = await _apiCall.getRequest(
          apiUrl: '/check-shift', catchError: (error) => {});
      var result = jsonDecode(response.body);

      if (result.containsKey('success') && result['success']) {}
    } catch (error) {
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  DateTime get workStart => _workStart;
  DateTime get workEnd => _workEnd;
  bool get isLoading => _isLoading;
}
