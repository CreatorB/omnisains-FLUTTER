import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:omnisains_mobile/api/api_client.dart';
import 'package:omnisains_mobile/models/participation.dart';

final participationRepositoryProvider = Provider<ParticipationRepository>((ref) {
  return ParticipationRepository(ref.watch(apiClientProvider));
});

class ParticipationRepository {
  final ApiClient _api;

  ParticipationRepository(this._api);

  Future<List<Participation>> getMyParticipations() async {
    final response = await _api.get('/participations/my');
    final items = response['items'] as List<dynamic>? ?? [];
    return items.map((json) => Participation.fromJson(json)).toList();
  }

  Future<Map<String, dynamic>> register(int stageId) async {
    return await _api.post('/participations/register', data: {'stageId': stageId});
  }
}