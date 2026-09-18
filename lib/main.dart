import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:flutter_tts/flutter_tts.dart';
import 'dart:math';

import 'package:firebase_core/firebase_core.dart';
import 'login_screen.dart';
import 'splash_screen.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  runApp(

    const MaterialApp(

      debugShowCheckedModeBanner: false,

      home: SplashScreen(),
    ),
  );
}
class SpeakBridgeApp extends StatefulWidget {
  const SpeakBridgeApp({super.key});

  @override
  State<SpeakBridgeApp> createState() => _SpeakBridgeAppState();
}

class _SpeakBridgeAppState extends State<SpeakBridgeApp> {

  bool isActive = false;
  int selectedAge = 1;
  String hindiText = "पंखा चालू करो";
  String englishText = "Please turn on the fan";

  String emotion = "Calm Request";
  String aiContext = "Home Routine";

  String lastDetectedSentence = "";

  int dailyStreak = 0;

  DateTime? lastUsageDate;

  String learningPriority = "High";

  String reinforcementType =
      "Daily Core Pattern";

  String emotionalIntensity =
      "Medium";

  String learningImpact = "Medium";

  String repetitionFrequency = "Frequent";

  String householdScenario = "General Home";

  double confidenceScore = 0;

  String confidenceLevel =
      "Beginner";

  late stt.SpeechToText speech;
  FlutterTts flutterTts = FlutterTts();

  bool isListening = false;
  bool isSpeaking = false;

  Map<String, int> phraseFrequency = {};

  String topPattern = "None";

  String learningAdaptation =
      "Developing";

  void updateDailyStreak() {

    DateTime now = DateTime.now();

    if (lastUsageDate == null) {

      dailyStreak = 1;

      lastUsageDate = now;

      return;

    }

    int difference = now.difference(lastUsageDate!).inDays;

    if (difference == 1) {

      dailyStreak++;

    }

    else if (difference > 1) {

      dailyStreak = 1;

    }

    lastUsageDate = now;
  }



  Map<String, List<Map<String, dynamic>>> immersionData = {

    "0-2": [

      {
        "hindi": "पानी पियो",

        "english": [
          "Drink water",
          "Please drink water",
          "Time to drink water"
        ],

        "emotion": "Care",

        "context": "Parenting"
      },

      {
        "hindi": "सो जाओ",

        "english": [
          "Go to sleep",
          "It is bedtime",
          "Time to sleep"
        ],

        "emotion": "Comfort",

        "context": "Sleep Routine"
      },

      {
        "hindi": "मम्मी आ गई",

        "english": [
          "Mom is here",
          "Mom has arrived",
          "Look, mom is here"
        ],

        "emotion": "Warmth",

        "context": "Family Bond"
      },

    ],

    "3-6": [

      {
        "hindi": "खाना तैयार है",

        "english": [
          "Food is ready",
          "Dinner is ready",
          "Come eat your food"
        ],

        "emotion": "Warm Family Tone",

        "context": "Dining Routine"
      },

      {
        "hindi": "स्कूल जाने का समय है",

        "english": [
          "It is time for school",
          "Get ready for school",
          "School time has started"
        ],

        "emotion": "Routine Guidance",

        "context": "Morning Routine"
      },

      {
        "hindi": "हाथ धो लो",

        "english": [
          "Wash your hands",
          "Please wash your hands",
          "Clean your hands first"
        ],

        "emotion": "Care Instruction",

        "context": "Hygiene"
      },

    ],

    "7+": [

      {
        "hindi": "पंखा चालू करो",

        "english": [
          "Please turn on the fan",
          "Turn the fan on",
          "Can you switch on the fan"
        ],

        "emotion": "Calm Request",

        "context": "Home Routine"
      },

      {
        "hindi": "पानी ले आओ",

        "english": [
          "Please bring water",
          "Can you bring some water",
          "Bring me a glass of water"
        ],

        "emotion": "Care Request",

        "context": "Family Interaction"
      },

      {
        "hindi": "आज तुम्हारा दिन कैसा था",

        "english": [
          "How was your day today",
          "Did you have a good day",
          "Tell me about your day"
        ],

        "emotion": "Emotional Connection",

        "context": "Family Conversation"
      },

    ]

  };





