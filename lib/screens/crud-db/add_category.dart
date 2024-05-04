import 'package:cw2/database/db_functions.dart';
import 'package:cw2/models/model_category.dart';
import 'package:cw2/provider/provider_notifier.dart';
import 'package:flutter/material.dart';

class AddCategory extends StatefulWidget {
  const AddCategory({super.key});

  @override
  State<AddCategory> createState() => _AddCategoryState();
}

class _AddCategoryState extends State<AddCategory> {
  //Llave para acceder al estado del formulario
  final _formKey = GlobalKey<FormState>(); // Add a form key for the validation

  //Crea los txtfields
  final _nameController = TextEditingController();
  int idCategorySelected = 0;
  String? dropdownValue;

  @override
  Widget build(BuildContext context) {
    List<DropdownMenuItem<dynamic>> itemsDropButton =
        _inicializarItemsCategories();

    /////
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agregar Categoria'),
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
              crossAxisAlignment: CrossAxisAlignment.start,
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

                const Text(
                  'Categoria Padre:',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),

                // categoryParent input field with validation
                Tooltip(
                  message: 'Seleccione una categoria padre',
                  child: DropdownButton(
                    value: dropdownValue,
                    onChanged: (value) {
                      setState(() {
                        dropdownValue = value;
                      });
                    },
                    items: itemsDropButton,
                    isExpanded: true,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<DropdownMenuItem<dynamic>> _inicializarItemsCategories() {
    List<DropdownMenuItem<dynamic>> dropdownItems =
        categorytList.value.map((CategoryModel category) {
      return DropdownMenuItem<dynamic>(
        value: category.name,
        child: Text(category.name),
        onTap: () {
          idCategorySelected = category.id;
        },
      );
    }).toList();

    dropdownItems.add(
      const DropdownMenuItem(
        value: null,
        child: Text('Raiz'),
      ),
    );

    return dropdownItems;
  }

  Future<void> buttonSave(mtx) async {
    //Verifica todos los 'validator' de los 'TextFormField' y la foto
    if (_formKey.currentState!.validate()) {
      final name = _nameController.text;
      final parent = idCategorySelected;

      final CategoryModel ctgData;

      if (parent == 0) {
        //crea una categoia con los datos de los TextFormFields
        ctgData = CategoryModel(
          id: 1,
          name: name,
        );
      } else {
        ctgData = CategoryModel(
          id: 1,
          name: name,
          parent: parent,
        );
      }

      await addCategory(ctgData);

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
      });
    }
  }
}
