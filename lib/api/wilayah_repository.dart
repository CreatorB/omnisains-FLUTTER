import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:omnisains_mobile/api/api_client.dart';
import 'package:omnisains_mobile/models/region.dart';

final wilayahRepositoryProvider = Provider<WilayahRepository>((ref) {
  return WilayahRepository(ref.watch(apiClientProvider));
});

class WilayahRepository {
  final ApiClient _api;

  WilayahRepository(this._api);

  Future<List<Province>> getProvinces() async {
    final response = await _api.get('/wilayah/provinces');
    final items = response['items'] as List<dynamic>? ?? [];
    return items.map((json) => Province.fromJson(json)).toList();
  }

  Future<List<Region>> getRegencies(String provinceCode) async {
    final response = await _api.get('/wilayah/regencies', queryParameters: {
      'province_code': provinceCode,
    });
    final items = response['items'] as List<dynamic>? ?? [];
    return items.map((json) => Region.fromJson(json)).toList();
  }

  Future<List<Region>> getCities() async {
    final response = await _api.get('/wilayah/cities');
    final items = response['items'] as List<dynamic>? ?? [];
    return items.map((json) => Region.fromJson(json)).toList();
  }

  Future<List<Region>> getDistricts(String regencyCode) async {
    final response = await _api.get('/wilayah/districts', queryParameters: {
      'regency_code': regencyCode,
    });
    final items = response['items'] as List<dynamic>? ?? [];
    return items.map((json) => Region.fromJson(json)).toList();
  }

  Future<List<Region>> getVillages(String districtCode) async {
    final response = await _api.get('/wilayah/villages', queryParameters: {
      'district_code': districtCode,
    });
    final items = response['items'] as List<dynamic>? ?? [];
    return items.map((json) => Region.fromJson(json)).toList();
  }

  Future<List<Region>> searchCities(String query) async {
    final response = await _api.get('/wilayah/cities/search', queryParameters: {'q': query});
    final items = response['items'] as List<dynamic>? ?? [];
    return items.map((json) => Region.fromJson(json)).toList();
  }
}