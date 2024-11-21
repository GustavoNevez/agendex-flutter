import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SchedulingService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String get userId => FirebaseAuth.instance.currentUser!.uid;

  Future<void> saveScheduling({
    required String servicoId,
    required DateTime date,
    required String time,
  }) async {
    try {
      await _firestore.collection('schedules').add({
        'userId': userId,
        'servicoId': servicoId,
        'date': date.toIso8601String(),
        'time': time,
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Erro ao salvar agendamento: $e');
    }
  }

  Future<void> deleteScheduling(String schedulingId) async {
    await _firestore.collection('schedules').doc(schedulingId).delete();
  }
}
