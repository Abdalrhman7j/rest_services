
import '../data/models/restaurant_model.dart';

abstract class HomeState {}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  final List<RestaurantModel> restaurants;

  HomeLoaded(this.restaurants);
}

class HomeError extends HomeState {
  final String message;

  HomeError(this.message);
}