import 'package:flutter/material.dart';

class ButtonAdicion extends StatefulWidget {
  final String title;
  final TextEditingController controller;

  const ButtonAdicion({Key? key, required this.title, required this.controller})
      : super(key: key);

  @override
  _ButtonAdicionState createState() => _ButtonAdicionState();
}

class _ButtonAdicionState extends State<ButtonAdicion> {
  int _counter = 0;

  void increment() {
    setState(() {
      _counter++; // Incrementar el contador
      widget.controller.text =
          '$_counter'; // Actualizar el valor del campo de texto
    });
  }

  //Solo decrementar si el contador es mayor que 0counter--; // Decrementar el contador
  void decrement() {
    setState(() {
      if (_counter >= 1) {
        _counter--;
        widget.controller.text =
            '$_counter'; // Actualizar el valor del campo de texto
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shadowColor: Colors.amber,
      elevation: 0,
      color: const Color.fromARGB(115, 43, 41, 1),
      child: Center(
        child: Column(
          children: <Widget>[
            Text(
              widget.title,
              style: const TextStyle(color: Colors.white),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  color: Colors.redAccent,
                  icon: const Icon(Icons.remove),
                  onPressed: decrement,
                ),
                SizedBox(
                  width: 20,
                  child: TextFormField(
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                    ),
                    readOnly: true,
                    controller: widget.controller,
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.number,
                  ),
                ),
                IconButton(
                  color: Colors.greenAccent,
                  icon: const Icon(Icons.add),
                  onPressed: increment,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