  @override
  void initState() {
    super.initState();

    speech = stt.SpeechToText();


    flutterTts.setLanguage("en-US");
    flutterTts.setSpeechRate(0.4);



  }
  Future<void> startListening() async {

    if (!isActive) return;

    bool available = await speech.initialize();

    if (!available) return;

    if (speech.isListening) {
      await speech.stop();
    }

    setState(() {
      isListening = true;
    });

    speech.listen(

      listenMode: stt.ListenMode.dictation,

      localeId: "hi_IN",

      partialResults: false,

      cancelOnError: false,

      listenFor: const Duration(minutes: 30),

      pauseFor: const Duration(minutes: 10),

      onResult: (result) async {
        if (result.recognizedWords.length < 3) {
          return;
        }

        if (isSpeaking) return;

        String words = result.recognizedWords.toLowerCase();
        if (words == lastDetectedSentence) {
          return;
        }

        lastDetectedSentence = words;

        if (words.isEmpty) return;

        setState(() {
          hindiText = words;
        });

        // FAN
        String currentGroup = getCurrentAgeGroup();


        List<Map<String, dynamic>> currentData =
        immersionData[currentGroup]!;

        bool found = false;

        for (var item in currentData) {

          phraseFrequency[aiContext] =
              (phraseFrequency[aiContext] ?? 0) + 1;

          String highestKey = aiContext;

          int highestValue = 0;

          phraseFrequency.forEach((key, value) {

            if (value > highestValue) {

              highestValue = value;

              highestKey = key;

            }

          });

          topPattern = highestKey;

          confidenceScore += 1.5;

// Bonus from streak
          if (dailyStreak > 7) {

            confidenceScore += 2;

          }

// Bonus from emotional exposure
          if (emotion.contains("Warm") ||
              emotion.contains("Emotional")) {

            confidenceScore += 1;

          }

// Limit to 100
          if (confidenceScore > 100) {

            confidenceScore = 100;

          }

// Confidence Levels
          if (confidenceScore > 85) {

            confidenceLevel =
            "Fluent and Comfortable";

          }

          else if (confidenceScore > 65) {

            confidenceLevel =
            "Conversationally Emerging";

          }

          else if (confidenceScore > 45) {

            confidenceLevel =
            "Building Confidence";

          }

          else {

            confidenceLevel =
            "Beginner";

          }

          if (highestValue > 10) {

            learningAdaptation = "High Retention";

          }

          else if (highestValue > 5) {

            learningAdaptation = "Moderate Retention";

          }

          else {

            learningAdaptation = "Developing";

          }

          if (words.contains(item["hindi"]!)) {

            List<dynamic> englishOptions =
            item["english"] as List<dynamic>;

            englishText =
            englishOptions[Random().nextInt(englishOptions.length)];
            emotion = item["emotion"]!;
            aiContext = item["context"]!;
            if (aiContext.contains("Dining")) {

              learningImpact = "High";

              repetitionFrequency = "Daily";

              householdScenario = "Family Meal Time";

            }

            else if (aiContext.contains("Sleep")) {

              learningImpact = "Medium";

              repetitionFrequency = "Night Routine";

              householdScenario = "Bedtime Interaction";

            }

            else if (aiContext.contains("School")) {

              learningImpact = "High";

              repetitionFrequency = "Morning Habit";

              householdScenario = "Learning Preparation";

            }

            else if (aiContext.contains("Family")) {

              learningImpact = "Very High";

              repetitionFrequency = "Emotional Repetition";

              householdScenario = "Family Bonding";

            }

            else if (aiContext.contains("Home")) {

              learningImpact = "Medium";

              repetitionFrequency = "Frequent";

              householdScenario = "General Home";

            }

            else {

              learningImpact = "Moderate";

              repetitionFrequency = "Regular";

              householdScenario = "General Interaction";

            }


            if (emotion.contains("Warm")) {

              learningPriority = "Very High";

              reinforcementType =
              "Emotion-Based Reinforcement";

              emotionalIntensity = "High";

            }

            else if (aiContext.contains("School")) {

              learningPriority = "High";

              reinforcementType =
              "Routine Learning Pattern";

              emotionalIntensity = "Medium";

            }

            else if (aiContext.contains("Sleep")) {

              learningPriority = "Medium";

              reinforcementType =
              "Night Habit Reinforcement";

              emotionalIntensity = "Low";

            }

            else if (aiContext.contains("Family")) {

              learningPriority = "Very High";

              reinforcementType =
              "Emotional Family Exposure";

              emotionalIntensity = "Very High";

            }

            else if (aiContext.contains("Home")) {

              learningPriority = "High";

              reinforcementType =
              "Daily Household Usage";

              emotionalIntensity = "Medium";

            }

            else {

              learningPriority = "Moderate";

              reinforcementType =
              "General Language Exposure";

              emotionalIntensity = "Low";

            }

            found = true;

            break;

          }

        }

        if (!found) return;


        setState(() {});

        isSpeaking = true;

        await speech.stop();
        await Future.delayed(
          const Duration(seconds: 2),
        );

        await flutterTts.speak(englishText);
        await configureVoiceStyle();


        isSpeaking = false;

        if (isActive) {

          await Future.delayed(const Duration(seconds: 2));

          startListening();

        }

      },
      onSoundLevelChange: (level) {},

    );
  }
  String getCurrentAgeGroup() {

    if (selectedAge == 0) {

      return "0-2";

    }

    else if (selectedAge == 1) {

      return "3-6";

    }

    else {

      return "7+";

    }

  }

