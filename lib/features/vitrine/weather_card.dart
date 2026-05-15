import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../core/theme.dart';
import 'glass_card.dart';

class WeatherCard extends StatefulWidget {
  final bool isTV;
  const WeatherCard({super.key, this.isTV = false});

  @override
  State<WeatherCard> createState() => _WeatherCardState();
}

class _WeatherCardState extends State<WeatherCard> with SingleTickerProviderStateMixin {
  double? _temperature;
  double? _windSpeed;
  int? _humidity;
  bool _isLoading = true;
  Timer? _pollingTimer;
  late AnimationController _floatController;
  late Animation<double> _floatAnimation;

  @override
  void initState() {
    super.initState();
    _fetchWeather();
    _pollingTimer = Timer.periodic(const Duration(seconds: 30), (_) {
      _fetchWeather(silent: true);
    });

    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);

    _floatAnimation = Tween<double>(begin: -5.0, end: 5.0).animate(
      CurvedAnimation(parent: _floatController, curve: Curves.easeInOutSine),
    );
  }

  Future<void> _fetchWeather({bool silent = false}) async {
    if (!silent) {
      setState(() => _isLoading = true);
    }
    try {
      final url = Uri.parse(
          'https://api.open-meteo.com/v1/forecast?latitude=-5.109&longitude=-38.375&current=temperature_2m,relative_humidity_2m,wind_speed_10m');
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (mounted) {
          setState(() {
            _temperature = data['current']['temperature_2m'];
            _humidity = data['current']['relative_humidity_2m'];
            _windSpeed = data['current']['wind_speed_10m'];
            _isLoading = false;
          });
        }
      }
    } catch (e) {
      if (mounted && !silent) {
        setState(() => _isLoading = false);
      }
    }
  }

  String _descricaoClima() {
    if (_temperature == null) return '';
    if (_temperature! >= 35) return 'Calor Intenso';
    if (_temperature! >= 28) return 'Sol Forte';
    if (_temperature! >= 22) return 'Agradável';
    return 'Ameno';
  }

  String _sensacaoTermica() {
    if (_temperature == null || _humidity == null) return '--';
    final t = _temperature!;
    final h = _humidity!;
    // Fórmula simplificada de sensação térmica por calor
    if (t >= 27) {
      final st = -8.785 + 1.611 * t + 2.339 * h - 0.146 * t * h;
      return '${st.toStringAsFixed(0)}°';
    }
    return '${t.toStringAsFixed(0)}°';
  }

  @override
  void dispose() {
    _pollingTimer?.cancel();
    _floatController.dispose();
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Morada Nova, CE",
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Colors.white.withValues(alpha: 0.95),
                      fontSize: widget.isTV ? 20 : 16,
                      fontWeight: FontWeight.w400,
                      letterSpacing: 2.0,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Previsão Ao Vivo",
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppTheme.colorAccent.withValues(alpha: 0.9),
                      fontSize: widget.isTV ? 12 : 10,
                      letterSpacing: 3.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              AnimatedBuilder(
                animation: _floatAnimation,
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(0, _floatAnimation.value),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        gradient: AppGradients.glassBorder,
                        shape: BoxShape.circle,
                      ),
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.3),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.wb_sunny_outlined, color: AppTheme.colorAccent, size: 28),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 32),
          if (_isLoading)
            const Center(child: CircularProgressIndicator(color: AppTheme.colorAccent, strokeWidth: 2))
          else if (_temperature != null)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${_temperature!.toStringAsFixed(0)}°',
                  style: Theme.of(context).textTheme.displayLarge?.copyWith(
                    color: Colors.white,
                    fontSize: widget.isTV ? 72 : 54,
                    fontWeight: FontWeight.w200,
                    height: 1.0,
                    letterSpacing: -2.0,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      _descricaoClima(),
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: Colors.white70,
                        fontSize: widget.isTV ? 22 : 18,
                        fontWeight: FontWeight.w300,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          const SizedBox(height: 40),
          Container(
            padding: const EdgeInsets.only(top: 24),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(color: Colors.white.withValues(alpha: 0.05), width: 1),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildDetailItem('UMIDADE', '${_humidity ?? 45}%'),
                _buildDetailItem('VENTO', '${_windSpeed?.toStringAsFixed(0) ?? 8} KM/H'),
                _buildDetailItem('SENSAÇÃO', _sensacaoTermica()),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Colors.white.withValues(alpha: 0.4),
            fontSize: 9,
            fontWeight: FontWeight.bold,
            letterSpacing: 3.0,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: Colors.white.withValues(alpha: 0.9),
            fontSize: 16,
            fontWeight: FontWeight.w400,
            letterSpacing: 1.0,
          ),
        ),
      ],
    );
  }
}
