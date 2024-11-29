import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:weather_app/hourly_forecast_item.dart';

import 'Additional_info_item.dart';
class WeatherScreen extends StatelessWidget {
  const WeatherScreen({super.key});

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
          IconButton(onPressed: (){}, icon: const Icon(Icons.refresh),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [

            //main card
            SizedBox(

              width: double.infinity,  //Take maximum amount of width possible
              child:  Card(
                elevation: 10,
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
                      child: const Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            Text('300 ° F',
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,

                            ),
                            ),
                            SizedBox(height: 16),
                            Icon(
                              Icons.cloud,
                              size: 64,
                            ),
                            SizedBox(height: 16),
                            Text(
                              'Rain',
                              style: TextStyle(
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
                'Weather Forecast',
                  style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,

                ),
              ),
            // weather forecast card-1
            const SizedBox(height: 8),
            const SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                   HourlyForecastItem(),
                    HourlyForecastItem(),
                   HourlyForecastItem(),
                  HourlyForecastItem(),
                  HourlyForecastItem(),
                  HourlyForecastItem(),
                ],
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
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                AdditionalInfoItem(),
                AdditionalInfoItem(),
                AdditionalInfoItem(),
              ],
            )


          ],
        ),
      ),

    );
  }
}

