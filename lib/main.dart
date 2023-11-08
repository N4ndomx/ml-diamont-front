import 'package:flutter/material.dart';

import 'service/api_service.dart';
import 'service/rentreno_service.dart';

void main() {
  runApp(MaterialApp(
    home: DiamondApp(),
  ));
}

class DiamondApp extends StatelessWidget {
  final TextEditingController caratController = TextEditingController();
  final TextEditingController cutController = TextEditingController();
  final TextEditingController colorController = TextEditingController();
  final TextEditingController clarityController = TextEditingController();
  final TextEditingController depthController = TextEditingController();
  final TextEditingController tableController = TextEditingController();
  final TextEditingController xController = TextEditingController();
  final TextEditingController yController = TextEditingController();
  final TextEditingController zController = TextEditingController();
  final TextEditingController resultController = TextEditingController();
  final TextEditingController urlController = TextEditingController();
  final TextEditingController tagController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.amber,
          title: Text('Diamond App'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: caratController,
                decoration: InputDecoration(labelText: 'Carat'),
              ),
              TextField(
                controller: cutController,
                decoration: InputDecoration(labelText: 'Cut'),
              ),
              TextField(
                controller: colorController,
                decoration: InputDecoration(labelText: 'Color'),
              ),
              TextField(
                controller: clarityController,
                decoration: InputDecoration(labelText: 'Clarity'),
              ),
              TextField(
                controller: depthController,
                decoration: InputDecoration(labelText: 'Depth'),
              ),
              TextField(
                controller: tableController,
                decoration: InputDecoration(labelText: 'Table'),
              ),
              TextField(
                controller: xController,
                decoration: InputDecoration(labelText: 'X'),
              ),
              TextField(
                controller: yController,
                decoration: InputDecoration(labelText: 'Y'),
              ),
              TextField(
                controller: zController,
                decoration: InputDecoration(labelText: 'Z'),
              ),
              MaterialButton(
                color: Colors.amber,
                onPressed: () async {
                  // Obtener los valores de las entradas del usuario
                  double carat = double.tryParse(caratController.text) ?? 0.0;
                  double cut = double.tryParse(cutController.text) ?? 0.0;
                  double color = double.tryParse(colorController.text) ?? 0.0;
                  double clarity =
                      double.tryParse(clarityController.text) ?? 0.0;
                  double depth = double.tryParse(depthController.text) ?? 0.0;
                  double table = double.tryParse(tableController.text) ?? 0.0;
                  double x = double.tryParse(xController.text) ?? 0.0;
                  double y = double.tryParse(yController.text) ?? 0.0;
                  double z = double.tryParse(zController.text) ?? 0.0;

                  // Crear un mapa con los datos del usuario
                  Map<String, dynamic> requestData = {
                    "carat": carat,
                    "cut": cut,
                    "color": color,
                    "clarity": clarity,
                    "depth": depth,
                    "table": table,
                    "x": x,
                    "y": y,
                    "z": z,
                  };

                  ApiService apiService = ApiService();

                  try {
                    var data = await apiService.postData(requestData);
                    // Hacer algo con los datos recibidos de la API, como mostrarlos en la caja de texto de resultado.
                    resultController.text = data.toString();
                  } catch (e) {
                    resultController.text = 'Error al enviar datos a la API';
                  }
                },
                child: Text('Realizar Prediccion'),
              ),
              TextField(
                controller: resultController,
                decoration: InputDecoration(labelText: 'Resultado'),
                enabled: false,
              ),
              // Agregar botón "Reentrenar Modelo"
              ElevatedButton(
                onPressed: () {
                  _showRetrainModelDialog(context);
                },
                child: Text('Reentrenar Modelo'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Función para mostrar el diálogo de reentrenamiento del modelo
  void _showRetrainModelDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Reentrenar Modelo'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: urlController,
                decoration: InputDecoration(labelText: 'URL'),
              ),
              TextField(
                controller: tagController,
                decoration: InputDecoration(labelText: 'Tag'),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () async {
                // Procesar la URL y la etiqueta ingresadas
                String url = urlController.text;
                String tag = tagController.text;

                Map<String, dynamic> requestData = {
                  "event_type": "ml_ci_cd",
                  "client_payload": {
                    "dataseturl": url,
                    "sha": tag,
                  }
                };

                reentrenoService apiService = reentrenoService();

                try {
                  var data = await apiService.postData(requestData);
                  // Hacer algo con los datos recibidos de la API, como mostrarlos en la caja de texto de resultado.
                  resultController.text = data.toString();
                } catch (e) {
                  resultController.text = 'Reentrenando Modelo...';
                }

                // Cerrar el diálogo
                Navigator.of(context).pop();
              },
              child: Text('Reentrenar'),
            ),
            TextButton(
              onPressed: () {
                // Cerrar el diálogo sin realizar ninguna acción
                Navigator.of(context).pop();
              },
              child: Text('Cancelar'),
            ),
          ],
        );
      },
    );
  }
}
