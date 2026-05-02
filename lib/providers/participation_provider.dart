import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:omnisains_mobile/api/participation_repository.dart';
import 'package:omnisains_mobile/models/participation.dart';

final myParticipationsProvider = FutureProvider<List<Participation>>((ref) async {
  return ref.watch(participationRepositoryProvider).getMyParticipations();
});