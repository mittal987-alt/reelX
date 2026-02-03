import 'package:flutter/material.dart';

class CustomIcon extends StatelessWidget {
  const CustomIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 30,
      width: 45,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Left pink layer
          Positioned(
            left: 0,
            child: Container(
              height: 30,
              width: 38,
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 250, 45, 108),
                borderRadius: BorderRadius.circular(7),
              ),
            ),
          ),

          // Right blue layer
          Positioned(
            right: 0,
            child: Container(
              height: 30,
              width: 38,
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 32, 211, 234),
                borderRadius: BorderRadius.circular(7),
              ),
            ),
          ),

          // Center white add button
          Container(
            height: 30,
            width: 38,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(7),
            ),
            child: const Icon(
              Icons.add,
              color: Colors.black,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }
}
