import 'package:flutter/material.dart';


// metodos y propuedaddes estaticas para usarla en cualquier parte de la palicaicon
class NotificationsService {

  // se usa ScaffoldMessengerState para mantener la referencia a mi Material App
  static late GlobalKey<ScaffoldMessengerState> messengerKey = new GlobalKey<ScaffoldMessengerState>();


  static showSnapbar(String message) {
    final snackBar = SnackBar( // tenia new OJO
      content: Text(message, style: const TextStyle(color: Colors.white, fontSize: 20))
    );

    // para mandarlo a llamar vamos a usar esta llave messengerKey
    messengerKey.currentState!.showSnackBar(snackBar);
  }

}