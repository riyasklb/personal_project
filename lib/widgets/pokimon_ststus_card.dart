import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:personal_project/providers/pokimon_data_providers.dart';

class PokimonStstusCard extends ConsumerWidget {
  final String pokemonURL;

  const PokimonStstusCard({
    super.key,
    required this.pokemonURL,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pokemon = ref.watch(pokemonDataProvider(pokemonURL));
    return AlertDialog(
      title: Text('Statistics'),
      content: pokemon.when(data: (data) {
        return Column(
            mainAxisSize: MainAxisSize.min,
            children: data?.stats?.map((s) {
                  return Text(
                      'name${s.stat!.name!.toLowerCase()}:${s.baseStat!}');
                }).toList() ??
                []);
      }, error: (error, stackTrace) {
        return Text('error:$error');
      }, loading: () {
        return CircularProgressIndicator();
      }),
    );
  }
}
