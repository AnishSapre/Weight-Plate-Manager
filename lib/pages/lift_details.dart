import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:weight_plate_manager/pages/do_lift.dart';

class LiftDetails extends StatefulWidget {
  final String selectedBarbell;
  final bool initialIsMetric;
  final double barbellWeight;

  const LiftDetails({
    Key? key,
    required this.selectedBarbell,
    this.initialIsMetric = true,
    required this.barbellWeight,
  }) : super(key: key);

  @override
  _LiftDetailsState createState() => _LiftDetailsState();
}

class _LiftDetailsState extends State<LiftDetails> {
  List<Map<String, dynamic>> selectedPlates = [];
  int _currentIndex = 0;
  late bool _isMetric;
  final List<Map<String, dynamic>> availablePlates = [
    {
      "asset": "assets/images/55lbs.svg",
      "name": "55 lbs",
      "weight": 25.0,
      "color": "#FF5252",
      "width": 11,
      "height": 54,
    },
    {
      "asset": "assets/images/45lbs.svg",
      "name": "45 lbs",
      "weight": 20.0,
      "color": "#2196F3",
      "width": 10,
      "height": 50,
    },
    {
      "asset": "assets/images/35lbs.svg",
      "name": "35 lbs",
      "weight": 15.0,
      "color": "#FFC107",
      "width": 9,
      "height": 46,
    },
    {
      "asset": "assets/images/25lbs.svg",
      "name": "25 lbs",
      "weight": 10.0,
      "color": "#4CAF50",
      "width": 8,
      "height": 42,
    },
    {
      "asset": "assets/images/10lbs.svg",
      "name": "10 lbs",
      "weight": 5.0,
      "color": "#9C27B0",
      "width": 7,
      "height": 38,
    },
    {
      "asset": "assets/images/5lbs.svg",
      "name": "5 lbs",
      "weight": 2.5,
      "color": "#607D8B",
      "width": 6,
      "height": 34,
    },
    {
      "asset": "assets/images/2.5lbs.svg",
      "name": "2.5 lbs",
      "weight": 1.25,
      "color": "#795548",
      "width": 5,
      "height": 30,
    },
  ];

  // Add visual feedback for plate selection
  bool _isAddingPlate = false;
  Map<String, dynamic>? _currentlyAddingPlate;

  @override
  void initState() {
    super.initState();
    _isMetric = widget.initialIsMetric;
  }

  void _toggleUnit() {
    setState(() {
      _isMetric = !_isMetric;
    });
  }

  double _calculateTotalWeight() {
    double totalPlatesWeight = 0.0;
    for (var plate in selectedPlates) {
      totalPlatesWeight += (plate["weight"] as double) * 2;
    }
    return _convertWeight(widget.barbellWeight) + totalPlatesWeight;
  }

  double _convertWeight(double weight) {
    return _isMetric ? weight : weight * 2.20462;
  }

  String _formatWeight(double weight) {
    return weight.toStringAsFixed(1);
  }

  void _selectPlate(Map<String, dynamic> plateData) {
    setState(() {
      selectedPlates.add(Map<String, dynamic>.from(plateData));
      selectedPlates.sort(
        (a, b) => (a["width"] as int).compareTo(b["width"] as int),
      );
    });
  }

  void _removePlate() {
    if (selectedPlates.isNotEmpty) {
      setState(() {
        _isAddingPlate = true;
      });

      Future.delayed(const Duration(milliseconds: 0), () {
        setState(() {
          selectedPlates.removeAt(0);
          _isAddingPlate = false;
        });
      });
    }
  }

