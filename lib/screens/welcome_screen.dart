import 'package:flutter/material.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoController;
  late AnimationController _contentController;

  late Animation<Offset> logoSlide;
  late Animation<double> logoFade;

  late Animation<Offset> contentSlide;
  late Animation<double> contentFade;

  @override
  void initState() {
    super.initState();

    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    logoSlide = Tween<Offset>(
      begin: const Offset(0.8, 0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.easeOutCubic),
    );

    logoFade = CurvedAnimation(parent: _logoController, curve: Curves.easeIn);

    _contentController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    contentSlide = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _contentController, curve: Curves.easeOutCubic),
    );

    contentFade = CurvedAnimation(
      parent: _contentController,
      curve: Curves.easeIn,
    );

    Future.delayed(const Duration(milliseconds: 350), () {
      _logoController.forward();
    });

    Future.delayed(const Duration(milliseconds: 950), () {
      _contentController.forward();
    });
  }

  @override
  void dispose() {
    _logoController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  void goToMain() {
    Navigator.pushReplacementNamed(context, '/main');
  }

  @override
  Widget build(BuildContext context) {
    const primaryBlue = Color.fromARGB(255, 16, 92, 177);

    return Scaffold(
  body: Stack(
    children: [
      /// 🌄 BACKGROUND IMAGE
      SizedBox.expand(
        child: Image.asset(
          'lib/assets/icon/welcome.png',
          fit: BoxFit.cover,
        ),
      ),

      // /// 🌫 OVERLAY (optional but helps readability)
      // Container(
      //   color: Colors.black.withOpacity(0.25),
      // ),

      /// 📄 CONTENT (BOTTOM LEFT ALIGNED)
      SafeArea(
        child: Align(
          alignment: Alignment.bottomLeft,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start, // 🔥 LEFT ALIGN EVERYTHING
              children: [
                /// 🔷 LOGO (TEXT-BASED → MUST BE LEFT ALIGNED)
               Container(
                width: double.infinity,
                alignment: Alignment.centerLeft,
                child: Transform.translate(
                  offset: Offset.zero,
                  child: FadeTransition(
                    opacity: logoFade,
                    child: SlideTransition(
                      position: logoSlide,
                      child: Image.asset(
                        'lib/assets/icon/pureflow_logo.png',
                        height: 22,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
              ),

                const SizedBox(height: 12),

                /// 🔷 DESCRIPTION
                FadeTransition(
                  opacity: contentFade,
                  child: SlideTransition(
                    position: contentSlide,
                    child: const Text(
                      "Transforming Communities and Growing Local Economies Through Asset Financing.",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontFamily: 'Poppins-Bold',
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 119, 119, 119),
                        height: 1.5,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                /// 🔵 GET STARTED BUTTON
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: goToMain,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 16, 92, 177),
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: const Text(
                      "Get Started",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                /// 🔗 CONTINUE TEXT
                GestureDetector(
  onTap: goToMain,
  child: Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      const Text(
        "Continue",
        style: TextStyle(
          color: Colors.black,
          fontSize: 15,
          fontWeight: FontWeight.w500,
        ),
      ),
      const SizedBox(width: 6),
      TweenAnimationBuilder<double>(
        tween: Tween(begin: 0, end: 6),
        duration: const Duration(milliseconds: 800),
        curve: Curves.easeInOut,
        builder: (context, value, child) {
          return Transform.translate(
            offset: Offset(value, 0),
            child: const Icon(
              Icons.arrow_forward_rounded,
              size: 18,
              color: Colors.black,
            ),
          );
        },
      ),
    ],
  ),
),
              ],
            ),
          ),
        ),
      ),
    ],
  ),
);
  }
}