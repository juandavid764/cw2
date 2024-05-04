class CategoryModel {
  //Atributos
  final int id;
  final String name;
  final int? parent;

  //Constructor
  CategoryModel({
    required this.id,
    required this.name,
    this.parent,
  });

  //Funcion que obtiene los datos de un mapa y retorna una categoia
  static CategoryModel fromMap(Map<String, Object?> map) {
    final int id = map['category_id'] as int;
    final String name = map['category_name'] as String;
    final int? parent = map['parentCategory'] as int?;

    return CategoryModel(
      id: id,
      name: name,
      parent: parent,
    );
  }

  bool isChild(int idCategory) {
    if (parent == idCategory) {
      return true;
    }

    return false;
  }
}
