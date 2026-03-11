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
      videoId: 'aIP0aQaxvZM', // Replace with your video ID
      autoPlay: false,
      params: const YoutubePlayerParams(
        showControls: true,
        showFullscreenButton: true,
      ),
    );
  }

  @override
  void dispose() {
    controller.close();
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

            // =========================
            // IMPACT VIDEO
            // =========================
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
                child: YoutubePlayer(controller: controller),
              ),
            ),
            const SizedBox(height: 20),

            // =========================
            // TRUST-BUILDING STATS
            // =========================
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                StatsCard(title: "Members Served", value: "10,000+"),
                StatsCard(title: "Branches Opened", value: "14+"),
                StatsCard(title: "Districts Reached", value: "104+"),
              ],
            ),
            const SizedBox(height: 30),

            // =========================
            // CONTACT US SECTION
            // =========================
            const Text(
              "Contact Us",
              style: TextStyle(
                  fontFamily: 'Poppins-Bold',
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
            ),
            const SizedBox(height: 12),
            Column(
              children: const [
                ContactCard(icon: Icons.phone, value: "+256 700 123 456"),
                SizedBox(height: 12),
                ContactCard(icon: Icons.phone_android, value: "+256 782 123 456"),
                SizedBox(height: 12),
                ContactCard(icon: Icons.email, value: "info@pureflowboda.org"),
              ],
            ),
            const SizedBox(height: 30),

            // APP VERSION
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
}

// =========================
// STATS CARD WIDGET
// =========================
class StatsCard extends StatelessWidget {
  final String title;
  final String value;

  const StatsCard({super.key, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          children: [
            Text(
              title,
              style: const TextStyle(
                fontFamily: 'Poppins-Regular',
                fontSize: 10,
                color: Colors.black54,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 6),
            Text(
              value,
              style: const TextStyle(
                fontFamily: 'Poppins-SemiBold',
                fontSize: 16,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// =========================
// CONTACT CARD WIDGET
// =========================
class ContactCard extends StatelessWidget {
  final IconData icon;
  final String value;

  const ContactCard({super.key, required this.icon, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, color: const Color.fromARGB(255, 16, 92, 177)),
          const SizedBox(width: 12),
          Text(
            value,
            style: const TextStyle(
              fontFamily: 'Poppins-SemiBold',
              fontSize: 16,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}