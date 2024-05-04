import 'package:cw2/models/model_additions.dart';
import 'package:cw2/models/model_category.dart';
import 'package:cw2/models/model_sale_product.dart';
import 'package:cw2/provider/provider_notifier.dart';
import 'package:sqflite/sqflite.dart';
import 'package:cw2/models/model_product.dart';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path/path.dart';

late Database _db;
//Es una variable privada que se declarara mas adelante (Antes de ser usada)

Future<void> initializeDatabase() async {
  var databasesPath = await getDatabasesPath();
  var path = join(databasesPath, "cw_database.db");

  // Check if the database exists
  var exists = await databaseExists(path);

  if (!exists) {
    // Should happen only the first time you launch your application

    // Make sure the parent directory exists
    try {
      await Directory(dirname(path)).create(recursive: true);
    } catch (e) {}

    // Copy from asset
    ByteData data = await rootBundle.load(url.join("assets", "cw_database.db"));
    List<int> bytes =
        data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

    // Write and flush the bytes written
    await File(path).writeAsBytes(bytes, flush: true);
  } else {}

  // open the database
  _db = await openDatabase(path);
}

//Obtener id fecha actual
Future<void> gerDateNow() async {
  DateTime time = DateTime.now();
  String fechaNow = '${time.year}-${time.month}-${time.day}';

  //Vaciamos la bd el primer dia del mes
  if (time.day == 1) {
    await _db.delete('details_sale_product');
    await _db.delete('sales');
    await _db.delete('dates');
  }

  //Consultamos si la fecha ya existe
  final List<Map<String, dynamic>> result = await _db.rawQuery(
    "SELECT date_id FROM dates WHERE date == '$fechaNow';",
  );

  if (result.isEmpty) {
    try {
      //Insertamos y obetemeos ultimo id
      int idFecha = await _db.rawInsert(
        'INSERT INTO dates (date) VALUES(?)',
        [fechaNow],
      );

      //Guardamos el id
      idFechaNow.value = idFecha;
      // ignore: empty_catches
    } catch (e) {}
    //Si hay coincidencias
  } else {
    //Obtenemos el id de la base de datos
    idFechaNow.value = result[0]['date_id'];
  }
}

//------------------------------------------------------------------------------
//Products
//Obtiene todo los productos de la base de datos
Future<void> getproductsdata() async {
  //Obtiene todos los productos de la tabla, guarda la filas encontradas en result
  final result = await _db.rawQuery(
    "SELECT * FROM products",
  );

  //Vacia la lista para llenarla con los valores de la consulta
  productList.value.clear();
  for (var map in result) {
    //Agrega cada producto obtenido a "productList"
    final product = ProductModel.fromMap(map);
    productList.value.add(product);
  }
  productList.notifyListeners();
}

//Insertar un nuevo producto a la BS
Future<void> addproduct(ProductModel value) async {
  try {
    await _db.rawInsert(
      'INSERT INTO products (name, price, category, additives, text) VALUES(?,?,?,?,?)',
      [
        value.name,
        value.price,
        value.category,
        value.salsas,
        value.text,
      ],
    );

    //Actuliza la lista de productos "productList"
    getproductsdata();
    // ignore: empty_catches
  } catch (e) {}
}

//Recibe un id y elimina el producto dicho id, actuliza "productList"
Future<void> deleteProduct(id) async {
  await _db.delete('products', where: 'product_id=?', whereArgs: [id]);
  getproductsdata();
}

//Realiza update en la bs, actualiza "productList"
Future<void> editproduct(
  int id,
  String name,
  int price,
  int category,
  int salsas,
  String texto,
) async {
  final dataflow = {
    'name': name,
    'price': price,
    'category': category,
    'additives': salsas,
    'text': texto,
  };
  await _db
      .update('products', dataflow, where: 'product_id=?', whereArgs: [id]);
  getproductsdata();
}

