// peticiones http post get etc

import 'package:flutter/material.dart';
import 'dart:convert'; // para usar json

import 'package:productos_app/models/models.dart';
import 'package:http/http.dart' as http;


class ProductsService extends ChangeNotifier { // ChangeNotifier para usarlo con el provider

  final String _baseUrl = 'flutter-varios-4355d-default-rtdb.firebaseio.com';

  // para ser usado y agregarle mas productos a esta lista desd ela base de datos
  final List<Product> products = [];

  // se va llenar con la informacion del producto seleccionado de la lista de productos
  Product? selectedProduct;

  // Propiedad para saber cuando estoy cargando y cuando no
  bool isLoadinng = true;

  // CUando la instancia de ProductService sea llamada voy a llamar este metodo
  // esto es el constructor fjate tiene el mismo nombre de la clase
  ProductsService() {
    this.loadProductos();
  }

  // TODO Regresar <List<Product>> .... Cargar los productos ...
  Future loadProductos() async {

    // setear cuanndo empiza a cargar
    this.isLoadinng = true;
    notifyListeners();

    // peticion http
    final url = Uri.https(_baseUrl, 'products.json');

    // aqui esta la respuesta
    final resp = await http.get( url );

    // convertimos la respuesta a un mapa de string dinamico usando json.decode()
    final Map<String, dynamic> productsMap = json.decode( resp.body );

    // acomodar los datos pa convertirlos en un listado iterable facil
    productsMap.forEach((key, value) {
      // convertimos el mapa en una lista, el value es un Mapa dinamico y el key es un string
      final tempProduct = Product.fromMap(value);
      // asignamos el valor de id 
      tempProduct.id = key;
      // agregamos a FInal ya que es mutable mas no modificable con el add() el valor de producto
      this.products.add(tempProduct);
      // print('$key: $value');
    });

    // print(this.products[0].id); 

    // print(productsMap);

    // Notifica que ya cargo
    // setear cuanndo empiza a cargar
    this.isLoadinng = false;
    notifyListeners();

    return this.products;
  }




} 