import 'dart:async';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int ms = 0, s = 0, m = 0;
  int lapMs = 0, lapS = 0, lapM = 0;
  String digMs = "00", digSec = "00", digMin = "00";
  String lapDigMs = "00", lapDigSec = "00", lapDigMin = "00";
  Timer? timer;
  bool started = false;

  List<Map<String, String>> Laps = [];

  // Stop Function
  void stop() {
    timer!.cancel();
    setState(() {
      started = false;
    });
  }

  // Reset Function
  void reset() {
    timer?.cancel();
    setState(() {
      ms = 0;
      s = 0;
      m = 0;
      lapMs = 0;
      lapS = 0;
      lapM = 0;
      digMs = "00";
      digSec = "00";
      digMin = "00";
      lapDigMs = "00";
      lapDigSec = "00";
      lapDigMin = "00";
      Laps.clear();
      started = false;
    });
  }

  // Adding Laps Function
  void addLap() {
    String lapTime = "$lapDigMin:$lapDigSec.$lapDigMs";
    String overallTime = "$digMin:$digSec.$digMs";

    setState(() {
      Laps.insert(0, { // Insert the new lap at the beginning of the list
        "lapCount": (Laps.length + 1).toString(),
        "lapTime": lapTime,
        "overallTime": overallTime,
      });

      lapMs = 0;
      lapS = 0;
      lapM = 0;
      lapDigMs = "00";
      lapDigSec = "00";
      lapDigMin = "00";
    });
  }

  // Start Function
  void start() {
    started = true;
    timer = Timer.periodic(Duration(milliseconds: 10), (timer) {
      int localMs = ms + 10;
      int localSec = s;
      int localMin = m;

      int localLapMs = lapMs + 10;
      int localLapSec = lapS;
      int localLapMin = lapM;

      if (localMs >= 1000) {
        localSec++;
        localMs = 0;
      }
      if (localSec >= 60) {
        localMin++;
        localSec = 0;
      }

      if (localLapMs >= 1000) {
        localLapSec++;
        localLapMs = 0;
      }
      if (localLapSec >= 60) {
        localLapMin++;
        localLapSec = 0;
      }

      setState(() {
        ms = localMs;
        s = localSec;
        m = localMin;

        lapMs = localLapMs;
        lapS = localLapSec;
        lapM = localLapMin;

        digMs = ((ms ~/ 10) >= 10) ? "${ms ~/ 10}" : "0${ms ~/ 10}";
        digSec = (s >= 10) ? "$s" : "0$s";
        digMin = (m >= 10) ? "$m" : "0$m";

        lapDigMs = ((lapMs ~/ 10) >= 10) ? "${lapMs ~/ 10}" : "0${lapMs ~/ 10}";
        lapDigSec = (lapS >= 10) ? "$lapS" : "0$lapS";
        lapDigMin = (lapM >= 10) ? "$lapM" : "0$lapM";
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF1C2657),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: Text(
                  'StopWatch App',
                  style: TextStyle(
                    fontSize: 28.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  width: 250,
                  height: 250,
                  decoration: BoxDecoration(
                    color: Color(0xFF313E66),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      '$digMin:$digSec:$digMs',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 45.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  height: 400.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Column(
                    children: [
                      if (Laps.isNotEmpty)
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Lap",
                                    style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white.withOpacity(0.7), // Dimmer color
                                    ),
                                  ),
                                  Text(
                                    "          Lap Time",
                                    style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white.withOpacity(0.7), // Dimmer color
                                    ),
                                  ),
                                  Text(
                                    "Overall Time",
                                    style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white.withOpacity(0.7), // Dimmer color
                                    ),
                                  ),
                                ],
                              ),
                              Divider(color: Colors.white.withOpacity(0.5)), // Line below the heading
                            ],
                          ),
                        ),
                      Expanded(
                        child: ListView.builder(
                          itemCount: Laps.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Lap ${Laps[index]['lapCount']}",
                                    style: TextStyle(
                                      fontSize: 16.0,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    Laps[index]['lapTime']!,
                                    style: TextStyle(
                                      fontSize: 16.0,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    Laps[index]['overallTime']!,
                                    style: TextStyle(
                                      fontSize: 16.0,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20.0),
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0, left: 8.0, right: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: RawMaterialButton(
                        onPressed: () {
                          (!started) ? start() : stop();
                        },
                        shape: StadiumBorder(
                          side: BorderSide(color: Colors.blue),
                        ),
                        child: Text(
                          (!started) ? "Start" : "Stop",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    SizedBox(width: 8.0),
                    IconButton(
                      onPressed: started ? addLap : null,
                      icon: Icon(
                        Icons.flag,
                        color: started ? Colors.white : Colors.white.withOpacity(0.5),
                      ),
                    ),
                    SizedBox(width: 8.0),
                    Expanded(
                      child: RawMaterialButton(
                        onPressed: (ms == 0 && s == 0 && m == 0) ? null : reset,
                        fillColor: (ms == 0 && s == 0 && m == 0) ? Colors.blue.withOpacity(0.5) : Colors.blue,
                        shape: StadiumBorder(),
                        child: Text(
                          'Restart',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
