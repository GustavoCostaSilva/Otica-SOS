import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../core/theme.dart';

class TestimonialsAdminScreen extends StatefulWidget {
  const TestimonialsAdminScreen({super.key});

  @override
  State<TestimonialsAdminScreen> createState() => _TestimonialsAdminScreenState();
}

class _TestimonialsAdminScreenState extends State<TestimonialsAdminScreen> {
  final _supabase = Supabase.instance.client;
  final _nameController = TextEditingController();
  final _textController = TextEditingController();

  Future<void> _addTestimonial() async {
    final author = _nameController.text;
    final text = _textController.text;
    if (author.isEmpty || text.isEmpty) return;
    
    try {
      await _supabase.from('testimonials').insert({
        'author': author,
        'text': text,
        'rating': 5,
      });
      
      _nameController.clear();
      _textController.clear();
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Elogio publicado com sucesso!'), backgroundColor: Colors.green),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao salvar: $e'), backgroundColor: Colors.redAccent),
        );
      }
    }
  }

  Future<void> _deleteTestimonial(String id) async {
    await _supabase.from('testimonials').delete().eq('id', id);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(40.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Formulario ADD
          Expanded(
            flex: 4,
            child: Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(color: AppTheme.colorBackground, borderRadius: BorderRadius.circular(16)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Novo Elogio de Balcão', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  const Text('O cliente elogiou? Digite e mande direto para a tela.', style: TextStyle(color: Colors.white54)),
                  const SizedBox(height: 32),
                  TextField(
                    controller: _nameController,
                    decoration: InputDecoration(labelText: 'Nome do Cliente (Primeiro Nome)', filled: true, fillColor: Colors.black26, border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none)),
                  ),
                  const SizedBox(height: 24),
                  TextField(
                    controller: _textController,
                    maxLines: 4,
                    decoration: InputDecoration(labelText: 'Depoimento (Elogio do Cliente)', filled: true, fillColor: Colors.black26, border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none)),
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _addTestimonial,
                      style: ElevatedButton.styleFrom(backgroundColor: AppTheme.colorAccent, foregroundColor: Colors.black, padding: const EdgeInsets.symmetric(vertical: 20)),
                      child: const Text('PUBLICAR NA VITRINE', style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.5)),
                    ),
                  )
                ],
              ),
            ),
          ),
          const SizedBox(width: 40),
          // Lista Feedback Realtime
          Expanded(
            flex: 6,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Avaliações Ativas no Painel', style: Theme.of(context).textTheme.displaySmall),
                const SizedBox(height: 24),
                Expanded(
                  child: StreamBuilder(
                    stream: Stream.periodic(const Duration(seconds: 2)).asyncMap((_) => _supabase.from('testimonials').select().order('created_at', ascending: false)),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) return const Center(child: CircularProgressIndicator(color: AppTheme.colorAccent));
                      
                      final items = snapshot.data as List<dynamic>;
                      if (items.isEmpty) return const Center(child: Text('Nenhum depoimento cadastrado', style: TextStyle(color: Colors.white54)));
                      
                      return ListView.separated(
                        itemCount: items.length,
                        separatorBuilder: (context, index) => const SizedBox(height: 16),
                        itemBuilder: (context, index) {
                          final t = items[index];
                          return ListTile(
                            contentPadding: const EdgeInsets.all(16),
                            tileColor: AppTheme.colorBackground,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            leading: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(color: Colors.black26, shape: BoxShape.circle),
                              child: const Icon(Icons.person, color: Colors.white54),
                            ),
                            title: Text(t['author'], style: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.colorAccent, fontSize: 18)),
                            subtitle: Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text('"${t['text']}"', style: const TextStyle(color: Colors.white70, fontStyle: FontStyle.italic)),
                            ),
                            trailing: IconButton(icon: const Icon(Icons.delete_outline, color: Colors.redAccent), onPressed: () => _deleteTestimonial(t['id'])),
                          );
                        },
                      );
                    },
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
