import 'package:flutter/material.dart';
import 'package:productos_app/models/models.dart';
import 'package:productos_app/screens/screens.dart';
import 'package:productos_app/services/products_service.dart';
import 'package:productos_app/services/services.dart';
import 'package:productos_app/widgets/widgets.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {

   
  const HomeScreen({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {

    // leer los datos de la api de productos llamando al provider
    final productsService = Provider.of<ProductsService>(context);

    if(productsService.isLoadinng) return const LoadingScreen();

    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Productos')),
      ),
      body: ListView.builder( // ListView.builder crea los widget justo cuando esten cerca de entrar a mostralo en pantalla para evitar saturar el sistema, es mas eficiente
        itemCount: productsService.products.length,
        itemBuilder: (BuildContext context, int index) => GestureDetector(
          onTap: () {
            // asignamos los valores del producto seleccionado a selected product par aenviarlo por Provider
            productsService.selectedProduct = productsService.products[index].copy();
            Navigator.pushNamed(context, 'product');
          },
          child: ProductCard(product: productsService.products[index])
        )
      ),
      floatingActionButton: FloatingActionButton(
        elevation: 10,
        backgroundColor: Colors.green,
        onPressed: () {
          // creamos un nuevo producto para poder tener uns instancia de producto la cual usaremos en la pantalla de 'product'
          productsService.selectedProduct = Product( // le quite el new a Product... tenia 'new Product'
            available: false, 
            name: '', 
            price: 0
          );
          // vamos ahora a la pantalla de producto donde ya tenemos la instancia de product creada pero con valores vacios lo cual vamos a llenar porque es nuevo
          Navigator.pushNamed(context, 'product');
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}