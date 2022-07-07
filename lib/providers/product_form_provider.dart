import 'package:flutter/material.dart';
import 'package:productos_app/models/models.dart';



class ProductFormProvider extends ChangeNotifier {

  // manera de mantener referencia del formulario  para hacer el isvalid form con la referencia al formulario
  GlobalKey<FormState> formKey = new GlobalKey<FormState>();


  // cuando este trabajando con ProductFormProvider siempre vas a tener product, sera una copia del producto seleccionado
  Product product;

  // Constructor
  ProductFormProvider(this.product);

  //
  updateAvailability(bool value) {
    print(value);
    this.product.available = value;
    // redibuja los widgets
    notifyListeners();
  }

  bool isValidForm() {
    print(product.name);
    print(product.available);
    print(product.price);
    return formKey.currentState?.validate() ?? false;
  }



}