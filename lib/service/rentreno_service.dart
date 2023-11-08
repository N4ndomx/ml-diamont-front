import 'dart:convert';

import 'package:http/http.dart' as http;

class reentrenoService {
  // Tu token Bearer
  String bearerToken = '';
  final String apiUrl =
      'https://api.github.com/repos/N4ndomx/ml-diamond-price/dispatches';

  Future<Map<String, dynamic>> postData(Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse(apiUrl),
      body: json.encode(data),
      headers: {
        'Authorization': 'Bearer $bearerToken',
        'Content-Type':
            'application/json', // Asegúrate de ajustar los encabezados según las necesidades de tu API.
      },
    );

    if (response.statusCode == 200) {
      // Si la solicitud es exitosa, analiza la respuesta JSON.
      return json.decode(response.body);
    } else {
      // Si la solicitud falla, puedes manejar el error aquí.
      throw Exception('Error ');
    }
  }
}
