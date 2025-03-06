import 'dart:convert';

import 'package:bg_location_task/preferences.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class LocationTrackScreen extends StatefulWidget {
  const LocationTrackScreen({super.key});

  @override
  State<LocationTrackScreen> createState() => _LocationTrackScreenState();
}

class _LocationTrackScreenState extends State<LocationTrackScreen> {
  List<dynamic> locationList = [];

  @override
  void initState() {
    fetchLocations();
    super.initState();
  }

  fetchLocations() {
    locationList.clear();
    var tempList = preferences.getList(SharedPreference.LocationTrack) ?? [];
    locationList.addAll(tempList.map((e) => json.decode(e)).toList() ?? []);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await preferences.putList(SharedPreference.LocationTrack, []);
          fetchLocations();
        },
        child: const Icon(Icons.delete_outline_outlined),
      ),
      body: ListView.builder(
        itemCount: locationList.length,
        itemBuilder: (context, index) {
          String? time;
          String? timestamp = locationList[index]["timestamp"];
          if (timestamp != null && timestamp.isNotEmpty) {
            var dateTime = DateTime.parse(timestamp);
            var dateLocal = dateTime.toLocal();
              time = DateFormat("yyyy-MM-dd hh:mm:ss a").format(dateLocal);
          }
          return Padding(
            padding: const EdgeInsets.all(10),
            child: Container(
              color: Colors.blueGrey.withValues(alpha: 0.2),
              child: Column(
                children: [
                  Text(time ?? ""),
                  Text(
                      "Latitude :-  ${locationList[index]["coords"]["latitude"].toString()}"),
                  Text(
                      "Longitude :-  ${locationList[index]["coords"]["longitude"].toString()}"),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
