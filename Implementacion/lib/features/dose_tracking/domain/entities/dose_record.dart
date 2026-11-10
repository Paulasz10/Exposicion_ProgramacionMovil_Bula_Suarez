class DoseRecord {
  final String id;
  final String medicationId;
  final String medicationName;
  final DateTime takenAt;
  final String scheduledSlot;

  const DoseRecord({
    required this.id,
    required this.medicationId,
    required this.medicationName,
    required this.takenAt,
    required this.scheduledSlot,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'medicationId': medicationId,
    'medicationName': medicationName,
    'takenAt': takenAt.toIso8601String(),
    'scheduledSlot': scheduledSlot,
  };

  factory DoseRecord.fromJson(Map<String, dynamic> json) => DoseRecord(
    id: json['id'] as String,
    medicationId: json['medicationId'] as String,
    medicationName: json['medicationName'] as String,
    takenAt: DateTime.parse(json['takenAt'] as String),
    scheduledSlot: json['scheduledSlot'] as String,
  );
}
