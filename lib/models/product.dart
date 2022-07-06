// To parse this JSON data, do
//
//     final product = productFromMap(jsonString);

import 'dart:convert';

class Product {
    Product({
      required this.available,
      required this.name,
      this.picture,
      required this.price,
      this.id,
    });

    bool available;
    String name;
    String? picture;
    double price;
    String? id;

    factory Product.fromJson(String str) => Product.fromMap(json.decode(str));


    // este va servir para que lo mandemos al servidor
    String toJson() => json.encode(toMap());

    factory Product.fromMap(Map<String, dynamic> json) => Product(
        available: json["available"],
        name: json["name"],
        picture: json["picture"],
        price: json["price"].toDouble(),
    );

    Map<String, dynamic> toMap() => {
        "available": available,
        "name": name,
        "picture": picture,
        "price": price,
    };


    // creamos un nuevo metodo para ser usado para pasar un producto como referencia y ser leido en la pagina de modificar
    // se hace una copia del modelo y lo hace independiente del Product original
    Product copy() => Product(
      available: this.available,
      name: this.name,
      picture: this.picture,
      price: this.price,
      id: this.id,
    );
    
}
