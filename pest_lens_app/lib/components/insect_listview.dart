import 'package:flutter/material.dart';

class InsectListView extends StatelessWidget {
  final List<Insect> insects = [
    Insect(name: 'Brown Planthopper', color: Colors.brown, quantity: 196),
    Insect(name: 'Stem Borers', color: Colors.orange, quantity: 274),
    Insect(name: 'Leaf Rollers', color: Colors.green, quantity: 242),
    Insect(name: 'Brown Planthopper', color: Colors.brown, quantity: 196),
    Insect(name: 'Stem Borers', color: Colors.orange, quantity: 274),
    Insect(name: 'Leaf Rollers', color: Colors.green, quantity: 242),
  ];

  InsectListView({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: insects.length,
      itemBuilder: (context, index) {
        return InsectTile(insect: insects[index]);
      },
    );
  }
}

class Insect {
  final String name;
  final Color color;
  final int quantity;

  Insect({required this.name, required this.color, required this.quantity});
}

class InsectTile extends StatelessWidget {
  final Insect insect;

  const InsectTile({super.key, required this.insect});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: insect.color,
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  insect.name,
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
            Text(
              insect.quantity.toString(),
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