  String _generateBarbellSVG() {
    // Barbell dimensions
    final int svgWidth = 300;
    final int svgHeight = 100;
    final int barY = 50;
    final int barHeight = 5;
    final int sleeveWidth = 12;
    final int sleeveHeight = 20;

    // Starting positions for plates
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

    // Left side plates
    int leftOffset =
        leftSleeveX -
        selectedPlates.fold(
          0,
          (sum, plate) => sum + (plate["width"] as int) ~/ 2.5,
        );
    for (var plate in selectedPlates) {
      int plateWidth = (plate["width"] as int) ~/ 2.5;
      int plateHeight = ((plate["height"] as int) * 1.5).toInt();
      String plateColor = plate["color"] as String;

      // Add shadow effect
      svg +=
          '<filter id="plateShadow"><feDropShadow dx="0" dy="2" stdDeviation="2" flood-opacity="0.3"/></filter>';
      svg +=
          '<rect x="$leftOffset" y="${barY - plateHeight / 2}" width="$plateWidth" height="$plateHeight" fill="$plateColor" rx="2" stroke="black" stroke-width="1" filter="url(#plateShadow)"/>';
      leftOffset += plateWidth;
    }

    // Right side plates
    int rightOffset = rightSleeveX + sleeveWidth;
    for (var plate in selectedPlates.reversed) {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        backgroundColor: Colors.grey[850],
        title: const Text('Do Lift', style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.tealAccent),
            ),
            child: TextButton(
              onPressed: _toggleUnit,
              child: Text(
                _isMetric ? 'lbs' : 'kg',
                style: const TextStyle(
                  color: Colors.tealAccent,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                SvgPicture.string(
                  _generateBarbellSVG(),
                  height: 150,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 10),
                Text(
                  widget.selectedBarbell,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  'Total Weight: ${_formatWeight(_calculateTotalWeight())} ${_isMetric ? 'kg' : 'lbs'}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Select Plates',
                        style: TextStyle(color: Colors.white70, fontSize: 18),
                      ),
                      SizedBox(width: 10),
                      Icon(Icons.touch_app, color: Colors.white60, size: 18),
                    ],
                  ),
                  Expanded(
                    child: CarouselSlider(
                      options: CarouselOptions(
                        height: 180,
                        enableInfiniteScroll: false,
                        viewportFraction: 0.5,
                        onPageChanged: (index, reason) {
                          setState(() {
                            _currentIndex = index;
                          });
                        },
                      ),
                      items:
                          availablePlates.map((plateData) {
                            String displayWeight =
                                _isMetric
                                    ? '${_formatWeight(plateData["weight"] as double)} kg'
                                    : '${_formatWeight((plateData["weight"] as double) * 2.20462)} lbs';

                            return GestureDetector(
                              onTap: () => _selectPlate(plateData),
                              child: AnimatedContainer(
                                duration: Duration(milliseconds: 300),
                                margin: EdgeInsets.symmetric(horizontal: 5),
                                decoration: BoxDecoration(
                                  color: Colors.grey[800],
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: Color(
                                      int.parse(
                                            (plateData["color"] as String)
                                                .substring(1),
                                            radix: 16,
                                          ) |
                                          0xFF000000,
                                    ),
                                    width:
                                        _currentlyAddingPlate == plateData
                                            ? 3
                                            : 2,
                                  ),
                          
                                ),
                                padding: EdgeInsets.all(10),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      height: 80,
                                      child: SvgPicture.asset(
                                        plateData["asset"] as String,
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    Text(
                                      displayWeight,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: 5),
                                    Text(
                                      "Tap to add",
                                      style: TextStyle(
                                        color: Colors.white54,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                    ),
                  ),
                ],
              ),
            ),
          ),

          Container(
            padding: EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: selectedPlates.isNotEmpty ? _removePlate : null,
                  icon: Icon(Icons.remove_circle),
                  label: Text("Remove Plate"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red[700],
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed:
                      selectedPlates.isNotEmpty
                          ? () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) => DoLift(
                                      selectedBarbell: widget.selectedBarbell,
                                      barbellWeight: widget.barbellWeight,
                                      selectedPlates: selectedPlates,
                                      isMetric: _isMetric,
                                    ),
                              ),
                            );
                          }
                          : null,
                  icon: Icon(Icons.fitness_center),
                  label: Text("Start Lift"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
