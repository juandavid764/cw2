import 'package:cw2/database/db_functions.dart';
import 'package:cw2/provider/provider_notifier.dart';
import 'package:flutter/material.dart';
import 'package:esc_pos_printer/esc_pos_printer.dart';
import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:intl/intl.dart';

class PrintPage extends StatefulWidget {
  const PrintPage({Key? key}) : super(key: key);

  @override
  State<PrintPage> createState() => _PrintPage();
}

class _PrintPage extends State<PrintPage> {
  //Datos comanda
  TextEditingController txtComanda = TextEditingController(text: '');
  //Datos devuelta
  TextEditingController devueltaController = TextEditingController(text: '');

  final FocusNode _focusNode = FocusNode();
  final FocusNode _focusNode2 = FocusNode();
  //Datos ip
  TextEditingController txtIp = TextEditingController(text: '192.168.100.119');
  int total = 0;
  List<List<int>> productInsert = [];
  bool _pagoNequi = false;

  @override
  void initState() {
    super.initState();
    iniciarTextfield();
  }

  void iniciarTextfield() {
    int totalProducto = 0;
    int totalAdiciones = 0;
    int cantAdicion = 0;

    //Recorre cada orden
    for (var orderNow in comanda.value) {
      int tamanoListSalsas = orderNow.salsas.length;

      txtComanda.text += '*${orderNow.cantidad} ${orderNow.product.text}\n';
      productInsert.add([orderNow.cantidad, orderNow.product.id]);

      totalProducto += (orderNow.cantidad) * (orderNow.product.price);

      //Si el producto habilita salsas y adiciones
      if (orderNow.product.salsas == 1) {
        //Recore las salsas
        for (var i = 0; i < tamanoListSalsas; i++) {
          //Agrega cada salsas
          txtComanda.text += orderNow.salsas[i];
          //Si la Listadicion no esta vacia
          if (orderNow.adiciones[i].isNotEmpty) {
            txtComanda.text += '\nAdics:';
            //Agrega ListAdiciones
            for (var mapa in orderNow.adiciones[i]) {
              for (var key in mapa.keys) {
                cantAdicion = mapa[key]!;

                txtComanda.text += '\n-$cantAdicion ${key.name}';

                //Calculamos el total de las adiones
                totalAdiciones += cantAdicion * key.price;
              }
            }
          }
          //Salto despues de cada salsas
          txtComanda.text += '\n';
        }
      }
      //Salto de linea cuando se agrega una orden
      txtComanda.text += '\n';
    }
    total = totalAdiciones + totalProducto;
    txtComanda.text += '- - - - - - - - - - - - -\n';
  }

  @override
  void dispose() {
    txtIp.dispose();
    _focusNode.dispose();
    _focusNode2.dispose();
    super.dispose();
    devueltaController.dispose();
  }

  //Pantalla impresion
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;
    final double fontSize;

