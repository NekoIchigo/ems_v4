class Location {
  final int id;
  final int companyId;
  final String name;
  final String logo;
  final String latitude;
  final String longitude;
  final double radius;
  final String address;
  final String city;
  final String province;

  Location({
    required this.id,
    required this.companyId,
    required this.name,
    required this.logo,
    required this.latitude,
    required this.longitude,
    required this.radius,
    required this.address,
    required this.city,
    required this.province,
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      id: json['id'] as int,
      companyId: json['company_id'] as int,
      name: json['name'] as String,
      logo: json['logo'] as String,
      latitude: json['latitude'] as String,
      longitude: json['longitude'] as String,
      radius: json['radius'].toDouble(),
      address: json['address'] as String,
      city: json['city'] as String,
      province: json['province'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'company_id': companyId,
      'name': name,
      'logo': logo,
      'latitude': latitude,
      'longitude': longitude,
      'radius': radius,
      'address': address,
      'city': city,
      'province': province,
    };
  }
}
