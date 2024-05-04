import 'package:cw2/models/model_additions.dart';
import 'package:cw2/models/model_widget_adicion.dart';
import 'package:cw2/provider/provider_notifier.dart';
import 'package:cw2/screens/confrim.dart';
import 'package:cw2/screens/salsas.dart';
import 'package:cw2/widgets/buttonAdicion.dart';
import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';

class Adiciones extends StatefulWidget {
  const Adiciones({Key? key}) : super(key: key);

  @override
  AdicionesState createState() => AdicionesState();
}

class AdicionesState extends State<Adiciones> {
  final List<WidgetAdicion> _adiciones = [];

  @override
  void initState() {
    super.initState();

    for (AdditionModel adicionActual in additionsList.value) {
      _adiciones.add(
        WidgetAdicion(adicionActual, TextEditingController()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            // Navegar hacia atrás manualmente
            Navigator.pop(context);
          },
        ),
        title: const Text("Adiciones",
            style: TextStyle(
              fontWeight: FontWeight.bold,
            )),
      ),
      body: ResponsiveBuilder(
        builder: (context, sizingInformation) {
          int itemCount;
          double itemWidth;
          double itemHeight;

          if (sizingInformation.deviceScreenType == DeviceScreenType.desktop) {
            itemCount = 5;
            itemWidth = 200.0;
            itemHeight = 100.0;
          } else if (sizingInformation.deviceScreenType ==
              DeviceScreenType.tablet) {
            itemCount = 5;
            itemWidth = 200.0;
            itemHeight = 50.0;
          } else {
            itemCount = 3;
            itemWidth = 80.0;
            itemHeight = 50.0;
          }

          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 480,
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: itemCount,
                    crossAxisSpacing: 5.0,
                    mainAxisSpacing: 5.0,
                    childAspectRatio: 1.5,
                  ),
                  itemCount: _adiciones.length,
                  itemBuilder: (context, index) {
                    return Container(
                      alignment: Alignment.center,
                      width: itemWidth,
                      height: itemHeight,
                      child: ButtonAdicion(
                        title: _adiciones[index].adicion.name,
                        controller: _adiciones[index].controller,
                      ),
                    );
                  },
                ),
              ),
              ElevatedButton(
                style: const ButtonStyle(),
                onPressed: _save,
                child: const Text("Siguiente"),
              ),
            ],
          );
        },
      ),
    );
  }

  void _save() {
    String txtCant = '';
    List<Map<AdditionModel, int>> adicionesSelected = [];

    //Obtenemos las adiciones
    for (var data in _adiciones) {
      txtCant = data.controller.text;
      //Si se seleciono una adicion la agrega a una lista con su cantidad
      if (txtCant != '' && txtCant != '0') {
        adicionesSelected.add({
          data.adicion: int.parse(
            txtCant,
          ),
        });
      }
    }

    //Agregamos la lista de adiciones a la comanda
    int tamano = comanda.value[indexComanda.value].adiciones.length;

    int index = indexSalsas.value;

    //si el indice se ha inicializado
    if (index >= 0 && index < tamano) {
      comanda.value[indexComanda.value].adiciones[indexSalsas.value] =
          adicionesSelected;
    } else {
      comanda.value[indexComanda.value].adiciones.add(adicionesSelected);
    }

    //Recorre las salsas para cada producto
    if (comanda.value[indexComanda.value].cantidad == indexSalsas.value + 1) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: ((context) => const PrintPage()),
        ),
      );
    } else {
      indexSalsas.value++;

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: ((context) => const Salsas()),
        ),
      );
    }
  }
}
