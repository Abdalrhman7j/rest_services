import 'package:flutter/material.dart';

class CategoriesWidget extends StatelessWidget {
  const CategoriesWidget({required this.selected, required this.onSelected, super.key});

  final String? selected;
  final ValueChanged<String?> onSelected;

  static const _categories = <(String, IconData)>[
    ('Burger', Icons.lunch_dining),
    ('Pizza', Icons.local_pizza),
    ('Coffee', Icons.coffee),
    ('Chicken', Icons.set_meal),
    ('Dessert', Icons.cake),
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 112,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          final category = _categories[index];
          final active = selected == category.$1;
          return Padding(
            padding: EdgeInsets.only(left: index == 0 ? 16 : 8, right: index == _categories.length - 1 ? 16 : 0),
            child: InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: () => onSelected(active ? null : category.$1),
              child: Column(
                children: [
                  Ink(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(color: active ? Colors.orange : Colors.white, borderRadius: BorderRadius.circular(20)),
                    child: Icon(category.$2, size: 30, color: active ? Colors.white : Colors.orange),
                  ),
                  const SizedBox(height: 8),
                  Text(category.$1),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
