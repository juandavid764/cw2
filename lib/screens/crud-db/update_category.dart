import 'package:cw2/database/db_functions.dart';
import 'package:cw2/models/model_category.dart';
import 'package:cw2/provider/provider_notifier.dart';
import 'package:flutter/material.dart';

class UpdateCategory extends StatefulWidget {
  final CategoryModel category;

  const UpdateCategory({super.key, required this.category});

  @override
  State<UpdateCategory> createState() => _UpdateCategoryState();
}

class _UpdateCategoryState extends State<UpdateCategory> {
  final _formKey = GlobalKey<FormState>(); //  form key for the validation

  final _nameController = TextEditingController();
  final _idController = TextEditingController();
  int idCategorySelected = 0;
  String? dropdownValue;

  @override
  Widget build(BuildContext context) {
    //Items categorias
    List<DropdownMenuItem<dynamic>> itemsDropButton =
        _inicializarItemsCategories();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Actualizar Categoria'),
        actions: [
          IconButton(
            onPressed: () {
              editCategoryClicked(
                context,
                widget.category,
              );
            },
            icon: const Icon(Icons.cloud_upload),
          )
        ],
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey, // Assign the form key
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 50),

                  Row(
                    children: [
                      const Icon(Icons.numbers_rounded),
                      // Add spacing between icon and text field
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextFormField(
                          enabled: false,
                          controller: _idController,
                          decoration: InputDecoration(
                            labelText: "Id",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 10),

                  // Name input field with validation
                  Row(
                    children: [
                      const Icon(Icons.abc_outlined),
                      const SizedBox(
                          width: 10), // Add spacing between icon and text field
                      Expanded(
                        child: TextFormField(
                          keyboardType: TextInputType.name,
                          controller: _nameController,
                          decoration: InputDecoration(
                            labelText: "Nombre",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Porfavor digita un Nombre';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  Row(
                    children: [
                      const Icon(Icons.numbers_rounded),
                      // Add spacing between icon and text field
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                          child: Tooltip(
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
                      )),
                    ],
                  ),
                ],
              ),
            )),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.category.name;
    _idController.text = widget.category.id.toString();
  }

  @override
  void didUpdateWidget(covariant oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  List<DropdownMenuItem<dynamic>> _inicializarItemsCategories() {
    //variable de items
    List<DropdownMenuItem<dynamic>> dropdownItems =
        categorytList.value.where((CategoryModel category) {
      // Filtramos categoria a editar (una categoria no puede ser padre e hija de)
      return category.name != widget.category.name;
    }).map((CategoryModel category) {
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

  Future<void> editCategoryClicked(
      BuildContext context, CategoryModel category) async {
    if (_formKey.currentState!.validate()) {
      final id = int.parse(_idController.text);
      final name = _nameController.text;
      final parent = idCategorySelected;

      final CategoryModel ctgData;

      if (parent == 0) {
        //crea una categoia con los datos de los TextFormFields
        ctgData = CategoryModel(
          id: id,
          name: name,
        );
      } else {
        ctgData = CategoryModel(
          id: id,
          name: name,
          parent: parent,
        );
      }

      await editCategory(ctgData);

      // Refresh the data in the StudentList widget.

      Navigator.of(context).pop();
    }
  }
}
