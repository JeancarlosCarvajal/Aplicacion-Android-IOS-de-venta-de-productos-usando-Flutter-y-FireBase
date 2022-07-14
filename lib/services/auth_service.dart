import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '/tokens/tokens.dart';

class AuthService extends ChangeNotifier {

  // el https ya lo anexa el paquete con que trabajamos, aqui se coloca solo la base del url
  final String _baseurl = 'identitytoolkit.googleapis.com';

  // token de acceso del API de firebase
  final String _firebaseToken = Tokens.tokenFireBse; 

  // storage, ya la podemos usar en cualquier parte de la aplicacion
  final storage = new FlutterSecureStorage();

  // si retornamos algo es un error sino todo bien
  Future<String> createUser( String email, String password ) async {

    final Map<String, dynamic> authData = {
      'email'   : email,
      'password': password,
      'returnSecureToken': true
    };

    // Creamos la peticion POST con el header del key
    final url = Uri.https(_baseurl, '/v1/accounts:signUp', {
      'key': _firebaseToken
    });

    // disparamos la peticion para obtener la respuesta
    // tomamos la url le agregamos el body el json encode con el authData
    final resp = await http.post(url, body: json.encode(authData));

    // Obtenemos la respuesta y la formateamos
    final Map<String, dynamic> decodedResp = json.decode(resp.body);
    print(decodedResp);

    if(decodedResp.containsKey('idToken')) {
      // guardar el token en un lugar seguro del storage
      await storage.write(key: 'token', value: decodedResp['idToken']);
      // return decodedResp['idToken'];
      return '';
    }else{
      return decodedResp['error']['message'];
    }

  }

  // si retornamos algo es un error sino todo bien
  Future<String> login( String email, String password ) async {

    final Map<String, dynamic> authData = {
      'email'   : email,
      'password': password,
      'returnSecureToken': true
    };

    // Creamos la peticion POST con el header del key
    final url = Uri.https(_baseurl, '/v1/accounts:signInWithPassword', {
      'key': _firebaseToken
    });

    // disparamos la peticion para obtener la respuesta
    // tomamos la url le agregamos el body el json encode con el authData
    final resp = await http.post(url, body: json.encode(authData));

    // Obtenemos la respuesta y la formateamos
    final Map<String, dynamic> decodedResp = json.decode(resp.body);

    // print(decodedResp);
    // return '';
    // print(decodedResp['idToken']);

    if(decodedResp.containsKey('idToken')) {
      // guardar el token en un lugar seguro del storage
      await storage.write(key: 'token', value: decodedResp['idToken']);
      // return decodedResp['idToken'];
      return '';
    }else{
      return decodedResp['error']['message'];
    }
  }

  // El secure Storage  esta Encriptado y es el mejor lugar para guardar Token 
  Future logout() async {
    await storage.delete(key: 'token');
    return;
  }

  // lee el token en el storage
  Future<String> readToken() async {
    // Si el token no existe regresa unn string vacio
    return await storage.read(key: 'token') ?? '';
  }



}