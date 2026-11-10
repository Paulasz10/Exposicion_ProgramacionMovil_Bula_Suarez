
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RemindersPage extends StatefulWidget {
  const RemindersPage({super.key});

  @override
  State<RemindersPage> createState() => _RemindersPageState();
}

class _RemindersPageState extends State<RemindersPage> {
  static const String storageKey = 'meditag_reminders_v1';

  final SharedPreferencesAsync prefs = SharedPreferencesAsync();

  List<Map<String, dynamic>> items = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    load();
  }

  // Cargar los recordatorios guardados
  Future<void> load() async {
    try {
      final value = await prefs.getString(storageKey);

      if (value != null) {
        items = (jsonDecode(value) as List)
            .map(
              (e) => Map<String, dynamic>.from(e as Map),
            )
            .toList();
      }
    } catch (_) {
      items = [];
    }

    if (mounted) {
      setState(() {
        loading = false;
      });
    }
  }

  // Guardar los recordatorios en almacenamiento local
  Future<void> save() async {
    await prefs.setString(
      storageKey,
      jsonEncode(items),
    );

    if (mounted) {
      setState(() {});
    }
  }

  // Agregar un nuevo recordatorio
  Future<void> add() async {
    final nameController = TextEditingController();

    TimeOfDay selectedTime = const TimeOfDay(
      hour: 8,
      minute: 0,
    );

    final accepted = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, refresh) {
            return AlertDialog(
              title: const Text('Nuevo recordatorio'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      labelText: 'Nombre de referencia',
                    ),
                  ),
                  const SizedBox(height: 12),
                  OutlinedButton.icon(
                    onPressed: () async {
                      final picked = await showTimePicker(
                        context: dialogContext,
                        initialTime: selectedTime,
                      );

                      if (picked != null) {
                        refresh(() {
                          selectedTime = picked;
                        });
                      }
                    },
                    icon: const Icon(Icons.schedule),
                    label: Text(
                      'Horario: '
                      '${selectedTime.hour.toString().padLeft(2, '0')}:'
                      '${selectedTime.minute.toString().padLeft(2, '0')}',
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(dialogContext, false);
                  },
                  child: const Text('Cancelar'),
                ),
                FilledButton(
                  onPressed: () {
                    Navigator.pop(dialogContext, true);
                  },
                  child: const Text('Guardar'),
                ),
              ],
            );
          },
        );
      },
    );

    final name = nameController.text.trim();

    if (accepted == true && name.isNotEmpty) {
      final time =
          '${selectedTime.hour.toString().padLeft(2, '0')}:'
          '${selectedTime.minute.toString().padLeft(2, '0')}';

      items.add({
        'id': DateTime.now().microsecondsSinceEpoch.toString(),
        'name': name,
        'time': time,
        'active': true,
      });

      await save();
    }

    // Esperar a que termine la transición del diálogo.
    await Future<void>.delayed(
      const Duration(milliseconds: 350),
    );

    nameController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 800,
            ),
            child: ListView(
              padding: const EdgeInsets.all(24),
              children: [
                const Text(
                  'Recordatorios',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 8),

                const Text(
                  'Configura horarios de referencia '
                  'para tu demostración.',
                  style: TextStyle(
                    color: Colors.black54,
                  ),
                ),

                const SizedBox(height: 12),

                const Card(
                  child: Padding(
                    padding: EdgeInsets.all(15),
                    child: Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          color: Color(0xFF087D70),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'Esta versión guarda y muestra '
                            'recordatorios dentro de la app; '
                            'todavía no envía notificaciones '
                            'ni alarmas del sistema.',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                if (loading)
                  const Center(
                    child: CircularProgressIndicator(),
                  )
                else if (items.isEmpty)
                  const Padding(
                    padding: EdgeInsets.all(40),
                    child: Center(
                      child: Text(
                        'Aún no has creado recordatorios.',
                      ),
                    ),
                  ),

                ...items.map((reminder) {
                  return Card(
                    child: ListTile(
                      leading: const Icon(
                        Icons.alarm,
                        color: Color(0xFF087D70),
                      ),
                      title: Text(
                        reminder['name'] as String,
                      ),
                      subtitle: Text(
                        'Hora: ${reminder['time']}',
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Switch(
                            value: reminder['active'] as bool,
                            onChanged: (value) {
                              reminder['active'] = value;
                              save();
                            },
                          ),
                          IconButton(
                            tooltip: 'Eliminar recordatorio',
                            icon: const Icon(
                              Icons.delete_outline,
                            ),
                            onPressed: () {
                              items.remove(reminder);
                              save();
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
        ),
      ),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: add,
        icon: const Icon(Icons.add_alarm),
        label: const Text('Crear recordatorio'),
      ),
    );
  }
}
