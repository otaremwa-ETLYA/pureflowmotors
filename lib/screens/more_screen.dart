import 'package:flutter/material.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:math';

class MoreScreen extends StatefulWidget {
  const MoreScreen({super.key});

  @override
  State<MoreScreen> createState() => _MoreScreenState();
}

class _MoreScreenState extends State<MoreScreen> {
    final List<String> videoIds = [
    'aIP0aQaxvZM',
    'GTkc1DXO6Zk',
    'QS8m2ngQSkk',
    'A6dmbTiBbMI',
  ];
  late YoutubePlayerController controller;

  @override
  void initState() {
    super.initState();
    final randomVideoId = videoIds[Random().nextInt(videoIds.length)];

    controller = YoutubePlayerController.fromVideoId(
      videoId: randomVideoId,
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

  Future<void> callNumber(String number) async {
    final Uri uri = Uri.parse("tel:$number");
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  Future<void> openWhatsApp(String number) async {
    final Uri uri = Uri.parse("https://wa.me/$number");
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
  toolbarHeight: 85, // taller AppBar
  backgroundColor: const Color.fromARGB(255, 16, 92, 177),
  elevation: 15, // subtle shadow
  shadowColor: Colors.black.withOpacity(0.3),
  shape: const RoundedRectangleBorder(
    borderRadius: BorderRadius.vertical(
      bottom: Radius.circular(10), // rounded bottom corners
    ),
  ),
  title: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisSize: MainAxisSize.min,
    children: const [
      Text(
        "Asset Financing",
        style: TextStyle(
          fontFamily: 'Poppins-Bold',
          fontWeight: FontWeight.bold,
          fontSize: 14,
          color: Colors.white,
        ),
      ),
      SizedBox(height: 2),
      Text(
        "Kingdom Initiatives Transforming Communities",
        style: TextStyle(
          fontFamily: 'Poppins-Regular',
          fontWeight: FontWeight.w400,
          fontSize: 14,
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
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(5),
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
  "Contact a Branch",
  style: TextStyle(
    fontFamily: 'Poppins-Bold',
    fontWeight: FontWeight.bold,
    fontSize: 14,
  ),
),
const SizedBox(height: 12),

Column(
  children: const [
    WhatsAppContactCard(branch: "Mbarara", number: "256755015732"),
    SizedBox(height: 12),
    WhatsAppContactCard(branch: "Ibanda", number: "256788146323"),
    SizedBox(height: 12),
    WhatsAppContactCard(branch: "Ishaka", number: "256789970658"),
    SizedBox(height: 12),
    WhatsAppContactCard(branch: "Ntungamo", number: "256706660271"),
    SizedBox(height: 12),
    WhatsAppContactCard(branch: "Rukungiri", number: "256774825245"),
    SizedBox(height: 12),
    WhatsAppContactCard(branch: "Kihihi", number: "256704171448"),
    SizedBox(height: 12),
    WhatsAppContactCard(branch: "Lyantonde", number: "256772997931"),
    SizedBox(height: 12),
    WhatsAppContactCard(branch: "Fort Portal", number: "256758240129"),
    SizedBox(height: 12),
    WhatsAppContactCard(branch: "Masaka", number: "256700742866"),
    SizedBox(height: 12),
    WhatsAppContactCard(branch: "Jinja", number: "256747658825"),
    SizedBox(height: 12),
    WhatsAppContactCard(branch: "Iganga", number: "256774681161"),
    SizedBox(height: 12),
    WhatsAppContactCard(branch: "Mukono", number: "256705780046"),
    SizedBox(height: 12),
    WhatsAppContactCard(branch: "Nansana", number: "256759554141"),
    SizedBox(height: 12),
    WhatsAppContactCard(branch: "Luwero", number: "256751792660"),
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
          borderRadius: BorderRadius.circular(5),
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
class WhatsAppContactCard extends StatelessWidget {
  final String branch;
  final String number;

  const WhatsAppContactCard({
    super.key,
    required this.branch,
    required this.number,
  });

  Future<void> openWhatsApp() async {
    final Uri uri = Uri.parse("https://wa.me/$number");
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: openWhatsApp,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5),
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
            // WhatsApp PNG Icon
            Image.asset(
              "lib/assets/icon/whatsapp.png", // <-- add your png here
              width: 28,
              height: 28,
            ),

            const SizedBox(width: 12),

            // Branch Name ONLY (no number)
            Text(
              branch,
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
