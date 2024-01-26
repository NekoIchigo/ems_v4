// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:ems_v4/models/deparment.dart';
import 'package:ems_v4/models/position.dart';

class EmployeeDetails {
  final int id;
  final int employeeId;
  final String employeeNumber;
  final String dateHired;
  final String skillType;
  final int employeeTypeId;
  final int employeeStatusId;
  final int companyId;
  final int departmentId;
  final int positionId;
  final int groupId;
  final int? costCenterId;
  final String? clientName;
  final int reportsAt;
  final String reportsTo;
  final String supervisor;
  final String sssNumber;
  final String phicNumber;
  final String hdmfNumber;
  final String tinNumber;
  final Position position;
  final Department department;

  EmployeeDetails({
    required this.id,
    required this.employeeId,
    required this.employeeNumber,
    required this.dateHired,
    required this.skillType,
    required this.employeeTypeId,
    required this.employeeStatusId,
    required this.companyId,
    required this.departmentId,
    required this.positionId,
    required this.groupId,
    this.costCenterId,
    this.clientName,
    required this.reportsAt,
    required this.reportsTo,
    required this.supervisor,
    required this.sssNumber,
    required this.phicNumber,
    required this.hdmfNumber,
    required this.tinNumber,
    required this.position,
    required this.department,
  });

  factory EmployeeDetails.fromJson(Map<String, dynamic> json) {
    return EmployeeDetails(
      id: json['id'] as int,
      employeeId: json['employee_id'] as int,
      employeeNumber: json['employee_number'] as String,
      dateHired: json['date_hired'] as String,
      skillType: json['skill_type'] as String,
      employeeTypeId: json['employee_type_id'] as int,
      employeeStatusId: json['employee_status_id'] as int,
      companyId: json['company_id'] as int,
      departmentId: json['department_id'] as int,
      positionId: json['position_id'] as int,
      groupId: json['group_id'] as int,
      costCenterId: json['cost_center_id'] as int?,
      clientName: json['client_name'] as String?,
      reportsAt: json['reports_at'] as int,
      reportsTo: json['reports_to'] as String,
      supervisor: json['supervisor'] as String,
      sssNumber: json['sss_number'] as String,
      phicNumber: json['phic_number'] as String,
      hdmfNumber: json['hdmf_number'] as String,
      tinNumber: json['tin_number'] as String,
      department: Department.fromJson(json['department']),
      position: Position.fromJson(json['position']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'employee_id': employeeId,
      'employee_number': employeeNumber,
      'date_hired': dateHired,
      'skill_type': skillType,
      'employee_type_id': employeeTypeId,
      'employee_status_id': employeeStatusId,
      'company_id': companyId,
      'department_id': departmentId,
      'position_id': positionId,
      'group_id': groupId,
      'cost_center_id': costCenterId,
      'client_name': clientName,
      'reports_at': reportsAt,
      'reports_to': reportsTo,
      'supervisor': supervisor,
      'sss_number': sssNumber,
      'phic_number': phicNumber,
      'hdmf_number': hdmfNumber,
      'tin_number': tinNumber,
      'deparment': department.toMap(),
      'position': position.toMap(),
    };
  }
}
