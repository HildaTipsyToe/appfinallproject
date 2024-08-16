import 'dart:convert';

import 'package:appfinallproject/marsobject.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class nasaTest{

  Future<Nasa> getData(String rover, String camera, int sol){
    String nasaApiKey = '6hh8VeCJ4sA8GmYKfEPahbovRkoM4o8CkpNUXiGf';
    String nasaUrl = 'https://api.nasa.gov/mars-photos/api/v1/rovers/$rover/photos?sol=$sol&camera=$camera&api_key=$nasaApiKey';
    Future<Nasa> test = fetchNasa(nasaUrl);
    return test;
  }
 
  Future<Nasa> fetchNasa(String url) async{
  
  final response = await http.get(Uri.parse(url));

  if(response.statusCode == 200){
    print("We got some data!");
    return Nasa.fromJson(jsonDecode(response.body) as Map<String, dynamic>); 
  }
  else {
    throw Exception('Failed to load album');
  }
}
}
