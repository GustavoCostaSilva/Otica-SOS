import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/banner_model.dart';
import '../models/store_config_model.dart';
import '../models/promotion_model.dart';
import '../models/testimonial_model.dart';

final supabaseClientProvider = Provider<SupabaseClient>((ref) {
  return Supabase.instance.client;
});

final storeConfigProvider = StreamProvider<StoreConfigModel?>((ref) async* {
  final supabase = ref.watch(supabaseClientProvider);
  while (true) {
    try {
      final response = await supabase.from('store_config').select();
      if (response.isNotEmpty) {
        yield StoreConfigModel.fromJson(response.first);
      }
    } catch (e) {
      debugPrint('[storeConfig] $e');
    }
    await Future.delayed(const Duration(seconds: 10));
  }
});

final bannersProvider = StreamProvider<List<BannerModel>>((ref) async* {
  final supabase = ref.watch(supabaseClientProvider);
  while (true) {
    try {
      final response = await supabase
          .from('banners')
          .select()
          .eq('ativo', true)
          .order('ordem', ascending: true);
      yield response.map((json) => BannerModel.fromJson(json)).toList();
    } catch (e) {
      debugPrint('[banners] $e');
    }
    await Future.delayed(const Duration(seconds: 3));
  }
});

final promotionsProvider = StreamProvider<List<PromotionModel>>((ref) async* {
  final supabase = ref.watch(supabaseClientProvider);
  while (true) {
    try {
      final response = await supabase
          .from('promotions')
          .select()
          .eq('ativo', true);
      yield response.map((json) => PromotionModel(
            title: json['title'] ?? '',
            endDate: DateTime.parse(json['end_date']),
          )).toList();
    } catch (e) {
      debugPrint('[promotions] $e');
    }
    await Future.delayed(const Duration(seconds: 10));
  }
});

final testimonialsProvider = StreamProvider<List<TestimonialModel>>((ref) async* {
  final supabase = ref.watch(supabaseClientProvider);
  while (true) {
    try {
      final response = await supabase
          .from('testimonials')
          .select()
          .order('created_at', ascending: false);
      yield response.map((json) => TestimonialModel(
            author: json['author'] ?? 'Cliente',
            text: json['text'] ?? '',
            rating: json['rating'] ?? 5,
          )).toList();
    } catch (e) {
      debugPrint('[testimonials] $e');
    }
    await Future.delayed(const Duration(seconds: 3));
  }
});
