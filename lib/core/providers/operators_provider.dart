import 'dart:async';
import 'dart:convert' as convert;
import 'dart:io';
import 'package:http/io_client.dart' as http;
import 'package:mysharps/core/routes/operators_route.dart';

class OperatorsProvider {
  //creation of http client
  final ioClient = HttpClient();

  Future<dynamic> getAllOperators() async {
    //All Operatorss routes
    String allOperatorsRoute = OperatorsRoute.alloperators;
    //parse request time out for login request
    ioClient.connectionTimeout = const Duration(seconds: 60);

    //create http format
    final client = http.IOClient(ioClient);

    //make request
    try {
      //Parse url for request
      final urlParse = Uri.parse(allOperatorsRoute);
      print("Execution de la requete : $urlParse");

      //Definition of header of request
      Map<String, String> headers = {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      };

      //Execute request
      final allOperatorsResult = await client.get(urlParse, headers: headers);

      var datas = convert.jsonDecode(allOperatorsResult.body);

      print("Code de retour : ${allOperatorsResult.statusCode}");

      return datas;
    } catch (e) {
      print("Erreur lors de la requete $e");
      return null;
    }
  }

  //Get all categories and code of operators
  Future<dynamic> getAllOperatorsDatas(int operatorId) async {
    //All Operatorss routes
    String allOperatorsDatasRoute = OperatorsRoute.alloperatorsDatas;
    //parse request time out for login request
    ioClient.connectionTimeout = const Duration(seconds: 60);

    //create http format
    final client = http.IOClient(ioClient);

    //make request
    try {
      //Parse url for request
      final urlParse = Uri.parse('$allOperatorsDatasRoute/$operatorId');
      print("Execution de la requete : $urlParse");

      //Definition of header of request
      Map<String, String> headers = {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      };

      //Execute request
      final allOperatorsDatasResult =
          await client.get(urlParse, headers: headers);

      var datas = convert.jsonDecode(allOperatorsDatasResult.body);

      print("Code de retour : ${allOperatorsDatasResult.statusCode}");

      return datas;
    } catch (e) {
      print("Erreur lors de la requete $e");
      return null;
    }
  }
}
