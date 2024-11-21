class SchedulingModel {
  String id;
  String name;
  String servicoId;
  DateTime data;
  String duracao;

  SchedulingModel({
    required this.id,
    required this.name,
    required this.servicoId,
    required this.data,
    required this.duracao,
  });

  SchedulingModel.fromMap(Map<String, dynamic> map,
      {required String documentId})
      : id = documentId,
        name = map["name"] ?? '',
        servicoId = map["servicoId"] ?? '',
        data = DateTime.parse(map["data"]),
        duracao = map["duracao"] ?? '';

  Map<String, dynamic> toMap() {
    return {
      "name": name,
      "servicoId": servicoId,
      "data": data.toIso8601String(),
      "duracao": duracao,
    };
  }
}
