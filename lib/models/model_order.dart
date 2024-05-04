import 'package:cw2/models/model_additions.dart';
import 'package:cw2/models/model_product.dart';

class Order {
  //Atributos
  final ProductModel product;
  final int cantidad;
  List<List<Map<AdditionModel, int>>> adiciones;
  List<String> salsas;

  //Constructor
  Order({
    required this.product,
    required this.cantidad,
    required this.adiciones,
    required this.salsas,
  });
}
