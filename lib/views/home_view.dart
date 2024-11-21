import 'package:flutter/material.dart';
import 'package:agendex_flutter/widgets/home_modal.dart';
import 'package:agendex_flutter/models/scheduling_model.dart';
import '../widgets/drawer_app.dart';

class HomeView extends StatelessWidget {
  HomeView({super.key});

  final List<SchedulingModel> services = [
    SchedulingModel(
      id: "01",
      name: "Cabelo",
      servicoId: "Cabelo",
      data: DateTime.now(),
      duracao: "30 minutos",
    ),
    SchedulingModel(
      id: "02",
      name: "Barba",
      servicoId: "Barba",
      data: DateTime.now().add(Duration(days: 1)),
      duracao: "20 minutos",
    ),
    SchedulingModel(
      id: "03",
      name: "Sobrancelha",
      servicoId: "Sobrancelha",
      data: DateTime.now().add(Duration(days: 2)),
      duracao: "15 minutos",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Serviços"),
      ),
      body: ListView.builder(
        itemCount: services.length,
        itemBuilder: (context, index) {
          SchedulingModel service = services[index];

          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
              leading: Icon(
                _getIconForService(service.servicoId),
                size: 40,
                color: Colors.blueAccent,
              ),
              title: Center(
                child: Text(
                  service.servicoId,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
              trailing: const Icon(
                Icons.arrow_forward_ios,
                size: 28,
              ),
              onTap: () {
                showModalScheduling(context, service);
              },
            ),
          );
        },
      ),
      drawer: const CustomDrawer(),
    );
  }

  IconData _getIconForService(String service) {
    switch (service) {
      case "Cabelo":
        return Icons.cut;
      case "Barba":
        return Icons.content_cut;
      case "Sobrancelha":
        return Icons.remove_red_eye;
      default:
        return Icons.help_outline;
    }
  }
}
