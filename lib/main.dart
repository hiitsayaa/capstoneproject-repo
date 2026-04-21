import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

void main() {
  // Menahan Splash Screen asli sampai Flutter siap
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Majadigi App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // Mengatur Poppins sebagai font utama aplikasi
        fontFamily: 'Poppins',
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF0055CC)),
        useMaterial3: true,
      ),
      home: const AnimatedSplashScreen(),
    );
  }
}

class AnimatedSplashScreen extends StatefulWidget {
  const AnimatedSplashScreen({super.key});

  @override
  State<AnimatedSplashScreen> createState() => _AnimatedSplashScreenState();
}

class _AnimatedSplashScreenState extends State<AnimatedSplashScreen> {
  double _blueBoxScale = 0.0;
  double _contentOpacity = 1.0;

  @override
  void initState() {
    super.initState();
    _startAnimation();
  }

  void _startAnimation() async {
    // 1. Hilangkan Native Splash (statis)
    FlutterNativeSplash.remove();

    // 2. Jeda agar user bisa melihat logo dan teks footer sejenak
    await Future.delayed(const Duration(milliseconds: 800));

    // 3. Jalankan animasi scaling biru dan fade out konten
    if (mounted) {
      setState(() {
        _blueBoxScale = 15.0; // Melebar memenuhi seluruh layar
        _contentOpacity = 0.0; // Logo dan teks memudar
      });
    }

    // 4. Tunggu animasi selesai, lalu pindah ke halaman Home
    await Future.delayed(const Duration(milliseconds: 900));
    if (mounted) {
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => 
              const MyHomePage(title: 'Majadigi Home Page'),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Lapisan 1: Background Biru yang membesar dari tengah
          Center(
            child: AnimatedScale(
              scale: _blueBoxScale,
              duration: const Duration(milliseconds: 900),
              curve: Curves.easeInOutQuart,
              child: Container(
                width: 100,
                height: 100,
                decoration: const BoxDecoration(
                  color: Color(0xFF0055CC),
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
          
          // Lapisan 2: Konten (Logo & Text) yang memudar
          AnimatedOpacity(
            opacity: _contentOpacity,
            duration: const Duration(milliseconds: 600),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(), // Spacer atas
                
                // Logo Tengah
                Center(
                  child: Image.asset(
                    'assets/logomajadigi1.png',
                    width: 160,
                  ),
                ),
                
                // Footer Text sesuai Figma
                Padding(
                  padding: const EdgeInsets.only(bottom: 40.0),
                  child: Column(
                    children: const [
                      Text(
                        'Powered by',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w300, // Poppins Light
                          color: Colors.black45,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Pemerintah Provinsi Jawa Timur',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400, // Poppins Regular
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('You have pushed the button this many times:'),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}