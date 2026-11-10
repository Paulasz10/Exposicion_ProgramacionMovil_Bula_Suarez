import '../entities/dose_record.dart';
import '../repositories/dose_repository.dart';

class ListDoses {
  final DoseRepository repository;
  const ListDoses(this.repository);

  Future<List<DoseRecord>> call() => repository.getAll();
}
