class TransactionItem {
  final int id;
  final String title;
  final String dateCreated;
  final String subtitle;
  final String status;
  final String type;

  TransactionItem({
    required this.id,
    required this.title,
    required this.dateCreated,
    required this.subtitle,
    required this.status,
    required this.type,
  });

  factory TransactionItem.fromJson(Map<String, dynamic> json) {
    return TransactionItem(
      id: json['id'] as int,
      title: json['title'] as String,
      dateCreated: json['date_created'] as String,
      subtitle: json['subtitle'] as String,
      status: json['status'] as String,
      type: json['type'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'date_created': dateCreated,
      'subtitle': subtitle,
      'status': status,
      'type': type,
    };
  }
}
