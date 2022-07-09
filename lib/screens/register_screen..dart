import 'package:flutter/material.dart';
import 'package:productos_app/providers/login_form_provider.dart';
import 'package:productos_app/services/services.dart';
import 'package:provider/provider.dart';
import 'package:productos_app/Ui/input_decorations.dart';
import 'package:productos_app/widgets/widgets.dart';

class RegisterScreen extends StatelessWidget {
   
  const RegisterScreen({Key? key}) : super(key: key);
  
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
                    const SizedBox(height: 10),
                    Text('Register', style: Theme.of(context).textTheme.headline4),
                    const SizedBox(height: 30),

                    // Crea una instancia de LoginFormProvider que redibuja los widget cuando sean necesarios
                    // vivira en el login form en el scope
                    ChangeNotifierProvider(
                      create: (_) => new LoginFormProvider(),
                      child: const _RegisterForm(),
                    ), 

                  ],
                ),
              ),

              const SizedBox(height: 50),

              TextButton(
                onPressed: () => Navigator.pushReplacementNamed(context, 'login'),
                style: ButtonStyle(
                  overlayColor: MaterialStateProperty.all(Colors.indigo.withOpacity(0.1)),
                  shape: MaterialStateProperty.all(const StadiumBorder()),
                  backgroundColor: MaterialStateProperty.all(Colors.blue[600])
                ), 
                child: const Text('Ya tienes una cuenta?', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
              ),

              const SizedBox(height: 50),

            ],
          ),
        )
      ),
    );
  }
}

class _RegisterForm extends StatelessWidget {
 
  const _RegisterForm({Key? key}) : super(key: key);

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
              onPressed: loginForm.isLoading ? null : () async {
                // desabilitamos el boton
                FocusScope.of(context).unfocus();

                // llamaos el provider de autenticacion
                final authService = Provider.of<AuthService>(context, listen: false); 

                // si no el true no haga nada
                if(!loginForm.isValidForm()) return; // usando el provider leemos el formKey.currentState?.validate() de formulario en cuestion
                // si el formulario es valido hacemos una peticion http

                // si la peticion http es valida entonces cargamos como true el getter indicando que se esta cargando la peticion
                loginForm.isLoading = true;

                // simular el tiempo de espera de la peticion http de dos segundos
                // await Future.delayed(Duration(seconds: 2));
 
                // validar si el login es correcto. falta. Validacion real con FireBase autenticator
                final String? errorMessage = await authService.createUser(loginForm.email, loginForm.password);

                if(errorMessage == '') {
                  Navigator.pushReplacementNamed(context, 'home');
                  // aqui se mantiene el boton desabilitado
                }else{
                  // TODO mostrar error en pantalla
                  print(errorMessage);
                  // me coloca un mensaje en el footer de la aplicacion en cualquier lado donde se llame esta clase y metod estatico
                  NotificationsService.showSnapbar(errorMessage!);
                  // si la peticion http es recibida entonces cargamos como false el getter indicando que recibimos la respuesta y habiliatamos el boton optra vez
                  loginForm.isLoading = false;
                }

              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 15),
                child: Text(
                  loginForm.isLoading
                  ? 'Espere'
                  : 'Enviar',
                  style: const TextStyle(color: Colors.white),
                ),
              )
            )
          ],
        )
      ),
    );
  }
}