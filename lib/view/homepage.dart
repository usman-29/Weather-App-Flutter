import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/model/weather.dart';
import 'package:weather_app/model/weather_model.dart';

var dayInfo = DateTime.now();
var dateFormat = DateFormat('EEEE, d MMM, yyyy').format(dayInfo);
WModel data = WModel();

// ignore: must_be_immutable
class HomePage extends StatelessWidget {
  int status = 800;
  HomePage({super.key});

  Future weatherInfo() async {
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    double latitude = position.latitude;
    double longitude = position.longitude;
    var weather = WeatherModel(lat: latitude, lon: longitude);
    try {
      data = await weather.fetchData();
    } catch (e) {
      throw ('Error fetching weather data: $e');
    }

    status = data.id as int;
    return data;
  }

  String getStatus() {
    if (status >= 200 && status <= 232) {
      return 'Thunderstorm';
    } else if ((status >= 300 && status <= 321) ||
        (status >= 500 && status <= 531)) {
      return 'Rain';
    } else if (status >= 600 && status <= 622) {
      return 'Snow';
    } else if (status >= 701 && status <= 781) {
      return 'Fog';
    } else if (status >= 802 && status <= 804) {
      return 'Clouds';
    } else if (status >= 801) {
      return 'Haze';
    } else {
      return 'Clear';
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: FutureBuilder(
            future: weatherInfo(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                return Column(
                  children: [
                    Container(
                      height: size.height * 0.75,
                      width: size.width,
                      padding: const EdgeInsets.only(top: 30),
                      margin: const EdgeInsets.symmetric(
                        horizontal: 10,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(40),
                        gradient: const LinearGradient(
                          colors: [
                            Color(0xff955cd1),
                            Color(0xff3fa2fa),
                          ],
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          stops: [0.2, 0.85],
                        ),
                      ),
                      child: Column(
                        children: [
                          Text(
                            '${data.name}',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.9),
                              fontSize: 35,
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            dateFormat,
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.9),
                              fontSize: 15,
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Image.asset(
                            "assets/${getStatus()}.png",
                            width: size.width * 0.3,
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                            getStatus(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 35,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                            "${data.main?.temp}°",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 75,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  children: [
                                    Image.asset(
                                      "assets/wind.png",
                                      width: size.width * 0.15,
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      "${data.wind?.speed} km/h",
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      "Wind",
                                      style: TextStyle(
                                        color: Colors.white.withOpacity(0.6),
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  children: [
                                    Image.asset(
                                      "assets/humidity.png",
                                      width: size.width * 0.15,
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      "${data.main?.humidity}%",
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      "Humidity",
                                      style: TextStyle(
                                        color: Colors.white.withOpacity(0.6),
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  children: [
                                    Image.asset(
                                      "assets/Clouds.png",
                                      width: size.width * 0.15,
                                    ),
                                    Text(
                                      "${data.clouds?.all}%",
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      "Cloudiness",
                                      style: TextStyle(
                                        color: Colors.white.withOpacity(0.6),
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                  ],
                );
              }
            }),
      ),
    );
  }
}
