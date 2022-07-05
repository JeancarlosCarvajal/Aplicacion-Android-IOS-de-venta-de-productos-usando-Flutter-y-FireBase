import 'package:flutter/material.dart';
import 'package:productos_app/providers/login_form_provider.dart';
import 'package:provider/provider.dart';
import 'package:productos_app/Ui/input_decorations.dart';
import 'package:productos_app/widgets/widgets.dart';

class LoginScreen extends StatelessWidget {
   
  const LoginScreen({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AuthBackground(
        child: SingleChildScrollView( // para hacer scroll si un elemento hijo es muy grande  
          child: Column(
            children: [
              
              const SizedBox(height: 220),// para separar

              CardContainer(
                child: Column(
                  children: [
                    SizedBox(height: 10),
                    Text('Login', style: Theme.of(context).textTheme.headline4),
                    SizedBox(height: 30),

                    // Crea una instancia de LoginFormProvider que redibuja los widget cuando sean necesarios
                    // vivira en el login form en el scope
                    ChangeNotifierProvider(
                      create: (_) => new LoginFormProvider(),
                      child: _LoginForm(),
                    ), 

                  ],
                ),
              ),

              const SizedBox(height: 50),

              const Text('Crear una nueva Cuenta', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),

              const SizedBox(height: 50),

            ],
          ),
        )
      ),
    );
  }
}

class _LoginForm extends StatelessWidget {
 
  const _LoginForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    // para acceder al provider
    final loginForm = Provider.of<LoginFormProvider>(context);

    return Container(
      child: Form(
        // TODO mantener la referencia al KEY. el key dice si pasaron las validadiones
        key: loginForm.formKey, // asociamos el key al provider
        autovalidateMode: AutovalidateMode.onUserInteraction, // para que valide al hacer input
        child: Column(
          children: [
            TextFormField(
              autocorrect: false,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecorations.authInputDecoration(
                hintText: 'ejemplo@gmail.com', 
                labelText: 'Correo electronico', 
                prefixIcon:  Icons.alternate_email_sharp
              ),
              onChanged: (value) => loginForm.email = value,
              validator: (value){
                String pattern = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                RegExp regExp  = new RegExp(pattern);
                // toma la expresion regular y verifica si hace match
                return regExp.hasMatch(value ?? '')
                  ? null
                  : 'El valor ingresado no es un correo electronico';
              },
            ),
            const SizedBox(height: 30),
            TextFormField(
              autocorrect: false,
              obscureText: true,// pa que no vea lo que escribe
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecorations.authInputDecoration(
                hintText: '********', 
                labelText: 'Contrasena',
                prefixIcon:  Icons.lock_clock_outlined
              ),
              onChanged: (value) => loginForm.password= value,
              validator: (value){
                return (value != null && value.length >= 6) 
                  ? null
                  : 'La constrasena debe de ser de 6 caracteres o mas';
              },
            ),
            const SizedBox(height: 30),
            MaterialButton(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              disabledColor: Colors.grey,
              elevation: 0,
              color: Colors.deepPurple,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 15),
                child: Text(
                  loginForm.isLoading
                  ? 'Espere'
                  : 'Ingresar',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              onPressed: loginForm.isLoading ? null : () async {
                // desabilitamos el boton
                FocusScope.of(context).unfocus();
                // TODO login Form
                // si no el true no haga nada
                if(!loginForm.isValidForm()) return; // usando el provider leemos el formKey.currentState?.validate() de formulario en cuestion
                // si el formulario es valido hacemos una peticion http

                // si la peticion http es valida entonces cargamos como true el getter indicando que se esta cargando la peticion
                loginForm.isLoading = true;

                // simular el tiempo de espera de la peticion http de dos segundos
                await Future.delayed(Duration(seconds: 2));
 
                //TODO validar si el login es correcto. falta
                
                // si la peticion http es recibida entonces cargamos como false el getter indicando que recibimos la respuesta y habiliatamos el boton optra vez
                loginForm.isLoading = false;

                Navigator.pushReplacementNamed(context, 'home');
              }
            )
          ],
        )
      ),
    );
  }
}