import 'package:flutter/material.dart';
import 'package:productos_app/screens/screens.dart';
import 'package:productos_app/services/services.dart';
import 'package:provider/provider.dart';

void main() => runApp(const AppState());


class AppState extends StatelessWidget {
  const AppState({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // con esto tengo toda la informacion de mi usuario ai=utenticado en cualquier parte
        ChangeNotifierProvider(create: (_) => AuthService()), 
        ChangeNotifierProvider(create: (_) => ProductsService()),
      ],
      child: MyApp(),
    );
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Productos App',
      initialRoute: 'checking',
      routes: {
        // Pantalla de esoere
        'checking' : (_) => const CheckAuthScreen(),
        // Pantallas principales
        'home'     : (_) => const HomeScreen(),
        'product'  : (_) => const ProductScreen(),
        // Autenticacion 
        'login'    : (_) => const LoginScreen(),
        'register' : (_) => const RegisterScreen(),
      },
      // al hacer esto en cualquier lado de la aplicacion usando los metodos y propiedades estaticas de NotificationsService
      // se tiene acceso a este scaffold MaterialApp
      // el messengerKey sirve para mostrar los mensajes en cualquier lugar
      scaffoldMessengerKey: NotificationsService.messengerKey,
      theme: ThemeData.light().copyWith(
        scaffoldBackgroundColor: Colors.grey[300],
        appBarTheme: const AppBarTheme(
          elevation: 0,
          color: Colors.indigo
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Colors.indigo,
          elevation: 0
        )
      ),
    );
  }
}