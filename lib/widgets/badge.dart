import 'package:flutter/material.dart';

class MyBadge extends StatelessWidget {
  const MyBadge({
    super.key,
    required this.child,
    required this.value,
  });

  final Widget? child;
  final String value;

  @override
  Widget build(BuildContext context) {
    // print(value);
    return Stack(
      alignment: Alignment.center,
      children: [
        child!,
        Positioned(
          right: 4,
          top: 0,
          child: Container(
            padding: const EdgeInsets.all(2.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              color: 
                   Theme.of(context).colorScheme.tertiary,
            ),
            constraints: const BoxConstraints(
              minWidth: 16,
              minHeight: 16,
            ),
            child: Text(
              value,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.white,
              ),
            ),
          ),
        )
      ],
    );
  }
}
