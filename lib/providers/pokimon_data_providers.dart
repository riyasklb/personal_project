import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:personal_project/models/pokimon.dart';
import 'package:personal_project/service/http_service.dart';

final pokemonDataProvider = FutureProvider.family<Pokemon?, String>(
  (ref, url) async {
    HttpService _httpService = GetIt.instance.get<HttpService>();
    Response? res = await _httpService.get(url);
    if (res != null && res.data != null) {
      return Pokemon.fromJson(res.data);
    }
    return null;
  },
);
