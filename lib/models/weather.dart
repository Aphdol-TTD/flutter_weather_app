class Weather {
  final String temp;
  final String feelsLike;
  final String low;
  final String high;
  final String description;
  final String wind;
  final String clouds;


  Weather({ this.temp="",  this.feelsLike="",  this.low="" , this.high="" , this.description="" , this.wind="" , this.clouds=""});

  factory Weather.fromJson(Map<String, dynamic> json) {

    return Weather(
      temp: json['main'] ['temp'].toString(),
      feelsLike: json['main'] ['temp'].toString(),
      low: json['main'] ['temp'].toString(),
      high: json['main'] ['temp'].toString(),
      wind: json['main'] ['temp'].toString(),
      clouds: json['main'] ['temp'].toString(),
      description: json['weather'][0]['description'],
    );
  }
}
