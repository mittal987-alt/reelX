import 'package:flutter/material.dart';

class AlbumRotator extends StatefulWidget {
  final String profilePicUrl;

  const AlbumRotator({
    super.key,
    required this.profilePicUrl,
  });

  @override
  State<AlbumRotator> createState() => _AlbumRotatorState();
}

class _AlbumRotatorState extends State<AlbumRotator>
    with SingleTickerProviderStateMixin {

  late AnimationController controller;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..repeat();   // rotate forever
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RotationTransition(
      turns: Tween<double>(begin: 0.0, end: 1.0).animate(controller),
      child: SizedBox(
        width: 70,
        height: 70,
        child: Container(
          height: 60,
          width: 60,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [
                Colors.grey,
                Colors.white,
              ],
            ),
            borderRadius: BorderRadius.circular(35),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(35),
            child: Image.network(
              widget.profilePicUrl,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}
