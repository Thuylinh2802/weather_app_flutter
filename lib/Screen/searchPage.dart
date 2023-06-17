import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_app_flutter/Screen/homePage.dart';
import '../Helper/utils.dart';
import '../Model/weatherDatabase.dart';
import '../Model/weather_model.dart';
import '../Provider/weatherProvider.dart';

class SearchCity extends StatefulWidget {
  const SearchCity({super.key});

  @override
  State<SearchCity> createState() => _SearchCityState();
}

class _SearchCityState extends State<SearchCity> {
  List<WeatherDB> _weatherList = [];

  Future<void> _loadWeatherList() async {
    // WeatherDatabase.instance.deleteAll();
    final weatherList = await WeatherDatabase.instance.getAll();
    setState(() {
      _weatherList = weatherList;
    });
  }

   @override
    void initState() {
      super.initState();
      _loadWeatherList();
    }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<WeatherProvider>(context);

    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.only(top: 20, right: 16, left: 16),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15)
                ),
                hintText: 'Search city',
                hintStyle: const TextStyle(color: Colors.grey),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: (() {}),
                ),
              ),
              onSubmitted: (value) {
                provider.fetchWeather(value);
                _loadWeatherList();
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const HomePage()),
                );
              },
            ),
            const SizedBox(height: 10,),
            Expanded(
              child: ListView.builder(
                itemCount: _weatherList.length,
                itemBuilder: (context, index) {
                  final weather = _weatherList[index];
                  if(weather != null) {
                    return GestureDetector(
                      onTap: (() {
                        final weather = _weatherList[index];
                        provider.fetchWeather(weather.cityName);
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const HomePage()),
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
                          title: Text(
                            weather.cityName,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 23,
                            ),
                          ),
                          subtitle: Row(
                            children: [
                              Icon(
                                MapString.mapStringToIcon(weather.weatherCondition),
                                size: 30,
                                color: Colors.blue,
                              ),
                              const SizedBox(width: 10,),
                              Text(
                                weather.weatherCondition,
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
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}