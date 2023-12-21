// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Employee {
  final int id;
  final String employeeNumber;
  final String firstName;
  final String? middleName;
  final String lastName;
  final String birthday;
  final String gender;
  final String civilStatus;

  Employee({
    required this.id,
    required this.employeeNumber,
    required this.firstName,
    this.middleName,
    required this.lastName,
    required this.birthday,
    required this.gender,
    required this.civilStatus,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'employeeNumber': employeeNumber,
      'firstName': firstName,
      'middleName': middleName,
      'lastName': lastName,
      'birthday': birthday,
      'gender': gender,
      'civilStatus': civilStatus,
    };
  }

  factory Employee.fromMap(Map<String, dynamic> map) {
    return Employee(
      id: map['id'] as int,
      employeeNumber: map['employeeNumber'] as String,
      firstName: map['firstName'] as String,
      middleName:
          map['middleName'] != null ? map['middleName'] as String : null,
      lastName: map['lastName'] as String,
      birthday: map['birthday'] as String,
      gender: map['gender'] as String,
      civilStatus: map['civilStatus'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Employee.fromJson(String source) =>
      Employee.fromMap(json.decode(source) as Map<String, dynamic>);
}
