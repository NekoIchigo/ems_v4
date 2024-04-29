class DRTModel {
  String? clockIn;
  String? clockOut;
  String dtr;
  String scheduleName;
  int scheduleId;

  DRTModel({
    required this.clockIn,
    required this.clockOut,
    required this.dtr,
    required this.scheduleName,
    required this.scheduleId,
  });

  factory DRTModel.fromJson(Map<String, dynamic> json) {
    return DRTModel(
      clockIn: json['clock_in'] as String?,
      clockOut: json['clock_out'] as String?,
      dtr: json['dtr'] as String,
      scheduleName: json['schedule_name'] as String,
      scheduleId: json['schedule_id'] as int,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'clock_in': clockIn,
      'clock_out': clockOut,
      'dtr': dtr,
      'schedule_name': scheduleName,
      'schedule_id': scheduleId,
    };
  }
}
