class Weather {
  int? id;
  String? cityName;
  String? weatherCondition;
  double? temperature;

  Weather({
    this.id, 
    required this.cityName, 
    required this.weatherCondition, 
    required this.temperature, 
    });

  factory Weather.fromMap(Map<String, dynamic> json) => Weather(
        id: json['id'],
        cityName: json['cityName'],
        weatherCondition: json['weatherCondition'],
        temperature: json['temperature'],
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'cityName': cityName,
        'weatherCondition': weatherCondition,
        'temperature': temperature,
      };
}
