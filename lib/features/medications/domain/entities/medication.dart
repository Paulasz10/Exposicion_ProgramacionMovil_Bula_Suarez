class Medication {
  final String id;
  final String name;
  final String dosage;
  final String schedule;
  final String? tagId;

  const Medication({
    required this.id,
    required this.name,
    required this.dosage,
    required this.schedule,
    this.tagId,
  });
}
