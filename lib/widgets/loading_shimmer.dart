import 'package:flutter/widgets.dart';

class LoadingShimmer extends StatefulWidget {
  const LoadingShimmer({super.key});

  @override
  State<LoadingShimmer> createState() => _LoadingShimmerState();
}

class _LoadingShimmerState extends State<LoadingShimmer> 
  with SingleTickerProviderStateMixin{
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
