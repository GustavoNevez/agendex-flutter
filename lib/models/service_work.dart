class ServiceWork {
  String id;
  String servico;
  String descricao;
  String duracao;

  ServiceWork({
    required this.id,
    required this.servico,
    required this.duracao,
    required this.descricao,
  });

  ServiceWork.fromMap(Map<String, dynamic> map)
      : id = map["id"],
        servico = map["servico"],
        descricao = map["descricao"],
        duracao = map["duracao"];

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "servico": servico,
      "duracao": duracao,
      "descricao": descricao
    };
  }
}
