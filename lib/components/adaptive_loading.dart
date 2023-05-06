import 'package:flutter/material.dart';

class AdaptiveLoading extends StatelessWidget {
  const AdaptiveLoading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const CircularProgressIndicator.adaptive();
  }
}
