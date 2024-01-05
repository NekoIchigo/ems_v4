import 'package:ems_v4/models/employee_details.dart';

class Employee {
  final int id;
  final int companyId;
  final int userId;
  final int accountStatusId;
  final String firstName;
  final String? middleName;
  final String lastName;
  final String dailyTimeRecord;
  final String birthday;
  final String gender;
  final String civilStatus;
  final EmployeeDetails employeeDetails;

  Employee({
    required this.id,
    required this.companyId,
    required this.userId,
    required this.accountStatusId,
    required this.firstName,
    this.middleName,
    required this.lastName,
    required this.dailyTimeRecord,
    required this.birthday,
    required this.gender,
    required this.civilStatus,
    required this.employeeDetails,
  });

  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
      id: json['id'] as int,
      companyId: json['company_id'] as int,
      userId: json['user_id'] as int,
      accountStatusId: json['account_status_id'] as int,
      firstName: json['first_name'] as String,
      middleName: json['middle_name'] as String?,
      lastName: json['last_name'] as String,
      dailyTimeRecord: json['daily_time_record'] as String,
      birthday: json['birthday'] as String,
      gender: json['gender'] as String,
      civilStatus: json['civil_status'] as String,
      employeeDetails: EmployeeDetails.fromJson(json['employee_details']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'company_id': companyId,
      'user_id': userId,
      'account_status_id': accountStatusId,
      'first_name': firstName,
      'middle_name': middleName,
      'last_name': lastName,
      'daily_time_record': dailyTimeRecord,
      'birthday': birthday,
      'gender': gender,
      'civil_status': civilStatus,
      'employee_details': employeeDetails.toMap(),
    };
  }
}
