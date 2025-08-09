import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:gogogrow/firebase_options.dart';

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
    // Navigate to next page with all the collected data
    // Replace 'FinalPage()' with your actual next page widget
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => DashboardPage(
          userName: '', // TODO: Pass the actual user name here
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
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ParentDashboardPage(activity: activity),
      ),
    );
  }
}

// Sample activity page (replace with your actual activity pages)
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
