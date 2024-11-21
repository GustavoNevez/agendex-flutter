import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MySchedulesScreen extends StatelessWidget {
  const MySchedulesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final String userId = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Meus Agendamentos"),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('schedules')
            .where('userId', isEqualTo: userId)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("Nenhum agendamento encontrado."));
          }

          final documents = snapshot.data!.docs;

          return ListView.builder(
            itemCount: documents.length,
            itemBuilder: (context, index) {
              final data = documents[index].data() as Map<String, dynamic>;
              final docId = documents[index].id; // Pega o ID do documento
              final date = DateTime.parse(data['date']);
              final time = data['time'];
              final servicoId = data['servicoId'];

              return ListTile(
                leading: const Icon(Icons.event),
                title: Text("Serviço: $servicoId"),
                subtitle: Text(
                    "Data: ${date.day}/${date.month}/${date.year} - Hora: $time"),
                onTap: () => _showScheduleDetails(
                  context,
                  docId,
                  servicoId,
                  date,
                  time,
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _showScheduleDetails(
    BuildContext context,
    String docId,
    String servicoId,
    DateTime date,
    String time,
  ) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Detalhes do Agendamento"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Serviço: $servicoId",
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 8),
              Text(
                "Data: ${date.day}/${date.month}/${date.year}",
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 8),
              Text(
                "Horário: $time",
                style: const TextStyle(fontSize: 18),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Fechar"),
            ),
            ElevatedButton.icon(
              onPressed: () async {
                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text("Confirmar Exclusão"),
                    content: const Text(
                        "Tem certeza de que deseja excluir este agendamento?"),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(false),
                        child: const Text("Cancelar"),
                      ),
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(true),
                        child: const Text(
                          "Excluir",
                          selectionColor: Colors.white,
                        ),
                      ),
                    ],
                  ),
                );

                if (confirm == true) {
                  try {
                    // Excluir o documento do Firestore
                    await FirebaseFirestore.instance
                        .collection('schedules')
                        .doc(docId)
                        .delete();

                    Navigator.of(context).pop(); // Fecha o diálogo atual

                    // Mostrar notificação de sucesso
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Agendamento excluído com sucesso!"),
                        backgroundColor: Colors.red,
                      ),
                    );
                  } catch (e) {
                    // Mostrar erro
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text("Erro"),
                        content:
                            Text("Não foi possível excluir o agendamento: $e"),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: const Text("OK"),
                          ),
                        ],
                      ),
                    );
                  }
                }
              },
              icon: const Icon(Icons.delete),
              label: const Text("Excluir"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
            ),
          ],
        );
      },
    );
  }
}
