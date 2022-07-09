import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '/tokens/tokens.dart';

class AuthService extends ChangeNotifier {

  // el https ya lo anexa el paquete con que trabajamos, aqui se coloca solo la base del url
  final String _baseurl = 'identitytoolkit.googleapis.com';

  // token de acceso del API de firebase
  final String _firebaseToken = Tokens.tokenFireBse; 

  // si retornamos algo es un error sino todo bien
  Future<String> createUser( String email, String password ) async {

    final Map<String, dynamic> authData = {
      'email'   : email,
      'password': password
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
      'password': password
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

    if(decodedResp.containsKey('idToken')) {
      // guardar el token en un lugar seguro del storage
      // return decodedResp['idToken'];
      return '';
    }else{
      return decodedResp['error']['message'];
    }
  }

  // El secure Storage  esta Encriptado y es el mejor lugar para guardar Token 




}