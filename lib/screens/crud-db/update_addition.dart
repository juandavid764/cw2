import 'package:cw2/database/db_functions.dart';
import 'package:cw2/models/model_additions.dart';
import 'package:flutter/material.dart';

class UpdateAddition extends StatefulWidget {
  final AdditionModel addition;

  const UpdateAddition({super.key, required this.addition});

  @override
  State<UpdateAddition> createState() => _UpdateAdditionState();
}

class _UpdateAdditionState extends State<UpdateAddition> {
  final _formKey = GlobalKey<FormState>(); //  form key for the validation

  final _nameController = TextEditingController();
  final _idController = TextEditingController();
  final _priceController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Actualizar Adicion'),
        actions: [
          IconButton(
            icon: const Icon(Icons.cloud_upload),
            onPressed: () {
              editAddicionClicked(
                context,
                widget.addition,
              );
            },
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
                        child: TextFormField(
                          keyboardType: TextInputType.number,
                          controller: _priceController,
                          decoration: InputDecoration(
                            labelText: "Precio",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Porfavor digita un precio';
                            }
                            return null;
                          },
                        ),
                      ),
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
    _nameController.text = widget.addition.name;
    _idController.text = widget.addition.id.toString();
    _priceController.text = widget.addition.price.toString();
  }

  @override
  void didUpdateWidget(covariant oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  Future<void> editAddicionClicked(
      BuildContext context, AdditionModel adicion) async {
    if (_formKey.currentState!.validate()) {
      final id = int.parse(_idController.text);
      final name = _nameController.text;
      final price = int.parse(_priceController.text);

      final AdditionModel adicData;

      adicData = AdditionModel(
        id: id,
        name: name,
        price: price,
      );

      await editAddtion(adicData);

      // Refresh the data in the StudentList widget.

      Navigator.of(context).pop();
    }
  }
}
