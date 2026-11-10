
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../medications/domain/entities/medication.dart';
import '../../../dose_tracking/presentation/controllers/dose_controller.dart';
import '../../domain/usecases/identify_medication_by_tag.dart';

class NfcScanPage extends StatefulWidget {
  final IdentifyMedicationByTag identifyMedication;
  final DoseController doseController;
  final bool embedded;

  const NfcScanPage({
    super.key,
    required this.identifyMedication,
    required this.doseController,
    this.embedded = false,
  });

  @override
  State<NfcScanPage> createState() => _NfcScanPageState();
}

class _NfcScanPageState extends State<NfcScanPage> {
  bool loading = false;
  bool confirming = false;

  String? error;
  String? message;
  Medication? result;

  bool get isAndroid =>
      !kIsWeb &&
      defaultTargetPlatform == TargetPlatform.android;

  Future<void> scan(String tagId) async {
    if (loading || confirming) return;

    setState(() {
      loading = true;
      error = null;
      message = null;
      result = null;
    });

    try {
      final medication =
          await widget.identifyMedication(tagId);

      if (!mounted) return;

      setState(() {
        result = medication;

        if (medication == null) {
          error =
              'La etiqueta fue leída, pero no hay un '
              'medicamento asociado a su identificador.';
        }
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        error = e.toString().replaceFirst(
          'Exception: ',
          '',
        );
      });
    } finally {
      if (mounted) {
        setState(() {
          loading = false;
        });
      }
    }
  }

  Future<void> confirm() async {
    final medication = result;

    if (medication == null || confirming) return;

    setState(() {
      confirming = true;
    });

    try {
      final response =
          await widget.doseController.confirm(medication);

      if (!mounted) return;

      setState(() {
        message = response;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        error = 'No se pudo confirmar la toma: $e';
      });
    } finally {
      if (mounted) {
        setState(() {
          confirming = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final content = Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 700),
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            const SizedBox(height: 22),

            const Icon(
              Icons.nfc,
              size: 90,
              color: Color(0xFF087D70),
            ),

            const SizedBox(height: 12),

            const Text(
              'Escáner NFC',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            Text(
              isAndroid
                  ? 'Acerca tu etiqueta NFC a la parte '
                        'trasera del teléfono.'
                  : 'Modo demostración para navegador.',
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 25),

            if (isAndroid)
              FilledButton.icon(
                onPressed: loading || confirming
                    ? null
                    : () => scan(''),
                icon: const Icon(Icons.nfc),
                label: Text(
                  loading
                      ? 'Esperando etiqueta...'
                      : 'Escanear etiqueta NFC',
                ),
              )
            else ...[
              FilledButton.icon(
                onPressed: loading || confirming
                    ? null
                    : () => scan('ETIQUETA_BLANCA'),
                icon: const Icon(Icons.credit_card),
                label: const Text(
                  'Simular tarjeta blanca',
                ),
              ),

              const SizedBox(height: 12),

              OutlinedButton.icon(
                onPressed: loading || confirming
                    ? null
                    : () => scan('ETIQUETA_CIRCULAR'),
                icon: const Icon(Icons.circle_outlined),
                label: const Text(
                  'Simular etiqueta circular',
                ),
              ),
            ],

            if (loading) ...[
              const SizedBox(height: 20),
              const Center(
                child: CircularProgressIndicator(),
              ),
              const SizedBox(height: 10),
              const Text(
                'Mantén la etiqueta cerca del lector NFC.',
                textAlign: TextAlign.center,
              ),
            ],

            if (error != null) ...[
              const SizedBox(height: 18),
              Text(
                error!,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.red,
                ),
              ),
            ],

            if (result != null) ...[
              const SizedBox(height: 25),

              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(
                            Icons.check_circle,
                            color: Color(0xFF087D70),
                          ),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Medicamento identificado',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 18),

                      Text(
                        result!.name,
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge,
                      ),

                      const SizedBox(height: 10),

                      Text('Dosis: ${result!.dosage}'),
                      Text('Horario: ${result!.schedule}'),

                      const SizedBox(height: 20),

                      FilledButton.icon(
                        onPressed:
                            confirming ? null : confirm,
                        icon: const Icon(Icons.check),
                        label: const Text(
                          'Confirmar toma',
                        ),
                      ),

                      if (message != null) ...[
                        const SizedBox(height: 12),

                        Text(
                          message!,
                          style: const TextStyle(
                            color: Color(0xFF087D70),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],

            const SizedBox(height: 20),

            const Text(
              'El escaneo identifica el medicamento, '
              'pero no confirma que haya sido tomado. '
              'Debes registrar la toma manualmente.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black54,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );

    return Scaffold(
      appBar: widget.embedded
          ? null
          : AppBar(
              title: const Text('Escanear NFC'),
            ),
      body: SafeArea(
        child: content,
      ),
    );
  }
}