//------------------------------------------------------------------------------
//Categories
//Obtiene todo los productos de la base de datos
Future<void> getcategoriesdata() async {
  //Obtiene todos las categorias de la tabla, guarda la filas encontradas en result
  final result = await _db.rawQuery(
    "SELECT * FROM categories",
  );
  //print('All Products data : $result');

  //Vacia la lista para llenarla con los valores de la consulta
  categorytList.value.clear();
  for (var map in result) {
    //Agrega cada producto obtenido a "productList"
    final category = CategoryModel.fromMap(map);
    categorytList.value.add(category);
  }
  categorytList.notifyListeners();
}

//Obtiene las categorias raiz
Future<void> getRoots() async {
  //Obtiene todos los productos de la tabla, guarda la filas encontradas en result
  final result = await _db.rawQuery(
    "SELECT category_id, category_name, parentCategory FROM categories WHERE parentCategory IS NULL;",
  );
  //print('All Products data : $result');

  //Vacia la lista para llenarla con los valores de la consulta
  rootsCategories.value.clear();
  for (var map in result) {
    //Agrega cada producto obtenido a "productList"
    final category = CategoryModel.fromMap(map);
    rootsCategories.value.add(category);
  }
}

//Insentar una nueva categoria
Future<void> addCategory(CategoryModel value) async {
  try {
    await _db.rawInsert(
      'INSERT INTO categories (category_name, parentCategory) VALUES(?,?)',
      [
        value.name,
        value.parent,
      ],
    );

    //Actuliza la lista de categorias "categoryList"
    await getcategoriesdata();
    await getRoots();
    // ignore: empty_catches
  } catch (e) {}
}

//Recibe un id y elimina la categoria dicho id, actuliza "CategotytList"
Future<void> deleteCategory(id) async {
  await _db.transaction((txn) async {
    await txn.rawDelete('DELETE FROM categories WHERE category_id = ?', [id]);
  });

  await getcategoriesdata();
  await getRoots();
}

//Realiza update en la bs, actualiza "CategotytList"
Future<void> editCategory(CategoryModel categoria) async {
  final dataflow = {
    'category_name': categoria.name,
    'category_id': categoria.id,
    'parentCategory': categoria.parent,
  };
  await _db.update('categories', dataflow,
      where: 'category_id=?', whereArgs: [categoria.id]);
  await getcategoriesdata();
  await getRoots();
}

//------------------------------------------------------------------------------
//additions
//Obtiene todo los productos de la base de datos
Future<void> getAdditionesData() async {
  final result = await _db.rawQuery(
    "SELECT * FROM additions",
  );
  //print('All Products data : $result');

  //Vacia la lista para llenarla con los valores de la consulta
  additionsList.value.clear();

  for (var map in result) {
    //Agrega cada producto obtenido a "additionsList"
    final addition = AdditionModel.fromMap(map);
    additionsList.value.add(addition);
  }
  //Avisar a los oyentes (widgets) un cambio en la lista
  additionsList.notifyListeners();
}

///Insentar una nueva adicion
Future<void> addAddition(AdditionModel value) async {
  try {
    await _db.rawInsert(
      'INSERT INTO additions (name, price) VALUES(?,?)',
      [
        value.name,
        value.price,
      ],
    );

    //Actuliza la lista de categorias "categoryList"
    await getAdditionesData();
    // ignore: empty_catches
  } catch (e) {}
}

//Recibe un id y elimina la adicion de dicho id, actuliza "AdditionsList"
Future<void> deleteAddition(int id) async {
  await _db.delete('additions', where: 'addition_id=?', whereArgs: [id]);

  await getAdditionesData();
}

//Realiza update de Adden la bs, actualiza "productList"
Future<void> editAddtion(AdditionModel addition) async {
  final dataflow = {
    'name': addition.name,
    'price': addition.price,
  };
  await _db.update('additions', dataflow,
      where: 'addition_id=?', whereArgs: [addition.id]);
  await getAdditionesData();
}

