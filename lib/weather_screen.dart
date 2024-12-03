import 'dart:convert';
import 'dart:ui';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:weather_app/hourly_forecast_item.dart';
import 'package:weather_app/secrets.dart';
import 'package:weather_icons/weather_icons.dart';
import 'Additional_info_item.dart';
class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});
  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}
class _WeatherScreenState extends State<WeatherScreen> {
late Future<Map<String,dynamic>> weather;
  Future<Map<String,dynamic>> getCurrentWeather() async{
    try {

      String cityName = 'Hyderabad';
      final res = await http.get(
        Uri.parse(
            'https://api.openweathermap.org/data/2.5/forecast?q=$cityName&APPID=$apiKey'
        ),
      );
      
      final data = jsonDecode(res.body);
      if(data['cod'] != '200'){
        throw 'An unexpected error occurred';
      }
      return data;

    } catch(e){
      throw e.toString();
    }

  }
  @override
  void initState() {
    super.initState();
    weather = getCurrentWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        //weather app text
        title: const Text(
          'Weather App',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions:  [
          //refresh button
          IconButton(
            onPressed: (){
              setState(() {
                weather = getCurrentWeather();

              });
            }, icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: FutureBuilder(
        future: weather,
        builder: (context,snapshot)
        //snapshot -> a class that allows to handle all the states
        {

          if(snapshot.connectionState == ConnectionState.waiting){
            return const Center(
                child: CircularProgressIndicator.adaptive(),
            );
          }
          
          if(snapshot.hasError){
            return Center(
                child: Text(snapshot.error.toString()));
          }

          final data = snapshot.data!;
          final currentWeatherData = data['list'][0];
          final currentTemp = currentWeatherData['main']['temp'];
          final currentSky = currentWeatherData['weather'][0]['main'];
          final currentPressure = currentWeatherData['main']['pressure'];
          final currentWindSpeed = currentWeatherData['wind']['speed'];
          final currentHumidity = currentWeatherData['main'] ['humidity'];

          return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            //mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [

              //main card
              SizedBox(

                width: double.infinity,  //Take maximum amount of width possible
                child:  Card(
                  elevation: 10,
                  color: const Color(0xFFFFE4E1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: ClipRect(
                    //for border radius
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      // for blur effect
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                        child:  Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              Text(
                                '$currentTemp K',
                              style: const TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,

                              ),
                              ),
                              const SizedBox(height: 16),
                               Icon(
                              //WeatherIcons.rain,
                                currentSky == 'Clouds' || currentSky == 'Rain'
                                 ?WeatherIcons.cloud
                                 :WeatherIcons.sunrise,
                                size: 64,
                              ),
                              const SizedBox(height: 16),
                               Text(
                                currentSky,
                                style: const TextStyle(
                                  fontSize: 20,
                                ),

                              )

                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              //weather forecast Text
              const Text(
                  'Hourly Forecast',
                    style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,

                  ),
                ),
              // weather forecast card-1
              const SizedBox(height: 8),
            SizedBox(
              height: 130,
              child: ListView.builder(
                itemCount: 5,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context,index){
                  final hourlyForecast = data['list'] [index+1];
                  final hourlySky =
                  data['list'][index+1]['weather'][0]['main'];
                  final hourlyTemp =
                  hourlyForecast['main']['temp'].toString();
                  final time =
                  DateTime.parse(hourlyForecast['dt_txt']);
                      return HourlyForecastItem(
                        hours  : DateFormat.j().format(time),
                        degree: hourlyTemp,
                          icon: hourlySky == 'Clouds' || hourlySky == 'Rain'
                                            ? Icons.cloud
                                            : Icons.sunny,

                      );
                  },
              ),
            ),


            const SizedBox(height: 20),
              const Text(
                'Additional Information',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  AdditionalInfoItem(
                    icon: Icons.water_drop,
                    label: 'Humidity',
                    value: currentHumidity.toString(),
                  ),
                  AdditionalInfoItem(
                    icon: Icons.air,
                    label: 'Wind Speed',
                    value: currentWindSpeed.toString(),
                  ),
                  AdditionalInfoItem(
                    icon: Icons.beach_access,
                    label: 'Pressure',
                    value: currentPressure.toString(),
                  ),
                ],
              )


            ],
          ),
        );
        },
      ),

    );
  }
}

