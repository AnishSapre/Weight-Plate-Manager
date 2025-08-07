import 'package:flutter/material.dart';
import 'package:weight_plate_manager/config/router.dart';
import 'package:weight_plate_manager/widgets/radio_button.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AddLift extends StatefulWidget {
  const AddLift({super.key});

  @override
  _AddLiftState createState() => _AddLiftState();
}

class _AddLiftState extends State<AddLift> with SingleTickerProviderStateMixin {
  final List<Map<String, String>> images = [
    {
      "asset": "assets/images/mens_olympic_barbell.svg",
      "name": "Men's Olympic Barbell",
      "defaultWeight": "20.0", // 20 kg as per image
    },
    {
      "asset": "assets/images/womens_olympic_barbell.svg",
      "name": "Women's Olympic Barbell",
      "defaultWeight": "15.0", // 15 kg as per image
    },
    {
      "asset": "assets/images/trap_bar.svg",
      "name": "Trap Bar",
      "defaultWeight": "25.0", // 25 kg as per image
    },
    {
      "asset": "assets/images/squat_safety_bar.svg",
      "name": "Squat Safety Bar",
      "defaultWeight": "32.0", // 32 kg as per image (52 lbs)
    },
  ];

  int _currentIndex = 0; // To track the currently selected barbell
  bool _isCustomWeight = false;
  double _customWeight = 20.0; // Default to 20kg (Men's Olympic Barbell)
  bool _isMetric = true; // True for kg, false for lbs
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleUnit() {
    setState(() {
      if (_isMetric) {
        // Convert kg to lbs
        _customWeight = double.parse(
          (_customWeight * 2.20462).toStringAsFixed(1),
        );
      } else {
        // Convert lbs to kg
        _customWeight = double.parse(
          (_customWeight * 0.453592).toStringAsFixed(1),
        );

        // If converted value is outside kg range, reset to default
        if (_customWeight < 10.0 || _customWeight > 50.0) {
          _customWeight = 20.0;
        }
      }
      _isMetric = !_isMetric;
    });
  }

  double _getSelectedBarbellWeight() {
    // If custom weight is selected, use the custom weight
    if (_isCustomWeight) {
      return _customWeight;
    }

    // Otherwise, use the default weight of the selected barbell
    return double.parse(images[_currentIndex]["defaultWeight"]!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        backgroundColor: Colors.grey[850],
        title: const Text(
          'Select Barbell',
          style: TextStyle(color: Colors.white),
        ),
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
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 20),
                // Radio buttons for barbell selection
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  padding: const EdgeInsets.all(16),
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
                  child: const RadioExample(),
                ),
                const SizedBox(height: 20),
                // Barbell carousel
                SizedBox(
                  height: 450,
                  child: CarouselSlider(
                    options: CarouselOptions(
                      height: 450.0,
                      autoPlay: false,
                      enlargeCenterPage: true,
                      onPageChanged: (index, reason) {
                        setState(() {
                          _currentIndex = index;
                          _animationController.forward().then((_) {
                            _animationController.reverse();
                          });
                        });
                      },
                    ),
                    items: images.map((imageData) {
                      return Builder(
                        builder: (BuildContext context) {
                          return AnimatedBuilder(
                            animation: _scaleAnimation,
                            builder: (context, child) {
                              return Transform.scale(
                                scale: _currentIndex == images.indexOf(imageData)
                                    ? _scaleAnimation.value
                                    : 1.0,
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  margin: const EdgeInsets.symmetric(horizontal: 5.0),
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
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SvgPicture.asset(
                                        imageData["asset"]!,
                                        height: 300,
                                        fit: BoxFit.contain,
                                      ),
                                      const SizedBox(height: 20),
                                      Text(
                                        imageData["name"]!,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 20.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      Text(
                                        '${imageData["defaultWeight"]!} kg (${(double.parse(imageData["defaultWeight"]!) * 2.20462).toStringAsFixed(2)} lbs)',
                                        style: const TextStyle(
                                          color: Colors.white70,
                                          fontSize: 16.0,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 20),
                // Custom weight section
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  padding: const EdgeInsets.all(16),
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Checkbox(
                            value: _isCustomWeight,
                            onChanged: (bool? value) {
                              setState(() {
                                _isCustomWeight = value ?? false;
                              });
                            },
                            activeColor: Colors.blue,
                            checkColor: Colors.white,
                          ),
                          const Text(
                            'Custom Barbell Weight',
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                      if (_isCustomWeight) ...[
                        const SizedBox(height: 20),
                        // Weight Slider
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Slider(
                                      value: _customWeight,
                                      min: _isMetric ? 10.0 : 20.0,
                                      max: _isMetric ? 50.0 : 110.0,
                                      divisions: 40,
                                      label: '${_customWeight.toStringAsFixed(1)} ${_isMetric ? 'kg' : 'lbs'}',
                                      onChanged: (double value) {
                                        setState(() {
                                          _customWeight = value;
                                        });
                                      },
                                      activeColor: Colors.blue,
                                      inactiveColor: Colors.blue.withOpacity(0.3),
                                    ),
                                  ),
                                  // Unit Toggle Switch
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Colors.grey[800],
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(color: Colors.blue),
                                    ),
                                    child: TextButton(
                                      onPressed: _toggleUnit,
                                      child: Text(
                                        _isMetric ? 'kg' : 'lbs',
                                        style: const TextStyle(
                                          color: Colors.blue,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                '${_customWeight.toStringAsFixed(1)} ${_isMetric ? 'kg' : 'lbs'}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                // Proceed button
                Container(
                  margin: const EdgeInsets.only(bottom: 20),
                  child: ElevatedButton(
                    onPressed: () {
                      router.push(
                        '/dolift?barbell=${Uri.encodeComponent(images[_currentIndex]["name"]!)}&weight=${_getSelectedBarbellWeight()}&unit=$_isMetric',
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 40,
                        vertical: 15,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      elevation: 5,
                      shadowColor: Colors.green.withOpacity(0.5),
                    ),
                    child: const Text(
                      "Proceed",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
