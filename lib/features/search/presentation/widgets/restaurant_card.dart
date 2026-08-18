import 'package:flutter/material.dart';

class RestaurantCard extends StatelessWidget {
  const RestaurantCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ),

      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [

            Container(
              height: 180,

              decoration: const BoxDecoration(
                color: Colors.orange,

                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
              ),

              child: const Center(
                child: Icon(
                  Icons.restaurant,
                  color: Colors.white,
                  size: 80,
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(16),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: const [

                  Text(
                    "Burger House",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  SizedBox(height: 10),

                  Row(
                    children: [

                      Icon(
                        Icons.star,
                        color: Colors.orange,
                      ),

                      SizedBox(width: 5),

                      Text("4.8"),

                      SizedBox(width: 15),

                      Icon(Icons.timer),

                      SizedBox(width: 5),

                      Text("20 min"),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}