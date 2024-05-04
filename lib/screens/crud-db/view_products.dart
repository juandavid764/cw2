import 'package:cw2/database/db_functions.dart';
import 'package:cw2/models/model_product.dart';
import 'package:cw2/screens/crud-db/add_product.dart';
import 'package:cw2/screens/crud-db/update_product.dart';
import 'package:cw2/provider/provider_notifier.dart';
import 'package:flutter/material.dart';

class ViewProducts extends StatelessWidget {
  const ViewProducts({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Productos'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const AddProduct(),
              ));
            },
            icon: const Icon(Icons.add),
          )
        ],
        centerTitle: true,
      ),
      body: ValueListenableBuilder(
        valueListenable: productList,
        builder: (context, value, child) {
          return ListView.builder(
            itemCount: value.length,
            itemBuilder: (context, index) {
              final product = value[index];

              return Card(
                margin: const EdgeInsets.all(10),
                elevation: 1,
                child: ListTile(
                  title: Text(product.name,
                      style: Theme.of(context).textTheme.bodyMedium),
                  subtitle: Text(
                    "Precio: \$${product.price} \nCategoria: ${product.category}",
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
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
                                UpdateProduct(product: product),
                          ));
                        },
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.delete,
                          color: Colors.black,
                        ),
                        onPressed: () {
                          deleteproduct(context, product);
                        },
                      ),
                    ],
                  ),
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => UpdateProduct(product: product),
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

  void deleteproduct(rtx, ProductModel product) {
    showDialog(
      context: rtx,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete'),
          content: const Text('¿Quieres eliminar este producto?'),
          actions: [
            TextButton(
              onPressed: () {
                delectYes(context, product);
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

  void delectYes(ctx, ProductModel product) {
    deleteProduct(product.id);
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
