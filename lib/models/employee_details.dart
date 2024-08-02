import 'package:ems_v4/models/department.dart';
import 'package:ems_v4/models/location.dart';
import 'package:ems_v4/models/position.dart';
import 'package:ems_v4/models/employment_type.dart';

class EmployeeDetails {
  final int id;
  final int employeeId;
  final String employeeNumber;
  final String? dateHired;
  final String? skillType;
  final int? employeeTypeId;
  final int? employeeStatusId;
  final int? companyId;
  final int? departmentId;
  final int? positionId;
  final int? groupId;
  final int? costCenterId;
  final String? clientName;
  final int? reportsAt;
  final String? reportsTo;
  final String? supervisor;
  final String? sssNumber;
  final String? phicNumber;
  final String? hdmfNumber;
  final String? tinNumber;
  final Position position;
  final Location location;
  final Department department;
  final EmploymentType? employmentType;

  EmployeeDetails({
    required this.id,
    required this.employeeId,
    required this.employeeNumber,
    this.dateHired,
    this.skillType,
    this.employeeTypeId,
    this.employeeStatusId,
    this.companyId,
    this.departmentId,
    this.positionId,
    this.groupId,
    this.costCenterId,
    this.clientName,
    required this.position,
    required this.location,
    required this.department,
    this.reportsAt,
    this.reportsTo,
    this.supervisor,
    required this.sssNumber,
    required this.phicNumber,
    required this.hdmfNumber,
    required this.tinNumber,
    this.employmentType,
  });

  factory EmployeeDetails.fromJson(Map<String, dynamic> json) {
    return EmployeeDetails(
      id: json['id'] as int,
      employeeId: json['employee_id'] as int,
      employeeNumber: json['employee_number'] as String,
      dateHired: json['date_hired'] as String?,
      skillType: json['skill_type'] as String?,
      employeeTypeId: json['employee_type_id'] as int?,
      employeeStatusId: json['employee_status_id'] as int?,
      companyId: json['company_id'] as int?,
      departmentId: json['department_id'] as int?,
      positionId: json['position_id'] as int?,
      groupId: json['group_id'] as int?,
      costCenterId: json['cost_center_id'] as int?,
      clientName: json['client_name'] as String?,
      reportsAt: json['reports_at'] as int?,
      reportsTo: json['reports_to'] as String?,
      supervisor: json['supervisor'] as String?,
      sssNumber: json['sss_number'] as String?,
      phicNumber: json['phic_number'] as String?,
      hdmfNumber: json['hdmf_number'] as String?,
      tinNumber: json['tin_number'] as String?,
      employmentType: EmploymentType.fromJson(json['employee_type']),
      location: Location.fromJson(json['location']),
      position: Position.fromJson(json['position']),
      department: Department.fromJson(json['department']),
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
      'location': location.toMap(),
      'position': position.toMap(),
      'employee_type': employmentType?.toMap(),
      'department': department.toMap(),
    };
  }
}
