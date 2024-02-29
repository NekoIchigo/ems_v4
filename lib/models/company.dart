class Company {
  final int id;
  final String name;
  final String? logo;
  final String? description;

  Company({
    required this.id,
    required this.name,
    required this.logo,
    this.description,
  });

  factory Company.fromJson(Map<String, dynamic> json) {
    return Company(
      id: json['id'] as int,
      name: json['name'] as String,
      logo: json['logo'] as String?,
      description: json['description'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'logo': logo,
      'description': description,
    };
  }
}
