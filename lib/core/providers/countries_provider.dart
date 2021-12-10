import 'dart:async';
import 'dart:convert' as convert;
import 'dart:io';
import 'package:http/io_client.dart' as http;
import 'package:mysharps/core/routes/countries_route.dart';

class CountriesProvider {
  //creation of http client
  final ioClient = HttpClient();

  Future<dynamic> getAllCountries() async {
    //All Countriess routes
    String allCountriesRoute = CountriesRoute.allcountries;
    //parse request time out for login request
    ioClient.connectionTimeout = const Duration(seconds: 60);

    //create http format
    final client = http.IOClient(ioClient);

    //make request
    try {
      //Parse url for request
      final urlParse = Uri.parse(allCountriesRoute);
      print("Execution de la requete : $urlParse");

      //Definition of header of request
      Map<String, String> headers = {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      };

      //Execute request
      final allCountriesResult = await client.get(urlParse, headers: headers);

      var datas = convert.jsonDecode(allCountriesResult.body);

      print("Code de retour : ${allCountriesResult.statusCode}");

      return datas;
    } catch (e) {
      print("Erreur lors de la requete $e");
      return null;
    }
  }
}
