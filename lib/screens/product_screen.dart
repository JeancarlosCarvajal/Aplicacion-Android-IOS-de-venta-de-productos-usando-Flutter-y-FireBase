import 'package:flutter/material.dart';
import 'package:productos_app/Ui/input_decorations.dart';
import 'package:productos_app/services/products_service.dart';
import 'package:productos_app/widgets/widgets.dart';
import 'package:provider/provider.dart';

class ProductScreen extends StatelessWidget {
   
  const ProductScreen({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {

    // para obtener acceso al provider
    final productsService = Provider.of<ProductsService>(context);

    return Scaffold(
      body: SingleChildScrollView( // SingleChildScrollView es para que se haga scroll si el elemento es mas grande que la pantalla
        child: Column(
          children: [
            Stack(
              children: [

                ProductImage(url: productsService.selectedProduct!.picture),

                Positioned(
                  top: 60,
                  left: 20,
                  child: IconButton(
                    onPressed: () => Navigator.of(context).pop(), // Navigator.of(context).pop() me devuelve atras de donde estaba
                    icon: const Icon(Icons.arrow_back_ios_new, size: 40, color: Colors.white)
                  )
                ),

                Positioned(
                  top: 60,
                  right: 20,
                  child: IconButton(
                    onPressed: () {
                      // TODO camara o galeria

                    }, 
                    icon: const Icon(Icons.camera_alt_outlined, size: 40, color: Colors.white)
                  )
                ),

              ],
            ),


            _ProductForm(),

            SizedBox(height: 100), // le da un poco mas de espacio a la persona para trabajar


          ],
        ),
      ),

      // Para localizar el boton de abajo
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,

      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.save_outlined),
        onPressed: (){
          // TODO guardar producto en la base de datos FireBase
        },
      ),


    );
  }
}

class _ProductForm extends StatelessWidget {
  const _ProductForm({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        width: double.infinity,
        // height: 200,
        decoration: _buildBoxDecoration(),
        child: Form(
          child: Column(
            children: [
              const SizedBox(height: 10),

              TextFormField(
                decoration: InputDecorations.authInputDecoration(
                  hintText: 'Nombre del Producto', 
                  labelText: 'Nombre:'
                ),
              ),


              const SizedBox(height: 30),


              
              TextFormField(
                keyboardType: TextInputType.number,
                decoration: InputDecorations.authInputDecoration(
                  hintText: '\$150', 
                  labelText: 'Precio:'
                ),
              ),

              const SizedBox(height: 30),


              SwitchListTile.adaptive(
                value: true, 
                title: Text('Disponible'),
                activeColor: Colors.indigo,
                onChanged: (value){
                  // TODO Pendiente cambiar estado

                }
              ),

              const SizedBox(height: 30),


              
            ],
          ),
        
        ),
      ),
    );
  }

  BoxDecoration _buildBoxDecoration() => BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.only(bottomRight: Radius.circular(25), bottomLeft: Radius.circular(25)),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.05),
        offset: Offset(0, 5),
        blurRadius: 5
      )
    ]
  );
}