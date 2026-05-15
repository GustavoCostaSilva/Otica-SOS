import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../core/theme.dart';

class DashboardAdminScreen extends StatefulWidget {
  const DashboardAdminScreen({super.key});

  @override
  State<DashboardAdminScreen> createState() => _DashboardAdminScreenState();
}

class _DashboardAdminScreenState extends State<DashboardAdminScreen> {
  final _supabase = Supabase.instance.client;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(40.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Dashboard', style: Theme.of(context).textTheme.displaySmall),
          const SizedBox(height: 8),
          Text('Visão geral do seu sistema', style: TextStyle(color: Colors.white54, fontSize: 16)),
          const SizedBox(height: 32),
          
          Expanded(
            child: GridView.count(
              crossAxisCount: 3,
              crossAxisSpacing: 24,
              mainAxisSpacing: 24,
              childAspectRatio: 1.5,
              children: [
                _buildStatCard(
                  title: 'Banners Ativos',
                  icon: Icons.photo_library,
                  stream: _supabase.from('banners').stream(primaryKey: ['id']).eq('ativo', true),
                ),
                _buildStatCard(
                  title: 'Ofertas Ativas',
                  icon: Icons.local_offer,
                  stream: _supabase.from('promotions').stream(primaryKey: ['id']).eq('ativo', true),
                ),
                _buildStatCard(
                  title: 'Depoimentos',
                  icon: Icons.forum,
                  stream: _supabase.from('testimonials').stream(primaryKey: ['id']),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard({required String title, required IconData icon, required Stream<List<Map<String, dynamic>>> stream}) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.colorBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.2), blurRadius: 10, offset: const Offset(0, 4))
        ]
      ),
      padding: const EdgeInsets.all(24),
      child: StreamBuilder<List<Map<String, dynamic>>>(
        stream: stream,
        builder: (context, snapshot) {
          int count = 0;
          if (snapshot.hasData) {
            count = snapshot.data!.length;
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  Icon(icon, color: AppTheme.colorAccent, size: 28),
                  const Spacer(),
                  if (!snapshot.hasData && snapshot.connectionState == ConnectionState.waiting)
                     const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: AppTheme.colorAccent)),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                count.toString(),
                style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              const SizedBox(height: 4),
              Text(
                title,
                style: const TextStyle(fontSize: 16, color: Colors.white54),
              ),
            ],
          );
        }
      ),
    );
  }
}
