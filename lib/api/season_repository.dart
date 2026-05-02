import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:omnisains_mobile/api/api_client.dart';
import 'package:omnisains_mobile/models/season.dart';

final seasonRepositoryProvider = Provider<SeasonRepository>((ref) {
  return SeasonRepository(ref.watch(apiClientProvider));
});

class SeasonRepository {
  final ApiClient _api;

  SeasonRepository(this._api);

  Future<List<Season>> getActiveSeasons() async {
    final response = await _api.get('/admin/events/seasons');
    final items = response['items'] as List<dynamic>? ?? [];
    return items.map((json) => Season.fromJson(json)).toList();
  }
}