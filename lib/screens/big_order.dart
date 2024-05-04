import 'package:cw2/models/model_order.dart';
import 'package:cw2/models/model_product.dart';
import 'package:cw2/provider/provider_notifier.dart';
import 'package:cw2/screens/confrim.dart';
import 'package:cw2/screens/salsas.dart';
import 'package:cw2/widgets/buttonAdicion.dart';
import 'package:flutter/material.dart';

class BigOrder extends StatefulWidget {
  const BigOrder({Key? key, required this.product}) : super(key: key);
  final ProductModel product;

  @override
  BigOrderState createState() => BigOrderState();
}

class BigOrderState extends State<BigOrder> {
  @override
  void initState() {
    super.initState();
  }

  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Pedido Grupal",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              )),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 400,
                ),
                ButtonAdicion(
                  title: widget.product.name,
                  controller: _controller,
                ),
              ],
            ),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                const SizedBox(
                  height: 10,
                ),
                OutlinedButton(
                  style: ButtonStyle(
                    minimumSize: WidgetStateProperty.all(
                      const Size(100, 50),
                    ),
                  ),
                  onPressed: () {
                    //Creamos la order con la cantidad seleccionada
                    Order orderActual = Order(
                      product: widget.product,
                      cantidad: int.parse(_controller.text),
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
                    if (orderActual.product.salsas == 1) {
                      indexSalsas.value = 0;
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
                  child: const Text("Siguiente"),
                ),
              ]),
            ])
          ],
        ));
  }
}
