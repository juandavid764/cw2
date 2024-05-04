//import 'dart:io';
import 'package:cw2/models/model_category.dart';
import 'package:cw2/models/model_order.dart';
import 'package:cw2/models/model_product.dart';
import 'package:cw2/screens/big_order.dart';
import 'package:cw2/screens/confrim.dart';
import 'package:cw2/screens/salsas.dart';
import 'package:cw2/provider/provider_notifier.dart';
import 'package:flutter/material.dart';

class Navigation extends StatelessWidget {
  final int category;

  const Navigation({
    super.key,
    required this.category,
  });

  @override
  Widget build(BuildContext context) {
    ValueNotifier<List<ProductModel>> tempProductList = ValueNotifier(
      filtrarProduct(productList.value, category),
    );
    int cantProducts = tempProductList.value.length;

    ValueNotifier<List<CategoryModel>> tempCategoryList = ValueNotifier(
      filtrarCategory(categorytList.value, category),
    );
    int cantCategories = tempCategoryList.value.length;

    //
    int flexCategories = 2;
    int flexProducts = 2;

    //Define disposicion de los botones
    if (cantCategories == 0) {
      flexCategories = 1;
    } else if (cantProducts == 0) {
      flexProducts = 1;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Navegacion',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
        Expanded(
          flex: flexProducts,
          child: ValueListenableBuilder(
            valueListenable: tempProductList,
            builder: (context, value, child) {
              return GridView.builder(
                reverse: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: cantProducts == 0
                      ? 1
                      : cantProducts >= 3
                          ? 3
                          : cantProducts, // Set the number of columns here
                ),
                itemCount: value.length,
                itemBuilder: (context, index) {
                  final botonSelected = value[index];

                  return Card(
                    margin: const EdgeInsets.all(10),
                    elevation: 7,
                    child: InkWell(
                      //1+ producto a la vez
                      onLongPress: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (ctr) => BigOrder(product: botonSelected),
                        ));
                      },

                      //1 prodcto a la vez
                      onTap: () {
                        //Datos producto actual
                        Order orderActual = Order(
                          product: botonSelected,
                          cantidad: 1,
                          salsas: [],
                          adiciones: [],
                        );

                        //Insertamos datos a la comanda
                        int index = indexComanda.value;
                        int tamano = comanda.value.length;

                        //Se verifica si ya inserto en ese indice
                        if (index >= 0 && index < tamano) {
                          comanda.value[indexComanda.value] = orderActual;
                        } else {
                          comanda.value.add(orderActual);
                        }

                        //Si el producto lleva salsas
                        if (botonSelected.salsas == 1) {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (ctr) => const Salsas(),
                          ));

                          //El producto no lleva salsas ni adiciones
                        } else {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (ctr) => const PrintPage(),
                          ));
                        }
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(height: 12),
                          Text(
                            botonSelected.name,
                            style: const TextStyle(
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
            },
          ),
        ),
        Expanded(
          flex: flexCategories,
          child: ValueListenableBuilder(
            valueListenable: tempCategoryList,
            builder: (context, value, child) {
              return GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: cantCategories == 0
                      ? 1
                      : cantCategories >= 3
                          ? 3
                          : cantCategories, // Set the number of columns here
                ),
                itemCount: value.length,
                itemBuilder: (context, index) {
                  final botonSelected = value[index];

                  return Card(
                    margin: const EdgeInsets.all(10),
                    elevation: 1,
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (ctr) =>
                              Navigation(category: botonSelected.id),
                        ));
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(height: 12),
                          Text(
                            botonSelected.name,
                            style: const TextStyle(
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
            },
          ),
        ),
      ]),
    );
  }

  // Función para filtrar los productos por categoría
  List<ProductModel> filtrarProduct(
    List<ProductModel> products,
    int idCategory,
  ) {
    List<ProductModel> tempProductList = [];

    for (var product in products) {
      if (product.isChild(
        idCategory,
      )) {
        tempProductList.add(
          product,
        );
      }
    }
    return tempProductList;
  }

  // Función para filtrar las categorias por categoría
  List<CategoryModel> filtrarCategory(
    List<CategoryModel> categories,
    int idCategory,
  ) {
    List<CategoryModel> tempCategoriesList = [];

    for (var category in categories) {
      if (category.isChild(
        idCategory,
      )) {
        tempCategoriesList.add(
          category,
        );
      }
    }
    return tempCategoriesList;
  }
}
