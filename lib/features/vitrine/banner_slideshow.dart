import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../models/banner_model.dart';
import '../../core/theme.dart';

class BannerSlideshow extends StatefulWidget {
  final List<BannerModel> banners;
  final bool isTV;

  const BannerSlideshow({
    super.key,
    required this.banners,
    this.isTV = false,
  });

  @override
  State<BannerSlideshow> createState() => _BannerSlideshowState();
}

class _BannerSlideshowState extends State<BannerSlideshow> {
  late PageController _pageController;
  int _currentPage = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
    _startAutoplay();
  }

  void _startAutoplay() {
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (widget.banners.isEmpty) return;
      
      if (mounted) {
        setState(() {
          _currentPage = (_currentPage + 1) % widget.banners.length;
        });
        if (_pageController.hasClients) {
          _pageController.animateToPage(
            _currentPage,
            duration: const Duration(milliseconds: 800),
            curve: Curves.easeInOut,
          );
        }
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.banners.isEmpty) {
      return Container(
        color: Colors.black12,
        child: const Center(child: CircularProgressIndicator()),
      );
    }

    return Stack(
      children: [
        PageView.builder(
          controller: _pageController,
          onPageChanged: (index) {
            setState(() {
              _currentPage = index;
            });
          },
          itemCount: widget.banners.length,
          itemBuilder: (context, index) {
            final banner = widget.banners[index];
            return _buildSlide(banner);
          },
        ),
        // Dots
        Positioned(
          bottom: widget.isTV ? 40 : 20,
          left: 0,
          right: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              widget.banners.length,
              (index) => Container(
                margin: const EdgeInsets.symmetric(horizontal: 6),
                width: _currentPage == index ? 24 : 12,
                height: 12,
                decoration: BoxDecoration(
                  color: _currentPage == index 
                      ? AppTheme.colorAccent 
                      : Colors.white.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSlide(BannerModel banner) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // Imagem mockada fallback ou CachedNetworkImage
        banner.imageUrl.startsWith('http') 
            ? CachedNetworkImage(
                imageUrl: banner.imageUrl,
                fit: BoxFit.cover,
                errorWidget: (context, url, error) => _placeholderImage(),
              )
            : _placeholderImage(),
            
        // Gradiente para texto legível
        if (banner.titulo != null || banner.subtitulo != null)
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [
                  Colors.black.withValues(alpha: 0.8),
                  Colors.transparent,
                ],
              ),
            ),
          ),
          
        // Texto do banner
        if (banner.titulo != null || banner.subtitulo != null)
          Positioned(
            left: widget.isTV ? 60 : 20,
            bottom: widget.isTV ? 100 : 60,
            right: widget.isTV ? 60 : 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (banner.subtitulo != null)
                  Text(
                    banner.subtitulo!,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppTheme.colorAccent,
                      letterSpacing: 2,
                    ),
                  ),
                if (banner.subtitulo != null)
                  const SizedBox(height: 8),
                if (banner.titulo != null)
                  Text(
                    banner.titulo!,
                    style: Theme.of(context).textTheme.displayMedium?.copyWith(
                      color: Colors.white,
                    ),
                  ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _placeholderImage() {
    return Container(
      color: AppTheme.colorBackground.withValues(alpha: 0.8),
      child: const Center(
        child: Icon(Icons.image, size: 64, color: Colors.white54),
      ),
    );
  }
}
