import 'package:flutter/material.dart';
import '../../core/responsive.dart';
import 'mobile_layout.dart';
import 'tv_layout.dart';

class VitrineScreen extends StatelessWidget {
  const VitrineScreen({super.key});

  @override
  Widget build(BuildContext context) {
    if (Responsive.isTV(context) || Responsive.isLandscape(context)) {
      return const TvLayout();
    }
    return const MobileLayout();
  }
}
