import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:gogogrow/firebase_options.dart';
import 'dart:async';
import 'dart:math';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kids Welcome App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Comic Sans MS', // You can add this font to pubspec.yaml
      ),
      home: const WelcomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

// FIRST PAGE - Welcome Screen
class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with TickerProviderStateMixin {
  late AnimationController _floatingController;
  late AnimationController _scaleController;
  late Animation<double> _floatingAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    // Animation for floating emojis
    _floatingController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);

    _floatingAnimation = Tween<double>(begin: -10.0, end: 10.0).animate(
      CurvedAnimation(parent: _floatingController, curve: Curves.easeInOut),
    );

    // Animation for button scale effect
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _floatingController.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  void _onButtonPressed() {
    _scaleController.forward().then((_) {
      _scaleController.reverse();
    });

    // Navigate to name input page after animation
    Future.delayed(const Duration(milliseconds: 200), () {
      Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              const NameInputScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(1.0, 0.0);
            const end = Offset.zero;
            const curve = Curves.ease;

            var tween = Tween(
              begin: begin,
              end: end,
            ).chain(CurveTween(curve: curve));

            return SlideTransition(
              position: animation.drive(tween),
              child: child,
            );
          },
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF87CEEB), // Sky blue
              Color(0xFF98FB98), // Pale green
              Color(0xFFFFFFE0), // Light yellow
            ],
            stops: [0.0, 0.5, 1.0],
          ),
        ),
        child: Stack(
          children: [
            // Floating emojis
            AnimatedBuilder(
              animation: _floatingAnimation,
              builder: (context, child) {
                return Stack(
                  children: [
                    // Cat emoji - top left
                    Positioned(
                      top: 80 + _floatingAnimation.value,
                      left: 50,
                      child: const Text('🐱', style: TextStyle(fontSize: 40)),
                    ),
                    // Sun emoji - top right area
                    Positioned(
                      top: 280 + _floatingAnimation.value * 0.8,
                      right: 100,
                      child: const Text('☀️', style: TextStyle(fontSize: 45)),
                    ),
                    // Rainbow - right side
                    Positioned(
                      top: 150 - _floatingAnimation.value * 0.5,
                      right: 20,
                      child: const Text('🌈', style: TextStyle(fontSize: 35)),
                    ),
                    // Star - left side
                    Positioned(
                      top: 330 + _floatingAnimation.value * 1.2,
                      left: 80,
                      child: const Text('⭐', style: TextStyle(fontSize: 30)),
                    ),
                    // Cloud - left side
                    Positioned(
                      bottom: 200 + _floatingAnimation.value * 0.7,
                      left: 60,
                      child: const Text('☁️', style: TextStyle(fontSize: 35)),
                    ),
                    // Dog emoji - bottom right
                    Positioned(
                      bottom: 100 - _floatingAnimation.value,
                      right: 30,
                      child: const Text('🐶', style: TextStyle(fontSize: 40)),
                    ),
                    // Small stars scattered
                    Positioned(
                      top: 200 + _floatingAnimation.value * 0.3,
                      left: 200,
                      child: const Text('✨', style: TextStyle(fontSize: 20)),
                    ),
                    Positioned(
                      bottom: 300 - _floatingAnimation.value * 0.6,
                      right: 150,
                      child: const Text('💫', style: TextStyle(fontSize: 25)),
                    ),
                    // Help button - bottom right
                    Positioned(
                      bottom: 30,
                      right: 30,
                      child: Container(
                        width: 50,
                        height: 50,
                        decoration: const BoxDecoration(
                          color: Colors.black87,
                          shape: BoxShape.circle,
                        ),
                        child: const Center(
                          child: Text(
                            '?',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),

            // Main content
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Welcome text with shadow
                  Text(
                    'Welcome!',
                    style: TextStyle(
                      fontSize: 64,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          offset: const Offset(2, 2),
                          blurRadius: 4,
                          color: Colors.black.withOpacity(0.3),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Subtitle with emoji
                  const Text(
                    'Let\'s get to know you better! 😊',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  const SizedBox(height: 60),

                  // Animated gradient button
                  AnimatedBuilder(
                    animation: _scaleAnimation,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: _scaleAnimation.value,
                        child: GestureDetector(
                          onTap: _onButtonPressed,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 50,
                              vertical: 18,
                            ),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [
                                  Color(0xFFFF6B6B), // Coral red
                                  Color(0xFFFF8E8E), // Light coral
                                  Color(0xFFFFB6C1), // Light pink
                                  Color(0xFFDDA0DD), // Plum
                                ],
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                              ),
                              borderRadius: BorderRadius.circular(30),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  spreadRadius: 2,
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: const Text(
                              'Let\'s Start! 🚀',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
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
    );
  }
}

// SECOND PAGE - Name Input Screen
class NameInputScreen extends StatefulWidget {
  const NameInputScreen({super.key});

  @override
  State<NameInputScreen> createState() => _NameInputScreenState();
}

class _NameInputScreenState extends State<NameInputScreen>
    with TickerProviderStateMixin {
  late AnimationController _floatingController;
  late AnimationController _waveController;
  late AnimationController _cardController;
  late Animation<double> _floatingAnimation;
  late Animation<double> _waveAnimation;
  late Animation<double> _cardSlideAnimation;
  late Animation<double> _cardFadeAnimation;

  final TextEditingController _nameController = TextEditingController();
  bool _isNextEnabled = false;

  @override
  void initState() {
    super.initState();

    // Animation for floating emojis
    _floatingController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);

    _floatingAnimation = Tween<double>(begin: -10.0, end: 10.0).animate(
      CurvedAnimation(parent: _floatingController, curve: Curves.easeInOut),
    );

    // Animation for waving hand
    _waveController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    )..repeat(reverse: true);

    _waveAnimation = Tween<double>(begin: -0.2, end: 0.2).animate(
      CurvedAnimation(parent: _waveController, curve: Curves.easeInOut),
    );

    // Animation for card entrance
    _cardController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _cardSlideAnimation = Tween<double>(
      begin: 50.0,
      end: 0.0,
    ).animate(CurvedAnimation(parent: _cardController, curve: Curves.easeOut));

    _cardFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _cardController, curve: Curves.easeOut));

    // Start card entrance animation
    _cardController.forward();

    // Listen to text changes
    _nameController.addListener(() {
      setState(() {
        _isNextEnabled = _nameController.text.trim().isNotEmpty;
      });
    });
  }

  @override
  void dispose() {
    _floatingController.dispose();
    _waveController.dispose();
    _cardController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  void _onBackPressed() {
    Navigator.pop(context);
  }

  void _onNextPressed() {
    if (_isNextEnabled) {
      // Navigate to next page with the entered name
      Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              BirthdayPage(userName: _nameController.text.trim()),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(1.0, 0.0);
            const end = Offset.zero;
            const curve = Curves.ease;

            var tween = Tween(
              begin: begin,
              end: end,
            ).chain(CurveTween(curve: curve));

            return SlideTransition(
              position: animation.drive(tween),
              child: child,
            );
          },
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF20B2AA), // Light sea green
              Color(0xFF40E0D0), // Turquoise
              Color(0xFF48D1CC), // Medium turquoise
            ],
          ),
        ),
        child: Stack(
          children: [
            // Floating emojis
            AnimatedBuilder(
              animation: _floatingAnimation,
              builder: (context, child) {
                return Stack(
                  children: [
                    // Cat emoji - top left
                    Positioned(
                      top: 80 + _floatingAnimation.value,
                      left: 50,
                      child: const Text('🐱', style: TextStyle(fontSize: 40)),
                    ),
                    // Rainbow - top right
                    Positioned(
                      top: 150 - _floatingAnimation.value * 0.5,
                      right: 20,
                      child: const Text('🌈', style: TextStyle(fontSize: 35)),
                    ),
                    // Star - left side
                    Positioned(
                      top: 330 + _floatingAnimation.value * 1.2,
                      left: 80,
                      child: const Text('⭐', style: TextStyle(fontSize: 30)),
                    ),
                    // Cloud - left side
                    Positioned(
                      bottom: 200 + _floatingAnimation.value * 0.7,
                      left: 60,
                      child: const Text('☁️', style: TextStyle(fontSize: 35)),
                    ),
                    // Dog emoji - bottom right
                    Positioned(
                      bottom: 100 - _floatingAnimation.value,
                      right: 30,
                      child: const Text('🐶', style: TextStyle(fontSize: 40)),
                    ),
                    // Small stars scattered
                    Positioned(
                      bottom: 300 - _floatingAnimation.value * 0.6,
                      right: 150,
                      child: const Text('💫', style: TextStyle(fontSize: 25)),
                    ),
                    // Help button - bottom right
                    Positioned(
                      bottom: 30,
                      right: 30,
                      child: Container(
                        width: 50,
                        height: 50,
                        decoration: const BoxDecoration(
                          color: Colors.black87,
                          shape: BoxShape.circle,
                        ),
                        child: const Center(
                          child: Text(
                            '?',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),

            // Main content - Card
            Center(
              child: AnimatedBuilder(
                animation: _cardController,
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(0, _cardSlideAnimation.value),
                    child: Opacity(
                      opacity: _cardFadeAnimation.value,
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 40),
                        padding: const EdgeInsets.all(30),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(25),
                          border: Border.all(
                            color: const Color(0xFFFFD700), // Gold border
                            width: 3,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.15),
                              spreadRadius: 5,
                              blurRadius: 15,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Waving hand with animation
                            AnimatedBuilder(
                              animation: _waveAnimation,
                              builder: (context, child) {
                                return Transform.rotate(
                                  angle: _waveAnimation.value,
                                  child: const Text(
                                    '👋',
                                    style: TextStyle(fontSize: 50),
                                  ),
                                );
                              },
                            ),

                            const SizedBox(height: 20),

                            // Title
                            const Text(
                              'Hi there!',
                              style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF2C3E50), // Dark blue-gray
                              ),
                            ),

                            const SizedBox(height: 10),

                            // Subtitle
                            const Text(
                              'What should we call you?',
                              style: TextStyle(
                                fontSize: 18,
                                color: Color(0xFF7F8C8D), // Gray
                                fontWeight: FontWeight.w500,
                              ),
                            ),

                            const SizedBox(height: 30),

                            // Label
                            const Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'Your Name',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Color(0xFF2C3E50),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),

                            const SizedBox(height: 10),

                            // Name input field
                            Container(
                              decoration: BoxDecoration(
                                color: const Color(
                                  0xFFF8F9FA,
                                ), // Light gray background
                                borderRadius: BorderRadius.circular(25),
                                border: Border.all(
                                  color: const Color(
                                    0xFFE9ECEF,
                                  ), // Light border
                                  width: 1,
                                ),
                              ),
                              child: TextField(
                                controller: _nameController,
                                decoration: const InputDecoration(
                                  hintText: 'What\'s your name? 😊',
                                  hintStyle: TextStyle(
                                    color: Color(0xFFADB5BD),
                                    fontSize: 16,
                                  ),
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 15,
                                  ),
                                ),
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Color(0xFF2C3E50),
                                ),
                              ),
                            ),

                            const SizedBox(height: 40),

                            // Buttons row
                            Row(
                              children: [
                                // Back button
                                Expanded(
                                  child: GestureDetector(
                                    onTap: _onBackPressed,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 15,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(25),
                                        border: Border.all(
                                          color: const Color(0xFFDEE2E6),
                                          width: 2,
                                        ),
                                      ),
                                      child: const Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.arrow_back,
                                            color: Color(0xFF6C757D),
                                            size: 20,
                                          ),
                                          SizedBox(width: 8),
                                          Text(
                                            'Back',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                              color: Color(0xFF6C757D),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),

                                const SizedBox(width: 15),

                                // Next button
                                Expanded(
                                  child: GestureDetector(
                                    onTap: _isNextEnabled
                                        ? _onNextPressed
                                        : null,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 15,
                                      ),
                                      decoration: BoxDecoration(
                                        gradient: _isNextEnabled
                                            ? const LinearGradient(
                                                colors: [
                                                  Color(0xFF56AB2F), // Green
                                                  Color(0xFF56CCF2), // Blue
                                                ],
                                                begin: Alignment.centerLeft,
                                                end: Alignment.centerRight,
                                              )
                                            : null,
                                        color: _isNextEnabled
                                            ? null
                                            : const Color(0xFFE9ECEF),
                                        borderRadius: BorderRadius.circular(25),
                                        boxShadow: _isNextEnabled
                                            ? [
                                                BoxShadow(
                                                  color: Colors.black
                                                      .withOpacity(0.1),
                                                  spreadRadius: 1,
                                                  blurRadius: 8,
                                                  offset: const Offset(0, 2),
                                                ),
                                              ]
                                            : null,
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            'Next!',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: _isNextEnabled
                                                  ? Colors.white
                                                  : const Color(0xFFADB5BD),
                                            ),
                                          ),
                                          const SizedBox(width: 5),
                                          Text(
                                            '🚀',
                                            style: TextStyle(
                                              fontSize: 16,
                                              color: _isNextEnabled
                                                  ? Colors.white
                                                  : const Color(0xFFADB5BD),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// THIRD PAGE - Birthday Input Page
class BirthdayPage extends StatefulWidget {
  final String userName;
  const BirthdayPage({super.key, required this.userName});

  @override
  State<BirthdayPage> createState() => _BirthdayPageState();
}

class _BirthdayPageState extends State<BirthdayPage> {
  String selectedMonth = 'Jan';
  int selectedDay = 1;
  int selectedYear = 2020;

  final List<String> months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];

  final List<int> days = List.generate(31, (index) => index + 1);
  final List<int> years = List.generate(100, (index) => 2024 - index);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF98E4A6), Color(0xFF7BD88F)],
          ),
        ),
        child: Stack(
          children: [
            // Background decorative elements
            Positioned(
              top: 80,
              left: 30,
              child: Container(
                width: 35,
                height: 35,
                decoration: BoxDecoration(
                  color: Colors.orange.shade400,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Center(
                  child: Text('🐱', style: TextStyle(fontSize: 18)),
                ),
              ),
            ),
            Positioned(
              top: 100,
              right: 40,
              child: Container(
                width: 40,
                height: 20,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.red.shade300,
                      Colors.orange.shade300,
                      Colors.yellow.shade300,
                      Colors.green.shade300,
                      Colors.blue.shade300,
                      Colors.purple.shade300,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            Positioned(
              top: 180,
              left: 50,
              child: Container(
                width: 15,
                height: 15,
                decoration: BoxDecoration(
                  color: Colors.yellow.shade400,
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Positioned(
              bottom: 150,
              left: 40,
              child: Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: Colors.purple.shade200,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Center(
                  child: Text('💎', style: TextStyle(fontSize: 14)),
                ),
              ),
            ),
            Positioned(
              bottom: 100,
              right: 50,
              child: Container(
                width: 35,
                height: 35,
                decoration: BoxDecoration(
                  color: Colors.pink.shade200,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Center(
                  child: Text('🐶', style: TextStyle(fontSize: 16)),
                ),
              ),
            ),
            Positioned(
              bottom: 180,
              right: 60,
              child: Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: Colors.pink.shade300,
                  shape: BoxShape.circle,
                ),
              ),
            ),

            // Main content
            Center(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 30),
                padding: const EdgeInsets.all(30),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Cake icon
                    Container(
                      width: 60,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.orange.shade200,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Center(
                        child: Text('🎂', style: TextStyle(fontSize: 30)),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Title
                    const Text(
                      'Birthday Time!',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF333333),
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Subtitle
                    const Text(
                      'When were you born?',
                      style: TextStyle(fontSize: 16, color: Color(0xFF666666)),
                    ),
                    const SizedBox(height: 30),

                    // Dropdown labels
                    const Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Month',
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xFF666666),
                            ),
                          ),
                        ),
                        SizedBox(width: 15),
                        Expanded(
                          child: Text(
                            'Day',
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xFF666666),
                            ),
                          ),
                        ),
                        SizedBox(width: 15),
                        Expanded(
                          child: Text(
                            'Year',
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xFF666666),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    // Dropdown row
                    Row(
                      children: [
                        // Month dropdown
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF8F8F8),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: const Color(0xFFE0E0E0),
                              ),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                value: selectedMonth,
                                isExpanded: true,
                                items: months.map((String month) {
                                  return DropdownMenuItem<String>(
                                    value: month,
                                    child: Text(
                                      month,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        color: Color(0xFF333333),
                                      ),
                                    ),
                                  );
                                }).toList(),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    selectedMonth = newValue!;
                                  });
                                },
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 15),

                        // Day dropdown
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF8F8F8),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: const Color(0xFFE0E0E0),
                              ),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<int>(
                                value: selectedDay,
                                isExpanded: true,
                                items: days.map((int day) {
                                  return DropdownMenuItem<int>(
                                    value: day,
                                    child: Text(
                                      day.toString(),
                                      style: const TextStyle(
                                        fontSize: 16,
                                        color: Color(0xFF333333),
                                      ),
                                    ),
                                  );
                                }).toList(),
                                onChanged: (int? newValue) {
                                  setState(() {
                                    selectedDay = newValue!;
                                  });
                                },
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 15),

                        // Year dropdown
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF8F8F8),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: const Color(0xFFE0E0E0),
                              ),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<int>(
                                value: selectedYear,
                                isExpanded: true,
                                items: years.map((int year) {
                                  return DropdownMenuItem<int>(
                                    value: year,
                                    child: Text(
                                      year.toString(),
                                      style: const TextStyle(
                                        fontSize: 16,
                                        color: Color(0xFF333333),
                                      ),
                                    ),
                                  );
                                }).toList(),
                                onChanged: (int? newValue) {
                                  setState(() {
                                    selectedYear = newValue!;
                                  });
                                },
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 40),

                    // Buttons row
                    Row(
                      children: [
                        // Back button
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              side: const BorderSide(color: Color(0xFFE0E0E0)),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                            ),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.arrow_back_ios,
                                  size: 16,
                                  color: Color(0xFF666666),
                                ),
                                SizedBox(width: 5),
                                Text(
                                  'Back',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Color(0xFF666666),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 15),

                        // Next button
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              // Navigate to next page
                              // Replace 'NextPage()' with your actual next page widget
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => GenderSelectionPage(
                                    selectedMonth: selectedMonth,
                                    selectedDay: selectedDay,
                                    selectedYear: selectedYear,
                                  ),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFB794F6),
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                              elevation: 0,
                            ),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Next',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(width: 5),
                                Icon(
                                  Icons.arrow_forward_ios,
                                  size: 16,
                                  color: Colors.white,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// FOURTH PAGE
class GenderSelectionPage extends StatefulWidget {
  final String selectedMonth;
  final int selectedDay;
  final int selectedYear;

  const GenderSelectionPage({
    Key? key,
    required this.selectedMonth,
    required this.selectedDay,
    required this.selectedYear,
  }) : super(key: key);

  @override
  State<GenderSelectionPage> createState() => _GenderSelectionPageState();
}

class _GenderSelectionPageState extends State<GenderSelectionPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFE8D5FF), Color(0xFFFFE4D6)],
          ),
        ),
        child: Stack(
          children: [
            // Background decorative elements
            Positioned(
              top: 80,
              left: 30,
              child: Container(
                width: 35,
                height: 35,
                decoration: BoxDecoration(
                  color: Colors.orange.shade400,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Center(
                  child: Text('🐱', style: TextStyle(fontSize: 18)),
                ),
              ),
            ),
            Positioned(
              top: 100,
              right: 40,
              child: Container(
                width: 40,
                height: 20,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.red.shade300,
                      Colors.orange.shade300,
                      Colors.yellow.shade300,
                      Colors.green.shade300,
                      Colors.blue.shade300,
                      Colors.purple.shade300,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            Positioned(
              bottom: 100,
              right: 50,
              child: Container(
                width: 35,
                height: 35,
                decoration: BoxDecoration(
                  color: Colors.pink.shade200,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Center(
                  child: Text('🐶', style: TextStyle(fontSize: 16)),
                ),
              ),
            ),

            // Main content
            Center(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 30),
                padding: const EdgeInsets.all(30),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFF7BD88F), width: 3),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Family icon
                    Container(
                      width: 70,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.orange.shade100,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Center(
                        child: Text(
                          '👨‍👩‍👧‍👦',
                          style: TextStyle(fontSize: 25),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Title
                    const Text(
                      'Almost Done!',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF333333),
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Subtitle
                    const Text(
                      'Are you a boy or a girl?',
                      style: TextStyle(fontSize: 16, color: Color(0xFF666666)),
                    ),
                    const SizedBox(height: 40),

                    // I'm a Boy! button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          _navigateToNextPage('boy');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF4FC3F7),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 2,
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('😊', style: TextStyle(fontSize: 20)),
                            SizedBox(width: 10),
                            Text(
                              "I'm a Boy!",
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),

                    // I'm a Girl! button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          _navigateToNextPage('girl');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFF69B4),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 2,
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('😊', style: TextStyle(fontSize: 20)),
                            SizedBox(width: 10),
                            Text(
                              "I'm a Girl!",
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),

                    // Back button
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          side: const BorderSide(color: Color(0xFFE0E0E0)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.arrow_back_ios,
                              size: 16,
                              color: Color(0xFF666666),
                            ),
                            SizedBox(width: 5),
                            Text(
                              'Back',
                              style: TextStyle(
                                fontSize: 16,
                                color: Color(0xFF666666),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToNextPage(String gender) {
    // Retrieve the previous route arguments if available
    String userName = '';
    final previousRoute = ModalRoute.of(context);
    if (previousRoute != null && previousRoute.settings.arguments != null) {
      userName = previousRoute.settings.arguments as String;
    }
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => DashboardPage(
          userName: userName,
          selectedMonth: widget.selectedMonth,
          selectedDay: widget.selectedDay,
          selectedYear: widget.selectedYear,
          selectedGender: gender,
        ),
      ),
    );
  }
}

// Placeholder for the final page - replace with your actual final page

class DashboardPage extends StatelessWidget {
  final String userName;
  final int selectedDay;
  final String selectedMonth;
  final int selectedYear;
  final String selectedGender;
  const DashboardPage({
    Key? key,
    required this.userName,
    required this.selectedDay,
    required this.selectedMonth,
    required this.selectedYear,
    required this.selectedGender,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFFFF8E1), // Light cream
              Color(0xFFFFECB3), // Light yellow
              Color(0xFFFFF3E0), // Very light orange
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),

                // Greeting section
                Row(
                  children: [
                    const Text('☀', style: TextStyle(fontSize: 28)),
                    const SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Hi $userName! 👋',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        const Text(
                          'What do you want to do now?',
                          style: TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // Progress Card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Text(
                            "Today's Growth Progress",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Text('⌛', style: TextStyle(fontSize: 16)),
                        ],
                      ),
                      const SizedBox(height: 12),
                      // Progress bar
                      Container(
                        width: double.infinity,
                        height: 8,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: FractionallySizedBox(
                          alignment: Alignment.centerLeft,
                          widthFactor: 0.6,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        '60% Complete   Keep going!',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Activity Cards
                Expanded(
                  child: Column(
                    children: [
                      // Brush Teeth
                      _buildActivityCard(
                        context,
                        title: 'Brush Teeth',
                        subtitle: 'Keep those teeth sparkling!',
                        icon: '🪥',
                        color: const Color(0xFF81D4FA),
                        onTap: () =>
                            _navigateToActivity(context, 'Brush Teeth'),
                      ),

                      const SizedBox(height: 12),

                      // Eat Healthy
                      _buildActivityCard(
                        context,
                        title: 'Eat Healthy',
                        subtitle: 'Fuel your body with good food',
                        icon: '🍎',
                        color: const Color(0xFF7ED321),
                        onTap: () =>
                            _navigateToActivity(context, 'Eat Healthy'),
                      ),

                      const SizedBox(height: 12),

                      // Calm Mind
                      _buildActivityCard(
                        context,
                        title: 'Calm Mind',
                        subtitle: 'Take a moment to breathe!',
                        icon: '🧘',
                        color: const Color(0xFFB39DDB),
                        onTap: () => _navigateToActivity(context, 'Calm Mind'),
                      ),

                      const SizedBox(height: 12),

                      // Time Clock
                      _buildActivityCard(
                        context,
                        title: 'Time Clock',
                        subtitle: 'Learn about time!',
                        icon: '🕐',
                        color: const Color(0xFFFFCC80),
                        onTap: () => _navigateToActivity(context, 'Time Clock'),
                      ),

                      const SizedBox(height: 12),

                      // Mini Game
                      _buildActivityCard(
                        context,
                        title: 'Mini Game',
                        subtitle: 'Fun games to play!',
                        icon: '🎮',
                        color: const Color(0xFFFF8A80),
                        onTap: () => _navigateToActivity(context, 'Mini Game'),
                      ),
                      // Parent Dashboard
                      const SizedBox(height: 10),
                      _buildActivityCard(
                        context,
                        title: 'Child Activities Overview',
                        subtitle: 'Progress on activities',
                        icon: '👪',
                        color: const Color.fromARGB(255, 53, 231, 201),
                        onTap: () => _navigateToActivity(
                          context,
                          'Child Activities Overview',
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // Bottom decoration
                const Center(child: Text('🌸', style: TextStyle(fontSize: 24))),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActivityCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required String icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Container(
      width: double.infinity,
      height: 60,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.black87,
          elevation: 2,
          shadowColor: Colors.black.withOpacity(0.1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16),
        ),
        child: Row(
          children: [
            Text(icon, style: const TextStyle(fontSize: 24)),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: const TextStyle(fontSize: 12, color: Colors.black54),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Colors.black54,
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToActivity(BuildContext context, String activity) {
    if (activity == 'Mini Game') {
      // Navigate to the Bubble Pop Game
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const BubblePopGame()),
      );
    } else if (activity == 'Eat Healthy') {
      // Navigate to the Brush Teeth interface
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const EatHealthyInterface()),
      );
    } else {
      // For other activities, navigate to the Parent Dashboard
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ParentDashboardPage(activity: activity),
        ),
      );
    }
  }
}

// Sample activity page (replace with your actual activity pages)
// Update the Eat Healthy card in HomeDashboardPage to navigate to this new interface
class EatHealthyInterface extends StatefulWidget {
  const EatHealthyInterface({Key? key}) : super(key: key);

  @override
  State<EatHealthyInterface> createState() => _EatHealthyInterfaceState();
}

class _EatHealthyInterfaceState extends State<EatHealthyInterface>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int selectedFoodIndex = -1;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF81C784), // Light green
              Color(0xFFA5D6A7), // Lighter green
              Color(0xFFE8F5E8), // Very light green
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.arrow_back,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '🍎 Eat Healthy! 🥕',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            'Learn about nutritious foods!',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Tab Bar
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: TabBar(
                  controller: _tabController,
                  indicator: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: const Color(0xFF66BB6A),
                  ),
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.grey,
                  labelStyle: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                  tabs: const [
                    Tab(text: '🔍 Detector'),
                    Tab(text: '📚 Learn'),
                    Tab(text: '🍽 Good Foods'),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Tab Content
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildNutritionDetector(),
                    _buildFoodHabitsLearning(),
                    _buildGoodFoodsGrid(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNutritionDetector() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          // Detector Card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              children: [
                const Text(
                  '🔍 Food Nutrition Detector',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F5F5),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: Colors.grey.shade300,
                      style: BorderStyle.solid,
                      width: 2,
                    ),
                  ),
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.camera_alt, size: 48, color: Colors.grey),
                      SizedBox(height: 12),
                      Text(
                        'Take a photo of your food!',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'I\'ll tell you if it\'s healthy! 😊',
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => _showNutritionResult('Camera'),
                        icon: const Icon(Icons.camera_alt),
                        label: const Text('Camera'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF66BB6A),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => _showNutritionResult('Gallery'),
                        icon: const Icon(Icons.photo_library),
                        label: const Text('Gallery'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF42A5F5),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Quick Analysis Cards
          const Text(
            'Quick Food Analysis! 🚀',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 12),

          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 1.2,
            children: [
              _buildQuickAnalysisCard(
                '🍎',
                'Apple',
                'Super Healthy!',
                Colors.red.shade100,
              ),
              _buildQuickAnalysisCard(
                '🍔',
                'Burger',
                'Sometimes Food',
                Colors.orange.shade100,
              ),
              _buildQuickAnalysisCard(
                '🥕',
                'Carrot',
                'Very Healthy!',
                Colors.orange.shade100,
              ),
              _buildQuickAnalysisCard(
                '🍭',
                'Candy',
                'Treat Food',
                Colors.pink.shade100,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickAnalysisCard(
    String emoji,
    String food,
    String status,
    Color color,
  ) {
    return GestureDetector(
      onTap: () => _showDetailedNutrition(food, emoji, status),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(emoji, style: const TextStyle(fontSize: 32)),
            const SizedBox(height: 8),
            Text(
              food,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            Text(
              status,
              style: const TextStyle(fontSize: 12, color: Colors.black54),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFoodHabitsLearning() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Fun Facts Section
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '🌟 Fun Food Facts!',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 16),
                _buildFactCard(
                  '🥕 Carrots help you see better in the dark!',
                  Colors.orange.shade100,
                ),
                const SizedBox(height: 8),
                _buildFactCard(
                  '🍌 Bananas make you happy and give you energy!',
                  Colors.yellow.shade100,
                ),
                const SizedBox(height: 8),
                _buildFactCard(
                  '🥛 Milk makes your bones super strong!',
                  Colors.blue.shade100,
                ),
                const SizedBox(height: 8),
                _buildFactCard(
                  '🍎 An apple a day keeps the doctor away!',
                  Colors.red.shade100,
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Good Habits Section
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '✨ Super Healthy Habits!',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 16),
                _buildHabitCard('1. Eat 5 colors every day! 🌈', '🎨'),
                _buildHabitCard('2. Drink lots of water! 💧', '💦'),
                _buildHabitCard('3. Eat slowly and chew well! 😋', '🍽'),
                _buildHabitCard('4. Try new foods! 🆕', '🥗'),
                _buildHabitCard('5. Eat with family! 👨‍👩‍👧‍👦', '❤'),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Interactive Quiz
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.purple.shade100,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                const Text(
                  '🧠 Food Quiz Time!',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Which food gives you the most energy?',
                  style: TextStyle(fontSize: 16, color: Colors.black87),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildQuizOption('🍌', 'Banana', true),
                    _buildQuizOption('🍭', 'Candy', false),
                    _buildQuizOption('🥤', 'Soda', false),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFactCard(String fact, Color color) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        fact,
        style: const TextStyle(
          fontSize: 14,
          color: Colors.black87,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildHabitCard(String habit, String emoji) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 20)),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              habit,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black87,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuizOption(String emoji, String text, bool isCorrect) {
    return GestureDetector(
      onTap: () => _showQuizResult(isCorrect, text),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 24)),
            const SizedBox(height: 4),
            Text(
              text,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGoodFoodsGrid() {
    final goodFoods = [
      {
        'emoji': '🍎',
        'name': 'Apple',
        'benefit': 'Vitamins & Fiber',
        'color': Colors.red.shade100,
      },
      {
        'emoji': '🥕',
        'name': 'Carrot',
        'benefit': 'Good for Eyes',
        'color': Colors.orange.shade100,
      },
      {
        'emoji': '🍌',
        'name': 'Banana',
        'benefit': 'Energy & Potassium',
        'color': Colors.yellow.shade100,
      },
      {
        'emoji': '🥛',
        'name': 'Milk',
        'benefit': 'Strong Bones',
        'color': Colors.blue.shade50,
      },
      {
        'emoji': '🥬',
        'name': 'Spinach',
        'benefit': 'Iron & Strength',
        'color': Colors.green.shade100,
      },
      {
        'emoji': '🍓',
        'name': 'Strawberry',
        'benefit': 'Vitamin C',
        'color': Colors.pink.shade100,
      },
      {
        'emoji': '🥦',
        'name': 'Broccoli',
        'benefit': 'Super Veggie',
        'color': Colors.green.shade200,
      },
      {
        'emoji': '🐟',
        'name': 'Fish',
        'benefit': 'Brain Food',
        'color': Colors.cyan.shade100,
      },
      {
        'emoji': '🥜',
        'name': 'Nuts',
        'benefit': 'Healthy Fats',
        'color': Colors.brown.shade100,
      },
      {
        'emoji': '🍇',
        'name': 'Grapes',
        'benefit': 'Antioxidants',
        'color': Colors.purple.shade100,
      },
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '🌟 Super Foods for Super Kids!',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 1.1,
            ),
            itemCount: goodFoods.length,
            itemBuilder: (context, index) {
              final food = goodFoods[index];
              return GestureDetector(
                onTap: () {
                  setState(() {
                    selectedFoodIndex = selectedFoodIndex == index ? -1 : index;
                  });
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  transform: Matrix4.identity()
                    ..scale(selectedFoodIndex == index ? 1.05 : 1.0),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: food['color'] as Color,
                    borderRadius: BorderRadius.circular(16),
                    border: selectedFoodIndex == index
                        ? Border.all(color: Colors.green, width: 3)
                        : null,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: selectedFoodIndex == index ? 8 : 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        food['emoji'] as String,
                        style: const TextStyle(fontSize: 40),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        food['name'] as String,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        food['benefit'] as String,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.black54,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      if (selectedFoodIndex == index)
                        const Padding(
                          padding: EdgeInsets.only(top: 8.0),
                          child: Text(
                            '⭐ Great Choice!',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  void _showNutritionResult(String source) {
    final results = [
      'This looks like an apple! 🍎\nSuper healthy choice! ⭐⭐⭐⭐⭐',
      'I see a banana! �banana\nGreat for energy! ⭐⭐⭐⭐',
      'That\'s broccoli! 🥦\nSuper veggie power! ⭐⭐⭐⭐⭐',
      'Looks like cookies! 🍪\nTreat food - enjoy in moderation! ⭐⭐',
    ];

    final random = Random();
    final result = results[random.nextInt(results.length)];

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text('🔍 Nutrition Analysis'),
          content: Text(
            result,
            style: const TextStyle(fontSize: 16),
            textAlign: TextAlign.center,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cool! 😊'),
            ),
          ],
        );
      },
    );
  }

  void _showDetailedNutrition(String food, String emoji, String status) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text('$emoji $food'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Health Status: $status',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Nutritional Benefits:',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                _getNutritionalInfo(food),
                style: const TextStyle(fontSize: 14),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Thanks! 😊'),
            ),
          ],
        );
      },
    );
  }

  String _getNutritionalInfo(String food) {
    switch (food.toLowerCase()) {
      case 'apple':
        return 'Rich in fiber and vitamin C!\nHelps keep you full and healthy! 🍎';
      case 'burger':
        return 'Has protein but also high in fat.\nEnjoy occasionally! 🍔';
      case 'carrot':
        return 'Full of beta-carotene for good eyesight!\nCrunchy and sweet! 🥕';
      case 'candy':
        return 'High in sugar - gives quick energy.\nSave for special treats! 🍭';
      default:
        return 'Every food has its place in a balanced diet! 😊';
    }
  }

  void _showQuizResult(bool isCorrect, String choice) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text(isCorrect ? '🎉 Correct!' : '🤔 Try Again!'),
          content: Text(
            isCorrect
                ? 'Yes! Bananas are packed with natural sugars and potassium for quick, healthy energy! 🍌⚡'
                : 'Good try! Bananas are actually the best choice for natural energy! 🍌',
            textAlign: TextAlign.center,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Got it! 😊'),
            ),
          ],
        );
      },
    );
  }
}

// Bubble Pop Mini Game for Kids
class BubblePopGame extends StatefulWidget {
  const BubblePopGame({Key? key}) : super(key: key);

  @override
  State<BubblePopGame> createState() => _BubblePopGameState();
}

class _BubblePopGameState extends State<BubblePopGame>
    with TickerProviderStateMixin {
  List<Bubble> bubbles = [];
  int score = 0;
  Timer? gameTimer;
  Timer? bubbleTimer;
  final Random random = Random();
  late AnimationController animationController;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    startGame();
  }

  void startGame() {
    // Add bubbles periodically
    bubbleTimer = Timer.periodic(const Duration(milliseconds: 1000), (timer) {
      if (mounted) {
        addBubble();
      }
    });

    // Remove bubbles that go off screen
    gameTimer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      if (mounted) {
        setState(() {
          bubbles.removeWhere(
            (bubble) => bubble.y > MediaQuery.of(context).size.height,
          );
        });
      }
    });
  }

  void addBubble() {
    final screenWidth = MediaQuery.of(context).size.width;
    setState(() {
      bubbles.add(
        Bubble(
          x: random.nextDouble() * (screenWidth - 60),
          y: -50,
          color: Colors.primaries[random.nextInt(Colors.primaries.length)],
          size: 40 + random.nextDouble() * 30,
        ),
      );
    });
  }

  void popBubble(int index) {
    setState(() {
      bubbles.removeAt(index);
      score += 10;
    });

    // Play pop animation
    animationController.forward().then((_) {
      animationController.reset();
    });
  }

  @override
  void dispose() {
    gameTimer?.cancel();
    bubbleTimer?.cancel();
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF87CEEB), // Sky blue
              Color(0xFF98FB98), // Pale green
            ],
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              // Game Area
              Positioned.fill(
                child: Stack(
                  children: bubbles.asMap().entries.map((entry) {
                    int index = entry.key;
                    Bubble bubble = entry.value;

                    return AnimatedPositioned(
                      duration: const Duration(milliseconds: 100),
                      left: bubble.x,
                      top: bubble.y += 2, // Move bubbles down
                      child: GestureDetector(
                        onTap: () => popBubble(index),
                        child: Container(
                          width: bubble.size,
                          height: bubble.size,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: bubble.color.withOpacity(0.7),
                            border: Border.all(color: Colors.white, width: 3),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.white.withOpacity(0.5),
                                blurRadius: 10,
                                offset: const Offset(0, 0),
                              ),
                            ],
                          ),
                          child: Center(
                            child: Text(
                              '✨',
                              style: TextStyle(fontSize: bubble.size * 0.3),
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),

              // Header with score and back button
              Positioned(
                top: 20,
                left: 20,
                right: 20,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.arrow_back,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text('🏆', style: TextStyle(fontSize: 20)),
                          const SizedBox(width: 8),
                          Text(
                            'Score: $score',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Game Instructions
              if (bubbles.isEmpty && score == 0)
                Positioned(
                  bottom: 100,
                  left: 20,
                  right: 20,
                  child: Center(
                    child: Container(
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '🫧 Bubble Pop Game! 🫧',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Tap the bubbles to pop them and earn points!',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 16, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class Bubble {
  double x;
  double y;
  final Color color;
  final double size;

  Bubble({
    required this.x,
    required this.y,
    required this.color,
    required this.size,
  });
}

class ParentDashboardPage extends StatelessWidget {
  final String activity;
  const ParentDashboardPage({super.key, required this.activity});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F8F5), // Light green background
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: TextButton.icon(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios,
            size: 16,
            color: Colors.black54,
          ),
          label: const Text(
            'Back to App',
            style: TextStyle(fontSize: 14, color: Colors.black54),
          ),
        ),
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Child Activities Overview',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            Text('👨‍👩‍👧‍👦', style: TextStyle(fontSize: 16)),
          ],
        ),
        centerTitle: true,
        actions: [
          Container(width: 80), // Balance the leading width
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Progress Overview Section
            _buildSectionHeader('It\'s Progress Overview', '👏'),
            const SizedBox(height: 16),

            // Daily Average and Habits Today Cards
            Row(
              children: [
                // Daily Average Card
                Expanded(
                  child: Container(
                    height: 120,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8F4FD),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('📊', style: TextStyle(fontSize: 24)),
                        SizedBox(height: 8),
                        Text(
                          'Daily Average',
                          style: TextStyle(fontSize: 12, color: Colors.black54),
                        ),
                        SizedBox(height: 4),
                        Text(
                          '87%',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2196F3),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(width: 16),

                // Habits Today Card
                Expanded(
                  child: Container(
                    height: 120,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8F5E8),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('✅', style: TextStyle(fontSize: 24)),
                        SizedBox(height: 8),
                        Text(
                          'Habits Today',
                          style: TextStyle(fontSize: 12, color: Colors.black54),
                        ),
                        SizedBox(height: 4),
                        Text(
                          '3/5',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF4CAF50),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // This Week's Progress Section
            _buildSectionHeader('This Week\'s Progress', '📅'),
            const SizedBox(height: 16),

            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  _buildProgressRow('Mon', 0.89, '89%'),
                  const SizedBox(height: 12),
                  _buildProgressRow('Tue', 0.92, '92%'),
                  const SizedBox(height: 12),
                  _buildProgressRow('Wed', 0.85, '85%'),
                  const SizedBox(height: 12),
                  _buildProgressRow('Thu', 0.88, '88%'),
                  const SizedBox(height: 12),
                  _buildProgressRow('Fri', 0.95, '95%'),
                  const SizedBox(height: 12),
                  _buildProgressRow('Sat', 0.87, '87%'),
                  const SizedBox(height: 12),
                  _buildProgressRow('Sun', 0.90, '90%'),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Screen Time Today Section
            _buildSectionHeader('Screen Time Today', '📱'),
            const SizedBox(height: 16),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '45 minutes',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Recommended: 30-60 minutes per day',
                          style: TextStyle(fontSize: 12, color: Colors.black54),
                        ),
                      ],
                    ),
                  ),
                  const Text('😊', style: TextStyle(fontSize: 32)),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Tips for Parents Section
            _buildSectionHeader('Tips for Parents', '💡'),
            const SizedBox(height: 16),

            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  _buildTipItem(
                    '🎉',
                    'Celebrate small wins! Is doing great with daily habits.',
                  ),
                  const SizedBox(height: 16),
                  _buildTipItem(
                    '🏆',
                    'Try setting fun rewards for completing weekly goals together.',
                  ),
                  const SizedBox(height: 16),
                  _buildTipItem(
                    '🧘',
                    'Mindfulness activities help children develop emotional awareness.',
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, String emoji) {
    return Row(
      children: [
        Text(emoji, style: const TextStyle(fontSize: 18)),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _buildProgressRow(String day, double progress, String percentage) {
    return Row(
      children: [
        SizedBox(
          width: 30,
          child: Text(
            day,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.black54,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Container(
            height: 6,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(3),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: progress,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black87,
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        SizedBox(
          width: 35,
          child: Text(
            percentage,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.black54,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.end,
          ),
        ),
      ],
    );
  }

  Widget _buildTipItem(String emoji, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(emoji, style: const TextStyle(fontSize: 16)),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black87,
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }
}
