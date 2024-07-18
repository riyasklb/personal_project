import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:personal_project/models/pokimon.dart';
import 'package:personal_project/providers/pokimon_data_providers.dart';
import 'package:personal_project/widgets/pokimon_ststus_card.dart';
import 'package:skeletonizer/skeletonizer.dart';

class PokimonListTileWidget extends ConsumerWidget {
  PokimonListTileWidget({
    super.key,
    required this.pokimonurl,
  });
  final String pokimonurl;

  late FavoritePokemonsProvider _favoritePokemonsProvider;
  late List<String> _favoritePokemons;
  @override
  Widget build(
    BuildContext context,
    WidgetRef ref,
  ) {
    _favoritePokemonsProvider = ref.watch(
      favoritePokemonsProvider.notifier,
    );

    _favoritePokemons = ref.watch(
      favoritePokemonsProvider,
    );
    final pokemon = ref.watch(
      pokemonDataProvider(
        pokimonurl,
      ),
    );

    return pokemon.when(data: (data) {
      return _tile(
        context,
        false,
        data,
      );
    }, error: (error, stackTrace) {
      return Text('error:$error');
    }, loading: () {
      return _tile(
        context,
        true,
        null,
      );
    });
  }

  Widget _tile(
    BuildContext context,
    bool isLoading,
    Pokemon? pokemon,
  ) {
    return Skeletonizer(
      enabled: isLoading,
      child: InkWell(
          onTap: () {
          showDialog(
              context: context,
              builder: (_) {
                return PokimonStstusCard(
                  pokemonURL: pokimonurl,
                );
              });},
        child: ListTile(
          leading: pokemon != null
              ? CircleAvatar(
                  backgroundImage: NetworkImage(pokemon.sprites!.frontDefault!),
                )
              : CircleAvatar(),
          title: Text(pokemon != null
              ? pokemon.name!.toUpperCase()
              : 'currently loading name for pokemon'),
          subtitle: Text('Has${pokemon?.moves?.length.toString() ?? 0} moves'),
          trailing: IconButton(
              onPressed: () {
                if (_favoritePokemons.contains(pokimonurl)) {
                  _favoritePokemonsProvider.removeFavoritePokemon(pokimonurl);
                } else {
                  _favoritePokemonsProvider.addFavoritePokemon(pokimonurl);
                }
              },
              icon: Icon(
                _favoritePokemons.contains(pokimonurl)
                    ? Icons.favorite
                    : Icons.favorite_border_outlined,
                color: Colors.red,
              )),
        ),
      ),
    );
  }
}
