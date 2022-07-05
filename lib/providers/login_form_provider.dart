import 'package:flutter/material.dart';

class LoginFormProvider extends ChangeNotifier { 
  // es formstate porue es la llave del formulario, si fuera otra cosa seria otracosaState
  // es para tener la referencia al formulario
  GlobalKey<FormState> formKey = new GlobalKey<FormState>(); 

  String email    = '';
  String password = '';

  // verificar cargando espera de la respuesta http
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  // seteo el valor de cargando
  set isLoading(bool value){
    this._isLoading = value;
    // me redibuja el widget donde estoy una vez modificado el valor
    // cambia los datos del widget solo donde tenga el provider es decir en la clase _LoginForm en login_screen.dart
    notifyListeners();
  }

  bool isValidForm() { 
    print('$email - $password');
    print(formKey.currentState?.validate()); // formKey.currentState es el build context en donde esta construido esta clave KEY asociada
    return formKey.currentState?.validate() ?? false;
  }

}