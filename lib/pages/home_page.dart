import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:personal_project/controllers/home_page_controller.dart';
import 'package:personal_project/models/page_data.dart';
import 'package:personal_project/models/pokimon.dart';
import 'package:personal_project/providers/pokimon_data_providers.dart';
import 'package:personal_project/widgets/pokimon_card.dart';
import 'package:personal_project/widgets/pokimon_listtile_widget.dart';

final homePageControllerProvider =
    StateNotifierProvider<HomePageController, HomePageData>((ref) {
  return HomePageController(HomePageData.initial());
});

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  final ScrollController _allpockimonslistcontroller = ScrollController();
  late HomePageController _homePageController;
  late HomePageData _homePageData;
  late List<String> _favoritepokimon;

  @override
  void initState() {
    _allpockimonslistcontroller.addListener(_scrollListener);

    super.initState();
  }

  @override
  void dispose() {
    _allpockimonslistcontroller.removeListener(_scrollListener);
    _allpockimonslistcontroller.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_allpockimonslistcontroller.offset >=
            _allpockimonslistcontroller.position.maxScrollExtent &&
        !_allpockimonslistcontroller.position.outOfRange) {
      _homePageController.loadData();
    }
  }

  @override
  Widget build(BuildContext context) {
    _homePageController = ref.watch(
      homePageControllerProvider.notifier,
    );
    _homePageData = ref.watch(
      homePageControllerProvider,
    );
    _favoritepokimon = ref.watch(favoritePokemonsProvider);

    return Scaffold(
      body: _buildUI(
        context,
      ),
    );
  }

  Widget _buildUI(BuildContext context) {
    return SafeArea(
        child: SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.sizeOf(context).width * 0.02),
        width: MediaQuery.sizeOf(context).width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _favoritepockimonslist(
              context,
            ),
            _allpockimonslist(
              context,
            )
          ],
        ),
      ),
    ));
  }

  Widget _favoritepockimonslist(BuildContext context) {
    return SizedBox(
      width: MediaQuery.sizeOf(context).width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Favorite',
            style: TextStyle(fontSize: 25),
          ),
          SizedBox(
            width: MediaQuery.sizeOf(context).width,
            height: MediaQuery.sizeOf(context).height * 0.50,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (_favoritepokimon.isNotEmpty)
                  SizedBox(
                    height: MediaQuery.sizeOf(context).height * 0.48,
                    child: GridView.builder(scrollDirection: Axis.horizontal,
                      itemCount: _favoritepokimon.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2),
                      itemBuilder: (context, index) {
                        String pokimonURL = _favoritepokimon[index];
                        return PokimonCard(
                          pokimonURL: pokimonURL,
                        );
                      },
                    ),
                  ),
                if (_favoritepokimon.isEmpty)
                  const Text('No favorite pokimons yet!')
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _allpockimonslist(BuildContext context) {
    return SizedBox(
      width: MediaQuery.sizeOf(context).width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'All pockimon',
            style: TextStyle(fontSize: 25),
          ),
          SizedBox(
            height: MediaQuery.sizeOf(context).height * 0.60,
            child: ListView.builder(
                controller: _allpockimonslistcontroller,
                itemCount: _homePageData.data?.results?.length ?? 0,
                itemBuilder: (context, index) {
                  PokemonListResult pokimon =
                      _homePageData.data!.results![index];
                  return PokimonListTileWidget(
                    pokimonurl: pokimon.url!,
                  );
                }),
          )
        ],
      ),
    );
  }
}
