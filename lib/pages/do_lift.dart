import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:weight_plate_manager/config/router.dart';
import 'package:weight_plate_manager/models/lift_history.dart';
import 'package:weight_plate_manager/services/lift_history_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DoLift extends StatefulWidget {
  final String selectedBarbell;
  final double barbellWeight;
  final List<Map<String, dynamic>> selectedPlates;
  final bool isMetric;

  const DoLift({
    Key? key,
    required this.selectedBarbell,
    required this.barbellWeight,
    required this.selectedPlates,
    required this.isMetric,
  }) : super(key: key);

  @override
  State<DoLift> createState() => _DoLiftState();
}

class _DoLiftState extends State<DoLift> {
  bool? _liftResult; // null = in progress, true = success, false = failed

  double _convertWeight(double weight) {
    return widget.isMetric ? weight : weight * 2.20462;
  }

  double _calculateTotalWeight() {
    double totalPlatesWeight = 0.0;
    for (var plate in widget.selectedPlates) {
      totalPlatesWeight += (plate["weight"] as double) * 2;
    }
    return _convertWeight(widget.barbellWeight) + totalPlatesWeight;
  }

  String _generateBarbellSVG() {
    final int svgWidth = 300;
    final int svgHeight = 100;
    final int barY = 50;
    final int barHeight = 5;
    final int sleeveWidth = 12;
    final int sleeveHeight = 20;
    final int leftSleeveX = 60;
    final int rightSleeveX = svgWidth - leftSleeveX - sleeveWidth;

    String svg =
        '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 $svgWidth $svgHeight">';

    // Draw bar with gradient
    svg +=
        '<defs><linearGradient id="barGradient" x1="0%" y1="0%" x2="100%" y2="0%"><stop offset="0%" style="stop-color:#666;stop-opacity:1" /><stop offset="50%" style="stop-color:#888;stop-opacity:1" /><stop offset="100%" style="stop-color:#666;stop-opacity:1" /></linearGradient></defs>';
    svg +=
        '<rect x="0" y="$barY" width="$svgWidth" height="$barHeight" fill="url(#barGradient)"/>';

    // Draw sleeves with gradient
    svg +=
        '<defs><linearGradient id="sleeveGradient" x1="0%" y1="0%" x2="100%" y2="0%"><stop offset="0%" style="stop-color:#444;stop-opacity:1" /><stop offset="100%" style="stop-color:#666;stop-opacity:1" /></linearGradient></defs>';
    svg +=
        '<rect x="$leftSleeveX" y="${barY - sleeveHeight / 2}" width="$sleeveWidth" height="$sleeveHeight" fill="url(#sleeveGradient)" rx="2" stroke="black" stroke-width="1"/>';
    svg +=
        '<rect x="$rightSleeveX" y="${barY - sleeveHeight / 2}" width="$sleeveWidth" height="$sleeveHeight" fill="url(#sleeveGradient)" rx="2" stroke="black" stroke-width="1"/>';

    int leftOffset = leftSleeveX - widget.selectedPlates.fold(0, (sum, plate) => sum + (plate["width"] as int) ~/ 2.5);
    for (var plate in widget.selectedPlates) {
      int plateWidth = (plate["width"] as int) ~/ 2.5;
      int plateHeight = ((plate["height"] as int) * 1.5).toInt();
      String plateColor = plate["color"] as String;

      svg +=
          '<filter id="plateShadow"><feDropShadow dx="0" dy="2" stdDeviation="2" flood-opacity="0.3"/></filter>';
      svg +=
          '<rect x="$leftOffset" y="${barY - plateHeight / 2}" width="$plateWidth" height="$plateHeight" fill="$plateColor" rx="2" stroke="black" stroke-width="1" filter="url(#plateShadow)"/>';
      leftOffset += plateWidth;
    }

    int rightOffset = rightSleeveX + sleeveWidth;
    for (var plate in widget.selectedPlates.reversed) {
      int plateWidth = (plate["width"] as int) ~/ 2.5;
      int plateHeight = ((plate["height"] as int) * 1.5).toInt();
      String plateColor = plate["color"] as String;

      svg +=
          '<rect x="$rightOffset" y="${barY - plateHeight / 2}" width="$plateWidth" height="$plateHeight" fill="$plateColor" rx="2" stroke="black" stroke-width="1" filter="url(#plateShadow)"/>';
      rightOffset += plateWidth;
    }

    svg += '</svg>';
    return svg;
  }

  void _recordLift(bool success) async {
    setState(() {
      _liftResult = success;
    });

    final liftHistory = LiftHistory(
      barbellType: widget.selectedBarbell,
      totalWeight: _calculateTotalWeight(),
      isMetric: widget.isMetric,
      plates: widget.selectedPlates,
      timestamp: DateTime.now(),
      isSuccess: success,
    );

    final prefs = await SharedPreferences.getInstance();
    await LiftHistoryService(prefs).addLift(liftHistory);
    
    if (mounted) {
      Navigator.pop(context);
      router.push('/workoutlog');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        backgroundColor: Colors.grey[850],
        title: const Text('Lift in Progress', style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.grey[900]!,
              Colors.black,
              Colors.grey[900]!,
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.grey[850],
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      SvgPicture.string(
                        _generateBarbellSVG(),
                        height: 150,
                        fit: BoxFit.contain,
                      ),
                      const SizedBox(height: 20),
                      Text(
                        widget.selectedBarbell,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Total Weight: ${_calculateTotalWeight().toStringAsFixed(1)} ${widget.isMetric ? 'kg' : 'lbs'}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
                if (_liftResult == null) ...[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () => _recordLift(true),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 30,
                            vertical: 15,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          elevation: 5,
                          shadowColor: Colors.green.withOpacity(0.5),
                        ),
                        child: const Text(
                          "Successful Lift",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                      ElevatedButton(
                        onPressed: () => _recordLift(false),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.redAccent,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 30,
                            vertical: 15,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          elevation: 5,
                          shadowColor: Colors.redAccent.withOpacity(0.5),
                        ),
                        child: const Text(
                          "Failed Lift",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}