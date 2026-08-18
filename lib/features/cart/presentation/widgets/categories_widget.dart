import 'package:flutter/material.dart';

class CategoriesWidget extends StatelessWidget {
  const CategoriesWidget({super.key});

  @override
  Widget build(BuildContext context) {

    final categories = [
      "Burger",
      "Pizza",
      "Coffee",
      "Chicken",
      "Dessert",
    ];

    final icons = [
      Icons.lunch_dining,
      Icons.local_pizza,
      Icons.coffee,
      Icons.set_meal,
      Icons.cake,
    ];

    return SizedBox(
      height: 110,

      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,

        itemBuilder: (context, index) {

          return Padding(
            padding: const EdgeInsets.only(left: 16),

            child: Column(
              children: [

                Container(
                  padding: const EdgeInsets.all(18),

                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),

                  child: Icon(
                    icons[index],
                    size: 30,
                    color: Colors.orange,
                  ),
                ),

                const SizedBox(height: 10),

                Text(categories[index]),
              ],
            ),
          );
        },
      ),
    );
  }
}