import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:personal_project/models/pokimon.dart';
import 'package:personal_project/providers/pokimon_data_providers.dart';
import 'package:personal_project/widgets/pokimon_ststus_card.dart';
import 'package:skeletonizer/skeletonizer.dart';

class PokimonCard extends ConsumerWidget {
  final String pokimonURL;
  late FavoritePokemonsProvider _favoritePokemonsProvider;
  PokimonCard({
    super.key,
    required this.pokimonURL,
  });
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pokimon = ref.watch(
      pokemonDataProvider(
        pokimonURL,
      ),
    );
    _favoritePokemonsProvider = ref.watch(
      favoritePokemonsProvider.notifier,
    );
    return pokimon.when(data: (data) {
      return _card(
        context,
        false,
        data,
      );
    }, error: (error, stackTrace) {
      return Text('error:$error');
    }, loading: () {
      return _card(
        context,
        true,
        null,
      );
    });
  }

  Widget _card(
    BuildContext context,
    bool isLoading,
    Pokemon? pokemon,
  ) {
    return Skeletonizer(
      enabled: isLoading,
      ignoreContainers: isLoading,
      child: InkWell(
        onTap: () {
          showDialog(
              context: context,
              builder: (_) {
                return PokimonStstusCard(
                  pokemonURL: pokimonURL,
                );
              });
        },
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.sizeOf(context).width * 0.03,
            vertical: MediaQuery.sizeOf(context).height * 0.01,
          ),
          margin: EdgeInsets.symmetric(
            horizontal: MediaQuery.sizeOf(context).width * 0.03,
            vertical: MediaQuery.sizeOf(context).height * 0.01,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: Colors.grey[200],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  Text(
                    pokemon?.name!.toUpperCase()??'',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  )
                ],
              ),
              CircleAvatar(
                  radius: 40,
                  backgroundImage: pokemon != null
                      ? NetworkImage(pokemon.sprites!.frontDefault!)
                      : null),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                   Text("Moves ${pokemon?.moves!.length}"),
                  InkWell(
                    onTap: () {
                      _favoritePokemonsProvider.removeFavoritePokemon(
                        pokimonURL,
                      );
                    },
                    child: Icon(
                      Icons.favorite,
                      color: Colors.red,
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
