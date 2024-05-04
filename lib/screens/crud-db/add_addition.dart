import 'package:cw2/database/db_functions.dart';
import 'package:cw2/models/model_additions.dart';
import 'package:flutter/material.dart';

class AddAddition extends StatefulWidget {
  const AddAddition({super.key});

  @override
  State<AddAddition> createState() => _AddAdditionState();
}

class _AddAdditionState extends State<AddAddition> {
  //Llave para acceder al estado del formulario
  final _formKey = GlobalKey<FormState>(); // Add a form key for the validation

  //Crea los txtfields
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    /////
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agregar Adicion'),
        actions: [
          //Boton Guardar
          IconButton(
            onPressed: () {
              buttonSave(context);
            },
            icon: const Icon(Icons.save_rounded),
          )
        ],
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          //Inicio Formulario
          child: Form(
            key: _formKey, // The form key
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 50),

                // Name input field with validation
                TextFormField(
                  keyboardType: TextInputType.name,
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: "Nombre",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    suffixIcon: const Icon(Icons.abc_outlined),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Porfavor digita un Nombre';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // categoryParent input field with validation
                TextFormField(
                  keyboardType: TextInputType.number,
                  controller: _priceController,
                  decoration: InputDecoration(
                    labelText: "Precio",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    suffixIcon: const Icon(Icons.numbers_rounded),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Porfavor digita un precio';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> buttonSave(mtx) async {
    //Verifica todos los 'validator' de los 'TextFormField'
    if (_formKey.currentState!.validate()) {
      final name = _nameController.text;
      final price = int.parse(_priceController.text);

      final AdditionModel adicData;

      adicData = AdditionModel(
        id: 1,
        name: name,
        price: price,
      );

      await addAddition(adicData);

      //Mensaje de inserccion exitosa
      ScaffoldMessenger.of(mtx).showSnackBar(
        const SnackBar(
          content: Text("Isercion Exitosa"),
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.all(10),
          backgroundColor: Colors.greenAccent,
          duration: Duration(seconds: 2),
        ),
      );

      //Vaciar txtfields
      setState(() {
        _nameController.clear();
        _priceController.clear();
      });
    }
  }
}
