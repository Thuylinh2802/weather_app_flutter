import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:weather_app_flutter/Screen/homePage.dart';
import '../Helper/utils.dart';
import '../Model/weatherDatabase.dart';
import '../Model/weather_model.dart';

class SearchWeatherList extends StatefulWidget {
  const SearchWeatherList({super.key});

  @override
  State<SearchWeatherList> createState() => _SearchWeatherListState();
}

class _SearchWeatherListState extends State<SearchWeatherList> {
  final TextEditingController _controller = TextEditingController();
  List<Weather> _weatherList = [];

  @override
  void initState() {
    super.initState();
    _loadWeatherList();
    // WeatherDatabase.instance.deleteAll();
  }

  Future<void> _loadWeatherList() async {
    final weatherList = await WeatherDatabase.instance.getAll();
    setState(() {
      _weatherList = weatherList;
      print(_weatherList.length);
    });
  }

  Future<void> fetchWeather() async {
    final city = _controller.text;
    const apiKey = '1a68389fd8154e089e6153255233101';
    final apiUrl =
        'https://api.weatherapi.com/v1/current.json?key=$apiKey&q=$city';
    final response = await http.get(Uri.parse(apiUrl));
    final data = jsonDecode(response.body);

    final cityName = data['location']['name'];
    final tempC = data['current']['temp_c'];
    final status = data['current']['condition']['text'];
    Weather weather = Weather(cityName: cityName, temperature: tempC, weatherCondition: status);
    await WeatherDatabase.instance.insert(weather);
    _loadWeatherList();
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather List'),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 40, right: 16, left: 16),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15)
                ),
                hintText: 'Enter a city name',
                hintStyle: const TextStyle(color: Colors.grey),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {
                    fetchWeather();
                  },
                ),
              ),
            ),
            const SizedBox(height: 10,),
            Expanded(
              child: ListView.builder(
                itemCount: _weatherList.length,
                itemBuilder: (context, index) {
                  final weather = _weatherList[index];
                  return GestureDetector(
                    onTap: (() {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => HomePage()),
                      );
                    }),
                    child: Container(
                      margin: const EdgeInsets.only(top: 20),
                      padding: const EdgeInsets.only(top: 5),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            blurRadius: 7,
                            offset: const Offset(0, 3),
                          )
                        ],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ListTile(
                        // contentPadding: const EdgeInsets.all(8),
                        title: Text(
                          weather.cityName!,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 23,
                          ),
                        ),
                        subtitle: Row(
                          children: [
                            Icon(
                              MapString.mapStringToIcon(weather.weatherCondition!),
                              size: 30,
                              color: Colors.blue,
                            ),
                            const SizedBox(width: 10,),
                            Text(
                              weather.weatherCondition!,
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                        trailing: Text(
                          '${weather.temperature}°C',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 35,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}