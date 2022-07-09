import 'package:flutter/material.dart';
import 'package:productos_app/screens/home_screen.dart';
import 'package:productos_app/screens/login_screen.dart';
import 'package:productos_app/services/auth_service.dart';
import 'package:provider/provider.dart';

class CheckAuthScreen extends StatelessWidget {
   
  const CheckAuthScreen({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {

    // NO necesito redibujar este widget
    final authService = Provider.of<AuthService>(context, listen: false);

    return Scaffold(
      body: Center(
         child: FutureBuilder(
          future: authService.readToken(),
          builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
            
            print('Aqui auth screen: ${snapshot.hasData}');

            if(!snapshot.hasData) {
              return const Text('Espere');
            }

            if(snapshot.data == ''){
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
            

            return Container();

          }
        ),
      ),
    );
  }
}