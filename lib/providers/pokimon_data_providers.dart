import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:personal_project/models/pokimon.dart';
import 'package:personal_project/service/database_service.dart';
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

final favoritePokemonsProvider =
    StateNotifierProvider<FavoritePokemonsProvider, List<String>>((ref) {
  return FavoritePokemonsProvider(
    [],
  );
});

class FavoritePokemonsProvider extends StateNotifier<List<String>> {
  final DatabaseService _databaseService =
      GetIt.instance.get<DatabaseService>();
  String FAVORITE_POKIMON_LIST_KEY = "FAVORITE_POKIMON_LIST_KEY";

  FavoritePokemonsProvider(
    super._state,
  ) {
    _setup();
  }
  Future<void> _setup() async {
    List<String>? result =
        await _databaseService.getList(FAVORITE_POKIMON_LIST_KEY);
    state = result ?? [];
  }

  void removeFavoritePokemon(String url) {
    state = state.where((e) => e != url).toList();
     _databaseService.saveList(FAVORITE_POKIMON_LIST_KEY, state);
  }

  void addFavoritePokemon(String url) {
    state = [...state, url];
    _databaseService.saveList(FAVORITE_POKIMON_LIST_KEY, state);
  }
}
