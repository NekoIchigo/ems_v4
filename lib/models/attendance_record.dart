class AttendanceRecord {
  int? id;
  int? employeeId;
  DateTime? clockInAt;
  DateTime? clockOutAt;
  String? formattedClockIn;
  String? formattedClockOut;
  String? clockedInLocation;
  String? clockedOutLocation;
  String? clockedInLatitude;
  String? clockedInLongitude;
  String? clockedOutLatitude;
  String? clockedOutLongitude;
  String? clockedInLocationType;
  String? clockedOutLocationType;
  String? clockedInLocationSetting;
  String? clockedOutLocationSetting;
  String? healthCheck;
  String? scheduleId;
  String? healthTemperature;

  AttendanceRecord({
    this.id,
    this.employeeId,
    this.clockInAt,
    this.clockOutAt,
    this.formattedClockIn,
    this.formattedClockOut,
    this.clockedInLocation,
    this.clockedOutLocation,
    this.clockedInLatitude,
    this.clockedInLongitude,
    this.clockedOutLatitude,
    this.clockedOutLongitude,
    this.clockedInLocationType,
    this.clockedOutLocationType,
    this.clockedInLocationSetting,
    this.clockedOutLocationSetting,
    this.healthCheck,
    this.scheduleId,
    this.healthTemperature,
  });

  factory AttendanceRecord.fromJson(Map<String, dynamic> json) {
    return AttendanceRecord(
      id: json['id'] as int?,
      employeeId: json['employee_id'] as int?,
      clockInAt: json['clock_in_at'] != null
          ? DateTime.parse(json['clock_in_at'] as String)
          : null,
      clockOutAt: json['clock_out_at'] != null
          ? DateTime.parse(json['clock_out_at'] as String)
          : null,
      formattedClockIn: json['formatted_clock_in_at'] as String?,
      formattedClockOut: json['formatted_clock_out_at'] as String?,
      clockedInLocation: json['clocked_in_location'] as String?,
      clockedOutLocation: json['clocked_out_location'] as String?,
      clockedInLatitude: json['clocked_in_latitude'] as String?,
      clockedInLongitude: json['clocked_in_longitude'] as String?,
      clockedOutLatitude: json['clocked_out_latitude'] as String?,
      clockedOutLongitude: json['clocked_out_longitude'] as String?,
      clockedInLocationType: json['clocked_in_location_type'] as String?,
      clockedOutLocationType: json['clocked_out_location_type'] as String?,
      clockedInLocationSetting: json['clocked_in_location_setting'] as String?,
      clockedOutLocationSetting:
          json['clocked_out_location_setting'] as String?,
      healthCheck: json['health_check'] as String?,
      scheduleId: json['schedule_id'] as String?,
      healthTemperature: json['health_temperature'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'employee_id': employeeId,
      'formatted_clock_in_at': formattedClockIn,
      'formatted_clock_out_at': formattedClockOut,
      'clock_in_at': clockInAt?.toIso8601String(),
      'clock_out_at': clockOutAt?.toIso8601String(),
      'clocked_in_location': clockedInLocation,
      'clocked_out_location': clockedOutLocation,
      'clocked_in_latitude': clockedInLatitude,
      'clocked_in_longitude': clockedInLongitude,
      'clocked_out_latitude': clockedOutLatitude,
      'clocked_out_longitude': clockedOutLongitude,
      'clocked_in_location_type': clockedInLocationType,
      'clocked_out_location_type': clockedOutLocationType,
      'clocked_in_location_setting': clockedInLocationSetting,
      'clocked_out_location_setting': clockedOutLocationSetting,
      'health_check': healthCheck,
      'health_temperature': healthTemperature,
      'schedule_id': scheduleId,
    };
  }
}

// class Attendance {
//   String? clockedInAt;
//   String? clockedInlatitude;
//   String? clockedInLongitude;
//   String? clockedInLocationSetting;
//   String? clockedInLocationType;
//   String? clockedInLocation;
//   String? clockedOutAt;
//   String? clockedOutlatitude;
//   String? clockedOutLongitude;
//   String? clockedOutLocationSetting;
//   String? clockedOutLocationType;
//   String? clockedOutLocation;
//   String? healthCheck;
//   String? temperature;
//   int? id;
//   int? employeeId;

//   Attendance({
//     this.clockedInAt,
//     this.clockedInlatitude,
//     this.clockedInLongitude,
//     this.clockedInLocationSetting,
//     this.clockedInLocationType,
//     this.clockedInLocation,
//     this.clockedOutAt,
//     this.clockedOutlatitude,
//     this.clockedOutLongitude,
//     this.clockedOutLocationSetting,
//     this.clockedOutLocationType,
//     this.clockedOutLocation,
//     this.healthCheck,
//     this.temperature,
//     this.id,
//     this.employeeId,
//   });

//   factory Attendance.fromJson(Map<String, dynamic> json) {
//     return Attendance(
//       id: json['id'],
//       employeeId: json['employee_id'],
//       clockedInAt: json['clock_in_at'] ?? "",
//       clockedOutAt: json['clock_out_at'] ?? "",
//       clockedInLocationSetting: json['clocked_in_location_setting'] ?? "",
//       clockedOutLocationSetting: json['clocked_out_location_setting'] ?? "",
//       clockedInlatitude: json['clocked_in_latitude'] ?? "",
//       clockedInLongitude: json['clocked_in_longitude'] ?? "",
//       clockedOutlatitude: json['clocked_out_latitude'] ?? "",
//       clockedOutLongitude: json['clocked_out_longitude'] ?? "",
//       clockedInLocation: json['clocked_in_location'] ?? "",
//       clockedOutLocation: json['clocked_out_location'] ?? "",
//       clockedInLocationType: json['clocked_in_location_type'] ?? "",
//       clockedOutLocationType: json['clocked_out_location_type'] ?? "",
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'employee_id': employeeId,
//       'clock_in_at': clockedInAt,
//       'clock_out_at': clockedOutAt,
//       'clocked_in_location': clockedInLocation,
//       'clocked_out_location': clockedOutLocation,
//       'clocked_in_location_setting': clockedInLocationSetting,
//       'clocked_out_location_setting': clockedOutLocationSetting,
//       'clocked_in_latitude': clockedInlatitude,
//       'clocked_in_longitude': clockedInLongitude,
//       'clocked_out_latitude': clockedOutlatitude,
//       'clocked_out_longitude': clockedOutLongitude,
//       'clocked_in_location_type': clockedInLocationType,
//       'clocked_out_location_type': clockedOutLocationType,
//     };
//   }

//   Map<String, dynamic> toMap() {
//     return <String, dynamic>{
//       'clockedInAt': clockedInAt,
//       'clockedInlatitude': clockedInlatitude,
//       'clockedInLongitude': clockedInLongitude,
//       'clockedInLocationSetting': clockedInLocationSetting,
//       'clockedInLocationType': clockedInLocationType,
//       'clockedInLocation': clockedInLocation,
//       'clockedOutAt': clockedOutAt,
//       'clockedOutlatitude': clockedOutlatitude,
//       'clockedOutLongitude': clockedOutLongitude,
//       'clockedOutLocationSetting': clockedOutLocationSetting,
//       'clockedOutLocationType': clockedOutLocationType,
//       'clockedOutLocation': clockedOutLocation,
//       'healthCheck': healthCheck,
//       'temperature': temperature,
//       'id': id,
//       'employeeId': employeeId,
//     };
//   }

//   factory Attendance.fromMap(Map<String, dynamic> map) {
//     return Attendance(
//       clockedInAt:
//           map['clockedInAt'] != null ? map['clockedInAt'] as String : null,
//       clockedInlatitude: map['clockedInlatitude'] != null
//           ? map['clockedInlatitude'] as String
//           : null,
//       clockedInLongitude: map['clockedInLongitude'] != null
//           ? map['clockedInLongitude'] as String
//           : null,
//       clockedInLocationSetting: map['clockedInLocationSetting'] != null
//           ? map['clockedInLocationSetting'] as String
//           : null,
//       clockedInLocationType: map['clockedInLocationType'] != null
//           ? map['clockedInLocationType'] as String
//           : null,
//       clockedInLocation: map['clockedInLocation'] != null
//           ? map['clockedInLocation'] as String
//           : null,
//       clockedOutAt:
//           map['clockedOutAt'] != null ? map['clockedOutAt'] as String : null,
//       clockedOutlatitude: map['clockedOutlatitude'] != null
//           ? map['clockedOutlatitude'] as String
//           : null,
//       clockedOutLongitude: map['clockedOutLongitude'] != null
//           ? map['clockedOutLongitude'] as String
//           : null,
//       clockedOutLocationSetting: map['clockedOutLocationSetting'] != null
//           ? map['clockedOutLocationSetting'] as String
//           : null,
//       clockedOutLocationType: map['clockedOutLocationType'] != null
//           ? map['clockedOutLocationType'] as String
//           : null,
//       clockedOutLocation: map['clockedOutLocation'] != null
//           ? map['clockedOutLocation'] as String
//           : null,
//       healthCheck:
//           map['healthCheck'] != null ? map['healthCheck'] as String : null,
//       temperature:
//           map['temperature'] != null ? map['temperature'] as String : null,
//       id: map['id'] != null ? map['id'] as int : null,
//       employeeId: map['employeeId'] != null ? map['employeeId'] as int : null,
//     );
//   }
// }
