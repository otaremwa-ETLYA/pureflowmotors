import 'package:flutter/material.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class MoreScreen extends StatefulWidget {
  const MoreScreen({super.key});

  @override
  State<MoreScreen> createState() => _MoreScreenState();
}

class _MoreScreenState extends State<MoreScreen> {
  late YoutubePlayerController controller;

  @override
  void initState() {
    super.initState();

    controller = YoutubePlayerController.fromVideoId(
      videoId: 'aIP0aQaxvZM',    // Use only the video ID
      autoPlay: false,          // correct parameter
      params: const YoutubePlayerParams(
        showControls: true,
        showFullscreenButton: true,
      ),
    );
  }

  @override
  void dispose() {
    controller.close(); // correct cleanup
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 16, 92, 177),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              "Asset Financing",
              style: TextStyle(
                fontFamily: 'Poppins-Bold',
                fontWeight: FontWeight.bold,
                fontSize: 22,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 2),
            Text(
              "Kingdom Initiatives Transforming Communities",
              style: TextStyle(
                fontFamily: 'Poppins-Regular',
                fontWeight: FontWeight.w400,
                fontSize: 11,
                color: Colors.white70,
              ),
            ),
          ],
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // Impact Section
            const Text(
              "Impact",
              style: TextStyle(
                  fontFamily: 'Poppins-Bold',
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
            ),
            const SizedBox(height: 12),

            ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: YoutubePlayer(
                  controller: controller,
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Trust Stats
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: const [
                  ImpactStat("10,000+", "Members\nServed"),
                  ImpactStat("14+", "Branches\nOpened"),
                  ImpactStat("104+", "Districts\nReached"),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // Contact Us
            const Text(
              "Contact Us",
              style: TextStyle(
                  fontFamily: 'Poppins-Bold',
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
            ),
            const SizedBox(height: 12),

            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    contactRow(Icons.phone, "+256 700 123 456"),
                    const Divider(),
                    contactRow(Icons.phone_android, "+256 782 123 456"),
                    const Divider(),
                    contactRow(Icons.email, "info@pureflowboda.com"),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 30),

            Center(
              child: Text(
                "App Version 1.0",
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 12,
                  fontFamily: 'Poppins-Regular',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget contactRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: const Color.fromARGB(255, 16, 92, 177)),
        const SizedBox(width: 12),
        Text(
          text,
          style: const TextStyle(
            fontFamily: 'Poppins-Regular',
            fontSize: 15,
          ),
        ),
      ],
    );
  }
}

class ImpactStat extends StatelessWidget {
  final String number;
  final String label;

  const ImpactStat(this.number, this.label, {super.key});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          number,
          style: const TextStyle(
            fontFamily: 'Poppins-Bold',
            fontSize: 20,
            color: Color.fromARGB(255, 16, 92, 177),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontFamily: 'Poppins-Regular',
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}