    //Tamano de letra segun ancho
    if (screenWidth > 400.0) {
      fontSize = 40.3;
    } else {
      fontSize = 20;
    }

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            // Se establece la condición para eliminar todas las rutas y limpiar datos comanda
            onPressed: () {
              indexComanda.value = 0;
              indexSalsas.value = 0;
              comanda.value.clear();
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/home',
                (route) =>
                    false, // Se establece la condición para eliminar todas las rutas
              );
            },
            icon: const Icon(
              Icons.food_bank,
              color: Color.fromARGB(255, 255, 230, 0),
            ),
          )
        ],
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            //Vaciar el ultimo elemento del array

            Navigator.pop(
                context); // Navegar hacia atrás manualmente cuando se presiona el botón
          },
        ),
        title: const Text(
          "Confirmar Pedido",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        automaticallyImplyLeading: false,
      ),
      body: Center(
          child: ListView(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
                child: TextFormField(
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.normal,
                  ),
                  controller: txtIp,
                  decoration: const InputDecoration(
                    labelText: "Ip",
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              //Espacio entre el inputIP y comanda
              const SizedBox(
                height: 30,
              ),
              const Text(
                'Previsualización',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              const SizedBox(
                height: 30,
              ),

              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
                child: TextField(
                  textAlignVertical: TextAlignVertical.top,
                  expands: false,
                  style: TextStyle(
                    fontSize: fontSize,
                    color: Colors.white,
                    fontWeight: FontWeight.normal,
                  ),
                  controller: txtComanda,
                  focusNode: _focusNode,
                  maxLines: null, // Permite múltiples líneas
                  keyboardType: TextInputType
                      .multiline, // Habilita el teclado para múltiples líneas
                  decoration: const InputDecoration(
                    labelText: 'Comanda',
                    border: OutlineInputBorder(), // Borde del área de texto
                  ),
                ),
              ),

              const SizedBox(
                height: 25,
              ),
              //-------------------------------------
              Text(
                'Total: ${NumberFormat.simpleCurrency(decimalDigits: 0).format(total)}',
                style: const TextStyle(
                  color: Colors.white,
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              Text(
                  'Devuelta: ${restar(
                    devueltaController.text,
                  )}',
                  style: const TextStyle(color: Colors.white)),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    focusNode: _focusNode2,
                    decoration: const InputDecoration(
                      labelText: 'Dinero Recibido',
                      border: OutlineInputBorder(), // Borde del área de texto
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (text) {
                      setState(() {
                        if (devueltaController.text.isEmpty) {
                          devueltaController.text = '';
                        }
                      });
                    },
                    controller: devueltaController,
                  ),
                ),
              ),

              _checkboxWidget(),
              const SizedBox(
                height: 25,
              ),
              _botonesWidgets(),
              const SizedBox(
                height: 25,
              )
            ],
          ),
        ],
      )),
    );
  }

  String restar(String controler) {
    int numControler = 0;
    if (controler.isEmpty) {
      return '0';
    } else {
      try {
        numControler = int.parse(controler);
      } catch (e) {
        const AlertDialog();
      }
      return NumberFormat.simpleCurrency(decimalDigits: 0)
          .format(numControler - total);
    }
  }

  _botonesWidgets() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        //Button Calcular

        //Button imprimir
        GestureDetector(
          child: IconButton.filled(
            icon: const Icon(
              Icons.print,
              size: 40,
            ),
            onPressed: () {
              //Esconder teclado
              _focusNode.unfocus();
              _focusNode2.unfocus();

              //Obtener texto de los inputs
              String text = txtComanda.text;
              String iptxt = txtIp.text;

              connectAndPrint(text, context, iptxt, productInsert);
            },
          ),
          onLongPress: () {
            if (_pagoNequi == false) {
              addSale(total);
            }
            mostarSnackInserSucces(context);
          },
        ),
        //Button Add
        IconButton.filled(
          icon: const Icon(
            Icons.add,
            size: 40,
          ),
          //Se incrementa el indexComanda y navegamos a Home
          onPressed: () {
            indexComanda.value++;
            indexSalsas.value = 0;
            Navigator.pushNamed(
              context,
              '/home',
            );
          },
        ),
      ],
    );
  }

  _checkboxWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'Pago Virtual',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.normal),
        ),
        Checkbox(
          value: _pagoNequi,
          onChanged: (value) {
            setState(() {
              _pagoNequi = value!;
            });
          },
        ),
      ],
    );
  }

  Future<void> imprimir(NetworkPrinter ticket, String comandaFinal, context,
      List<List<int>> productInsert) async {
    //Obtener el tiempo actual
    DateTime time = DateTime.now();

    String fechaNow = '${time.day}-${time.month}-${time.year}';
    String horaNow = '${time.hour}:${time.minute}:${time.second}';

    //Elimina tildes y letras no legibles
    String comandaFormat = removeAccentsAndN(comandaFinal);

    //Imrimir comanda
    ticket.text(fechaNow);
    ticket.text(horaNow);
    ticket.text(comandaFormat,
        styles: const PosStyles(
          bold: false,
          height: PosTextSize.size2,
          width: PosTextSize.size2,
          fontType: PosFontType.fontB,
        ));
    ticket.cut();
    mostarSnackInserSucces(context);
  }

//Configuracion y coneccion a la impresora
  Future<void> connectAndPrint(String comandaFinal, context, String iptxt,
      List<List<int>> productInsert) async {
    //Variable que guarda la respuesta si la conexion es fallida
    String respuesta = '';

    //Propiedades de la impresiora
    const PaperSize paper = PaperSize.mm80;
    final profile = await CapabilityProfile.load();
    final ticket = NetworkPrinter(paper, profile);

    //Realiza la conexion
    final PosPrintResult res = await ticket.connect(iptxt, port: 9100);

    //Validar la conexion
    if (res == PosPrintResult.success) {
      await imprimir(ticket, comandaFinal, context, productInsert);

      //Verificamos si el pago es virtual
      if (_pagoNequi == false) {
        addSale(total);
      }

      await Future.delayed(const Duration(milliseconds: 500), () {
        ticket.disconnect();
      });
    } else {
      respuesta = 'Print result: ${res.msg}';
      mostrarSnackBarFail(context, respuesta);
    }
  }

//Mensaje flotante para impresion fallida
  void mostrarSnackBarFail(context, respuesta) {
    final snackBar = SnackBar(
      backgroundColor: const Color.fromARGB(255, 235, 103, 94),
      content: Text('Print result: $respuesta'),
      duration: const Duration(seconds: 1),
      action: SnackBarAction(
        label: 'Cerrar',
        onPressed: () {
          // Aquí puedes agregar alguna lógica al presionar el botón de acción
        },
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

//Mensaje flotante para impresion exitosa
  void mostrarSnackBarPrintSucess(context, respuesta) {
    final snackBar = SnackBar(
      backgroundColor: const Color.fromARGB(255, 0, 255, 157),
      content: Text('$respuesta'),
      duration: const Duration(microseconds: 500),
      action: SnackBarAction(
        label: 'Cerrar',
        onPressed: () {},
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

//Mensaje de insersion
  void mostarSnackInserSucces(context) {
    const snackBar = SnackBar(
      backgroundColor: Color.fromARGB(255, 0, 106, 255),
      content: Text('inserción exitosa'),
      duration: Duration(seconds: 1),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

// Reemplaza tildes y diéresis por letras normales y "ñ" por "n".
  String removeAccentsAndN(String input) {
    String result = input
        .replaceAll(RegExp('[áÁäÄàÀâÂãÃ]'), 'a')
        .replaceAll(RegExp('[éÉëËèÈêÊ]'), 'e')
        .replaceAll(RegExp('[íÍïÏìÌîÎ]'), 'i')
        .replaceAll(RegExp('[óÓöÖòÒôÔõÕ]'), 'o')
        .replaceAll(RegExp('[úÚüÜùÙûÛ]'), 'u')
        .replaceAll(RegExp('[ñÑ]'), 'n');

    return result;
  }
}
