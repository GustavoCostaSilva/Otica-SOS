import 'dart:async';
import 'package:flutter/material.dart';
import '../../core/theme.dart';
import '../../models/testimonial_model.dart';
import 'glass_card.dart';

class SocialFeedCard extends StatefulWidget {
  final List<TestimonialModel> testimonials;
  final bool isTV;

  const SocialFeedCard({
    super.key,
    required this.testimonials,
    this.isTV = false,
  });

  @override
  State<SocialFeedCard> createState() => _SocialFeedCardState();
}

class _SocialFeedCardState extends State<SocialFeedCard> {
  int _currentIndex = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startRotating();
  }

  void _startRotating() {
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (widget.testimonials.isEmpty) return;
      
      if (mounted) {
        setState(() {
          _currentIndex = (_currentIndex + 1) % widget.testimonials.length;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.only(top: 24, left: 24, right: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Avaliações",
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Colors.white.withValues(alpha: 0.9),
                  fontSize: widget.isTV ? 20 : 18,
                  fontWeight: FontWeight.w400,
                  letterSpacing: 2.0,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  gradient: AppGradients.glassBorder,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.4),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.star, color: AppTheme.colorAccent, size: 14),
                      const SizedBox(width: 6),
                      Text(
                        "@sos.oculos2",
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppTheme.colorAccent, 
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 2.0,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          Expanded(
            child: widget.testimonials.isEmpty
                ? const SizedBox()
                : AnimatedSwitcher(
                    duration: const Duration(milliseconds: 800),
                    transitionBuilder: (Widget child, Animation<double> animation) {
                      return FadeTransition(
                        opacity: animation,
                        child: SlideTransition(
                          position: Tween<Offset>(
                            begin: const Offset(0.0, 0.2),
                            end: Offset.zero,
                          ).animate(animation),
                          child: child,
                        ),
                      );
                    },
                    child: _buildTestimonialItem(widget.testimonials[_currentIndex]),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildTestimonialItem(TestimonialModel item) {
    return Container(
      key: ValueKey<String>(item.author + item.text),
      margin: const EdgeInsets.only(bottom: 24),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.white.withValues(alpha: 0.04),
            Colors.transparent,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              gradient: AppGradients.glassBorder,
              shape: BoxShape.circle,
            ),
            child: Container(
              margin: const EdgeInsets.all(1.5),
              decoration: BoxDecoration(
                color: AppTheme.colorBackgroundLight.withValues(alpha: 0.8),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.person_outline, color: AppTheme.colorAccent, size: 24),
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Text(
                      item.author,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: Colors.white.withValues(alpha: 0.95),
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 1.0,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Row(
                      children: List.generate(5, (i) => Icon(
                        i < item.rating ? Icons.star_rounded : Icons.star_border_rounded,
                        size: 16,
                        color: AppTheme.colorAccent, 
                      )),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  item.text,
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.white.withValues(alpha: 0.8),
                    fontSize: 15,
                    height: 1.5,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
