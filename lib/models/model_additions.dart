class AdditionModel {
  //Atributos
  final int id;
  final String name;
  final int price;

  //Constructor
  AdditionModel({
    required this.id,
    required this.name,
    required this.price,
  });

  //Funcion que obtiene los datos de un mapa y retorna una categoia
  static AdditionModel fromMap(Map<String, Object?> map) {
    final int id = map['addition_id'] as int;
    final String name = map['name'] as String;
    final int price = map['price'] as int;

    return AdditionModel(
      id: id,
      name: name,
      price: price,
    );
  }
}
