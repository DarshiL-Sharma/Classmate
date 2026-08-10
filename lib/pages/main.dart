import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'firebase_options.dart'; 
import '../constants.dart';
import 'login_page.dart';
import '../console/console_main.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();


  await Firebase.initializeApp();


  await FirebaseAppCheck.instance.activate(
    androidProvider: AndroidProvider.debug,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AuthGate(),
    );
  }
}


class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (snapshot.hasData) {
          return const HomeScreenPlaceholder();
        }
        return const OnboardingScreen();
      },
    );
  }
}
class OnboardData {
  final String image; 
  final String title;
  final String description;
  final Color cardColor;

  const OnboardData({
    required this.image,
    required this.title,
    required this.description,
    required this.cardColor,
  });
}

const List<OnboardData> onboardPages = [
  OnboardData(
    image: 'assets/images/Online document.gif', 
    title: 'All Your Docs,\nOne Tap Away',
    description:
    'Class notes, syllabus and exam hall tickets — organized and ready whenever you need them.',
    cardColor: AppColors.cardBeige,
  ),
  OnboardData(
    image: 'assets/images/Time management.gif', 
    title: 'Your Timetable,\nAlways Handy',
    description:
    'Check your daily class schedule and exam dates at a glance — no more asking around.',
    cardColor: AppColors.cardBeige,
  ),
  OnboardData(
    image: 'assets/images/Reminders.gif', 
    title: 'Never Miss\nAn Event',
    description:
    'Stay updated with the latest college events, fests and deadlines as they happen.',
    cardColor: AppColors.cardBeigeLight,
  ),
  OnboardData(
    image: 'assets/images/Refer a friend.gif', 
    title: 'Join The\nCommunity',
    description:
    'Post, comment and connect with your batch in dedicated community sections.',
    cardColor: AppColors.cardBeige,
  ),
  OnboardData(
    image: 'assets/images/Stand out.gif', 
    title: 'Get Verified,\nGet Noticed',
    description:
    'Apply for CR or organizer badges and stand out with a verified tick on your profile.',
    cardColor: AppColors.cardBeigeLight,
  ),
];


class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _currentPage = 0;

  void _onFinish() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLast = _currentPage == onboardPages.length - 1;

    return PopScope(
      canPop: _currentPage == 0,
     
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        if (_currentPage > 0) {
          _controller.previousPage(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: TweenAnimationBuilder<double>(
          tween: Tween(begin: 0.0, end: 1.0),
          duration: const Duration(milliseconds: 1000),
          builder: (context, value, child) {
            return Opacity(
              opacity: value,
              child: child,
            );
          },
          child: SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 24, vertical: 12),
                  child: SizedBox(
                    height: 40,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Visibility(
                          visible: !isLast,
                          maintainSize: true,
                          maintainAnimation: true,
                          maintainState: true,
                          child: TextButton(
                            onPressed: _onFinish,
                            child: const Text(
                              'Skip',
                              style: TextStyle(
                                color: AppColors.textGrey,
                                fontWeight: FontWeight.w600,
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                Expanded(
                  child: PageView.builder(
                    controller: _controller,
                    itemCount: onboardPages.length,
                    onPageChanged: (index) =>
                        setState(() => _currentPage = index),
                    itemBuilder: (context, index) {
                      return OnboardPageCard(data: onboardPages[index]);
                    },
                  ),
                ),
                const SizedBox(height: 12),
          
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    onboardPages.length,
                        (index) =>
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 250),
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          height: 8,
                          width: _currentPage == index ? 24 : 8,
                          decoration: BoxDecoration(
                            color: _currentPage == index
                                ? AppColors.accentGreen
                                : AppColors.dotInactive,
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                  ),
                ),
                const SizedBox(height: 28),
                SizedBox(
                  height: 48,
                  child: Visibility(
                    visible: isLast,
                    maintainSize: true,
                    maintainAnimation: true,
                    maintainState: true,
                    child: TextButton(
                      onPressed: _onFinish,
                      child: const Text(
                        'Get Started',
                        style: TextStyle(
                          color: AppColors.accentGreen,
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class OnboardPageCard extends StatelessWidget {
  final OnboardData data;
  const OnboardPageCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          const SizedBox(height: 8),
          Expanded(
            flex: 5,
            child: Center(
              child: Image.asset(
                data.image,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) => Center(
                  child: Icon(
                    Icons.image_outlined,
                    size: 64,
                    color: AppColors.textGrey.withValues(alpha: 0.4),
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 10),

          SizedBox(
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data.title,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w900,
                    color: AppColors.textDark,
                    letterSpacing: -0.5,
                    height: 1.1,
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  width: 45,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.accentGreen,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  data.description,
                  style: const TextStyle(
                    fontSize: 16,
                    color: AppColors.textGrey,
                    height: 1.5,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
