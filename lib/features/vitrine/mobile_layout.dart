import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../core/mocks.dart';
import '../../core/theme.dart';
import '../../core/supabase_providers.dart';
import 'banner_slideshow.dart';
import 'weather_card.dart';
import 'social_feed_card.dart';
import 'glass_card.dart';

class MobileLayout extends ConsumerWidget {
  const MobileLayout({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bannersAsync = ref.watch(bannersProvider);
    final testimonialsAsync = ref.watch(testimonialsProvider);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppTheme.colorBackground,
              AppTheme.colorBackgroundLight,
              Colors.black,
            ],
            stops: [0.0, 0.4, 1.0],
          ),
        ),
        child: Stack(
          children: [
            // Background Layer
            Positioned.fill(
              child: Opacity(
                opacity: 0.15,
                child: Image.asset(
                  'assets/bg_layer.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SafeArea(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    // Floating Header
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.05),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
                            ),
                            child: Image.asset('assets/logo.png', width: 28, height: 28, fit: BoxFit.contain),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            'ÓTICA SOS',
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: Colors.white,
                              letterSpacing: 2.0,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    // Slideshow Content (Responsivo com AspectRatio)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: AspectRatio(
                          aspectRatio: 4 / 5, // Proporção mais vertical para mobile
                          child: bannersAsync.when(
                            data: (banners) {
                              final displayBanners = banners.isNotEmpty ? banners : mockBanners;
                              return BannerSlideshow(
                                banners: displayBanners,
                                isTV: false,
                              );
                            },
                            loading: () => bannersAsync.hasValue 
                              ? BannerSlideshow(
                                  banners: bannersAsync.value!.isNotEmpty ? bannersAsync.value! : mockBanners,
                                  isTV: false,
                                )
                              : const Center(child: CircularProgressIndicator(color: AppTheme.colorAccent)),
                            error: (error, stack) => BannerSlideshow(
                              banners: mockBanners,
                              isTV: false,
                            ),
                          ),
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Widgets Mobile Otimizados
                    const WeatherCard(isTV: false),
                    
                    const SizedBox(height: 16),
                    _buildPromoQRCard(context),
                    const SizedBox(height: 16),
                    
                    SizedBox(
                      height: 360,
                      width: double.infinity,
                      child: testimonialsAsync.when(
                        data: (testimonials) {
                          final displayTestimonials = testimonials;
                          return SocialFeedCard(testimonials: displayTestimonials, isTV: false);
                        },
                        loading: () => testimonialsAsync.hasValue
                          ? SocialFeedCard(
                              testimonials: testimonialsAsync.value!.isNotEmpty ? testimonialsAsync.value! : mockTestimonials, 
                              isTV: false
                            )
                          : const Center(child: CircularProgressIndicator(color: AppTheme.colorAccent)),
                        error: (error, stack) => SocialFeedCard(testimonials: mockTestimonials, isTV: false),
                      ),
                    ),
                    
                    const SizedBox(height: 32),
                    Text(
                      '© 2026 Ótica SOS',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.4),
                        fontSize: 12,
                        letterSpacing: 1.5,
                      ),
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPromoQRCard(BuildContext context) {
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
