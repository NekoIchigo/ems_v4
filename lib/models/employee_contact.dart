class EmployeeContact {
  final int id;
  final int employeeId;
  final String personalEmail;
  final String contactNumber;
  final String workContactNumber;
  final String email;
  final String houseNumber;
  final String? subdivisionName;
  final String streetName;
  final String barangay;
  final String city;
  final String province;
  final String createdAt;
  final String updatedAt;

  EmployeeContact({
    required this.id,
    required this.employeeId,
    required this.personalEmail,
    required this.contactNumber,
    required this.workContactNumber,
    required this.email,
    required this.houseNumber,
    this.subdivisionName,
    required this.streetName,
    required this.barangay,
    required this.city,
    required this.province,
    required this.createdAt,
    required this.updatedAt,
  });

  factory EmployeeContact.fromJson(Map<String, dynamic> json) {
    return EmployeeContact(
      id: json['id'] as int,
      employeeId: json['employee_id'] as int,
      personalEmail: json['personal_email'] as String,
      contactNumber: json['contact_number'] as String,
      workContactNumber: json['work_contact_number'] as String,
      email: json['email'] as String,
      houseNumber: json['house_number'] as String,
      subdivisionName: json['subdivision_name'] as String?,
      streetName: json['street_name'] as String,
      barangay: json['barangay'] as String,
      city: json['city'] as String,
      province: json['province'] as String,
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'employee_id': employeeId,
      'personal_email': personalEmail,
      'contact_number': contactNumber,
      'work_contact_number': workContactNumber,
      'email': email,
      'house_number': houseNumber,
      'subdivision_name': subdivisionName,
      'street_name': streetName,
      'barangay': barangay,
      'city': city,
      'province': province,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}
