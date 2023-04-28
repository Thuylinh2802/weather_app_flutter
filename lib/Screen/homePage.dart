import 'dart:convert';
import 'package:flutter_geocoder/geocoder.dart';
import 'package:weather_app_flutter/Screen/searchPage.dart';
import 'package:weather_app_flutter/Screen/weeklyWeatherPage.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import '../Helper/utils.dart';
import 'package:diacritic/diacritic.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController _textController = TextEditingController();

  static String API_Key = '1a68389fd8154e089e6153255233101';
  String searchWeatherAPI = 'https://api.weatherapi.com/v1/forecast.json?key=$API_Key&q=';

  String location = 'london';
  var currentWeather;
  int temperature = 0;
  int maxTemp = 0;
  int minTemp = 0;
  int uvIndex = 0;
  double precipitation = 0.1;
  int aqiIndex = 0;

  String currentWeatherStatus = '';
  String currentDate = '';

  List hourlyWeatherForecast = [];
  List weeklyWeatherForecast = [];

  Future<void> fetchWeatherData(String searchText) async {
    var result = await http.get(Uri.parse('$searchWeatherAPI$searchText&days=7&aqi=no&alerts=no'));
    Map<String, dynamic> weatherData = jsonDecode(result.body);
    location = weatherData['location']['name'];
   
    var aqiSearch = await http.get(Uri.parse('http://api.waqi.info/feed/$location/?token=0cc4deb2e2d13a737a98d776145012fb35ac2efa'));
    Map<String, dynamic> aqiData = jsonDecode(aqiSearch.body);

    currentWeather = weatherData["current"];
    temperature = currentWeather['temp_c'].toInt();
    uvIndex = currentWeather['uv'].toInt();
    precipitation = currentWeather['precip_mm'].toDouble();
    currentWeatherStatus = currentWeather['condition']['text'];
    var parsedDate = DateTime.parse(weatherData['location']["localtime"].substring(0, 10));
    currentDate = DateFormat('MMMMEEEEd').format(parsedDate);
    aqiIndex = aqiData['data']['aqi'];

    weeklyWeatherForecast = weatherData['forecast']['forecastday'];
    hourlyWeatherForecast = weeklyWeatherForecast[0]['hour'];

    maxTemp = weeklyWeatherForecast[0]['day']['maxtemp_c'].toInt();
    minTemp = weeklyWeatherForecast[0]['day']['mintemp_c'].toInt();
    //print(weeklyWeatherForecast.length);
  }

  void getCurrentPosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    final Position currentPosition = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    double latitude = 21.028511;
    double longitude = 105.804817;
    final coordinates = Coordinates(latitude, longitude);
    List<Address> addresses = await Geocoder.local.findAddressesFromCoordinates(coordinates);
    Address first = addresses.first;
    String cityName = removeDiacritics(first.adminArea!);
    fetchWeatherData(cityName);
  }

  @override
  void initState() {
    getCurrentPosition();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.symmetric(
                vertical: 40,
                horizontal: size.width * .05,
              ),
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
              child: TextField(
                onChanged: (searchText) {
                  fetchWeatherData(searchText);
                },
                controller: _textController,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: "Search Location",
                  hintStyle: TextStyle(color: Colors.grey),
                  icon: Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: Icon(
                      Icons.search,
                      color: Colors.blue,
                    ),
                  ),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.location_on_outlined),
                Text(
                  location,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                  ),
                )
              ],
            ),
            const SizedBox(height: 5),
            Text(
              currentDate,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: Colors.grey[700],             
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  MapString.mapStringToIcon(currentWeatherStatus),
                  size: 65,
                  color: Colors.blue,
                ),
                const SizedBox(width: 16),
                Text(
                  '$temperature°C',
                  style: const TextStyle(
                    fontSize: 60,
                    fontWeight: FontWeight.w600,
                  ),
                )
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'H: $maxTemp°C',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(width: 20),
                Text(
                  'L: $minTemp°C',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 5),
            Text(
              currentWeatherStatus,
              style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
            ),
            Container(
              margin: EdgeInsets.symmetric(
                vertical: 20,
                horizontal: MediaQuery.of(context).size.width * .05,
              ),
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
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      const Icon(
                        MdiIcons.weatherRainy,
                        color: Colors.blue,
                        size: 40,
                      ),
                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Precipitation',
                            style: TextStyle(
                              fontWeight: FontWeight.w400, 
                              fontSize: 17
                            ),
                          ),
                          Text(
                            '$precipitation mn',
                            style: const TextStyle(
                              fontWeight: FontWeight.w700, 
                              fontSize: 16
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 5.0),
                    height: 65,
                    child: const VerticalDivider(
                      color: Colors.black,
                      indent: 10,
                      endIndent: 10,
                    ),
                  ),
                  Row(
                    children: [
                      const Icon(
                        MdiIcons.sunWireless,
                        color: Colors.blue,
                        size: 40,
                      ),
                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'UV Index',
                            style: TextStyle(
                              fontWeight: FontWeight.w400, 
                              fontSize: 17
                            ),
                          ),
                          Text(
                            UvIndex.mapUviValueToString(uvi: uvIndex),
                            style: const TextStyle(
                              fontWeight: FontWeight.w700, 
                              fontSize: 16
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Forecast 24 Hours',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => 
                        // WeeklyPage(weeklyWeatherForecast: weeklyWeatherForecast, currentWeather: currentWeather)
                        SearchWeatherList()
                        ),
                      );
                    }, 
                    child: const Text(
                      'Next 7 days',
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: 17,
                      ),
                    ),
                  ) 
                ],
              ),
            ),
            const SizedBox(height: 5),
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10, bottom: 20),
              child: SizedBox(
                height: 160,
                child: ListView.builder(
                  itemCount: hourlyWeatherForecast.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: ((context, index) {
                    int forecastTemperature = hourlyWeatherForecast[index]['temp_c'].toInt();
                    String forecastTime = hourlyWeatherForecast[index]['time'].substring(11, 16);
                    String forecastHour = forecastTime.substring(0, 2);
                    String currentTime = DateFormat('HH:mm:ss').format(DateTime.now());
                    String currentHour = currentTime.substring(0, 2);
                    String forecastWeatherName = hourlyWeatherForecast[index]['condition']['text'];
      
                    return Container(
                      width: 80,
                      margin: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: currentHour == forecastHour ? Colors.blue[300] : Colors.white,
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
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            forecastTime,
                            style: const TextStyle(
                              fontSize: 18,
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Icon(
                            MapString.mapStringToIcon(forecastWeatherName),
                            size: 50,
                            color: Colors.blue,
                          ),
                          Text(
                            '$forecastTemperature°C',
                            style: const TextStyle(
                              fontSize: 20,
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                            ),
                          )
                        ],
                      ),
                    );
                  } )
                ),
              ),
            ),
            SizedBox(
              height: 320,
              child: SizedBox(
                child: SfRadialGauge(
                  title: const GaugeTitle(
                    text: 'Air Quality Index',
                    textStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 22
                    )
                  ),
                  axes: <RadialAxis> [
                    RadialAxis(
                      showTicks: false,
                      showAxisLine: false,
                      showLastLabel: true,
                      labelsPosition: ElementsPosition.outside,
                      startAngle: 180,
                      endAngle: 0,
                      minimum: 0,
                      maximum: 500,
                      axisLabelStyle: const GaugeTextStyle(fontWeight: FontWeight.w700, fontSize: 13),
                      ranges: <GaugeRange> [
                        GaugeRange(
                          startValue: 0, 
                          endValue: 50,
                          color: Colors.green,
                          startWidth: 50,
                          endWidth: 50,
                        ),
                        GaugeRange(
                          startValue: 50, 
                          endValue: 100,
                          color: Colors.yellow,
                          startWidth: 50,
                          endWidth: 50,
                        ),
                        GaugeRange(
                          startValue: 100, 
                          endValue: 150,
                          color: Colors.orange,
                          startWidth: 50,
                          endWidth: 50,
                        ),
                        GaugeRange(
                          startValue: 150, 
                          endValue: 200,
                          color: Colors.red,
                          startWidth: 50,
                          endWidth: 50,
                        ),
                        GaugeRange(
                          startValue: 200, 
                          endValue: 300,
                          color: Colors.pink[900],
                          startWidth: 50,
                          endWidth: 50,
                        ),
                        GaugeRange(
                          startValue: 300, 
                          endValue: 500,
                          color: const Color.fromRGBO(128, 0, 0, 1),
                          startWidth: 50,
                          endWidth: 50,
                        )
                      ],
                      pointers: <GaugePointer> [
                        NeedlePointer(
                          value: aqiIndex.toDouble(),
                        )
                      ],
                      annotations: <GaugeAnnotation> [
                        GaugeAnnotation(
                          widget: Text(
                            aqiIndex.toString(),
                            style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                          ) ,
                          angle: 90,
                          positionFactor: 0.2,
                        ),
                        GaugeAnnotation(
                          widget: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Column(
                                children: [
                                  ClipOval(
                                    child: Container(
                                      color: Colors.green,
                                      width: 20,
                                      height: 20,
                                    ),
                                  ),
                                  const Text(
                                    "Good",
                                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                                  )
                                ],
                              ),
                              Column(
                                children: [
                                  ClipOval(
                                    child: Container(
                                      color: Colors.yellow,
                                      width: 20,
                                      height: 20,
                                    ),
                                  ),
                                  const Text(
                                    "Moderate",
                                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                                  )
                                ],
                              ),
                              Column(
                                children: [
                                  ClipOval(
                                    child: Container(
                                      color: Colors.orange,
                                      width: 20,
                                      height: 20,
                                    ),
                                  ),
                                  const Text(
                                    "Unhealthy\nfor\nSensitive\nGroups",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                                  )
                                ],
                              ),
                              Column(
                                children: [
                                  ClipOval(
                                    child: Container(
                                      color: Colors.red,
                                      width: 20,
                                      height: 20,
                                    ),
                                  ),
                                  const Text(
                                    "Unhealthy",
                                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                                  )
                                ],
                              ),
                              Column(
                                children: [
                                  ClipOval(
                                    child: Container(
                                      color: Colors.pink[900],
                                      width: 20,
                                      height: 20,
                                    ),
                                  ),
                                  const Text(
                                    "Very\nUnhealthy",
                                    maxLines: 2,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                                  )
                                ],
                              ),
                              Column(
                                children: [
                                  ClipOval(
                                    child: Container(
                                      color: const Color.fromRGBO(128, 0, 0, 1),
                                      width: 20,
                                      height: 20,
                                    ),
                                  ),
                                  const Text(
                                    "Hazardeous",
                                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                                  )
                                ],
                              ),
                            ]
                          ) ,
                          angle: 90,
                          positionFactor: 1.4,
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}