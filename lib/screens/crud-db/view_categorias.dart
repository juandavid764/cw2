import 'package:cw2/database/db_functions.dart';
import 'package:cw2/models/model_category.dart';
import 'package:cw2/screens/crud-db/add_category.dart';
import 'package:cw2/screens/crud-db/update_category.dart';
import 'package:cw2/provider/provider_notifier.dart';
import 'package:flutter/material.dart';

class ViewCategories extends StatelessWidget {
  const ViewCategories({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Categorias'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const AddCategory(),
              ));
            },
            icon: const Icon(Icons.add),
          )
        ],
        centerTitle: true,
      ),
      body: ValueListenableBuilder(
        valueListenable: categorytList,
        builder: (context, value, child) {
          return ListView.builder(
            itemCount: value.length,
            itemBuilder: (context, index) {
              final category = value[index];

              return Card(
                margin: const EdgeInsets.all(10),
                elevation: 1,
                child: ListTile(
                  title: Text(category.name,
                      style: Theme.of(context).textTheme.bodyMedium),
                  subtitle: Text("Id: ${category.id}",
                      style: Theme.of(context).textTheme.bodySmall),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.edit,
                          color: Colors.black,
                        ),
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) =>
                                UpdateCategory(category: category),
                          ));
                        },
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.delete,
                          color: Colors.black,
                        ),
                        onPressed: () {
                          confirmarEliminacion(context, category);
                        },
                      ),
                    ],
                  ),
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => UpdateCategory(category: category),
                    ));
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }

  void confirmarEliminacion(rtx, CategoryModel category) {
    showDialog(
      context: rtx,
      builder: (context) {
        return AlertDialog(
          title: const Text('Eliminar'),
          content: const Text('¿Quieres eliminar esta categoria?'),
          actions: [
            TextButton(
              onPressed: () {
                delectYes(context, category);
              },
              child: const Text('Si'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(rtx);
              },
              child: const Text('No'),
            ),
          ],
        );
      },
    );
  }

  void delectYes(ctx, CategoryModel category) {
    deleteCategory(category.id);
    ScaffoldMessenger.of(ctx).showSnackBar(
      const SnackBar(
        content: Text("Borrado Exitoso"),
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.all(10),
        backgroundColor: Color.fromARGB(255, 82, 134, 255),
        duration: Duration(seconds: 2),
      ),
    );
    Navigator.of(ctx).pop();
  }
}
