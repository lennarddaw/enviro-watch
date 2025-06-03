import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:lottie/lottie.dart';

import 'login_or_registered_page.dart';

class HomePage extends StatefulWidget {
  final String username;
  const HomePage({Key? key, required this.username}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Stream<DatabaseEvent> _sensorStream;

  @override
  void initState() { //vor dem rendern
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    _sensorStream = FirebaseDatabase.instance.ref('sensors').onValue;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildGraph(String title, List<FlSpot> spots, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            title,
            style: const TextStyle(color: Colors.white, fontSize: 18),
          ),
        ),
        SizedBox(
          height: 200,
          child: LineChart(
            LineChartData(
              gridData: const FlGridData(show: true),
              titlesData: const FlTitlesData(show: true),
              borderData: FlBorderData(show: true),
              lineBarsData: [
                LineChartBarData(
                  spots: spots,
                  isCurved: true,
                  color: color,
                  barWidth: 4,
                  isStrokeCapRound: true,
                  belowBarData: BarAreaData(show: false),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  List<FlSpot> _getSpots(String type, List<Map<String, dynamic>> dataList) {
    return List<FlSpot>.generate(
      dataList.length,
      (index) {
        double value = dataList[index][type]?.toDouble() ?? 0.0;
        return FlSpot(index.toDouble(), value);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        toolbarHeight: 50,
        leading: IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const HomePage(username: '',)),
            );
          },
          icon: Lottie.asset(
            'lib/assets/svg/Archive.json',
            controller: _controller,
            onLoaded: (composition) {
              _controller.forward();
            },
            width: 100,
            height: 100,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginOrRegisterPage()),
              );
            },
            icon: const Icon(Icons.logout_outlined),
          )
        ],
      ),
      body: StreamBuilder<DatabaseEvent>(
        stream: _sensorStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasData && snapshot.data!.snapshot.value != null) {
            final data = snapshot.data!.snapshot.value as Map<dynamic, dynamic>;
            List<Map<String, dynamic>> sensorDataList = [];


            data.forEach((key, value) {
              if (value is Map<dynamic, dynamic>) {
                sensorDataList.add({
                  'timestamp': key,
                  'temperature': value['temperature'] ?? 0,
                  'humidity': value['humidity'] ?? 0,
                  'pressure': value['pressure'] ?? 0,
                  'mq135AnalogValue': value['mq135AnalogValue'] ?? 0,
                  'mq135DigitalValue': value['mq135DigitalValue'] ?? 0,
                });
              }
            });

            sensorDataList.sort((a, b) => (a['timestamp']).compareTo(b['timestamp']));
            if (sensorDataList.length > 10) {
              sensorDataList = sensorDataList.sublist(sensorDataList.length - 10);
            }

            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        'Welcome ${widget.username.split('@').first}',
                        textAlign: TextAlign.left,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontFamily: 'Abnes',
                        ),
                      ),
                    ),
                    // Temperatur-Graph
                    _buildGraph("Temperature", _getSpots("temperature", sensorDataList), Colors.red),
                    // Luftfeuchtigkeits-Graph
                    _buildGraph("Humidity", _getSpots("humidity", sensorDataList), Colors.blue),
                    // Luftdruck-Graph
                    _buildGraph("Pressure", _getSpots("pressure", sensorDataList), Colors.green),
                    // MQ-135 Analog-Graph
                    _buildGraph("MQ-135 Analog Value", _getSpots("mq135AnalogValue", sensorDataList), Colors.orange),
                    // MQ-135 Digital-Graph
                    _buildGraph("MQ-135 Digital Value", _getSpots("mq135DigitalValue", sensorDataList), Colors.purple),
                  ],
                ),
              ),
            );
          } else {
            return const Center(
              child: Text('Keine Daten verfügbar', style: TextStyle(color: Colors.white)),
            );
          }
        },
      ),
    );
  }
}
