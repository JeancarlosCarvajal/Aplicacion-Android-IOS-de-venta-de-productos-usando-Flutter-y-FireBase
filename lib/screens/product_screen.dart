import 'package:flutter/material.dart';
import 'package:productos_app/Ui/input_decorations.dart';
import 'package:productos_app/providers/product_form_provider.dart';
import 'package:productos_app/services/products_service.dart';
import 'package:productos_app/widgets/widgets.dart';
import 'package:provider/provider.dart';

class ProductScreen extends StatelessWidget {
   
  const ProductScreen({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {

    // para obtener acceso al provider
    final productsService = Provider.of<ProductsService>(context);

    // para poder usar el ChangeNotifierProvider debo tener un widget en este punto y lo que tento es el return del Scaffold
    // por lo tanto tuve que extraer el scaffold y meterlo en un nuevo widget llamado _ProductScreenBody y hacer un return de ChangeNotifierProvider
    return ChangeNotifierProvider(
      create: (_) => ProductFormProvider(productsService.selectedProduct!),
      child: _ProductScreenBody(productsService: productsService),
    );

  }
}

class _ProductScreenBody extends StatelessWidget {
  const _ProductScreenBody({
    Key? key,
    required this.productsService,
  }) : super(key: key);

  final ProductsService productsService;

  @override
  Widget build(BuildContext context) {
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

    // ProductFormProvider tiene la informacion del producto que se esta manejando en el formulario
    final productForm = Provider.of<ProductFormProvider>(context);
    final product = productForm.product;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        width: double.infinity,
        // height: 200,
        decoration: _buildBoxDecoration(),
        child: Form(
          child: Column(
            children: [
              const SizedBox(height: 10),

              TextFormField(
                initialValue: product.name,
                onChanged: (value) => product.name = value, // asignamos el valor del nombre obtenido del provider al value del input tipo javaScript
                validator: (value) {
                  if(value == null || value.length < 1){
                    return 'El nombre es Obligatorio';
                  }
                },
                decoration: InputDecorations.authInputDecoration(
                  hintText: 'Nombre del Producto', 
                  labelText: 'Nombre:'
                ),
              ),


              const SizedBox(height: 30),


              
              TextFormField(
                initialValue: '\$${product.price}',
                onChanged: (value) {
                  // si el valor no se puede parsear a double entonces el precio es cero
                  if(double.tryParse(value) == null){
                    product.price = 0;
                  }else{// si el valor se puede parcear a doble entonces dame el valor en el input form
                    product.price = double.parse(value);
                  }
                }, // asignamos el valor del nombre obtenido del provider al value del input tipo javaScript
                validator: (value) {
                  if(value == null || value.isEmpty){
                    return 'El nombre es Obligatorio';
                  }
                },
                keyboardType: TextInputType.number,
                decoration: InputDecorations.authInputDecoration(
                  hintText: '\$150', 
                  labelText: 'Precio:'
                ),
              ),

              const SizedBox(height: 30),


              SwitchListTile.adaptive(
                value: product.available, 
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