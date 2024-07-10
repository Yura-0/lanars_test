import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class LoginButton extends StatelessWidget {
  final void Function() onTap;
  const LoginButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: Adaptive.h(5),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 34, 60, 254),
            borderRadius: BorderRadius.circular(50),
          ),
          child: const Center(
            child: Text(
              'Log in',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
