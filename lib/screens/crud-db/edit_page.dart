import 'package:cw2/screens/crud-db/statistics/screen_statistics.dart';
import 'package:cw2/screens/crud-db/view_additions.dart';
import 'package:cw2/screens/crud-db/view_categorias.dart';
import 'package:cw2/screens/crud-db/view_products.dart';
import 'package:flutter/material.dart';

class EditPage extends StatefulWidget {
  const EditPage({super.key});

  @override
  State<EditPage> createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/home',
                (route) =>
                    false, // Se establece la condición para eliminar todas las rutas
              );
            },
            icon: const Icon(Icons.food_bank)),
        automaticallyImplyLeading: false,
        title: const Text(
          'Editar',
        ),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (ctr) => const StatisticsScreen(),
                ));
              },
              icon: const Icon(
                Icons.insert_chart_rounded,
                color: Color.fromARGB(255, 255, 230, 0),
              ))
        ],
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            const SizedBox(height: 100),

            //Boton 'Products'
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (ctr) => const ViewProducts(),
                ));
              },
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 40.0),
                child: Text(
                  'Productos',
                  style: TextStyle(fontSize: 18.0),
                ),
              ),
            ),

            //Boton 'categorias'
            const SizedBox(height: 100),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (ctr) => const ViewCategories(),
                ));
              },
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 40.0),
                child: Text(
                  'Categorias',
                  style: TextStyle(fontSize: 18.0),
                ),
              ),
            ),
            const SizedBox(height: 100),

            //Boton 'Adiciones'
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (ctr) => const ViewAdditions(),
                ));
              },
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 40.0),
                child: Text(
                  'Adiciones',
                  style: TextStyle(fontSize: 18.0),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
