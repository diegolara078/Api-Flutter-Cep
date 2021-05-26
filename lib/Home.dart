import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController _controllerCep = TextEditingController();
  String _end = "";
  String _ip = "";
  _recuperarCep() async {
    String cep = _controllerCep.text;
    var urlIp = Uri.https('api.country.is', '', {'q': '{http}'});

    var urlCep =
        Uri.https('viacep.com.br', '/ws/' + cep + '/json/', {'q': '{http}'});

    var responseIP = await http.get(urlIp);
    var responseCep = await http.get(urlCep);
    //print("teste" + responseIP.body);

    if (responseCep.statusCode == 200) {
      var jsonResponse =
          convert.jsonDecode(responseCep.body) as Map<String, dynamic>;
      var jsonResponseIp =
          convert.jsonDecode(responseIP.body) as Map<String, dynamic>;
      //IP
      String ip = jsonResponseIp["ip"];
      //cep
      String logradouro = jsonResponse["logradouro"];
      String bairro = jsonResponse["bairro"];
      String localidade = jsonResponse["localidade"];
      String uf = jsonResponse["uf"];

      setState(() {
        _ip = "IP :" + ip;
        _end = logradouro + " , " + bairro + " , " + localidade + " - " + uf;
      });
    } else {
      setState(() {
        _end = "Ops não encontramos o seu CEP!!!";
      });
    }
    //print(logradouro + " , " + bairro + " , " + localidade + " - " + uf);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Localize o seu CEP"),
      ),
      body: Container(
        padding: EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(_ip, style: TextStyle(fontSize: 20)),
            Text(_end, style: TextStyle(fontSize: 20)),
            Padding(
              //padding: EdgeInsets.symmetric(horizontal: 160, vertical: 3),
              padding: EdgeInsets.all(80.0),
              child: TextField(
                keyboardType: TextInputType.number,
                decoration:
                    InputDecoration(labelText: "Digite o cep: ex: xxxxxxx"),
                style: TextStyle(fontSize: 20),
                controller: _controllerCep,
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  primary: Colors.blue, onPrimary: Colors.white),
              child: Text("Consultar"),
              onPressed: _recuperarCep,
            )
          ],
        ),
      ),
    );
  }
}
