import 'package:flutter/material.dart';

class SearchHeader extends StatelessWidget {
  final Function(String)? onChangeTextFunction;
  const SearchHeader({super.key, required this.onChangeTextFunction});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 0,
        ),
        const Align(
          alignment: Alignment.center,
          child: Text(
            'Tìm kiếm',
            style: TextStyle(fontSize: 30),
          ),
        ),
        const SizedBox(
          height: 22,
        ),
        TextField(
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.grey.shade300,
            prefixIcon: const Icon(
              Icons.search,
              color: Colors.black,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          onChanged: onChangeTextFunction,
        ),
      ],
    );
  }
}
