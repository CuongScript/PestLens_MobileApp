import 'package:flutter/material.dart';
import 'package:pest_lens_app/models/insect_model.dart';

class InsectListView extends StatelessWidget {
  final List<Insect> hardcodedInsects = [
    Insect(name: 'Brown Planthopper', color: Colors.brown, quantity: 196),
    Insect(name: 'Stem Borers', color: Colors.orange, quantity: 274),
    Insect(name: 'Leaf Rollers', color: Colors.green, quantity: 242),
    Insect(name: 'Brown Planthopper', color: Colors.brown, quantity: 196),
    Insect(name: 'Stem Borers', color: Colors.orange, quantity: 274),
    Insect(name: 'Leaf Rollers', color: Colors.green, quantity: 242),
  ];

  final List<Insect>? insects;

  InsectListView({super.key, this.insects});

  @override
  Widget build(BuildContext context) {
    final displayInsects = insects ?? hardcodedInsects;

    return ListView.builder(
      itemCount: displayInsects.length,
      itemBuilder: (context, index) {
        return InsectTile(insect: displayInsects[index]);
      },
    );
  }
}

class InsectTile extends StatelessWidget {
  final Insect insect;

  const InsectTile({Key? key, required this.insect}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      color: Colors.white,
      shadowColor: Colors.grey.withOpacity(0.3),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: insect.color,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.bug_report, color: Colors.white),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                insect.name,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Text(
              insect.quantity.toString(),
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: insect.color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
