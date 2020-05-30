import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:teepme/globals.dart' as globals;

class APIService<T> {
  final String url;
  final dynamic body;
  T Function(http.Response response) parse;
  APIService({this.url, this.body, this.parse});  
}

class APIWeb{ 
  final String urlHost = globals.urlAPI; 
  
  Future<T> load<T>(APIService<T> resource) async {
      final response = await http.get(urlHost + resource.url);
      if(response.statusCode == 200) {
        return resource.parse(response);
      } else {
        throw Exception(response.statusCode);
      }
  }

  Future<T> post<T>(APIService<T> resource) async {
    Map<String, String>  headers = {
      "Content-Type": "application/json",
    };
    final response = await http.post(urlHost + resource.url, body: jsonEncode(resource.body), headers: headers);
    if(response.statusCode == 200) {
      return resource.parse(response);
    } else {
      throw Exception(response.statusCode);
    }
  }

}