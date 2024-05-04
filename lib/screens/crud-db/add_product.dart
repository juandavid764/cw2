import 'package:cw2/database/db_functions.dart';
import 'package:cw2/models/model_product.dart';
import 'package:flutter/material.dart';

class AddProduct extends StatefulWidget {
  const AddProduct({super.key});

  @override
  State<AddProduct> createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  //Llave para acceder al estado del formulario
  final _formKey = GlobalKey<FormState>(); // Add a form key for the validation

  //Crea los txtfields
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _categoryController = TextEditingController();
  final _salsasController = TextEditingController();
  final _textoController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agregar Producto'),
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

                // Class input field with validation
                TextFormField(
                  keyboardType: TextInputType.number,
                  controller: _priceController,
                  decoration: InputDecoration(
                    labelText: "Precio",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    suffixIcon: const Icon(Icons.price_change_rounded),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Porfavor digite un Precio';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // Guardian input field with validation
                TextFormField(
                  keyboardType: TextInputType.number,
                  controller: _categoryController,
                  decoration: InputDecoration(
                    labelText: "Categoria",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    suffixIcon: const Icon(Icons.group_work_sharp),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Porfavor digite una Categoria';
                    } else if (value.length != 1) {
                      return 'Solo un digito';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // Mobile input field with validation
                TextFormField(
                  keyboardType: TextInputType.number,
                  controller: _salsasController,
                  decoration: InputDecoration(
                    labelText: "Salsas y Adiciones",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    suffixIcon: const Icon(Icons.select_all_rounded),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter a bolean data';
                    } else if (value.length != 1) {
                      return 'Solo un digito';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  keyboardType: TextInputType.name,
                  controller: _textoController,
                  decoration: InputDecoration(
                    labelText: "Texto",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    suffixIcon: const Icon(Icons.short_text_sharp),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Porfavor digite un texto';
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
    //Verifica todos los 'validator' de los 'TextFormField' y la foto
    if (_formKey.currentState!.validate()) {
      final name = _nameController.text;
      final price = _priceController.text;
      final category = _categoryController.text;
      final salsas = _salsasController.text;
      final texto = _textoController.text;

      //crea un estudiante con los datos de los TextFormFields
      final pdtData = ProductModel(
        id: 1,
        name: name,
        price: int.parse(price),
        category: int.parse(category),
        salsas: int.parse(salsas),
        text: texto,
      );
      await addproduct(pdtData); // Use the correct function name addStudent.

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
        _categoryController.clear();
        _salsasController.clear();
        _textoController.clear();
      });
    }
  }
}
