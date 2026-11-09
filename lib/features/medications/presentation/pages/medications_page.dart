import 'package:flutter/material.dart';

import '../../domain/entities/medication.dart';
import '../controllers/medication_controller.dart';

class MedicationsPage extends StatefulWidget {
  final MedicationController controller;
  const MedicationsPage({super.key, required this.controller});

  @override
  State<MedicationsPage> createState() => _MedicationsPageState();
}

class _MedicationsPageState extends State<MedicationsPage> {
  @override
  void initState() {
    super.initState();
    widget.controller.load();
  }

  Future<void> _addMedication() async {
    final formKey = GlobalKey<FormState>();
    final name = TextEditingController();
    final dosage = TextEditingController();
    final schedule = TextEditingController();
    try {
      await showDialog<void>(
        context: context,
        builder: (dialogContext) => AlertDialog(
          title: const Text('Nuevo medicamento'),
          content: SizedBox(
            width: 420,
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: name,
                    decoration: const InputDecoration(labelText: 'Nombre'),
                    validator: (value) => (value == null || value.trim().isEmpty)
                        ? 'Campo obligatorio'
                        : null,
                  ),
                  TextFormField(
                    controller: dosage,
                    decoration: const InputDecoration(labelText: 'Dosis indicada'),
                    validator: (value) => (value == null || value.trim().isEmpty)
                        ? 'Campo obligatorio'
                        : null,
                  ),
                  TextFormField(
                    controller: schedule,
                    decoration: const InputDecoration(labelText: 'Horario'),
                    validator: (value) => (value == null || value.trim().isEmpty)
                        ? 'Campo obligatorio'
                        : null,
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancelar'),
            ),
            FilledButton(
              onPressed: () async {
                if (!formKey.currentState!.validate()) return;
                final success = await widget.controller.add(
                  name: name.text,
                  dosage: dosage.text,
                  schedule: schedule.text,
                );
                if (!dialogContext.mounted) return;
                if (success) {
                  Navigator.pop(dialogContext);
                } else {
                  ScaffoldMessenger.of(dialogContext).showSnackBar(
                    SnackBar(content: Text(widget.controller.error ?? 'No se pudo guardar')),
                  );
                }
              },
              child: const Text('Guardar'),
            ),
          ],
        ),
      );
    } finally {
      // Defer disposal until the dialog's closing animation has completed.
      await Future<void>.delayed(const Duration(milliseconds: 300));
      name.dispose();
      dosage.dispose();
      schedule.dispose();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mis medicamentos')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addMedication,
        icon: const Icon(Icons.add),
        label: const Text('Agregar'),
      ),
      body: AnimatedBuilder(
        animation: widget.controller,
        builder: (context, _) {
          final controller = widget.controller;
          if (controller.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (controller.error != null) {
            return Center(child: Text(controller.error!));
          }
          if (controller.medications.isEmpty) {
            return const Center(child: Text('Aún no tienes medicamentos registrados.'));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: controller.medications.length,
            itemBuilder: (context, index) {
              final Medication medication = controller.medications[index];
              return Card(
                child: ListTile(
                  leading: const CircleAvatar(child: Icon(Icons.medication_outlined)),
                  title: Text(medication.name),
                  subtitle: Text('${medication.dosage}\nHorario: ${medication.schedule}'),
                  isThreeLine: true,
                  trailing: IconButton(
                    tooltip: 'Eliminar',
                    icon: const Icon(Icons.delete_outline),
                    onPressed: () => controller.remove(medication.id),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
