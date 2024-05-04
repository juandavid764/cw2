import 'package:cw2/models/model_additions.dart';
import 'package:cw2/models/model_category.dart';
import 'package:cw2/models/model_order.dart';
import 'package:cw2/models/model_product.dart';
import 'package:flutter/material.dart';

ValueNotifier<List<ProductModel>> productList = ValueNotifier([]);
ValueNotifier<List<CategoryModel>> categorytList = ValueNotifier([]);
ValueNotifier<List<CategoryModel>> rootsCategories = ValueNotifier([]);
ValueNotifier<List<AdditionModel>> additionsList = ValueNotifier([]);
ValueNotifier<List<Order>> comanda = ValueNotifier([]);
ValueNotifier<int> indexComanda = ValueNotifier<int>(0);
ValueNotifier<int> indexSalsas = ValueNotifier<int>(0);
ValueNotifier<int> idFechaNow = ValueNotifier<int>(0);
ValueNotifier<Map<String, double>> pdtStadictsList =
    ValueNotifier({'Sin ventas': 0});
