import 'dart:async';
import 'dart:io';

import 'package:appfinallproject/nasa.dart';
import 'package:flutter/material.dart';
import 'package:appfinallproject/marsobject.dart';
import 'package:appfinallproject/nasa_model.dart';
import 'package:flutter/services.dart';
import 'package:sensors_plus/sensors_plus.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
    [
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ],
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'New inovative app'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  AccelerometerEvent? _accelerometerEvent;
  static const Duration _ignoreDuration = Duration(milliseconds: 20);
  DateTime? _accelerometerUpdateTime;
  DateTime timeInterval = DateTime.now();
  int? _accelerometerLastInterval;
  final _streamSubscriptions = <StreamSubscription<dynamic>>[];
  Duration sensorInterval = SensorInterval.uiInterval;
  bool isMobile = (Platform.isIOS || Platform.isAndroid);
  int length = 0;
  bool initdata = false;
  bool gesture = true;

  bool fetchingData = false;
  Future<Nasa>? futureNasa;

  void FecthNasaData() {
    setState(() {
      futureNasa = nasaTest()
          .getData(rover, pickedCameraList[cameraCounter], sol.toInt());
      fetchingData = true;
      imagecounter = 0;
      length = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            if(isMobile)
            ElevatedButton(
                onPressed: () => {gesture = !gesture,
                 print(gesture)},
                child: Text("USE GESTURE: $gesture")),
            DropdownMenu<String>(
              initialSelection: rovers.first,
              requestFocusOnTap: true,
              onSelected: (String? value) {
                setState(() {
                  rover = value!;
                  cameraCounter = 0;
                  if (value == "curiosity") {
                    pickedCameraList = curiosityCameras;
                  }
                  if (value == "opportunity") {
                    pickedCameraList = opportunityCameras;
                  }
                  if (value == "spirt") {
                    pickedCameraList = spiritCameras;
                  }
                });
              },
              dropdownMenuEntries:
                  rovers.map<DropdownMenuEntry<String>>((String value) {
                return DropdownMenuEntry<String>(value: value, label: value);
              }).toList(),
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 25),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: const CircleBorder(),
                    ),
                    onPressed: () => {
                      setState(() {
                        if (cameraCounter - 1 < 0) {
                          cameraCounter = pickedCameraList.length - 1;
                        } else {
                          cameraCounter--;
                        }
                      })
                    },
                    child: const Icon(Icons.arrow_back),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 25),
                    child: Text(
                      pickedCameraList[cameraCounter].toUpperCase(),
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: const CircleBorder(),
                    ),
                    onPressed: () => {
                      setState(() {
                        if (cameraCounter + 1 > pickedCameraList.length - 1) {
                          cameraCounter = 0;
                        } else {
                          cameraCounter++;
                        }
                      }),
                    },
                    child: const Icon(Icons.arrow_forward),
                  ),
                ],
              ),
            ),
            Text(sol.toInt().toString()),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: const CircleBorder(),
                  ),
                  onPressed: () => {
                    setState(() {
                      sol -= 10;
                    })
                  },
                  child: const Icon(Icons.remove),
                ),
                Container(
                  width: MediaQuery.of(context).size.width / 3,
                  child: Slider(
                      value: sol,
                      max: 1000,
                      divisions: 100,
                      onChanged: (double value) => {
                            setState(() {
                              sol = value;
                            })
                          }),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: const CircleBorder(),
                  ),
                  onPressed: () => {
                    setState(() {
                      sol += 10;
                    })
                  },
                  child: const Icon(Icons.add),
                ),
              ],
            ),
            Center(
              child: FutureBuilder(
                future: futureNasa,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data!.list.isNotEmpty) {
                      length = snapshot.data!.list.length - 1;
                    }
                    return SizedBox(
                      height: 1000,
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        children: <Widget>[
                          snapshot.data!.list.isNotEmpty
                              ? Text(
                                  "name: ${snapshot.data!.list[0].rover.name}, landing date: ${snapshot.data!.list[0].rover.landingDate}, Status: ${snapshot.data!.list[0].rover.status}",
                                )
                              : const Text("No data was found :("),
                          snapshot.data!.list.isNotEmpty
                              ? Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        shape: const CircleBorder(),
                                      ),
                                      onPressed: () => {
                                        setState(
                                          () {
                                            if (imagecounter - 1 < 0) {
                                              imagecounter =
                                                  snapshot.data!.list.length -
                                                      1;
                                            } else {
                                              imagecounter--;
                                            }
                                          },
                                        ),
                                      },
                                      child: const Icon(Icons.arrow_back),
                                    ),
                                    Image.network(
                                      width: 500,
                                      height: 500,
                                      snapshot.data!.list[imagecounter].imgSrc,
                                    ),
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        shape: const CircleBorder(),
                                      ),
                                      onPressed: () => {
                                        setState(
                                          () {
                                            if (imagecounter + 1 >
                                                snapshot.data!.list.length -
                                                    1) {
                                              imagecounter = 0;
                                            } else {
                                              imagecounter++;
                                            }
                                          },
                                        ),
                                      },
                                      child: const Icon(Icons.arrow_forward),
                                    ),
                                  ],
                                )
                              : Container()
                        ],
                      ),
                    );
                  } else {
                    if (fetchingData) {
                      return SizedBox(
                          height: MediaQuery.of(context).size.height -
                              (MediaQuery.of(context).padding.top +
                                  kToolbarHeight +
                                  kBottomNavigationBarHeight),
                          child:
                              const Center(child: CircularProgressIndicator()));
                    } else {
                      return Container(
                        height: MediaQuery.of(context).size.height -
                            (MediaQuery.of(context).padding.top +
                                kToolbarHeight +
                                kBottomNavigationBarHeight),
                        child: const Center(
                          child: Text("Fetching data, press button"),
                        ),
                      );
                    }
                  }
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: FecthNasaData,
        tooltip: 'Presse to fecth data',
        child: const Icon(Icons.add),
      ),
    );
  }

  @protected
  @mustCallSuper
  void initState() {
    pickedCameraList = curiosityCameras;
    if (isMobile) {
      _streamSubscriptions.add(
        accelerometerEventStream(samplingPeriod: sensorInterval).listen(
          (AccelerometerEvent event) {
            final now = event.timestamp;
            setState(() {
              _accelerometerEvent = event;
              if (_accelerometerUpdateTime != null) {
                final interval = now.difference(_accelerometerUpdateTime!);
                if (interval > _ignoreDuration) {
                  _accelerometerLastInterval = interval.inMilliseconds;
                }
              }
              if (_accelerometerEvent!.y > 5.0 &&
                  timeBetween(timeInterval, now) > 1 &&
                  !initdata && gesture) {
                FecthNasaData();
                timeInterval = now;
                initdata = true;
              }
              if (_accelerometerEvent!.y < 5.0 &&
                  timeBetween(timeInterval, now) > 1 &&
                  initdata && gesture) {
                FecthNasaData();
                timeInterval = now;
              }

              if (_accelerometerEvent!.x > 5.0 &&
                  timeBetween(timeInterval, now) > 1 && gesture) {
                if (imagecounter - 1 < 0) {
                  imagecounter = length;
                } else {
                  imagecounter--;
                }
                timeInterval = now;
              }
              if (_accelerometerEvent!.x < -5.0 &&
                  timeBetween(timeInterval, now) > 1 && gesture) {
                if (imagecounter + 1 > length) {
                  imagecounter = 0;
                } else {
                  imagecounter++;
                }
                timeInterval = now;
              }
            });
            _accelerometerUpdateTime = now;
          },
          onError: (e) {
            showDialog(
                context: context,
                builder: (context) {
                  return const AlertDialog(
                    title: Text("Sensor Not Found"),
                    content: Text(
                        "It seems that your device doesn't support Accelerometer Sensor"),
                  );
                });
          },
          cancelOnError: true,
        ),
      );
    }
  }

  double timeBetween(DateTime from, DateTime to) {
    from = DateTime(from.year, from.month, from.day, from.hour, from.minute,
        from.second, from.millisecond);
    to = DateTime(to.year, to.month, to.day, to.hour, to.minute, to.second,
        to.microsecond);
    return (to.difference(from).inSeconds).toDouble();
  }
}
