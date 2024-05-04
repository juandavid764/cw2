import 'package:cw2/screens/navigation.dart';
import 'package:cw2/provider/provider_notifier.dart';
import 'package:flutter/material.dart';

class Nodes extends StatelessWidget {
  const Nodes({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int cantRoots = rootsCategories.value.length;
    return GridView.builder(
      reverse: true,
      itemCount: cantRoots,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: cantRoots == 0
            ? 1
            : cantRoots >= 3
                ? 3
                : cantRoots, // Set the number of columns here
      ),
      itemBuilder: (context, index) {
        final categoria = rootsCategories.value[index];

        return Card(
          margin: const EdgeInsets.all(10),
          elevation: 1,
          child: InkWell(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (ctr) => Navigation(category: categoria.id),
              ));
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 12),
                Text(
                  categoria.name,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
