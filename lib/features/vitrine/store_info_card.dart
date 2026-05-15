import 'package:flutter/material.dart';
import '../../models/store_config_model.dart';
import '../../core/theme.dart';

class StoreInfoCard extends StatelessWidget {
  final StoreConfigModel config;
  final bool isTV;

  const StoreInfoCard({
    super.key,
    required this.config,
    this.isTV = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(isTV ? 32 : 16),
      child: Padding(
        padding: EdgeInsets.all(isTV ? 32 : 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Logo / Nome
            Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: const BoxDecoration(
                    color: AppTheme.colorBackground,
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Icon(Icons.remove_red_eye, color: AppTheme.colorAccent),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    config.nome,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: AppTheme.colorBackground,
                    ),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 32),
            
            _buildInfoRow(context, Icons.location_on, config.endereco),
            const SizedBox(height: 16),
            _buildInfoRow(context, Icons.access_time, config.horario),
            const SizedBox(height: 16),
            _buildInfoRow(context, Icons.phone, config.whatsapp),
            
            if (config.instagram != null) ...[
              const SizedBox(height: 16),
              _buildInfoRow(context, Icons.camera_alt, config.instagram!),
            ],
            
            const Spacer(),
            
            if (isTV)
              const Center(
                child: Padding(
                  padding: EdgeInsets.only(bottom: 24),
                  child: Icon(Icons.qr_code_2, size: 180, color: AppTheme.colorBackground),
                ),
              ),

            if (!isTV)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    // Launch whatsapp
                  },
                  icon: const Icon(Icons.chat),
                  label: const Text('Falar no WhatsApp'),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context, IconData icon, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: AppTheme.colorAccent, size: 24),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            text,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: AppTheme.colorOnSurface,
            ),
          ),
        ),
      ],
    );
  }
}
