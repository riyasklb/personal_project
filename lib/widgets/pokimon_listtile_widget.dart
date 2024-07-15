import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:personal_project/models/pokimon.dart';
import 'package:personal_project/providers/pokimon_data_providers.dart';
import 'package:skeletonizer/skeletonizer.dart';

class PokimonListTileWidget extends ConsumerWidget {
  const PokimonListTileWidget({
    super.key,
    required this.pokimonurl,
  });
  final String pokimonurl;
  @override
  Widget build(
    BuildContext context,
    WidgetRef ref,
  ) {
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
      child: ListTile(
        title: Text(pokimonurl),
      ),
    );
  }
}
