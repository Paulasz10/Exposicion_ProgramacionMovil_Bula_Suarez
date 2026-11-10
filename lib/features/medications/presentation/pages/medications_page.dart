
import 'package:flutter/material.dart';

import '../../domain/entities/medication.dart';
import '../controllers/medication_controller.dart';

class MedicationsPage extends StatefulWidget {
  final MedicationController controller;
  final bool embedded;

  const MedicationsPage({
    super.key,
    required this.controller,
    this.embedded = false,
  });

  @override
  State<MedicationsPage> createState() => _MedicationsPageState();
}

class _MedicationsPageState extends State<MedicationsPage> {
  @override
  void initState() {
    super.initState();
    widget.controller.load();
  }

  Future<void> add() async {
    final formKey = GlobalKey<FormState>();

    final nameController = TextEditingController();
    final doseController = TextEditingController();
    final timeController = TextEditingController();

    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Nuevo medicamento'),
          content: SizedBox(
            width: 440,
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      labelText: 'Nombre',
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Ingresa un nombre';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 10),

                  TextFormField(
                    controller: doseController,
                    decoration: const InputDecoration(
                      labelText: 'Dosis (indicada previamente)',
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Ingresa una dosis';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 10),

                  TextFormField(
                    controller: timeController,
                    decoration: const InputDecoration(
                      labelText: 'Horario (ej. 08:00)',
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Ingresa un horario';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text('Cancelar'),
            ),
            FilledButton(
              onPressed: () async {
                if (!formKey.currentState!.validate()) {
                  return;
                }

                final saved = await widget.controller.add(
                  name: nameController.text.trim(),
                  dosage: doseController.text.trim(),
                  schedule: timeController.text.trim(),
                );

                if (!dialogContext.mounted) return;

                if (saved) {
                  Navigator.pop(dialogContext);
                } else {
                  ScaffoldMessenger.of(dialogContext).showSnackBar(
                    SnackBar(
                      content: Text(
                        widget.controller.error ??
                            'Error al guardar el medicamento',
                      ),
                    ),
                  );
                }
              },
              child: const Text('Guardar'),
            ),
          ],
        );
      },
    );

    // Espera a que termine la animación de cierre del diálogo.
    await Future<void>.delayed(
      const Duration(milliseconds: 350),
    );

    nameController.dispose();
    doseController.dispose();
    timeController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final content = AnimatedBuilder(
      animation: widget.controller,
      builder: (context, _) {
        final controller = widget.controller;

        if (controller.isLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (controller.error != null) {
          return Center(
            child: Text(controller.error!),
          );
        }

        return Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 850),
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                const Text(
                  'Mis medicamentos',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                const Text(
                  'Información de ejemplo o registrada por ti.',
                  style: TextStyle(color: Colors.black54),
                ),
                const SizedBox(height: 14),

                if (controller.medications.isEmpty)
                  const Padding(
                    padding: EdgeInsets.all(24),
                    child: Center(
                      child: Text(
                        'Aún no hay medicamentos. '
                        'Agrega uno para comenzar.',
                      ),
                    ),
                  ),

                ...controller.medications.map((Medication medication) {
                  String? tagDescription;

                  if (medication.tagId == 'ETIQUETA_BLANCA') {
                    tagDescription = 'Tarjeta blanca';
                  } else if (
                      medication.tagId == 'ETIQUETA_CIRCULAR') {
                    tagDescription = 'Etiqueta circular';
                  } else if (medication.tagId != null) {
                    tagDescription = medication.tagId;
                  }

                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 7),
                      child: ListTile(
                        leading: const CircleAvatar(
                          backgroundColor: Color(0xFFD5F3E9),
                          child: Icon(
                            Icons.medication_outlined,
                            color: Color(0xFF087D70),
                          ),
                        ),
                        title: Text(
                          medication.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        subtitle: Text(
                          '${medication.dosage}\n'
                          'Horario: ${medication.schedule}'
                          '${tagDescription == null ? '' : '\nEtiqueta: $tagDescription'}',
                        ),
                        isThreeLine: true,
                        trailing: IconButton(
                          tooltip: 'Eliminar',
                          icon: const Icon(Icons.delete_outline),
                          onPressed: () {
                            widget.controller.remove(medication.id);
                          },
                        ),
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
        );
      },
    );

    return Scaffold(
      appBar: widget.embedded
          ? null
          : AppBar(
              title: const Text('Mis medicamentos'),
            ),
      body: SafeArea(
        child: content,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: add,
        icon: const Icon(Icons.add),
        label: const Text('Agregar medicamento'),
      ),
    );
  }
}
