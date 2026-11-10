
import 'package:flutter/material.dart';

const Color _teal = Color(0xFF087D70);
const Color _darkTeal = Color(0xFF064D46);
const Color _mint = Color(0xFFD5F3E9);
const Color _background = Color(0xFFFCFEFD);

/// Muestra la bienvenida antes de entrar a MediTag.
/// Recibe la aplicación principal mediante [child].
class WelcomeGate extends StatefulWidget {
  final Widget child;

  const WelcomeGate({
    super.key,
    required this.child,
  });

  @override
  State<WelcomeGate> createState() => _WelcomeGateState();
}

class _WelcomeGateState extends State<WelcomeGate> {
  bool _started = false;

  void _startApp() {
    if (_started) return;

    setState(() {
      _started = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 650),
      reverseDuration: const Duration(milliseconds: 350),
      switchInCurve: Curves.easeOutCubic,
      switchOutCurve: Curves.easeInCubic,
      transitionBuilder: (child, animation) {
        final slide = Tween<Offset>(
          begin: const Offset(0, 0.045),
          end: Offset.zero,
        ).animate(animation);

        return FadeTransition(
          opacity: animation,
          child: SlideTransition(
            position: slide,
            child: child,
          ),
        );
      },
      child: _started
          ? KeyedSubtree(
              key: const ValueKey('meditag-home'),
              child: widget.child,
            )
          : _WelcomeScreen(
              key: const ValueKey('meditag-welcome'),
              onStart: _startApp,
            ),
    );
  }
}

class _WelcomeScreen extends StatelessWidget {
  final VoidCallback onStart;

  const _WelcomeScreen({
    super.key,
    required this.onStart,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _background,
      body: Stack(
        children: [
          // Decoración superior
          Positioned(
            top: -155,
            left: -165,
            child: Container(
              width: 340,
              height: 340,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: _mint,
              ),
            ),
          ),

          Positioned(
            top: -130,
            left: -140,
            child: Container(
              width: 245,
              height: 245,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFF9DDDD0),
              ),
            ),
          ),

          // Decoración inferior
          Positioned(
            bottom: -160,
            right: -155,
            child: Container(
              width: 330,
              height: 330,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: _mint,
              ),
            ),
          ),

          Positioned(
            bottom: -145,
            right: -190,
            child: Container(
              width: 280,
              height: 280,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFF9DDDD0),
              ),
            ),
          ),

          // Contenido principal
          SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 28,
                        vertical: 30,
                      ),
                      child: Column(
                        mainAxisAlignment:
                            MainAxisAlignment.center,
                        children: [
                          const SizedBox(height: 35),

                          // Logo
                          const _MediTagLogo(),

                          const SizedBox(height: 25),

                          const Text(
                            'MediTag',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 43,
                              fontWeight: FontWeight.w800,
                              color: _darkTeal,
                              letterSpacing: -1.5,
                            ),
                          ),

                          const SizedBox(height: 12),

                          Container(
                            width: 65,
                            height: 4,
                            decoration: BoxDecoration(
                              color: _teal,
                              borderRadius:
                                  BorderRadius.circular(10),
                            ),
                          ),

                          const SizedBox(height: 42),

                          // Bienvenida
                          const Text(
                            '¡Bienvenid@!',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 31,
                              fontWeight: FontWeight.bold,
                              color: _darkTeal,
                            ),
                          ),

                          const SizedBox(height: 18),

                          const Text(
                            'Tu tratamiento, a un toque.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: _teal,
                            ),
                          ),

                          const SizedBox(height: 14),

                          const Text(
                            'Organiza tus medicamentos, '
                            'consulta su información con NFC '
                            'y registra tus tomas fácilmente.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 15,
                              height: 1.6,
                              color: Color(0xFF62746F),
                            ),
                          ),

                          const SizedBox(height: 65),

                          // Botón Comenzar
                          ConstrainedBox(
                            constraints: const BoxConstraints(
                              maxWidth: 340,
                            ),
                            child: SizedBox(
                              width: double.infinity,
                              height: 58,
                              child: FilledButton(
                                onPressed: onStart,
                                style: FilledButton.styleFrom(
                                  backgroundColor: _teal,
                                  foregroundColor: Colors.white,
                                  elevation: 2,
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.circular(19),
                                  ),
                                ),
                                child: const Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Comenzar',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(width: 12),
                                    Icon(Icons.arrow_forward_rounded),
                                  ],
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 38),

                          const Text(
                            'MEDICAMENTOS  ·  NFC  ·  BIENESTAR',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 10,
                              letterSpacing: 1.5,
                              color: Color(0xFF8AA49D),
                              fontWeight: FontWeight.w600,
                            ),
                          ),

                          const SizedBox(height: 35),
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
    );
  }
}

/// Logo vectorial creado con widgets de Flutter.
/// No requiere imágenes externas.
class _MediTagLogo extends StatelessWidget {
  const _MediTagLogo();

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.88, end: 1),
      duration: const Duration(milliseconds: 850),
      curve: Curves.easeOutBack,
      builder: (context, scale, child) {
        return Transform.scale(
          scale: scale,
          child: child,
        );
      },
      child: Container(
        width: 145,
        height: 145,
        decoration: BoxDecoration(
          color: _mint.withValues(alpha: 0.7),
          borderRadius: BorderRadius.circular(40),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 105,
              height: 105,
              decoration: BoxDecoration(
                border: Border.all(
                  color: _darkTeal,
                  width: 3,
                ),
                borderRadius: BorderRadius.circular(25),
              ),
            ),
            const Icon(
              Icons.medication_rounded,
              size: 68,
              color: _teal,
            ),
            const Positioned(
              right: 9,
              top: 10,
              child: Icon(
                Icons.wifi_rounded,
                size: 35,
                color: _darkTeal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
