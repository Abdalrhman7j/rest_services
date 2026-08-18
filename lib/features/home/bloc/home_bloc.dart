import 'package:flutter_bloc/flutter_bloc.dart';


import '../data/repositories/home_repository.dart';
import 'home_event.dart';
import 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {

  final HomeRepository repository;

  HomeBloc(this.repository) : super(HomeInitial()) {

    on<LoadRestaurantsEvent>((event, emit) async {

      emit(HomeLoading());

      try {
        final data = await repository.getRestaurants();
        emit(HomeLoaded(data));
      } catch (e) {
        emit(HomeError("Something went wrong"));
      }
    });
  }
}