  Future<void> configureVoiceStyle() async {

    String currentGroup = getCurrentAgeGroup();

    // 0-2 YEARS
    if (currentGroup == "0-2") {

      await flutterTts.setSpeechRate(0.28);

      await flutterTts.setPitch(1.45);

      await flutterTts.setVolume(0.95);

    }

    // 3-6 YEARS
    else if (currentGroup == "3-6") {

      await flutterTts.setSpeechRate(0.38);

      await flutterTts.setPitch(1.2);

      await flutterTts.setVolume(1.0);

    }

    // 7+ YEARS
    else {

      await flutterTts.setSpeechRate(0.5);

      await flutterTts.setPitch(0.95);

      await flutterTts.setVolume(1.0);

    }

    // Emotional Adjustment
    if (emotionalIntensity == "Very High") {

      await flutterTts.setSpeechRate(0.42);

    }

  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SpeakBridge',
      home: Scaffold(
          backgroundColor: const Color(0xFFF4F0DD),

        appBar: AppBar(
          backgroundColor: Color(0xFFF4F0DD),
          elevation: 0,
          centerTitle: false,
          title: const Text(
            "SpeakBridge",
            style: TextStyle(
              color: Color(0xFF7F5539),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        body: Padding(
          padding: const EdgeInsets.all(20),

          child: SingleChildScrollView(
            child: Column(
              children: [

                const SizedBox(height: 20),

                // AI STATUS CARD
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),

                  decoration: BoxDecoration(
                    color: const Color(0xFFF8F6EC),
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 10,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),

                  child: Column(
                    children: [

                      const Text(
                        "AI-powered passive English immersion ecosystem for Indian households",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF5E503F),
                        ),
                      ),





                      const SizedBox(height: 20),

                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),

                        decoration: BoxDecoration(
                          color: const Color(0xFFDDE5B6),
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 10,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),

                        child: Row(
                          mainAxisSize: MainAxisSize.min,

                          children: [

                            const Icon(
                              Icons.local_fire_department,
                              color: Color(0xFF8B5E3C),
                            ),

                            const SizedBox(width: 10),

                            Text(
                              "$dailyStreak Day Streak",
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF8B5E3C),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

              const SizedBox(height: 40),

// AGE MODE SECTION

                Align(
                  alignment: Alignment.centerLeft,

                  child: Text(
                    "Select Age Mode",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF5E503F),
                    ),
                  ),
                ),

                const SizedBox(height: 15),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,

                  children: [

                    // 0-2
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedAge = 0;
                          });
                        },

                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 15),

                          decoration: BoxDecoration(
                            color: selectedAge == 0
                                ? const Color(0xFFDDE5B6)
                                : const Color(0xFFF8F6EC),

                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 10,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),

                          child: const Column(
                            children: [

                              Text(
                                "0-2",
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFF5E503F),
                                ),
                              ),

                              SizedBox(height: 5),

                              Text("Passive"),
                            ],
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 10),

                    // 3-6
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedAge = 1;
                          });
                        },

                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 15),

                          decoration: BoxDecoration(
                            color: selectedAge == 1
                                ? const Color(0xFFDDE5B6)
                                : const Color(0xFFF8F6EC),

                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 10,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),

                          child: const Column(
                            children: [

                              Text(
                                "3-6",
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFF5E503F),
                                ),
                              ),

                              SizedBox(height: 5),

                              Text("Routine"),
                            ],
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 10),

                    // 7+
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedAge = 2;
                          });
                        },

                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 15),

                          decoration: BoxDecoration(
                            color: selectedAge == 2
                                ? const Color(0xFFDDE5B6)
                                : const Color(0xFFF8F6EC),

                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 10,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),

                          child: const Column(
                            children: [

                              Text(
                                "7+",
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFF5E503F),
                                ),
                              ),

                              SizedBox(height: 5),

                              Text("Adaptive"),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 30),

                SizedBox(
                  width: double.infinity,
                  height: 60,

                  child: ElevatedButton(
                    onPressed: () async {
                      updateDailyStreak();

                      setState(() {
                        isActive = !isActive;
                      });

                      if (isActive) {

                        await startListening();

                      } else {

                        speech.stop();

                        setState(() {
                          isListening = false;
                        });
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                      isActive ? const Color(0xFF7F5539) : const Color(0xFFA8BE6F),

                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),

                    child: Text(
                      isActive ? "STOP IMMERSION" : "START IMMERSION",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFFF8F6EC),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // TRANSLATION CARD
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),

                  decoration: BoxDecoration(
                    color: const Color(0xFFF8F6EC),
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 10,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      const Text(
                        "Detected Hindi",
                        style: TextStyle(
                          fontSize: 18,
                          color: const Color(0xFFB08968),
                        ),
                      ),

                      const SizedBox(height: 10),

                      Text(
                        hindiText,
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF5E503F),
                        ),
                      ),

                      const SizedBox(height: 25),

                      const Text(
                        "AI Emotional Translation",
                        style: TextStyle(
                          fontSize: 18,
                          color: const Color(0xFFB08968),
                        ),
                      ),

                      const SizedBox(height: 10),

                      Text(
                        englishText,
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF5E503F),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),
                // AI ANALYSIS SECTION



                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),

                  decoration: BoxDecoration(
                    color: const Color(0xFFF8F6EC),
                    borderRadius: BorderRadius.circular(25),

                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 10,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [

                      const Text(
                        "AI Decision Engine",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF5E503F),
                        ),
                      ),

                      const SizedBox(height: 30),

                      Row(
                        children: [

                          Icon(
                            Icons.auto_graph,
                            color: Color(0xFFA8BE6F),
                          ),

                          SizedBox(width: 10),

                          Expanded(
                            child: Text(
                              "Learning Priority: $learningPriority",
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 15),

                      Row(
                        children: [

                          Icon(
                            Icons.repeat,
                            color: Color(0xFFA8BE6F),
                          ),

                          SizedBox(width: 10),

                          Expanded(
                            child: Text(
                              "Reinforcement: $reinforcementType",
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 15),

                      Row(
                        children: [

                          Icon(
                            Icons.favorite,
                            color: Color(0xFFA8BE6F),
                          ),

                          SizedBox(width: 10),

                          Expanded(
                            child: Text(
                              "Emotional Intensity: $emotionalIntensity",
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                        ],
                      ),

                    ],
                  ),
                ),
                const SizedBox(height: 30),


                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),

                  decoration: BoxDecoration(
                    color: const Color(0xFFF8F6EC),
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 10,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [

                      const Text(
                        "AI Context Analysis",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF5E503F),
                        ),
                      ),

                      const SizedBox(height: 20),

                      Row(
                        children: [

                          Icon(
                            Icons.psychology,
                            color: const Color(0xFFA8BE6F),
                          ),

                          const SizedBox(width: 10),

                          Expanded(
                            child: Text(
                              "Emotion: $emotion",
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 15),

                      Row(
                        children: [

                          Icon(
                            Icons.family_restroom,
                            color: const Color(0xFFA8BE6F),
                          ),

                          const SizedBox(width: 10),

                          Expanded(
                            child: Text(
                              "Context: $aiContext",
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 15),
                      const SizedBox(height: 15),

                      Row(
                        children: [

                          Icon(
                            Icons.trending_up,
                            color: const Color(0xFFA8BE6F),
                          ),

                          const SizedBox(width: 10),

                          Expanded(
                            child: Text(
                              "Learning Impact: $learningImpact",
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 15),

                      Row(
                        children: [

                          Icon(
                            Icons.repeat_on,
                            color: const Color(0xFFA8BE6F),
                          ),

                          const SizedBox(width: 10),

                          Expanded(
                            child: Text(
                              "Repetition Frequency: $repetitionFrequency",
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 15),

                      Row(
                        children: [

                          Icon(
                            Icons.home,
                            color: const Color(0xFFA8BE6F),
                          ),

                          const SizedBox(width: 10),

                          Expanded(
                            child: Text(
                              "Household Scenario: $householdScenario",
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                        ],
                      ),

                      Row(
                        children: [

                          Icon(
                            Icons.auto_awesome,


                            color: const Color(0xFFA8BE6F),
                          ),


                          const SizedBox(width: 10),

                          const Expanded(
                            child: Text(
                              "AI selected high-frequency learning sentence",
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 40),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),

                  decoration: BoxDecoration(
                    color: const Color(0xFFF8F6EC),
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 10,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [

                      const Text(
                        "AI Confidence Tracker",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF5E503F),
                        ),
                      ),

                      const SizedBox(height: 25),

                      Center(
                        child: Text(
                          "${confidenceScore.toInt()}%",
                          style: const TextStyle(
                            fontSize: 50,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFA8BE6F),
                          ),
                        ),
                      ),

                      const SizedBox(height: 15),

                      Center(
                        child: Text(
                          confidenceLevel,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF7F5539),
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      Row(
                        children: [

                          const Icon(
                            Icons.trending_up,
                            color: Color(0xFFA8BE6F),
                          ),

                          const SizedBox(width: 10),

                          Expanded(
                            child: Text(
                              "Confidence grows through daily immersion exposure",
                              style: const TextStyle(fontSize: 16),
                            ),
                          ),
                        ],
                      ),

                    ],
                  ),
                ),

                const SizedBox(height: 40),



              ],
            ),
          ),
        ),
      ),
    );
  }
}