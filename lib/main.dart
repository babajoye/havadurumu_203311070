
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: WeatherApp(),
    );
  }
}




Future<Map<String, dynamic>> getWeatherData(String city) async {
  var uri = Uri.https('api.openweathermap.org', '/data/2.5/weather', {'q': city, 'appid': 'ff433bfa8b6011a16cec45471ba6b6cd'});
  http.Response response = await http.get(uri);
  return json.decode(response.body);
}


class WeatherApp extends StatefulWidget {
  @override
  _WeatherAppState createState() => _WeatherAppState();
}

class _WeatherAppState extends State<WeatherApp> {
  Map<String, dynamic> _weatherData = {};
  String _city = '';


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Hava Durumu Uygulaması'),
        ),
        body: Container(
        child: Column(
        children: <Widget>[
        Padding(
        padding: const EdgeInsets.all(16.0),
    child: TextField(
    decoration: InputDecoration(
    hintText: 'Şehir Adı',
    ),
    onChanged: (value) {
    _city = value;
    },
    ),
    ),
    RaisedButton(
    onPressed: () {
    getWeatherData(_city).then((value) {
    setState(() {
    _weatherData = value;
    });
    });
    },
    child: Text('Hava Durumunu Göster'),
    ),
    Expanded(
    child: _weatherData == null
    ? Center(child: CircularProgressIndicator())
        : ListView(
    children: <Widget>[
      Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            _weatherData == null || !_weatherData.containsKey("sys") || !_weatherData["sys"].containsKey("country")
                ? "Bilinmeyen"
                : '${_weatherData['name']}, ${_weatherData['sys']['country']}',
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),

      Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: _weatherData != null &&
              _weatherData['main'] != null &&
              _weatherData['main']['temp'] != null
              ? Text(
            'Sıcaklık: ${_weatherData['main']['temp']}°C',
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          )
              : Text(
            'Sıcaklık bilgisi yüklenemedi',
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),

      Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: _weatherData != null &&
              _weatherData['main'] != null &&
              _weatherData['main'].containsKey("pressure")
              ? Text(
            'Basınç: ${_weatherData['main']['pressure']} hPa',
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          )
              : Text(
            'Basınç bilgisi yüklenemedi',
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    ],
    ),
    ),
    ],
    ),
    ),
    );
   }
 }
void main() => runApp(MyApp());




