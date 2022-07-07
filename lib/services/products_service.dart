// peticiones http post get etc
import 'dart:io';

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

  // creamos una propiedad opcional para la imagen que sleccionamemos si queremos modificar o crear
  File? newPictureFile;

  // Propiedad para saber cuando estoy cargando y cuando no
  bool isLoadinng = true;

  // saber si estan guandando la informacion
  bool isSaving = false;

  // CUando la instancia de ProductService sea llamada voy a llamar este metodo
  // esto es el constructor fjate tiene el mismo nombre de la clase
  ProductsService() {
    this.loadProductos();
  }

  // <List<Product>> .... Cargar los productos ...
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
    // notifica a los widgets cobre el cambio
    notifyListeners();

    return this.products;
  }


  // Guardar o crear productos
  Future saveOrCreateProduct(Product product) async {

    // setea el valor en true de gardando o creando
    isSaving = true;
    // notifica a los widgets
    notifyListeners();

    // Aqui la Logica
    if(product.id == null){
      // Creacion... si no tengo id es porque voy a crear un producto
      await this.createProduct(product);
    }else{
      // Actualizacion... si tengo el id entonces voy a actualizar el producto
      await this.updateProduct(product);
    }

    // setea a true el valor de guardando ya sea guardar o crear nuevo
    isSaving = true;
    // Actualiza todos los widgets
    notifyListeners();
    

  }

  // peticion al Back End
  Future<String> updateProduct(Product product) async {

    
    // peticion http
    final url = Uri.https(_baseUrl, 'products/${product.id}.json');

    // aqui esta la respuesta y se le hace un put() para actualizar
    final resp = await http.put( url, body: product.toJson() );

    // decodificando la respuesta
    final decodedData = resp.body;

    print(decodedData);

    // TODO Actualizar el listado de productos para que se vea las modificaciones con notifyListener()
    // Implementacion N 1... forma moderna de implementarlo
    final index = this.products.indexWhere((element) => element.id == product.id); // funcionn que busca el indice de un producto segun una condicional
    this.products[index] = product; // igualamos el producto de la lista al producto actualizado

    // Implementacion N 2... Otra forma de implementarlo
    // for (var i = 0; i < products.length; i++) {
    //   if(product.id == products[i].id){
    //     print('Lo encontre: ${products[i].id} == ${product.id}');
    //     products[i] = product;
    //   }
    // }

    // actualizamos todos los widgets en la funcion de saveOrCreateProduct

    return product.id!;
  }


// peticion al Back End
  Future<String> createProduct(Product product) async {

    
    // peticion http
    final url = Uri.https(_baseUrl, 'products/.json');

    // aqui esta la respuesta y se le hace un put() para actualizar
    final resp = await http.post( url, body: product.toJson() );

    // decodificando la respuesta, viene en jason dedemos decodificarlo
    final decodedData =  jsonDecode(resp.body);

    // me regresa {"name":"-N6Of2wcabl3rOzOgLAd"} el cual es el id del producto que me genera el propio FireBase de manera automatica
    // El id asignado por FireBse es Unico se puede dejar asi 
    print(decodedData); 

    // Agregamos el id devuelto por fireBase al producto creado
    product.id = decodedData['name'];

    // Agregamos el producto de la lista al productos
    this.products.add(product);

    // actualizamos todos los widgets en la funcion de saveOrCreateProduct

    return product.id!;
  }

  // Metodo creado Para imprimir la imagen previa en el widget de modificar o crear imagen
  void updateSelectedProductImage( String path ) {

    // para establecer la imagen de fondo en el widget
    this.selectedProduct!.picture = path;

    // al usar este metodo se guarda el archivo File en la variable newPictureFile para ser usada  en cualquier momento con Provider
    // este File es el que enviaremos mediante el motodo Post al servidor de imgenes con la Api Rest
    this.newPictureFile = File.fromUri(Uri(path: path));
    notifyListeners();
  }


} 