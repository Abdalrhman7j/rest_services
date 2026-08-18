import 'package:flutter/material.dart';

class HomeAppBar extends StatelessWidget {
  const HomeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),

      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,

        children: [

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: const [

              Text(
                "Deliver To",
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),

              SizedBox(height: 5),

              Text(
                "Damascus, Syria",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          Container(
            padding: const EdgeInsets.all(12),

            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
            ),

            child: const Icon(Icons.notifications_none),
          ),
        ],
      ),
    );
  }
}