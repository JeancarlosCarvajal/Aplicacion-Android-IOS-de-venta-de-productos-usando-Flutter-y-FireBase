import 'package:flutter/material.dart';
import 'package:productos_app/screens/home_screen.dart';
import 'package:productos_app/screens/login_screen.dart';
import 'package:productos_app/services/auth_service.dart';
import 'package:productos_app/services/services.dart';
import 'package:provider/provider.dart';

class CheckAuthScreen extends StatelessWidget {
   
  const CheckAuthScreen({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {

    // NO necesito redibujar este widget
    final authService = Provider.of<AuthService>(context, listen: false);

    // leer los datos de la api de productos llamando al provider
    final productsService = Provider.of<ProductsService>(context);  


    return Scaffold(
      body: Center(
         child: FutureBuilder(
          future: authService.readToken(),
          builder: (BuildContext context, AsyncSnapshot<String> snapshot) {

            // snapshot.hasData indica si la data fue recibida en true y false no ha sido recibida
            print('Aqui auth screen: ${snapshot.hasData}');

            if(!snapshot.hasData) { // snapshot.hasData indica si la data fue recibida en true y false no ha sido recibida
              return const Text('Espere');
            }

             // snapshot.data es la data que estoy esperando, en este caso es el Token de sesion
            print('Soy Auth snapshot.data: ${snapshot.data}');

            if(snapshot.data == ''){ // snapshot.data es la data que estoy esperando, en este caso es el Token de sesion
              // NOO se puede redibujar el widget y hacer una redireccion al mismo tiempo
              // se debe usar  para que al temrinar de construir el widget se haga la redireccion
              Future.microtask(() {
                // Navigator.of(context).pushReplacementNamed('home');
                Navigator.pushReplacement(context, PageRouteBuilder(
                    pageBuilder: (_, __, ___) => const LoginScreen(),
                    transitionDuration: const Duration(seconds: 0)
                  )
                );
              });
            }else{ 
              // si productervice me devuelve error es porque el token existe en el dispositivo pero expiro
              // por lo tanto redirecciono al loging
              if(productsService.products.isEmpty) {
                print('Token Expiro');
                Future.microtask(() {
                  // Navigator.of(context).pushReplacementNamed('home');
                  Navigator.pushReplacement(context, PageRouteBuilder(
                      pageBuilder: (_, __, ___) => const LoginScreen(),
                      transitionDuration: const Duration(seconds: 0)
                    )
                  ); 
                }); 
              }else{
                // NOO se puede redibujar el widget y hacer una redireccion al mismo tiempo
                // se debe usar  para que al temrinar de construir el widget se haga la redireccion
                Future.microtask(() {
                  // Navigator.of(context).pushReplacementNamed('home');
                  Navigator.pushReplacement(context, PageRouteBuilder(
                      pageBuilder: (_, __, ___) => const HomeScreen(),
                      transitionDuration: const Duration(seconds: 0)
                    )
                  );
                }); 
              }
            }
            

            return Container(); 
          }
        ),
      ),
    );
  }
}