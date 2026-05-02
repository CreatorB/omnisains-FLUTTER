import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:omnisains_mobile/api/api_client.dart';
import 'package:omnisains_mobile/models/stage.dart';

final stageRepositoryProvider = Provider<StageRepository>((ref) {
  return StageRepository(ref.watch(apiClientProvider));
});

class StageRepository {
  final ApiClient _api;

  StageRepository(this._api);

  Future<List<Stage>> getStages() async {
    final response = await _api.get('/events/stages');
    final items = response['items'] as List<dynamic>? ?? [];
    return items.map((json) => Stage.fromJson(json)).toList();
  }

  Future<Stage> getPublicStage(String program) async {
    final response = await _api.get('/public/stage', queryParameters: {'program': program});
    final stageData = response['stage'] as Map<String, dynamic>? ?? response['data'] as Map<String, dynamic>? ?? {};
    return Stage.fromJson(stageData);
  }
}