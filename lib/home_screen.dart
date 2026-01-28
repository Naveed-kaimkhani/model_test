
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:model_testing/gift_predictor.dart';
import 'package:model_testing/utils/utils.dart';
import 'package:model_testing/view/product_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GiftSuggestionHome extends StatefulWidget {
  @override
  _GiftSuggestionHomeState createState() => _GiftSuggestionHomeState();
}

class _GiftSuggestionHomeState extends State<GiftSuggestionHome> {
  String _relationship = 'Friend';
  String _occasion = 'Birthday';
  double _budget = 50;
  final List<String> _interests = [];
  final TextEditingController ageController = TextEditingController();
  final TextEditingController genderController = TextEditingController();
  final TextEditingController occasionController = TextEditingController();
  final TextEditingController interestController = TextEditingController();
  final TextEditingController priceRangeController = TextEditingController();

  String _gender = 'Male'; // New gender variable
 
  String _ageGroup = '18-25'; // Default value


  final GiftPredictor predictor = GiftPredictor();

  String prediction = '';
  bool loading = false;

  Future<void> predict() async {
    setState(() => loading = true);

    // Show loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async => false,
          child: Dialog(
            backgroundColor: Colors.transparent,
            insetPadding: EdgeInsets.all(20),
            child: Container(
              padding: EdgeInsets.all(25),
              decoration: BoxDecoration(
                color: Color(0xFF6A1B9A),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 10,
                    spreadRadius: 2,
                  )
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Animated gift icon
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                      ),
                      SpinKitPumpingHeart(
                        color: Color(0xFFFFD700),
                        size: 50.0,
                        duration: Duration(milliseconds: 1500),
                      ),
                    ],
                  ),

                  SizedBox(height: 20),

                  // Animated text - FIXED VERSION
                  AnimatedTextKit(
                    animatedTexts: [
                      TypewriterAnimatedText(
                        "Finding perfect matches...",
                        textStyle: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                        speed: Duration(milliseconds: 100),
                      ),
                      TypewriterAnimatedText(
                        "Almost there...",
                        textStyle: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                        speed: Duration(milliseconds: 100),
                      ),
                    ],
                    totalRepeatCount: 3,
                    pause: Duration(milliseconds: 800),
                    displayFullTextOnTap: false,
                    stopPauseOnTap: false,
                  ),

                  SizedBox(height: 20),

                  // Progress indicator
                  LinearProgressIndicator(
                    backgroundColor: Colors.white.withOpacity(0.2),
                    valueColor:
                        AlwaysStoppedAnimation<Color>(Color(0xFFFFD700)),
                    minHeight: 6,
                    borderRadius: BorderRadius.circular(10),
                  ),

                  SizedBox(height: 15),

                  // Cancel button
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      setState(() => loading = false);
                    },
                    child: Text(
                      'CANCEL',
                      style: TextStyle(
                        color: Colors.white70,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );

    // Simulate some processing time
    await Future.delayed(Duration(seconds: 3));

    final combinedInput =
        "$_ageGroup | $_gender | $_occasion | ${_interests.join(', ')} | $_budget";

    final result = await predictor.predictGift(combinedInput);

    // Close the dialog
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    }

    setState(() {
      prediction = result;
      loading = false;
    });

    // Show result in a dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            padding: EdgeInsets.all(25),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.card_giftcard,
                  color: Color(0xFF6A1B9A),
                  size: 50,
                ),
                SizedBox(height: 15),
                Text(
                  'Gift Suggestions',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF6A1B9A),
                  ),
                ),
                SizedBox(height: 15),
                Text(
                  result,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFFFD700),
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  // onPressed: () => Navigator.of(context).pop(),
                  onPressed: () { 
                    
   Navigator.of(context).pop();
    Navigator.push(
    context,
    MaterialPageRoute<void>(
      builder: (context) =>  ProductScreen(title: result,),
    ),
  );
  //  Navigator.of(context).pop();
  },
                  child: Text(
                    'GOT IT',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
Future<void> _checkAndShowBaseUrlDialog() async {
  // final prefs = await SharedPreferences.getInstance();
  // final baseUrl = prefs.getString('base_url');
    _showBaseUrlDialog();

}
void _showBaseUrlDialog() {
  final TextEditingController urlController = TextEditingController();

  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return AlertDialog(
        title: Text("Backend URL"),
        content: TextField(
          controller: urlController,
          decoration: InputDecoration(
            hintText: "http://10.0.21.239:5000",
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          ElevatedButton(
            child: Text("Save"),
            onPressed: () async {
              final url = urlController.text.trim();

              if (url.isEmpty) return;

              final prefs = await SharedPreferences.getInstance();
              await prefs.setString('base_url', url);

              Navigator.pop(context);
            },
          ),
        ],
      );
    },
  );
}

  // @override
  // void initState() {
  //   super.initState();
  //   predictor.loadModel();
  // }
