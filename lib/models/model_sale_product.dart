class SaleProductsModel {
  //Atributos
  final String name;
  final int quantity;

  //Constructor
  SaleProductsModel({required this.name, required this.quantity});

  //Funcion que obtiene los datos de un mapa y retorna una categoia
  static SaleProductsModel fromMap(Map<String, Object?> map) {
    final String name = map['text'] as String;
    final int quantity = map['ventaProducto'] as int;

    return SaleProductsModel(
      name: name,
      quantity: quantity,
    );
  }
}
