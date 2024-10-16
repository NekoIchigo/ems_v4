class EmploymentType {
  final int? id;
  final String? name;
  final int? transactionAccess;

  EmploymentType({
    this.id,
    this.name,
    this.transactionAccess,
  });

  factory EmploymentType.fromJson(Map<String, dynamic>? json) {
    return EmploymentType(
      id: json?['id'] as int?,
      name: json?['name'] as String?,
      transactionAccess: json?['transaction_access'] as int?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'transaction_access': transactionAccess,
    };
  }
}
