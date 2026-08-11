import 'package:flutter/material.dart';
import 'package:little_kids_ai/core/common_imports.dart';

class MoodBottomSheet extends StatelessWidget {
  const MoodBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final moods = [
      {'label': 'EXCITED', 'color': Colors.cyan},
      {'label': 'HAPPY', 'color': Colors.green},
      {'label': 'SILLY', 'color': Colors.teal},
      {'label': 'TIRED', 'color': Colors.blueGrey},
      {'label': 'SAD', 'color': Colors.blue},
      {'label': 'ANXIOUS', 'color': Colors.greenAccent},
    ];

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            "Groovy time! Pick how do you feel and let's play some music that'll make you smile",
            textAlign: TextAlign.center,
            style: GoogleFonts.comicNeue(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.italic,
            ),
          ),
          const SizedBox(height: 30),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: moods.map((mood) => _buildMoodItem(mood)).toList(),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildMoodItem(Map<String, dynamic> mood) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          Text(
            mood['label'],
            style: GoogleFonts.comicNeue(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Container(
            width: 60,
            height: 100,
            decoration: BoxDecoration(
              color: mood['color'],
              borderRadius: BorderRadius.circular(30),
            ),
            child: const Center(child: Icon(Icons.face, color: Colors.white, size: 40)),
          ),
          const SizedBox(height: 10),
          const Icon(Icons.music_note, size: 40, color: Colors.yellow),
        ],
      ),
    );
  }
}