//------------------------------------------------------------------------------
//sales
Future<void> addSale(int total) async {
  DateTime time = DateTime.now();
  String horaNow = '${time.hour}';
  int idsale;

  //Insertamos la venta y detalles
  try {
    idsale = await _db.rawInsert(
      'INSERT INTO sales (fecha, hora, total) VALUES(?,?,?)',
      [
        idFechaNow.value,
        horaNow,
        total,
      ],
    );

    //Se inserta cada producto y su cantidad a la venta correspondiente
    for (var orderNow in comanda.value) {
      await _db.rawInsert(
        'INSERT INTO details_sale_product (product_id, quantity, sale_id) VALUES(?,?,?)',
        [
          orderNow.product.id,
          orderNow.cantidad,
          idsale,
        ],
      );
    }
    // ignore: empty_catches
  } catch (e) {}
}

//Obtiene la cantidad de ventas en un fecha
Future<int> getQuantityCostumers(int dateToSearch) async {
  //Obtiene cuantos registro
  final List<Map<String, dynamic>> result = await _db.rawQuery(
    "SELECT count(*) as cantVentas FROM sales s INNER JOIN dates d ON s.fecha = d.date_id WHERE  d.date_id = $dateToSearch;",
  );

  //Verifica que retornaron datos
  if (result.isNotEmpty) {
    // Obtener el valor de la columna "sales_count" del primer resultado
    final int salesCount = result[0]['cantVentas'];
    return salesCount; // Retornar el valor
  } else {
    // Si no se encontraron resultados, retornar 0
    return 0;
  }
}

//Suma los totales de cada venta en una fecha
Future<int> getNetValue(int dateToSearch) async {
  //Obtiene cuantos registro
  final List<Map<String, dynamic>> result = await _db.rawQuery(
    "SELECT sum(s.total) as neto FROM sales s INNER JOIN dates d ON s.fecha = d.date_id WHERE d.date_id = $dateToSearch;",
  );

  if (result[0]['neto'] != null) {
    // Obtener el valor de la columna "sales_count" del primer resultado
    final int valorNeto = result[0]['neto'];
    return valorNeto; // Retornar el valor
  } else {
    // Si no se encontraron resultados, retornar 0
    return 0;
  }
}

//Obtiene el id de un fecha texto
Future<int> getIdFechaSearch(String fecha) async {
  //Obtiene el id de la fecha que se quiere buscar

  final List<Map<String, dynamic>> result = await _db
      .rawQuery("SELECT date_id FROM dates AS d WHERE d.date = ?", [fecha]);
  //Verifica que retornaron datos
  if (result.isNotEmpty) {
    // Obtener el valor de la columna "sales_count" del primer resultado
    final int salesCount = result[0]['date_id'];
    return salesCount; // Retornar el valor
  } else {
    // Si no se encontraron resultados, retornar 0
    return 0;
  }
}

//Obtenemos la hora con mas ventas
Future<String> getBestHour(int dateToSearch) async {
  final List<Map<String, dynamic>> result = await _db.rawQuery(
    "SELECT hora FROM sales GROUP BY hora HAVING fecha = $dateToSearch ORDER BY COUNT(*) DESC LIMIT 1;",
  );

  //Verifica que retornaron datos
  if (result.isNotEmpty) {
    // Obtener el valor de la columna "hora" del primer resultado
    final String besHour = result[0]['hora'];
    return besHour; // Retornar el valor
  } else {
    // Si no se encontraron resultados, retornar ''
    return '';
  }
}

//Obtenemos los productos yentas
Future<void> getProductsSales(int dateToSearch) async {
  pdtStadictsList.value.clear();
  final List<Map<String, dynamic>> result = await _db.rawQuery(
    "SELECT p.text, SUM(dsp.quantity) AS ventaProducto FROM products p INNER JOIN details_sale_product dsp USING(product_id) INNER JOIN sales s USING(sale_id) INNER JOIN dates d ON d.date_id =  s.fecha GROUP BY p.text HAVING s.fecha = $dateToSearch ORDER BY COUNT(*) DESC;",
  );
  if (result.isEmpty) {
    pdtStadictsList.value['Sin ventas'] = 0;
  } else {
    print(result);
    for (var map in result) {
      //Agrega cada producto obtenido al mapa
      final product = SaleProductsModel.fromMap(map);
      pdtStadictsList.value[product.name] = product.quantity.toDouble();
    }
  }
}
