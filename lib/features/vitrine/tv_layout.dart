import 'dart:async';
import 'package:go_router/go_router.dart';
import 'dart:ui';
import 'dart:math' as math;
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:marquee/marquee.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../core/theme.dart';
import '../../core/supabase_providers.dart';
import 'banner_slideshow.dart';
import 'weather_card.dart';
import 'social_feed_card.dart';
import 'glass_card.dart';

class TvLayout extends ConsumerStatefulWidget {
  const TvLayout({super.key});

  @override
  ConsumerState<TvLayout> createState() => _TvLayoutState();
}

class _TvLayoutState extends ConsumerState<TvLayout> with SingleTickerProviderStateMixin {
  late AnimationController _glowController;
  late Timer _clockTimer;
  Timer? _newsTimer;
  String _currentHours = '';
  String _currentMinutes = '';
  bool _colonVisible = true;
  String _newsHeadlines = "AGUARDANDO ATUALIZAÇÕES DO G1 CEARÁ... • BEM-VINDO À ÓTICA SOS";
  
  bool _isNightMode = false;
  Timer? _nightModeTimer;

  @override
  void initState() {
    super.initState();
    _updateTime();
    _clockTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (timer.tick % 60 == 0) {
        _updateTime();
      }
      setState(() {
        _colonVisible = !_colonVisible; 
      });
    });
    
    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat(reverse: true);

    _fetchLiveNews();
    _checkNightMode();
    
    _newsTimer = Timer.periodic(const Duration(minutes: 5), (_) {
      _fetchLiveNews();
    });

    _nightModeTimer = Timer.periodic(const Duration(minutes: 1), (_) => _checkNightMode());
  }

  void _updateTime() {
    final now = DateTime.now();
    setState(() {
      _currentHours = DateFormat('HH').format(now);
      _currentMinutes = DateFormat('mm').format(now);
    });
  }

  void _checkNightMode() {
    final hour = DateTime.now().hour;
    final isNight = hour >= 20 || hour < 7;
    if (_isNightMode != isNight && mounted) {
      setState(() { _isNightMode = isNight; });
    }
  }

  Future<void> _fetchLiveNews() async {
    try {
      final url = Uri.parse('https://api.rss2json.com/v1/api.json?rss_url=https://g1.globo.com/rss/g1/ce/ceara/');
      final response = await http.get(url);
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'ok' && data['items'] != null) {
          final List items = data['items'];
          final headlines = items.take(8).map((item) => item['title'].toString().toUpperCase()).join('    •    ');
          
          if (mounted) {
            setState(() {
              _newsHeadlines = "BEM-VINDO À ÓTICA SOS    •    $headlines    •    VENHA FAZER SEU ORÇAMENTO E AJUSTE GRÁTIS! ";
            });
          }
        }
      }
    } catch (_) {}
  }

  @override
  void dispose() {
    _clockTimer.cancel();
    _newsTimer?.cancel();
    _nightModeTimer?.cancel();
    _glowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bannersAsync = ref.watch(bannersProvider);
    final promotionsAsync = ref.watch(promotionsProvider);
    final testimonialsAsync = ref.watch(testimonialsProvider);

    final activeBanners = bannersAsync.value ?? [];
    final activeTestimonials = testimonialsAsync.value ?? [];
    final activePromotion = promotionsAsync.value?.firstOrNull;

    if (_isNightMode) {
      return Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Opacity(
                opacity: 0.15, 
                child: Image.asset('assets/logo.png', width: 140, height: 140, fit: BoxFit.contain)
              ),
              const SizedBox(height: 48),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(_currentHours, style: Theme.of(context).textTheme.displayLarge?.copyWith(color: Colors.white24, fontWeight: FontWeight.w100)),
                  AnimatedOpacity(
                    opacity: _colonVisible ? 1.0 : 0.1, 
                    duration: const Duration(milliseconds: 300),
                    child: Text(':', style: Theme.of(context).textTheme.displayLarge?.copyWith(color: AppTheme.colorAccent.withValues(alpha: 0.3), fontWeight: FontWeight.w100)),
                  ),
                  Text(_currentMinutes, style: Theme.of(context).textTheme.displayLarge?.copyWith(color: Colors.white24, fontWeight: FontWeight.w100)),
                ],
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppTheme.colorBackgroundLight,
              AppTheme.colorBackground,
              Colors.black,
            ],
            stops: [0.0, 0.4, 1.0],
          ),
        ),
        child: Stack(
          children: [
            AnimatedBuilder(
              animation: _glowController,
              builder: (context, child) {
                final sinValue = math.sin(_glowController.value * math.pi * 2);
                final cosValue = math.cos(_glowController.value * math.pi * 2);
                return Positioned(
                  left: MediaQuery.of(context).size.width * 0.3 + (100 * sinValue),
                  top: MediaQuery.of(context).size.height * 0.2 + (50 * cosValue),
                  child: Container(
                    width: 600,
                    height: 600,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppTheme.colorAccent.withValues(alpha: 0.04), 
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.colorAccent.withValues(alpha: 0.05),
                          blurRadius: 120,
                          spreadRadius: 100,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            Positioned.fill(
              child: Opacity(
                opacity: 0.1, 
                child: Image.asset(
                  'assets/bg_layer.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            
            Positioned.fill(
              bottom: 60,
              child: Row(
                children: [
                  Expanded(
                    flex: 65,
                    child: Container(
                      margin: const EdgeInsets.fromLTRB(48, 140, 24, 32),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(32),
                        border: Border.all(color: AppTheme.colorAccent.withValues(alpha: 0.4), width: 3),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.6),
                            blurRadius: 40,
                            offset: const Offset(0, 20),
                          )
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(29),
                        child: BannerSlideshow(
                          banners: activeBanners,
                          isTV: true,
                        ),
                      ),
                    ),
                  ),
                  
                  Expanded(
                    flex: 35,
                    child: Container(
                      margin: const EdgeInsets.fromLTRB(8, 140, 48, 32),
                      child: Column(
                        children: [
                          const WeatherCard(isTV: true),
                          const SizedBox(height: 16),
                          _buildPromoQRCard(),
                          const SizedBox(height: 16),
                          Expanded(
                            child: SocialFeedCard(
                              testimonials: activeTestimonials,
                              isTV: true,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Positioned(
              top: 40,
              left: 48,
              right: 48,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.05),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
                        ),
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Image.asset('assets/logo.png', width: 36, height: 36, fit: BoxFit.contain),
                        ),
                      ),
                      const SizedBox(width: 24),
                      GestureDetector(
                        onDoubleTap: () => context.go('/admin'),
                        child: Text(
                          'ÓTICA SOS',
                          style: Theme.of(context).textTheme.displaySmall?.copyWith(
                            color: Colors.white.withValues(alpha: 0.95),
                            letterSpacing: 6.0,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        _currentHours,
                        style: Theme.of(context).textTheme.displayMedium?.copyWith(
                          color: Colors.white.withValues(alpha: 0.8),
                          fontWeight: FontWeight.w200,
                          letterSpacing: 2.0,
                        ),
                      ),
                      AnimatedOpacity(
                        opacity: _colonVisible ? 1.0 : 0.2, 
                        duration: const Duration(milliseconds: 300),
                        child: Text(
                          ':',
                          style: Theme.of(context).textTheme.displayMedium?.copyWith(
                            color: AppTheme.colorAccent.withValues(alpha: 0.8),
                            fontWeight: FontWeight.w200,
                          ),
                        ),
                      ),
                      Text(
                        _currentMinutes,
                        style: Theme.of(context).textTheme.displayMedium?.copyWith(
                          color: Colors.white.withValues(alpha: 0.8),
                          fontWeight: FontWeight.w200,
                          letterSpacing: 2.0,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              height: 60,
              child: ClipRRect(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppTheme.colorBackground.withValues(alpha: 0.7),
                      border: Border(top: BorderSide(color: Colors.white.withValues(alpha: 0.15), width: 1.5)),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          height: double.infinity,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [AppTheme.colorAccent, AppTheme.colorAccent.withValues(alpha: 0.8)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            boxShadow: [
                              BoxShadow(color: AppTheme.colorAccent.withValues(alpha: 0.3), blurRadius: 12, offset: const Offset(4, 0))
                            ],
                          ),
                          alignment: Alignment.center,
                          child: Row(
                            children: [
                              const Icon(Icons.flash_on_rounded, color: Colors.black87, size: 24),
                              const SizedBox(width: 8),
                              Text(
                                "G1 CEARÁ",
                                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 3.0,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Marquee(
                            key: ValueKey(_newsHeadlines),
                            text: _newsHeadlines,
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: AppTheme.colorAccent,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 2.0,
                            ),
                            scrollAxis: Axis.horizontal,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            blankSpace: 200.0,
                            velocity: 40.0,
                            startPadding: 16.0,
                            accelerationDuration: const Duration(seconds: 1),
                            accelerationCurve: Curves.linear,
                            decelerationDuration: const Duration(milliseconds: 500),
                            decelerationCurve: Curves.easeOut,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPromoQRCard() {
    return GlassCard(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4), 
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: QrImageView(
              data: "https://wa.me/5588921458348", 
              version: QrVersions.auto,
              size: 64.0,
              eyeStyle: const QrEyeStyle(
                eyeShape: QrEyeShape.square,
                color: AppTheme.colorBackground,
              ),
              dataModuleStyle: const QrDataModuleStyle(
                dataModuleShape: QrDataModuleShape.square,
                color: AppTheme.colorBackground,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "ORÇAMENTO ONLINE",
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppTheme.colorAccent,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2.0,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "Aponte a câmera",
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w400,
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