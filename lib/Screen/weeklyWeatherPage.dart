import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';

import '../Helper/utils.dart';
import '../Provider/weatherProvider.dart';

class WeeklyPage extends StatefulWidget {

  const WeeklyPage({Key? key}) : super(key: key);

  @override
  State<WeeklyPage> createState() => _WeeklyPageState();
}

class _WeeklyPageState extends State<WeeklyPage> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final provider = Provider.of<WeatherProvider>(context);
    final weather = provider.state.currentWeather;
    final dailyForecasts = provider.state.currentWeather?.dailyForecasts;

    int currentHumidity = weather!.humidity;
    int currentWindSpeed = weather.windSpeed;
    int currentFeelslike = weather.feelslike;
    int currentCloud = weather.cloud;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          '7 Days',
          style: TextStyle(
            color: Colors.white
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 20, top: 10, bottom: 10),
              child: Text(
                weather.cityName,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  margin: const EdgeInsets.only(left: 20, top: 10),
                  height: 60,
                  width: size.width * 0.44,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.white),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        blurRadius: 7,
                        offset: const Offset(0, 3),
                      )
                    ],
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          MdiIcons.waterPercent,
                          color: Colors.blue,
                          size: 35,
                        ),
                        const SizedBox(width: 15),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '$currentHumidity%',
                              style: const TextStyle(
                                fontWeight: FontWeight.w700, 
                                fontSize: 18
                              ),
                            ),
                            const Text(
                              'Humidity',
                              style: TextStyle(
                                fontWeight: FontWeight.w400, 
                                fontSize: 15
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only (top: 10, right: 20),
                  height: 60,
                  width: size.width * 0.44,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.white),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        blurRadius: 7,
                        offset: const Offset(0, 3),
                      )
                    ],
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          MdiIcons.weatherWindy,
                          color: Colors.blue,
                          size: 35,
                        ),
                        const SizedBox(width: 15),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '$currentWindSpeed km/h',
                              style: const TextStyle(
                                fontWeight: FontWeight.w700, 
                                fontSize: 18
                              ),
                            ),
                            const Text(
                              'Wind',
                              style: TextStyle(
                                fontWeight: FontWeight.w400, 
                                fontSize: 15
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  margin: const EdgeInsets.only(left: 20, top: 10, bottom: 20),
                  height: 60,
                  width: size.width * 0.44,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.white),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        blurRadius: 7,
                        offset: const Offset(0, 3),
                      )
                    ],
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          MdiIcons.temperatureCelsius,
                          color: Colors.blue,
                          size: 35,
                        ),
                        const SizedBox(width: 15),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '$currentFeelslike°C',
                              style: const TextStyle(
                                fontWeight: FontWeight.w700, 
                                fontSize: 18
                              ),
                            ),
                            const Text(
                              'Feels Like',
                              style: TextStyle(
                                fontWeight: FontWeight.w400, 
                                fontSize: 15
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only (top: 10, bottom: 20, right: 20),
                  height: 60,
                  width: size.width * 0.44,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.white),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        blurRadius: 7,
                        offset: const Offset(0, 3),
                      )
                    ],
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          MdiIcons.weatherCloudy,
                          color: Colors.blue,
                          size: 35,
                        ),
                        const SizedBox(width: 15),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '$currentCloud%',
                              style: const TextStyle(
                                fontWeight: FontWeight.w700, 
                                fontSize: 18
                              ),
                            ),
                            const Text(
                              'Cloud',
                              style: TextStyle(
                                fontWeight: FontWeight.w400, 
                                fontSize: 15
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
            const Padding(
              padding: EdgeInsets.only(left: 20, bottom: 10),
              child: Text(
                'Next 7 Days',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(
              height: size.height * 0.8,
              child: ListView.builder(
                itemCount: dailyForecasts!.length,
                itemBuilder: (context, index) {
                  int maxTemperature = dailyForecasts[index]['day']['maxtemp_c'].round().toInt();
                  int minTemperature = dailyForecasts[index]['day']['mintemp_c'].round().toInt();
                  String weatherStatus = dailyForecasts[index]['day']['condition']['text'];
                  var date = DateFormat('MMMMEEEEd').format(DateTime.parse(dailyForecasts[index]["date"]));

                  return Container(
                    margin: const EdgeInsets.only(left: 20, right: 20, top: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.white),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          blurRadius: 7,
                          offset: const Offset(0, 3),
                        )
                      ],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                date,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold
                                ),
                              ),
                              const SizedBox(height: 5,),
                              Row(
                                children: [
                                  Icon(
                                    MapString.mapStringToIcon(weatherStatus),
                                    color: Colors.blue,
                                    size: 30,
                                  ),
                                  const SizedBox(width: 7),
                                  Text(
                                    weatherStatus,
                                    style: const TextStyle(
                                      fontSize: 18,
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Text(
                                '$maxTemperature°C',
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold
                                ),
                              ),
                              const SizedBox(width: 7,),
                              Text(
                                '$minTemperature°C',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 20
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}