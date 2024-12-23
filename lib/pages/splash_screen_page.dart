// import 'dart:async';
// import 'package:firstapp/pages/login_page.dart';
// import 'package:flutter/material.dart';
// import 'dart:ui'; // For the blur effect

// class SplashScreenPage extends StatefulWidget {
//   const SplashScreenPage({super.key});

//   @override
//   State<SplashScreenPage> createState() => _SplashScreenPageState();
// }

// class _SplashScreenPageState extends State<SplashScreenPage> {
//   double _topPosition = 400.0; // Initially, the logo is at the center (top: 0)
//   double _scaleFactor = 0.3; // Initial size of the logo (smaller)
//   double _blurAmount = 300.0; // Initial blur
//   bool _isAnimating = false; // Flag to track animation status

//   @override
//   void initState() {
//     super.initState();

//     // Start showing the logo at the center, and after a short delay, start the animation
//     Timer(Duration(milliseconds: 150), () {
//       setState(() {
//         _isAnimating = true; // Trigger the animation
//         _topPosition = MediaQuery.of(context).size.height * 0.4; // Move logo down to 40% of the screen height
//         _scaleFactor = 1.5; // Enlarge the logo to its normal size
//         _blurAmount = 0.0; // Remove blur
//       });

//       // After the animation completes, navigate to the LoginPage after 3 more seconds
//       Timer(Duration(seconds: 3), () {
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(builder: (context) => LoginPage()),
//         );
//       });
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         children: [
//           // The animated logo position, size, and blur effect
//           AnimatedPositioned(
//             duration: Duration(seconds: 2), // Duration for the logo to move down
//             curve: Curves.easeInOut, // Smooth animation curve
//             top: _topPosition, // This value will change to move the logo down
//             left: MediaQuery.of(context).size.width / 2 - 90, // Center horizontally
//             child: Center(
//               child: AnimatedContainer(
//                 duration: Duration(seconds: 2), // Duration for size animation
//                 curve: Curves.easeInOut, // Smooth animation curve for size
//                 transform: Matrix4.identity()..scale(_scaleFactor), // Scale the logo size
//                 child: BackdropFilter(
//                   filter: ImageFilter.blur(
//                     sigmaX: _blurAmount, // Apply blur effect
//                     sigmaY: _blurAmount,
//                   ),
//                   child: Image.asset(
//                     'assets/images/tym_logo1.png', // Replace with your logo path
//                     width: 130, // Adjust the size of your logo
//                     height: 130,
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// import 'dart:async';
// import 'dart:math';
// import 'package:flutter/material.dart';
// import 'package:firstapp/pages/login_page.dart';

// class SplashScreenPage extends StatefulWidget {
//   const SplashScreenPage({super.key});

//   @override
//   State<SplashScreenPage> createState() => _SplashScreenPageState();
// }

// class _SplashScreenPageState extends State<SplashScreenPage>
//     with TickerProviderStateMixin {
//   late AnimationController _logoController;
//   late AnimationController _colorController;
//   late AnimationController _revealController;

//   @override
//   void initState() {
//     super.initState();

//     // Logo animation controller
//     _logoController = AnimationController(
//       vsync: this,
//       duration: Duration(seconds: 3),
//     )..forward();

//     // Color pulse animation controller
//     _colorController = AnimationController(
//       vsync: this,
//       duration: Duration(seconds: 8),
//     )..repeat(reverse: true);

//     // Circular reveal transition animation controller
//     _revealController = AnimationController(
//       vsync: this,
//       duration: Duration(seconds: 2),
//     );

//     // Navigate to LoginPage after splash screen
//     Timer(Duration(seconds: 5), () {
//       _revealController.forward();
//       Timer(Duration(milliseconds: 1000), () {
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(builder: (context) => LoginPage()),
//         );
//       });
//     });
//   }

//   @override
//   void dispose() {
//     _logoController.dispose();
//     _colorController.dispose();
//     _revealController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         children: [
//           // Dynamic Animated Gradient Background
//           Positioned.fill(
//             child: AnimatedGradientBackground(animation: _colorController),
//           ),

//           // Center Morphing Logo
//           Center(
//             child: AnimatedBuilder(
//               animation: _logoController,
//               builder: (context, child) {
//                 double scale = 1 + sin(_logoController.value * pi) * 0.3;
//                 return Transform.scale(
//                   scale: scale,
//                   child: Container(
//                     width: 150,
//                     height: 150,
//                     decoration: BoxDecoration(
//                       shape: BoxShape.circle,
//                       gradient: RadialGradient(
//                         colors: [
//                           Colors.blue.withOpacity(0.8),
//                           Colors.purple.withOpacity(0.5),
//                           Colors.transparent
//                         ],
//                         stops: [0.4, 0.6, 1],
//                       ),
//                     ),
//                     child: Image.asset(
//                       'assets/images/tym_logo1.png',
//                       fit: BoxFit.contain,
//                     ),
//                   ),
//                 );
//               },
//             ),
//           ),

//           // Circular Reveal Transition with Logo
//           AnimatedBuilder(
//             animation: _revealController,
//             builder: (context, child) {
//               return ClipOval(
//                 clipper: CircularRevealClipper(
//                   radius: _revealController.value *
//                       MediaQuery.of(context).size.width * 1.0,
//                 ),
//                 child: Transform.scale(
//                   scale: _revealController.value + 2, // Scale the logo during reveal
//                   child: Container(
//                     color: Colors.transparent, // No solid background
//                     child: Center(
//                       child: Image.asset(
//                         'assets/images/tym_logo1.png', // Same logo growing
//                         fit: BoxFit.contain,
//                       ),
//                     ),
//                   ),
//                 ),
//               );
//             },
//           ),
//         ],
//       ),
//     );
//   }
// }

// class AnimatedGradientBackground extends StatelessWidget {
//   final Animation<double> animation;

//   AnimatedGradientBackground({required this.animation});

//   @override
//   Widget build(BuildContext context) {
//     return AnimatedBuilder(
//       animation: animation,
//       builder: (context, child) {
//         return Container(
//           decoration: BoxDecoration(
//             gradient: LinearGradient(
//               colors: [
//                 Color.lerp(Colors.blue, Colors.purple, animation.value) ??
//                     Colors.blue,
//                 Color.lerp(Colors.pink, Colors.orange, animation.value) ??
//                     Colors.pink,
//               ],
//               begin: Alignment.topLeft,
//               end: Alignment.bottomRight,
//             ),
//           ),
//         );
//       },
//     );
//   }
// }

// class CircularRevealClipper extends CustomClipper<Rect> {
//   final double radius;

//   CircularRevealClipper({required this.radius});

//   @override
//   Rect getClip(Size size) {
//     return Rect.fromCircle(
//       center: Offset(size.width / 2, size.height / 2),
//       radius: radius,
//     );
//   }

//   @override
//   bool shouldReclip(CircularRevealClipper oldClipper) {
//     return radius != oldClipper.radius;
//   }
// }

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firstapp/pages/login_page.dart';

class SplashScreenPage extends StatefulWidget {
  const SplashScreenPage({super.key});

  @override
  State<SplashScreenPage> createState() => _SplashScreenPageState();
}

class _SplashScreenPageState extends State<SplashScreenPage>
    with TickerProviderStateMixin {
  late AnimationController _logoController;
  late AnimationController _fadeController;
  late AnimationController _textSlideController;
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();

    // Logo bounce animation controller
    _logoController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 3),
    )..repeat(reverse: true);

    // Fade transition animation controller
    _fadeController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 3),
    )..forward();

    // Text slide animation controller
    _textSlideController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    )..forward();

    // Pulse effect controller
    _pulseController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    )..repeat(reverse: true);

    // Navigate to LoginPage after splash screen
    Timer(Duration(seconds: 5), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    });
  }

  @override
  void dispose() {
    _logoController.dispose();
    _fadeController.dispose();
    _textSlideController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Solid Background Color
          Positioned.fill(
            child: Container(
              color: Colors.white,
            ),
          ),

          // Pulsating Background Circle
          Positioned(
            top: MediaQuery.of(context).size.height / 2 - 200,
            left: MediaQuery.of(context).size.width / 2 - 200,
            child: AnimatedBuilder(
              animation: _pulseController,
              builder: (context, child) {
                double scale = 1 + _pulseController.value * 0.5;
                return Transform.scale(
                  scale: scale,
                  child: Container(
                    width: 400,
                    height: 400,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.blue.withOpacity(0.2),
                    ),
                  ),
                );
              },
            ),
          ),

          // Center Animated Logo
          Center(
            child: AnimatedBuilder(
              animation: _logoController,
              builder: (context, child) {
                double scale = 1 + 0.05 * (1 - (_logoController.value - 0.5).abs() * 2);
                return Transform.scale(
                  scale: scale,
                  child: FadeTransition(
                    opacity: _fadeController,
                    child: Container(
                      // width: 150,
                      // height: 150,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            blurRadius: 10,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      //child: ClipOval(
                        child: Image.asset(
                          'assets/images/tym_logo1.png',
                          fit: BoxFit.cover,
                        ),
                      //),
                    ),
                  ),
                );
              },
            ),
          ),

          // Sliding App Name Below Logo
          Positioned(
            bottom: 120,
            left: 0,
            right: 0,
            child: AnimatedBuilder(
              animation: _textSlideController,
              builder: (context, child) {
                double slide = (1 - _textSlideController.value) * 50;
                return Transform.translate(
                  offset: Offset(0, slide),
                  child: Opacity(
                    opacity: _textSlideController.value,
                    child: Column(
                      children: [
                        Text(
                          'Welcome to TheTym',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Experience the Future of Convenience',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w300,
                            color: Colors.grey[700],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
