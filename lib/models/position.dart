class Position {
  final int id;
  final int companyId;
  final String name;
  final String description;
  final int status;

  Position({
    required this.id,
    required this.companyId,
    required this.name,
    required this.description,
    required this.status,
  });

  factory Position.fromJson(Map<String, dynamic> json) {
    return Position(
      id: json['id'] as int,
      companyId: json['company_id'] as int,
      name: json['name'] as String,
      description: json['description'] as String,
      status: json['status'] as int,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'company_id': companyId,
      'name': name,
      'description': description,
      'status': status,
    };
  }
}
