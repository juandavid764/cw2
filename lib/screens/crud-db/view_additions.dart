import 'package:cw2/database/db_functions.dart';
import 'package:cw2/models/model_additions.dart';
import 'package:cw2/screens/crud-db/add_addition.dart';
import 'package:cw2/screens/crud-db/update_addition.dart';
import 'package:cw2/provider/provider_notifier.dart';
import 'package:flutter/material.dart';

class ViewAdditions extends StatelessWidget {
  const ViewAdditions({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Adiciones'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const AddAddition(),
              ));
            },
            icon: const Icon(Icons.add),
          )
        ],
        centerTitle: true,
      ),
      body: ValueListenableBuilder(
        valueListenable: additionsList,
        builder: (context, value, child) {
          return ListView.builder(
            itemCount: value.length,
            itemBuilder: (context, index) {
              final addition = value[index];

              return Card(
                margin: const EdgeInsets.all(10),
                elevation: 1,
                child: ListTile(
                  title: Text(addition.name,
                      style: Theme.of(context).textTheme.bodyMedium),
                  subtitle: Text("Precio: \$${addition.price}",
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
                                UpdateAddition(addition: addition),
                          ));
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.black),
                        onPressed: () {
                          confirmarEliminacion(context, addition);
                        },
                      ),
                    ],
                  ),
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => UpdateAddition(addition: addition),
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

  void confirmarEliminacion(rtx, AdditionModel addition) {
    showDialog(
      context: rtx,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete'),
          content: const Text('¿Quieres eliminar esta adicion?'),
          actions: [
            TextButton(
              onPressed: () {
                delectYes(context, addition);
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

  void delectYes(ctx, AdditionModel addition) {
    deleteAddition(addition.id);
    ScaffoldMessenger.of(ctx).showSnackBar(
      const SnackBar(
        content: Text("Successfully Deleted"),
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.all(10),
        backgroundColor: Color.fromARGB(255, 82, 134, 255),
        duration: Duration(seconds: 2),
      ),
    );
    Navigator.of(ctx).pop();
  }
}
