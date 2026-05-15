import 'dart:async';
import 'package:flutter/material.dart';
import '../../core/theme.dart';
import '../../models/promotion_model.dart';
import 'glass_card.dart';

class CountdownCard extends StatefulWidget {
  final PromotionModel promotion;
  final bool isTV;

  const CountdownCard({
    super.key,
    required this.promotion,
    this.isTV = false,
  });

  @override
  State<CountdownCard> createState() => _CountdownCardState();
}

class _CountdownCardState extends State<CountdownCard> {
  late Timer _timer;
  Duration _timeLeft = Duration.zero;

  @override
  void initState() {
    super.initState();
    _updateTime();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _updateTime();
    });
  }

  void _updateTime() {
    final now = DateTime.now();
    final difference = widget.promotion.endDate.difference(now);
    if (mounted) {
      setState(() {
        _timeLeft = difference.isNegative ? Duration.zero : difference;
      });
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  widget.promotion.title.split('\n').first,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: widget.isTV ? 20 : 16,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppTheme.colorAccent.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.timer_outlined, color: AppTheme.colorAccent, size: 24),
              ),
            ],
          ),
          const SizedBox(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildTimeBox('${_timeLeft.inDays}'.padLeft(2, '0'), 'DIAS'),
              _buildTimeBox('${_timeLeft.inHours.remainder(24)}'.padLeft(2, '0'), 'HRS'),
              _buildTimeBox('${_timeLeft.inMinutes.remainder(60)}'.padLeft(2, '0'), 'MIN'),
              _buildTimeBox('${_timeLeft.inSeconds.remainder(60)}'.padLeft(2, '0'), 'SEG'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTimeBox(String value, String label) {
    return Container(
      width: widget.isTV ? 76 : 64,
      decoration: BoxDecoration(
        gradient: AppGradients.glassBorder,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        margin: const EdgeInsets.all(1),
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(15),
        ),
        padding: const EdgeInsets.symmetric(vertical: 18),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              value,
              style: Theme.of(context).textTheme.displaySmall?.copyWith(
                color: AppTheme.colorAccent, 
                fontSize: widget.isTV ? 28 : 24,
                fontWeight: FontWeight.w200,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.white.withValues(alpha: 0.5),
                fontSize: 10,
                fontWeight: FontWeight.w600,
                letterSpacing: 2.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
