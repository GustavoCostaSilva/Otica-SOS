import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:intl/intl.dart';
import '../../core/theme.dart';

class PromotionsAdminScreen extends StatefulWidget {
  const PromotionsAdminScreen({super.key});

  @override
  State<PromotionsAdminScreen> createState() => _PromotionsAdminScreenState();
}

class _PromotionsAdminScreenState extends State<PromotionsAdminScreen> {
  final _supabase = Supabase.instance.client;
  final _titleController = TextEditingController();
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  Future<void> _updatePromotion() async {
    final title = _titleController.text;
    if (title.isEmpty || _selectedDate == null || _selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Preencha os dados')));
      return;
    }
    
    final endDateTime = DateTime(
      _selectedDate!.year, _selectedDate!.month, _selectedDate!.day,
      _selectedTime!.hour, _selectedTime!.minute,
    );
    
    // Deleta os antigos
    await _supabase.from('promotions').delete().neq('id', '00000000-0000-0000-0000-000000000000');
    // Insere o novo
    await _supabase.from('promotions').insert({
      'title': title,
      'end_date': endDateTime.toIso8601String(),
    });
    
    if(mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Nova Promoção na TV!'), backgroundColor: AppTheme.colorAccent));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(40.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Cronômetro de Ofertas', style: Theme.of(context).textTheme.displaySmall),
          const SizedBox(height: 48),
          
          Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(color: AppTheme.colorBackground, borderRadius: BorderRadius.circular(16)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Prepara o relógio de contagem regressiva da Vitrine", style: TextStyle(color: Colors.white54, fontSize: 16)),
                const SizedBox(height: 16),
                TextField(
                  controller: _titleController,
                  decoration: InputDecoration(
                    labelText: 'Título da Promoção (ex: BLACK FRIDAY - 50% OFF)',
                    filled: true,
                    fillColor: Colors.black26,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.calendar_today),
                        label: Text(_selectedDate == null ? 'Agendar Dia Final' : DateFormat('dd/MM/yyyy').format(_selectedDate!)),
                        onPressed: () async {
                          final d = await showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime.now(), lastDate: DateTime(2030));
                          if (d != null) setState(() => _selectedDate = d);
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 24), backgroundColor: Colors.white10
                        )
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.access_time),
                        label: Text(_selectedTime == null ? 'Agendar Hora Final' : _selectedTime!.format(context)),
                        onPressed: () async {
                          final t = await showTimePicker(context: context, initialTime: TimeOfDay.now());
                          if (t != null) setState(() => _selectedTime = t);
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 24), backgroundColor: Colors.white10
                        )
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 48),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _updatePromotion,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.colorAccent,
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 24),
                    ),
                    child: const Text('DISPARAR PROMOÇÃO PARA A TV', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, letterSpacing: 2)),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
