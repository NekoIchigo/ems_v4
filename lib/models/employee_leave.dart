class EmployeeLeave {
  final int id;
  final int? leaveId;
  final int? employeeId;
  final double? employeeCredits;
  final String? name;

  EmployeeLeave({
    required this.id,
    this.leaveId,
    this.employeeId,
    this.employeeCredits,
    this.name,
  });

  factory EmployeeLeave.fromJson(Map<String, dynamic> json) {
    return EmployeeLeave(
      id: json['id'] as int,
      name: json['name'] as String?,
      leaveId: json['leave_id'] as int?,
      employeeId: json['employee_id'] as int?,
      employeeCredits: json['credits'] as double?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "name": name,
      "leave_id": leaveId,
      "employee_id": employeeId,
      "credits": employeeCredits,
    };
  }
}
