import 'package:flutter/material.dart';

class AuthButton extends StatelessWidget {
  final String labelButton;
  final VoidCallback onTap;

  const AuthButton({
    super.key,
    required this.labelButton,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 55,
        width: 345,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.lightBlue,
        ),
        child: Center(
          child: Text(
            labelButton,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ),
      ),
    );
  }
}
