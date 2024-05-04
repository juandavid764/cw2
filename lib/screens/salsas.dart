//import 'dart:ffi';
import 'package:cw2/provider/provider_notifier.dart';
import 'package:cw2/screens/adiciones.dart';
import 'package:cw2/screens/confrim.dart';
import 'package:flutter/material.dart';

//inicializar pantalla salsas
class Salsas extends StatefulWidget {
  const Salsas({Key? key}) : super(key: key);

  @override
  _SalsasState createState() => _SalsasState();
}

//Pantalla Menu
class _SalsasState extends State<Salsas> {
  bool isSwitchedOn = false;
  List<String> options = [
    'Roja',
    'Verde',
    'BBQ',
    'Piña',
    'Rosada',
    'Showy',
    'Sin Roja',
    'Sin Verde',
    'Sin pina',
    'Todas'
  ];
  List<bool> isSelected = [
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
  ];

  double marginHorizontal = 40;
  double marginVertical = 20;
  @override
  Widget build(BuildContext context) {
    String selectedOptions = '';
    int cantProductos = comanda.value[indexComanda.value].cantidad;

    void salsaSelected() {
      //Se obtienen las salsas y se formatea
      selectedOptions = '[';

      for (int i = 0; i < isSelected.length; i++) {
        if (isSelected[i]) {
          selectedOptions += '${options[i]}, ';
        }
      }

      selectedOptions += ']';

      //Si no se seleccionaron, van sin salsas
      if (selectedOptions == '[]') {
        selectedOptions = '[Sin salsas]';
      }

      int tamano = comanda.value[indexComanda.value].salsas.length;

      int index = indexSalsas.value;

      //si el indice se ha inicializado
      if (index >= 0 && index < tamano) {
        comanda.value[indexComanda.value].salsas[indexSalsas.value] =
            selectedOptions;
      } else {
        comanda.value[indexComanda.value].salsas.add(selectedOptions);
      }
    }

    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
              automaticallyImplyLeading: false,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  //Si se selecionaron todas las salsas
                  if (cantProductos == indexSalsas.value + 1 &&
                      indexSalsas.value + 1 > 1) {
                    indexSalsas.value--;
                  }
                  Navigator.pop(context);
                  // Navegar hacia atrás manualmente cuando se presiona el botón
                },
              ),
              title: const Text("Salsas",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  )),
              actions: [
                Switch(
                  value: isSwitchedOn,
                  onChanged: (newValue) {
                    setState(() {
                      isSwitchedOn = newValue;
                    });
                  },
                ),
              ]),
          body: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text('${indexSalsas.value + 1}/$cantProductos',
                  style: const TextStyle(color: Colors.white)),
              const Text('Selecciona tus salsas favoritas:',
                  style: TextStyle(color: Colors.white)),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  //----------------
                  //Salsa Roja
                  ChoiceChip(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          20.0), // Radio de la esquina del borde
                    ),
                    selectedColor: const Color.fromARGB(255, 255, 82, 82),
                    //backgroundColor: Color.fromARGB(150, 196, 57, 57),
                    padding: EdgeInsets.all(
                        MediaQuery.of(context).size.width * 0.03),
                    label: Text(options[0]),
                    selected: isSelected[0],
                    onSelected: (bool selected) {
                      setState(() {
                        isSelected[0] = selected;
                      });
                    },
                  ),
                  //--------------------------------------------
                  Container(
                      padding: const EdgeInsets.all(
                        5,
                      ), // Padding deseado para el botón
                      child: ChoiceChip(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              20.0), // Radio de la esquina del borde
                        ),
                        //backgroundColor: Color.fromARGB(255, 45, 120, 76),
                        selectedColor: const Color.fromARGB(255, 45, 182, 105),
                        padding: EdgeInsets.all(
                            MediaQuery.of(context).size.width * 0.03),
                        label: Text(options[1]),
                        selected: isSelected[1],
                        onSelected: (bool selected) {
                          setState(() {
                            isSelected[1] = selected;
                          });
                        },
                      )),
                  //--------------------------------------------
                  ChoiceChip(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          20.0), // Radio de la esquina del borde
                    ),
                    //backgroundColor: Color.fromARGB(255, 110, 33, 5),
                    selectedColor: const Color.fromARGB(255, 138, 21, 12),
                    padding: EdgeInsets.all(
                        MediaQuery.of(context).size.width * 0.03),
                    label: Text(options[2]),
                    selected: isSelected[2],
                    onSelected: (bool selected) {
                      setState(() {
                        isSelected[2] = selected;
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  //--------------------------------------------
                  Container(
                      padding: const EdgeInsets.all(
                        3,
                      ), // Padding deseado para el botón
                      child: ChoiceChip(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              20.0), // Radio de la esquina del borde
                        ),
                        //backgroundColor: Color.fromARGB(200, 130, 130, 11),
                        selectedColor: const Color.fromARGB(255, 150, 150, 59),
                        padding: EdgeInsets.all(
                            MediaQuery.of(context).size.width * 0.03),
                        label: Text(options[3]),
                        selected: isSelected[3],
                        onSelected: (bool selected) {
                          setState(() {
                            isSelected[3] = selected;
                          });
                        },
                      )),
                  //--------------------------------------------
                  Container(
                      padding: const EdgeInsets.all(
                        5,
                      ), // Padding deseado para el botón
                      child: ChoiceChip(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              20.0), // Radio de la esquina del borde
                        ),
                        selectedColor: const Color.fromARGB(255, 255, 104, 229),
                        //backgroundColor: Color.fromARGB(255, 255, 128, 171),
                        padding: EdgeInsets.all(
                            MediaQuery.of(context).size.width * 0.03),
                        label: Text(options[4]),
                        selected: isSelected[4],
                        onSelected: (bool selected) {
                          setState(() {
                            isSelected[4] = selected;
                          });
                        },
                      )),

                  //--------------------------------------------
                  Container(
                      padding: const EdgeInsets.all(
                        5,
                      ), // Padding deseado para el botón
                      child: ChoiceChip(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              20.0), // Radio de la esquina del borde
                        ),
                        selectedColor: const Color.fromARGB(255, 163, 167, 102),
                        //backgroundColor: Color.fromARGB(255, 163, 167, 102),
                        padding: EdgeInsets.all(
                            MediaQuery.of(context).size.width * 0.03),
                        label: Text(options[5]),
                        selected: isSelected[5],
                        onSelected: (bool selected) {
                          setState(() {
                            isSelected[5] = selected;
                          });
                        },
                      )),
                  //--------------------------------------------
                ],
              ),
              const SizedBox(
                height: 20,
              ),

              const Divider(), //Divider --------

              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  //--------------------------------------------
                  Container(
                      padding: const EdgeInsets.all(
                        5,
                      ), // Padding deseado para el botón
                      child: ChoiceChip(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              20.0), // Radio de la esquina del borde
                        ),
                        padding: EdgeInsets.all(
                            MediaQuery.of(context).size.width * 0.03),
                        label: Text(options[6]),
                        selected: isSelected[6],
                        onSelected: (bool selected) {
                          setState(() {
                            isSelected[6] = selected;
                          });
                        },
                      )),

                  //--------------------------------------------
                  Container(
                      padding: const EdgeInsets.all(
                        3,
                      ), // Padding deseado para el botón
                      child: ChoiceChip(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              20.0), // Radio de la esquina del borde
                        ),
                        padding: EdgeInsets.all(
                            MediaQuery.of(context).size.width * 0.03),
                        label: Text(options[7]),
                        selected: isSelected[7],
                        onSelected: (bool selected) {
                          setState(() {
                            isSelected[7] = selected;
                          });
                        },
                      )),
                  //--------------------------------------------
                  Container(
                      padding: const EdgeInsets.all(
                        5,
                      ), // Padding deseado para el botón
                      child: ChoiceChip(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              20.0), // Radio de la esquina del borde
                        ),
                        padding: EdgeInsets.all(
                            MediaQuery.of(context).size.width * 0.03),
                        label: Text(options[8]),
                        selected: isSelected[8],
                        onSelected: (bool selected) {
                          setState(() {
                            isSelected[8] = selected;
                          });
                        },
                      )),
                ],
              ),

              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  //--------------------------------------------
                  Container(
                      padding: const EdgeInsets.all(
                        5,
                      ), // Padding deseado para el botón
                      child: ChoiceChip(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              30.0), // Radio de la esquina del borde
                        ),
                        padding: EdgeInsets.all(
                            MediaQuery.of(context).size.width * 0.03),
                        label: Text(options[9]),
                        selected: isSelected[9],
                        onSelected: (bool selected) {
                          setState(() {
                            isSelected[9] = selected;
                          });
                        },
                      )),

                  //--------------------------------------------
                ],
              ),
              const Row(children: [
                SizedBox(
                  height: 0, //50
                )
              ]),
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  //--------------------------------------------
                  Container(
                    padding: const EdgeInsets.all(
                      5,
                    ), // Boton siguiente
                    child: ElevatedButton(
                      style: const ButtonStyle(),
                      child: const Text("Siguiente"),
                      onPressed: () {
                        //Se obtienen las salsas y se formatea
                        salsaSelected();

                        //Navegacion a adiciones o confirm page segun switch
                        if (isSwitchedOn == true) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: ((context) => const Adiciones()),
                            ),
                          );
                        } else {
                          int tamanoListSalsas =
                              comanda.value[indexComanda.value].salsas.length;
                          int tamanoListAdics = comanda
                              .value[indexComanda.value].adiciones.length;
                          int diferencia = tamanoListSalsas - tamanoListAdics;

                          //Igualamos salsas y adiciones
                          for (var i = 0; i < diferencia; i++) {
                            comanda.value[indexComanda.value].adiciones.add([]);
                          }

                          //Si ya se seleccionaron salsa a cada producto
                          if (cantProductos == indexSalsas.value + 1) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: ((context) => const PrintPage()),
                              ),
                            );
                            //ciclo continua
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
                      },
                      onLongPress: () {
                        //Se obtienen las salsas y se agregarn
                        salsaSelected();
                        int tamanoListSalsas =
                            comanda.value[indexComanda.value].salsas.length;
                        int tamanoListAdics =
                            comanda.value[indexComanda.value].adiciones.length;
                        int diferencia = tamanoListSalsas - tamanoListAdics;

                        //Igualamos salsas y adiciones
                        for (var i = 0; i < diferencia; i++) {
                          comanda.value[indexComanda.value].adiciones.add([]);
                        }

                        int indexNow = indexSalsas.value;
                        int indexNext = indexNow + 1;

                        //Si los indices posteriores esta inicialidos
                        if (indexNow < cantProductos) {
                          for (var i = indexNext; i < cantProductos; i++) {
                            //si el indice se ha inicializado
                            if (i >= 0 && i < tamanoListSalsas) {
                              /* Eliminamos los indices posteriores al actual 
                              que no se iinicializaron */
                              comanda.value[indexComanda.value].salsas
                                  .removeAt(i);
                            }
                          }
                        }

                        //Navega a PrintPage
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: ((context) => const PrintPage()),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ],
          )),
    );
  }
}
