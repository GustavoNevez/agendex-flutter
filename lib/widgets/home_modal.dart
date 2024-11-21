import 'package:agendex_flutter/models/scheduling_model.dart';
import 'package:agendex_flutter/services/scheduling_service.dart';
import 'package:flutter/material.dart';

void showModalScheduling(
    BuildContext context, SchedulingModel schedulingModel) {
  showModalBottomSheet(
    context: context,
    builder: (context) {
      return ServiceWorkView(schedulingModel: schedulingModel);
    },
    backgroundColor: Colors.grey[100],
    isDismissible: true,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
    ),
  );
}

class ServiceWorkView extends StatefulWidget {
  final SchedulingModel schedulingModel;

  const ServiceWorkView({super.key, required this.schedulingModel});

  @override
  State<ServiceWorkView> createState() => _ServiceWorkViewState();
}

class _ServiceWorkViewState extends State<ServiceWorkView> {
  DateTime? selectedDate;
  String? selectedTime;

  final List<String> availableTimes = [
    "09:00",
    "10:00",
    "11:00",
    "14:00",
    "15:00",
    "16:00"
  ];

  final SchedulingService _schedulingService = SchedulingService();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Serviço: ${widget.schedulingModel.servicoId}",
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.blueAccent,
            ),
          ),
          const SizedBox(height: 20),

          Text(
            "Selecione a data:",
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          OutlinedButton.icon(
            icon: const Icon(Icons.calendar_today, color: Colors.blueAccent),
            label: Text(
              selectedDate == null
                  ? "Escolha uma data"
                  : "${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}",
              style: TextStyle(
                fontSize: 18,
                color: selectedDate == null ? Colors.grey : Colors.black,
              ),
            ),
            onPressed: () async {
              DateTime? date = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime.now(),
                lastDate: DateTime.now().add(const Duration(days: 30)),
              );
              if (date != null) {
                setState(() {
                  selectedDate = date;
                });
              }
            },
          ),
          const SizedBox(height: 20),

          Text(
            "Selecione o horário:",
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          DropdownButton<String>(
            isExpanded: true,
            value: selectedTime,
            hint: const Text(
              "Escolha um horário",
              style: TextStyle(fontSize: 18),
            ),
            items: availableTimes.map((time) {
              return DropdownMenuItem(
                value: time,
                child: Text(time, style: const TextStyle(fontSize: 18)),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                selectedTime = value;
              });
            },
          ),
          const SizedBox(height: 30),

          // Botão de agendar
          Center(
            child: ElevatedButton(
              onPressed: (selectedDate != null && selectedTime != null)
                  ? () async {
                      try {
                        await _schedulingService.saveScheduling(
                          servicoId: widget.schedulingModel.servicoId,
                          date: selectedDate!,
                          time: selectedTime!,
                        );

                        Navigator.of(context).pop();

                        showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                            title: const Text("Agendamento Confirmado",
                                style: TextStyle(fontSize: 20)),
                            content: Text(
                                "Agendado para ${widget.schedulingModel.servicoId} no dia ${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year} às $selectedTime.",
                                style: TextStyle(fontSize: 16)),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context, rootNavigator: true)
                                      .pop();
                                },
                                child: const Text("OK",
                                    style: TextStyle(fontSize: 18)),
                              ),
                            ],
                          ),
                        );
                      } catch (e) {
                        showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                            title: const Text("Erro",
                                style: TextStyle(fontSize: 20)),
                            content: Text(
                                "Não foi possível salvar o agendamento: $e",
                                style: TextStyle(fontSize: 16)),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.of(context).pop(),
                                child: const Text("OK",
                                    style: TextStyle(fontSize: 18)),
                              ),
                            ],
                          ),
                        );
                      }
                    }
                  : null,
              child: const Text(
                "Agendar",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                backgroundColor: Colors.blueAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                foregroundColor: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
