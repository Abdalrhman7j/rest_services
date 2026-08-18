import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../menu/presentation/pages/restaurant_page.dart';
import '../../bloc/home_bloc.dart';
import '../../bloc/home_event.dart';
import '../../bloc/home_state.dart';
import '../../data/models/restaurant_model.dart';
import '../widgets/banner_widget.dart';
import '../widgets/categories_widget.dart';
import '../widgets/home_app_bar.dart';
import '../widgets/restaurant_card.dart';
import '../widgets/search_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _query = '';
  String? _category;

  List<RestaurantModel> _filtered(List<RestaurantModel> restaurants) {
    final query = _query.trim().toLowerCase();
    return restaurants.where((restaurant) {
      final matchesQuery = query.isEmpty ||
          restaurant.name.toLowerCase().contains(query) ||
          restaurant.category.toLowerCase().contains(query);
      return matchesQuery && (_category == null || restaurant.category == _category);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          if (state is HomeLoading || state is HomeInitial) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is HomeError) {
            return _MessageView(message: state.message, onRetry: () => context.read<HomeBloc>().add(LoadRestaurantsEvent()));
          }
          final restaurants = _filtered((state as HomeLoaded).restaurants);
          return RefreshIndicator(
            onRefresh: () async => context.read<HomeBloc>().add(LoadRestaurantsEvent()),
            child: ListView(
              children: [
                const HomeAppBar(),
                const SizedBox(height: 12),
                SearchWidget(onChanged: (value) => setState(() => _query = value)),
                const SizedBox(height: 20),
                const BannerWidget(),
                const SizedBox(height: 25),
                CategoriesWidget(selected: _category, onSelected: (value) => setState(() => _category = value)),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
                  child: Text('Restaurants', style: Theme.of(context).textTheme.titleLarge),
                ),
                if (restaurants.isEmpty)
                  const Padding(padding: EdgeInsets.all(32), child: Center(child: Text('No restaurants match your search yet.'))),
                ...restaurants.map((restaurant) => RestaurantCard(
                      restaurant: restaurant,
                      onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => RestaurantPage(restaurant: restaurant))),
                    )),
                const SizedBox(height: 24),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _MessageView extends StatelessWidget {
  const _MessageView({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(mainAxisSize: MainAxisSize.min, children: [Text(message, textAlign: TextAlign.center), const SizedBox(height: 12), OutlinedButton(onPressed: onRetry, child: const Text('Try again'))]),
      ),
    );
  }
}
