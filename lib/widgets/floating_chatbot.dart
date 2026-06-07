import 'package:flutter/material.dart';
import 'package:flutter_application_1/chatbot/chatbot_page.dart';

class FloatingChatbotWidget extends StatefulWidget {
  final void Function()? onTapOverride;
  const FloatingChatbotWidget({super.key, this.onTapOverride});

  @override
  State<FloatingChatbotWidget> createState() => _FloatingChatbotWidgetState();
}

class _FloatingChatbotWidgetState extends State<FloatingChatbotWidget> {
  // Posisi awal widget
  Offset position = const Offset(20, 100); 
  bool _isInitialized = false;

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      // Set posisi default di kanan bawah
      final size = MediaQuery.of(context).size;
      position = Offset(size.width - 100, size.height - 200);
      _isInitialized = true;
    }

    return Positioned(
      left: position.dx,
      top: position.dy,
      child: GestureDetector(
        onPanUpdate: (details) {
          setState(() {
            position = Offset(
              position.dx + details.delta.dx,
              position.dy + details.delta.dy,
            );
          });
        },
        onTap: () {
          if (widget.onTapOverride != null) {
            widget.onTapOverride?.call();
          } else {
            Navigator.push(context, MaterialPageRoute(builder: (_) => const ChatbotPage()));
          }
        },
        child: SizedBox(
          width: 80,
          height: 80,
          child: Image.asset(
            'assets/aifloat.png',
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) {
              // Tampilan fallback jika gambar aifloat.png belum ditambahkan di folder assets
              return Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: const Icon(Icons.support_agent, color: Color(0xFF0D6EFD), size: 40),
              );
            },
          ),
        ),
      ),
    );
  }
}
