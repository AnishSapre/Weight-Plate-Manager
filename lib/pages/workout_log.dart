import 'package:flutter/material.dart';
import '../models/lift_history.dart';
import '../services/lift_history_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WorkoutLog extends StatefulWidget {
  const WorkoutLog({super.key});

  @override
  State<WorkoutLog> createState() => _WorkoutLogState();
}

class _WorkoutLogState extends State<WorkoutLog> {
  late LiftHistoryService _historyService;
  List<LiftHistory> _lifts = [];

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    final prefs = await SharedPreferences.getInstance();
    _historyService = LiftHistoryService(prefs);
    final history = await _historyService.getLiftHistory();
    setState(() {
      _lifts = history;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Workout Log'),
        backgroundColor: Colors.black,
        elevation: 0,
        foregroundColor: Colors.white,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.grey[900]!,
              Colors.black,
              Colors.grey[900]!,
            ],
          ),
        ),
        child: _lifts.isEmpty
            ? const Center(
                child: Text(
                  'No lifts recorded yet',
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
              )
            : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: _lifts.length,
                itemBuilder: (context, index) {
                  final lift = _lifts[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 16),
                    elevation: 4,
                    color: Colors.grey[850],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                lift.barbellType,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: lift.isSuccess
                                      ? Colors.green.withOpacity(0.2)
                                      : Colors.red.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  lift.isSuccess ? 'Success' : 'Failed',
                                  style: TextStyle(
                                    color: lift.isSuccess
                                        ? Colors.green
                                        : Colors.red,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '${lift.totalWeight} ${lift.isMetric ? 'kg' : 'lbs'}',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Plates: ${lift.plates.map((p) => '${p['weight']}${lift.isMetric ? 'kg' : 'lbs'}').join(', ')}',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[400],
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '${lift.timestamp.day}/${lift.timestamp.month}/${lift.timestamp.year} ${lift.timestamp.hour}:${lift.timestamp.minute.toString().padLeft(2, '0')}',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[400],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
} 