@override
void initState() {
  super.initState();
  WidgetsBinding.instance.addPostFrameCallback((_) {

    predictor.loadModel();
    _checkAndShowBaseUrlDialog();
  });
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Gradient
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF6A1B9A),
                  Color(0xFF4527A0),
                ],
              ),
            ),
          ),

          // Main Content
          SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 60),

                // Header
                Row(
                  children: [
                    Icon(Icons.card_giftcard, color: Colors.white, size: 32),
                    SizedBox(width: 10),
                    Text(
                      'GiftGenius',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 5),
                Text(
                  'Describe the person, we\'ll find the perfect gift!',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                    fontFamily: 'Quicksand',
                  ),
                ),

                SizedBox(height: 40),

                // Input Card
                Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white.withOpacity(0.3)),
                  ),
                  child: Column(
                    children: [
                      // Relationship Input
                      _buildInputSection(
                        icon: Icons.favorite,
                        title: "Who's the gift for?",
                        child: Column(
                          children: [
                            DropdownButtonFormField(
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                filled: true,
                                fillColor: Colors.white,
                              ),
                              value: _relationship,
                              items: [
                                'Friend',
                                'Partner',
                                'Parent',
                                'Sibling',
                                'Colleague'
                              ]
                                  .map((rel) => DropdownMenuItem(
                                        value: rel,
                                        child: Text(rel),
                                      ))
                                  .toList(),
                              onChanged: (value) {
                                setState(() {
                                  _relationship = value.toString();
                                });
                              },
                            ),
                            SizedBox(height: 25),

                            _buildInputSection(
                              icon: Icons.person_outline,
                              title: "Gender",
                              child: DropdownButtonFormField(
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  filled: true,
                                  fillColor: Colors.white,
                                ),
                                value: _gender,
                                items: [
                                  'Male',
                                  'Female',
                                  'Non-binary',
                                  'Prefer not to say'
                                ]
                                    .map((gender) => DropdownMenuItem(
                                          value: gender,
                                          child: Text(gender),
                                        ))
                                    .toList(),
                                onChanged: (value) {
                                  setState(() {
                                    _gender = value.toString();
                                  });
                                },
                              ),
                            ),

// Age Group Input
                            SizedBox(height: 25),

                            _buildInputSection(
                              icon: Icons.person,
                              title: "Age Group",
                              child: DropdownButtonFormField(
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  filled: true,
                                  fillColor: Colors.white,
                                ),
                                value: _ageGroup,
                                items: [
                                  'Under 18',
                                  '18-25',
                                  '26-35',
                                  '36-45',
                                  '46-55',
                                  '56-65',
                                  '65+'
                                ]
                                    .map((age) => DropdownMenuItem(
                                          value: age,
                                          child: Text(age),
                                        ))
                                    .toList(),
                                onChanged: (value) {
                                  setState(() {
                                    _ageGroup = value.toString();
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 25),

                      // Occasion Input
                      _buildInputSection(
                        icon: Icons.calendar_today,
                        title: "What's the occasion?",
                        child: Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          children: [
                            _buildOccasionChip('Birthday'),
                            _buildOccasionChip('Anniversary'),
                            _buildOccasionChip('Christmas'),
                            _buildOccasionChip('Graduation'),
                            _buildOccasionChip('Valentine\'s'),
                            _buildOccasionChip('Other'),
                          ],
                        ),
                      ),

                      SizedBox(height: 25),

                      // Budget Input
                      _buildInputSection(
                        icon: Icons.attach_money,
                        title: "Your budget",
                        child: Column(
                          children: [
                            SliderTheme(
                              data: SliderThemeData(
                                thumbShape: RoundSliderThumbShape(
                                  enabledThumbRadius: 10,
                                  elevation: 5,
                                ),
                                activeTrackColor: Color(0xFFFFD700),
                                inactiveTrackColor: Colors.grey[300],
                                thumbColor: Color(0xFFFFD700),
                              ),
                              child: Slider(
                                min: 10,
                                max: 500,
                                divisions: 10,
                                label: '\$${_budget.round()}',
                                value: _budget,
                                onChanged: (value) {
                                  setState(() {
                                    _budget = value;
                                  });
                                },
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Rs 1000',
                                    style: TextStyle(color: Colors.white70)),
                                Text('Rs 50000',
                                    style: TextStyle(color: Colors.white70)),
                              ],
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 25),

                      // Interests Input
                      _buildInputSection(
                        icon: Icons.interests,
                        title: "Their interests",
                        child: Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: allInterests
                              .map((interest) => _buildInterestChip(interest))
                              .toList(),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 30),

                // Generate Button
                Button(),
                SizedBox(height: 40),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Center Button() {
    return Center(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFFFFD700),
          padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
        ),
        // onPressed: () {
        //   log(_relationship);

        //   log(_name);

        //   log(_occasion);

        //   log(_budget.toString());

        //   log(_interests.toString());

        // },
        onPressed: loading ? null : predict,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Find Perfect Gifts',
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(width: 10),
            Icon(Icons.auto_awesome, color: Colors.black),
          ],
        ),
      ),
    );
  }

  Widget _buildInputSection({
    required IconData icon,
    required String title,
    required Widget child,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              icon,
              color: Color(0xFFFFD700),
            ),
            SizedBox(width: 10),
            Text(
              title,
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        SizedBox(height: 10),
        child,
      ],
    );
  }

  Widget _buildOccasionChip(String occasion) {
    return ChoiceChip(
      label: Text(
        occasion,
      ),
      selected: _occasion == occasion,
      onSelected: (selected) {
        setState(() {
          _occasion = occasion;
        });
      },
      selectedColor: Color(0xFFFFD700),
      backgroundColor: Colors.white.withOpacity(0.2),
      labelStyle: TextStyle(
        color: _occasion == occasion ? Colors.black : Colors.black,
      ),
    );
  }

  Widget _buildInterestChip(String interest) {
    return FilterChip(
      label: Text(interest),
      selected: _interests.contains(interest),
      onSelected: (selected) {
        setState(() {
          if (selected) {
            _interests.add(interest);
          } else {
            _interests.remove(interest);
          }
        });
      },
      backgroundColor: interestColors[interest]!.withOpacity(0.2),
      selectedColor: interestColors[interest],
      labelStyle: TextStyle(
        color: _interests.contains(interest) ? Colors.white : Colors.black,
      ),
      showCheckmark: false,
    );
  }
}
