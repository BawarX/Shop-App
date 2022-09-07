import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


class Auth with ChangeNotifier {
  String? _token;
  DateTime? _expireyDate;
  String? _userId;

  bool get isAuth{
    return token != null;
  }

  String? get token{
    if(_expireyDate != null && _expireyDate!.isAfter(DateTime.now()) && _token != null){
      return _token;
    }
    return null;
  }

  String? get userId {
    return _userId;
  }

  // Future<void> _authenticate(
  //     String email, String password, String urlSegment) async {
  //   final url = Uri.parse(
  //       'https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=AIzaSyCYZKFlX3S8G3BJgJVYKVMzHgOs5VzK00g');
  //   try {
  //     final response = await http.post(
  //       url,
  //       body: json.encode(
  //         {
  //           'email': email,
  //           'password': password,
  //           'returnSecureToken': true,
  //         },
  //       ),
  //     );
  //     final responseData = json.decode(response.body);
  //     if(responseData['error'] != null){// if it exist
  //       throw HttpException(responseData['error']['message']);
  //     }
  //   } catch (error) {
  //     throw error;
  //   }
  // }

  Future<void> signUp(String email, String password) async {
    //return _authenticate(email, password, 'signUp');
      final url = Uri.parse(
          'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=AIzaSyCYZKFlX3S8G3BJgJVYKVMzHgOs5VzK00g');
     final response = await http.post(
        url,
        body: json.encode(
          {
            'email': email,
            'password': password,
            'returnSecureToken': true,
          },
        ),
      );
      final responseData = json.decode(response.body);
      _token = responseData['idToken'];
      _userId = responseData['localId'];
      _expireyDate = DateTime.now().add(Duration(seconds: int.parse(responseData['expiresIn']) ));
      notifyListeners();
  }

  Future<void> logIn(String email, String password) async {
   // return _authenticate(email, password, 'signInWithPassword');
      final url = Uri.parse(
          'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=AIzaSyCYZKFlX3S8G3BJgJVYKVMzHgOs5VzK00g'
          );
     final response = await http.post(
        url,
        body: json.encode(
          {
            'email': email,
            'password': password,
            'returnSecureToken': true,
          },
        ),
      );
        final responseData = json.decode(response.body);
      _token = responseData['idToken'];
      _userId = responseData['localId'];
      _expireyDate = DateTime.now().add(Duration(seconds: int.parse(responseData['expiresIn']) ));
      notifyListeners();
      print(json.decode(response.body));
  }
}
