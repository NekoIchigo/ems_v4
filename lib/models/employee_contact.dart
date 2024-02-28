class EmployeeContact {
  final int id;
  final int employeeId;
  final String? personalEmail;
  final String? contactNumber;
  final String? workContactNumber;
  final String? email;
  final String? houseNumber;
  final String? subdivisionName;
  final String? streetName;
  final String? barangay;
  final String? city;
  final String? province;
  final String? region;

  EmployeeContact({
    required this.id,
    required this.employeeId,
    this.personalEmail,
    this.contactNumber,
    this.workContactNumber,
    this.email,
    this.houseNumber,
    this.subdivisionName,
    this.streetName,
    this.barangay,
    this.city,
    this.province,
    this.region,
  });

  factory EmployeeContact.fromJson(Map<String, dynamic> json) {
    return EmployeeContact(
      id: json['id'] as int,
      employeeId: json['employee_id'] as int,
      personalEmail: json['personal_email'] as String?,
      contactNumber: json['contact_number'] as String?,
      workContactNumber: json['work_contact_number'] as String?,
      email: json['email'] as String?,
      houseNumber: json['house_number'] as String?,
      subdivisionName: json['subdivision_name'] as String?,
      streetName: json['street_name'] as String?,
      barangay: json['barangay'] as String?,
      city: json['city'] as String?,
      province: json['province'] as String?,
      region: json['region'] as String?,
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
      'region': region,
    };
  }
}
