import 'dart:convert';
import 'dart:io';

import 'package:bg_location_task/location_track_screen.dart';
import 'package:bg_location_task/preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_geolocation/flutter_background_geolocation.dart'
    as bg;

@pragma('vm:entry-point')
void backgroundGeolocationHeadlessTask(bg.HeadlessEvent headlessEvent) async {
  await preferences.init();
  switch (headlessEvent.name) {
    case bg.Event.LOCATION:
      bg.Location location = headlessEvent.event;
      List<String> tempList = [];
      tempList
          .addAll(preferences.getList(SharedPreference.LocationTrack) ?? []);
      tempList.add(json.encode(location.toMap()));
      await preferences.putList(SharedPreference.LocationTrack, tempList);
      break;
  }
}

JsonEncoder encoder = const JsonEncoder.withIndent('     ');

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await preferences.init();
  runApp(const MyApp());
  bg.BackgroundGeolocation.registerHeadlessTask(
      backgroundGeolocationHeadlessTask);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with WidgetsBindingObserver {
  late bool _enabled;

  late String _content;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _enabled = false;
    _content = '';
    bg.BackgroundGeolocation.onLocation(
        _onLocation, (bg.LocationError error) {});
    bg.BackgroundGeolocation.onProviderChange(_onProviderChange);
    bg.BackgroundGeolocation.ready(bg.Config(
            desiredAccuracy: bg.Config.DESIRED_ACCURACY_HIGH,
            distanceFilter: 10.0,
            stopOnTerminate: false,
            startOnBoot: true,
            debug: Platform.isAndroid,
            enableHeadless: true,
            preventSuspend: true,
            disableElasticity: true,
            stopOnStationary: false,
            logLevel: bg.Config.LOG_LEVEL_VERBOSE,
            notificationPriority: 0,
            showsBackgroundLocationIndicator: false,
            reset: true))
        .then((bg.State state) {
      setState(() {
        _enabled = state.enabled;
      });
      _onClickChangePace();
    });
  }

  AppLifecycleState? _notification;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    setState(() {
      _notification = state;
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  void _onClickEnable(enabled) {
    if (enabled) {
      bg.BackgroundGeolocation.start().then((bg.State state) {
        _onClickChangePace();
        setState(() {
          _enabled = state.enabled;
        });
      });
    } else {
      bg.BackgroundGeolocation.stop().then((bg.State state) {
        _onClickChangePace();
        bg.BackgroundGeolocation.setOdometer(0.0);
        setState(() {
          _enabled = state.enabled;
        });
      });
    }
  }

  void _onClickChangePace() {
    bg.BackgroundGeolocation.changePace(true)
        .then((bool isMoving) {})
        .catchError((e) {});
  }

  void _onLocation(bg.Location location) {
    try {
      if (Platform.isIOS && _notification == AppLifecycleState.paused) {
        List<String> tempList = [];
        tempList
            .addAll(preferences.getList(SharedPreference.LocationTrack) ?? []);
        tempList.add(json.encode(location.toMap()));
        preferences.putList(SharedPreference.LocationTrack, tempList);
      }
      setState(() {
        _content = encoder.convert(location.toMap());
      });
    } catch (e) {
      e;
    }
  }

  void _onProviderChange(bg.ProviderChangeEvent event) {
    setState(() {
      _content = encoder.convert(event.toMap());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text(
            'Background Geolocation',
          ),
          actions: <Widget>[
            Switch(
              value: _enabled,
              onChanged: _onClickEnable,
            ),
          ]),
      body: SingleChildScrollView(child: Text(_content)),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute<void>(
              builder: (_) => const LocationTrackScreen(),
            ),
          );
        },
        child: const Icon(Icons.arrow_forward),
      ),
    );
  }
}
