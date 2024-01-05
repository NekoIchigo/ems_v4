class Shift {
  int id;
  int companyId;
  String day;
  String type;
  String workStart;
  String breakStart;
  String breakEnd;
  String workEnd;
  String totalHours;
  String workType;

  Shift({
    required this.id,
    required this.companyId,
    required this.day,
    required this.type,
    required this.workStart,
    required this.breakStart,
    required this.breakEnd,
    required this.workEnd,
    required this.totalHours,
    required this.workType,
  });

  factory Shift.fromJson(Map<String, dynamic> json) {
    return Shift(
      id: json['id'] as int,
      companyId: json['company_id'] as int,
      day: json['day'] as String,
      type: json['type'] as String,
      workStart: json['work_start'] as String,
      breakStart: json['break_start'] as String,
      breakEnd: json['break_end'] as String,
      workEnd: json['work_end'] as String,
      totalHours: json['total_hours'] as String,
      workType: json['work_type'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'company_id': companyId,
      'day': day,
      'type': type,
      'work_start': workStart,
      'break_start': breakStart,
      'break_end': breakEnd,
      'work_end': workEnd,
      'total_hours': totalHours,
      'work_type': workType,
    };
  }
}
