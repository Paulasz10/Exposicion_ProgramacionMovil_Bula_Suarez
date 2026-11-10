import '../../domain/repositories/nfc_reader_repository.dart';

/// Browser-safe stand-in for a native NFC adapter.
class SimulatedNfcReaderRepository implements NfcReaderRepository {
  @override
  Future<String> readTag(String simulatedTagId) async {
    if (simulatedTagId.trim().isEmpty) {
      throw ArgumentError('Identificador NFC vacío');
    }
    return simulatedTagId;
  }
}
