// peticiones http post get etc
import 'package:flutter/material.dart';
import 'package:productos_app/models/models.dart';




class ProductsService extends ChangeNotifier { // ChangeNotifier para usarlo con el provider

  final String baseUrl = 'flutter-varios-4355d-default-rtdb.firebaseio.com';
  final List<Product> products = [];

  // TODO hacer el fetch de productos



} 