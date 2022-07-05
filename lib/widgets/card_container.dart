import 'package:flutter/material.dart';

class CardContainer extends StatelessWidget {

  final Widget child;
   
  const CardContainer({
    Key? key, 
    required this.child
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Container(
        width: double.infinity,
        // height: 300, // TODO Borrar luego OJO, lo dejo porque mientras construyo el formulario de sesion el contenedor estaria vacio y no se me va a ver sino hasta que le meta los inputs
        // color: Colors.red, // para test 
        padding: EdgeInsets.all(20),
        decoration: _createCardShape(),
        child: this.child, // una vez llene este container elimino el height
      ),
    );
  }

  BoxDecoration _createCardShape() => BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(25),
    boxShadow: const [
      BoxShadow(
        color: Colors.black12,
        blurRadius: 15,
        offset: Offset(0,5)
      )
    ]
  ); 
}