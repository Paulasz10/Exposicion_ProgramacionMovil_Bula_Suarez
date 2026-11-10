
import 'dart:async';
import 'dart:convert';

import 'package:nfc_manager/nfc_manager.dart';
import 'package:nfc_manager/nfc_manager_android.dart';

import '../../domain/repositories/nfc_reader_repository.dart';

class NativeNfcReaderRepository implements NfcReaderRepository {
  @override
  Future<String> readTag(String unusedTagId) async {
    final availability =
        await NfcManager.instance.checkAvailability();

    if (availability != NfcAvailability.enabled) {
      throw Exception(
        'El NFC no está disponible o está desactivado. '
        'Actívalo en los ajustes del celular.',
      );
    }

    final completer = Completer<String>();
    var processed = false;

    try {
      await NfcManager.instance.startSession(
        pollingOptions: {
          NfcPollingOption.iso14443,
        },
        onDiscovered: (tag) async {
          if (processed) return;
          processed = true;

          try {
            final ndef = NdefAndroid.from(tag);

            if (ndef == null) {
              throw Exception(
                'Esta etiqueta no contiene información NDEF compatible.',
              );
            }

            final message = await ndef.getNdefMessage();

            if (message == null || message.records.isEmpty) {
              throw Exception(
                'La etiqueta está vacía. Escríbele '
                'MEDI-001 o MEDI-002 con NFC Tools.',
              );
            }

            String? identifier;

            for (final record in message.records) {
              // Registro NDEF de texto (tipo T).
              if (record.type.length != 1 ||
                  record.type.first != 0x54) {
                continue;
              }

              final payload = record.payload;

              if (payload.isEmpty) continue;

              // El primer byte contiene el largo del idioma.
              final languageLength = payload.first & 0x3F;
              final textStartsAt = 1 + languageLength;

              if (textStartsAt >= payload.length) {
                continue;
              }

              final text = utf8
                  .decode(
                    payload.sublist(textStartsAt),
                    allowMalformed: true,
                  )
                  .trim();

              if (text.isNotEmpty) {
                identifier = text;
                break;
              }
            }

            if (identifier == null) {
              throw Exception(
                'No se encontró un registro de texto '
                'en la etiqueta NFC.',
              );
            }

            // Compatibilidad con los medicamentos demo existentes.
            final normalizedId = switch (identifier) {
              'MEDI-001' => 'ETIQUETA_BLANCA',
              'MEDI-002' => 'ETIQUETA_CIRCULAR',
              _ => identifier,
            };

            if (!completer.isCompleted) {
              completer.complete(normalizedId);
            }
          } catch (error) {
            if (!completer.isCompleted) {
              completer.completeError(error);
            }
          }
        },
      );

      return await completer.future.timeout(
        const Duration(seconds: 30),
        onTimeout: () {
          throw TimeoutException(
            'No se detectó ninguna etiqueta NFC. '
            'Acerca la tarjeta a la parte trasera del celular.',
          );
        },
      );
    } finally {
      await NfcManager.instance.stopSession();
    }
  }
}
