import 'dart:async';
import 'dart:convert' as convert;
import 'dart:io';
import 'package:http/io_client.dart' as http;
import 'package:mysharps/core/routes/categories_route.dart';

class CategoriesProvider {
  //creation of http client
  final ioClient = HttpClient();

  Future<dynamic> getAllCategories() async {
    //All categories routes
    String allCategoriesRoute = CategoriesRoute.allcategories;
    //parse request time out for login request
    ioClient.connectionTimeout = const Duration(seconds: 60);

    //create http format
    final client = http.IOClient(ioClient);

    //make request
    try {
      //Parse url for request
      final urlParse = Uri.parse(allCategoriesRoute);
      print("Execution de la requete : $urlParse");

      //Definition of header of request
      Map<String, String> headers = {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      };

      //Execute request
      final allCategoriesResult = await client.get(urlParse, headers: headers);

      var datas = convert.jsonDecode(allCategoriesResult.body);

      print("Code de retour : ${allCategoriesResult.statusCode}");

      return datas;
    } catch (e) {
      print("Erreur lors de la requete $e");
      return null;
    }
  }
}
