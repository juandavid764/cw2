class ProductModel {
  //Atributos
  final int id;
  final String name;
  final int price;
  final int category;
  final int salsas;
  final String text;

  //Constructor
  ProductModel({
    required this.id,
    required this.name,
    required this.price,
    required this.category,
    required this.salsas,
    required this.text,
  });

  //Funcion que obtiene los datos de un mapa y retorna un estudiante
  static ProductModel fromMap(Map<String, Object?> map) {
    final int id = map['product_id'] as int;
    final String name = map['name'] as String;
    final int price = map['price'] as int;
    final int salsas = map['additives'] as int;
    final int category = map['category'] as int;
    final String text = map['text'] as String;

    return ProductModel(
      id: id,
      name: name,
      price: price,
      salsas: salsas,
      category: category,
      text: text,
    );
  }

  bool isChild(int idCategory) {
    if (category == idCategory) {
      return true;
    }

    return false;
  }
}
