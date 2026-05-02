import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:omnisains_mobile/api/stage_repository.dart';
import 'package:omnisains_mobile/api/season_repository.dart';
import 'package:omnisains_mobile/models/stage.dart';
import 'package:omnisains_mobile/models/season.dart';

final stagesProvider = FutureProvider<List<Stage>>((ref) async {
  return ref.watch(stageRepositoryProvider).getStages();
});

final seasonsProvider = FutureProvider<List<Season>>((ref) async {
  return ref.watch(seasonRepositoryProvider).getActiveSeasons();
});