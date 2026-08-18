import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../cart/bloc/cart_cubit.dart';
import '../../../cart/data/repositories/cart_repository.dart';
import '../../../cart/presentation/pages/cart_page.dart';
import '../../../orders/presentation/pages/orders_page.dart';
import '../../../profile/presentation/pages/profile_page.dart';
import '../../bloc/home_bloc.dart';
import '../../bloc/home_event.dart';
import '../../data/repositories/home_repository.dart';
import '../pages/home_page.dart';

class MainLayout extends StatelessWidget {
  const MainLayout({required this.userId, super.key});

  final String userId;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => HomeBloc(HomeRepository())..add(LoadRestaurantsEvent()),
        ),
        BlocProvider(
          create: (_) => CartCubit(CartRepository(userId: userId))..start(),
        ),
      ],
      child: _NavigationLayout(userId: userId),
    );
  }
}

class _NavigationLayout extends StatefulWidget {
  const _NavigationLayout({required this.userId});

  final String userId;

  @override
  State<_NavigationLayout> createState() => _NavigationLayoutState();
}

class _NavigationLayoutState extends State<_NavigationLayout> {
  int _currentIndex = 0;

  late final List<Widget> _pages = [
    const HomePage(),
    CartPage(userId: widget.userId),
    OrdersPage(userId: widget.userId),
    const ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _pages),
      bottomNavigationBar: BlocBuilder<CartCubit, CartState>(
        builder: (context, cart) {
          return NavigationBar(
            selectedIndex: _currentIndex,
            onDestinationSelected: (index) => setState(() => _currentIndex = index),
            destinations: [
              const NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: 'Home'),
              NavigationDestination(
                icon: Badge(isLabelVisible: cart.count > 0, label: Text('${cart.count}'), child: const Icon(Icons.shopping_cart_outlined)),
                selectedIcon: Badge(isLabelVisible: cart.count > 0, label: Text('${cart.count}'), child: const Icon(Icons.shopping_cart)),
                label: 'Cart',
              ),
              const NavigationDestination(icon: Icon(Icons.receipt_long_outlined), selectedIcon: Icon(Icons.receipt_long), label: 'Orders'),
              const NavigationDestination(icon: Icon(Icons.person_outline), selectedIcon: Icon(Icons.person), label: 'Profile'),
            ],
          );
        },
      ),
    );
  }
}
