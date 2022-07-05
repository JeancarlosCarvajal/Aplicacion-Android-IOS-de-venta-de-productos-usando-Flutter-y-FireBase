import 'dart:ffi';

import 'package:flutter/material.dart';

class AuthBackground extends StatelessWidget {

  final Widget child;
   
  const AuthBackground({
    Key? key,
    required this.child
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Container(
      // color: Colors.red, // tenia para pruebas
      width: double.infinity,
      height: double.infinity,
      child: Stack(// stack coloca widgets uno encima de otro
        children: [
          
          _PurpleBox(),
          

          _HeaderIcon(),

          // insertamos el widget del constructor
          this.child


        ],
      ),
    );
  }
}

class _HeaderIcon extends StatelessWidget {
  const _HeaderIcon({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea( // evita se meta dentro de arriba o abajo en los dispositivos deja un area segura
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.only(top: 30),
        child: Icon(Icons.person_pin, color: Colors.white, size: 100),
      ),
    );
  }
}

class _PurpleBox extends StatelessWidget {
  const _PurpleBox({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // obtenermos el valor del size al momento
    final size = MediaQuery.of(context).size;
    
    return Container(
      width: double.infinity,
      height: size.height * 0.4,
      // color: Colors.indigo, // no se puede usar junto con docration o es uno o es otro
      decoration: _purpleBackground(),
      child: Stack(
        children: const [
          Positioned(top: 90, left: 30, child: _Bubble()),
          Positioned(top: -40, left: -30, child: _Bubble()),
          Positioned(top: -50, right: -20, child: _Bubble()),
          Positioned(bottom: -50, left: 10, child: _Bubble()),
          Positioned(bottom: 120, right: 20, child: _Bubble()), 
        ],
      )
    );
  }

  BoxDecoration _purpleBackground() => const BoxDecoration(
    gradient: LinearGradient(
      colors: [
        Color.fromRGBO(63, 63, 156, 1),
        Color.fromRGBO(90, 70, 178, 1), // fromARGB(90, 70, 178, 1)
      ], 
    ),
  ); 
}


class _Bubble extends StatelessWidget {
  const _Bubble({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
        color: Color.fromRGBO(255, 255, 255, 0.05)
      ),
    );
  }
}