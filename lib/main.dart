
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

const request = 'https://api.hgbrasil.com/finance?format=json&key=4599f186';

void main() async {
  runApp(MaterialApp(
    home: Home(),
    theme: ThemeData(
      primaryColor: Colors.red,
      hintColor: Colors.amberAccent,
      inputDecorationTheme: InputDecorationTheme(
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.white,
          )
        )
      )
    ),
  ));
}

Future<Map> getData() async {
  http.Response response = await http.get(request);
  return json.decode(response.body);
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  final realController = TextEditingController();
  final dollarController = TextEditingController();
  final euroController = TextEditingController();
  final btcController = TextEditingController();


  double dolar;
  double euro;
  double btc;

  void _realChanged(String text){
    double real = double.parse(text);
    dollarController.text = (real/dolar).toStringAsFixed(2);
    euroController.text = (real/euro).toStringAsFixed(2);
    btcController.text = (real/btc).toStringAsFixed(6);
  }

  void _dollarChanged(String text){
    double dolar = double.parse(text);
    realController.text = (dolar * this.dolar).toStringAsFixed(2);
    euroController.text = (dolar * this.dolar / euro).toStringAsFixed(2);
    btcController.text = (dolar * this.dolar / btc).toStringAsFixed(6);
  }

  void _euroChanged(String text){
    double euro = double.parse(text);
    realController.text = (euro * this.euro).toStringAsFixed(2);
    dollarController.text = (euro * this.euro / dolar).toStringAsFixed(2);
    btcController.text = (euro * this.euro / btc).toStringAsFixed(6);
  }

  void _btcChanged(String text){
    double btc = double.parse(text);
    realController.text = (btc * this.btc).toStringAsFixed(2);
    dollarController.text = (btc * this.btc / dolar).toStringAsFixed(2);
    euroController.text = (btc * this.btc / euro).toStringAsFixed(2);
  }

  void _clearAll(){
    realController.text = "";
    dollarController.text = "";
    euroController.text = "";
    btcController.text = "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(
          '\$ Conversor \$',
        ),
        backgroundColor: Colors.amber,
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed:_clearAll,
          ),
        ],
      ),
      body: FutureBuilder<Map>(
        future: getData(),
          builder: (context, snapshot) {
            switch(snapshot.connectionState){
              case ConnectionState.none:
              case ConnectionState.waiting:
                return Center(
                  child: Text(
                    'Carregando Dados...',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.amber,
                    ),
                    textAlign: TextAlign.center,
                  ),
                );
              default:
                if(snapshot.hasError){
                  return Center(
                    child: Text(
                      'Erro ao Carregar Dados :(',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.amber,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  );
                } else{
                  dolar = snapshot.data['results']['currencies']['USD']['buy'];
                  euro = snapshot.data['results']['currencies']['EUR']['buy'];
                  btc = snapshot.data['results']['currencies']['BTC']['buy'];


                  return SingleChildScrollView(
                    padding: EdgeInsets.all(40),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Icon(
                          Icons.monetization_on,
                          size: 150,
                          color: Colors.amberAccent,
                        ),
                        buildTextField('Reais', 'R\$', realController, _realChanged),
                        Divider(),
                        buildTextField('Dólares', 'US\$', dollarController, _dollarChanged),
                        Divider(),
                        buildTextField('Euro', '€', euroController, _euroChanged),
                        Divider(),
                        buildTextField('Bitcoin', '₿', btcController, _btcChanged),
                      ],
                    ),
                  );
                }
            }
          })
    );
  }
}

Widget buildTextField(String label, String prefix, TextEditingController c, Function f){
  return TextField(
    controller: c,
    decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(
          color: Colors.amber,
        ),
        border: OutlineInputBorder(),
        prefixText: prefix
    ),
    style: TextStyle(
      color: Colors.red,
    ),
    onChanged: f,
    keyboardType: TextInputType.number,
  );
}