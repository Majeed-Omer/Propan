import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/l10n/app_localizations.dart';

class Celebrate extends StatefulWidget {
  const Celebrate({super.key});

  @override
  State<Celebrate> createState() => _CelebrateState();
}

class _CelebrateState extends State<Celebrate> {
  bool isPlaying = false;
  final controller = ConfettiController();

  @override
  void initState() {
    super.initState();
    controller.play();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;
    return Stack(alignment: Alignment.topCenter, children: [
      Scaffold(
          body: Center(
              child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            // AppLocalizations.of(context)!.youBuySuccefully,
            "You bought successfully!",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: w * 0.05,
                color: Colors.black),
          ),
          SizedBox(
            height: h * 0.05,
          ),
          Image.asset(
            "assets/done.png",
            fit: BoxFit.fill,
            height: h * 0.5,
            width: w * 0.8,
          ),
        ],
      ))),
      ConfettiWidget(
        confettiController: controller,
        shouldLoop: true,
        blastDirection: 3.14 / 2,
        emissionFrequency: 0.040,
        numberOfParticles: 60,
        minBlastForce: 10,
        maxBlastForce: 100,
        // gravity: 0.4,
        blastDirectionality: BlastDirectionality.explosive,
        // colors: [
        //   Colors.red,
        //   Colors.green,
        //   Colors.yellow,
        //   Colors.orange,
        //   Colors.blue
        // ],
        // createParticlePath: ((size) {
        //   final path = Path();

        //   path.addOval(Rect.fromCircle(center: Offset.zero, radius: 20));
        //   return path;
        // }
        // ),
      )
    ]);
  }
}
