import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:image_picker/image_picker.dart';
import '../../core/theme.dart';

class BannersAdminScreen extends StatefulWidget {
  const BannersAdminScreen({super.key});

  @override
  State<BannersAdminScreen> createState() => _BannersAdminScreenState();
}

class _BannersAdminScreenState extends State<BannersAdminScreen> {
  final _supabase = Supabase.instance.client;
  bool _isUploading = false;
  final ImagePicker _picker = ImagePicker();
  final _tituloController = TextEditingController();
  final _subtituloController = TextEditingController();

  Future<void> _uploadBanner() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

      if (image == null) return;

      setState(() {
        _isUploading = true;
      });

      final bytes = await image.readAsBytes();
      final fileName = '${DateTime.now().millisecondsSinceEpoch}_${image.name}';
      
      await _supabase.storage.from('banners').uploadBinary(
        fileName,
        bytes,
      );

      final imageUrl = _supabase.storage.from('banners').getPublicUrl(fileName);

      await _supabase.from('banners').insert({
        'titulo': _tituloController.text.trim(),
        'subtitulo': _subtituloController.text.trim(),
        'image_url': imageUrl,
        'ativo': true,
        'ordem': 1,
      });

      _tituloController.clear();
      _subtituloController.clear();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Banner adicionado com sucesso!'), backgroundColor: Colors.green),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao fazer upload: $e'), backgroundColor: Colors.redAccent),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isUploading = false;
        });
      }
    }
  }

  Future<void> _toggleActive(String id, bool current) async {
    await _supabase.from('banners').update({'ativo': !current}).eq('id', id);
  }

  Future<void> _deleteBanner(String id) async {
    await _supabase.from('banners').delete().eq('id', id);
  }

  Future<void> _editBannerText(String id, String currentTitulo, String currentSubtitulo) async {
    final titleCtrl = TextEditingController(text: currentTitulo);
    final subCtrl = TextEditingController(text: currentSubtitulo);
    
    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppTheme.colorBackgroundLight,
        title: const Text('Editar Textos do Banner', style: TextStyle(color: Colors.white)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleCtrl,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(labelText: 'Título', labelStyle: TextStyle(color: Colors.white54)),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: subCtrl,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(labelText: 'Subtítulo', labelStyle: TextStyle(color: Colors.white54)),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancelar', style: TextStyle(color: Colors.white54)),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.colorAccent),
            child: const Text('Salvar', style: TextStyle(color: Colors.black)),
          ),
        ],
      )
    );

    if (result == true) {
      await _supabase.from('banners').update({
        'titulo': titleCtrl.text.trim(),
        'subtitulo': subCtrl.text.trim(),
      }).eq('id', id);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Textos atualizados com sucesso!'), backgroundColor: Colors.green),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(40.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Gerenciador de Banners', style: Theme.of(context).textTheme.displaySmall),
          const SizedBox(height: 32),
          
          // Formulario Rápido
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(color: AppTheme.colorBackground, borderRadius: BorderRadius.circular(16)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '1. Digite o texto do banner (Opcional). 2. Selecione a imagem para upload (Recomendado: 1920x1080).',
                  style: TextStyle(color: Colors.white.withValues(alpha: 0.7)),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _tituloController,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          labelText: 'Título (Ex: Coleção Verão)', 
                          filled: true, 
                          fillColor: Colors.black26, 
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none)
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextField(
                        controller: _subtituloController,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          labelText: 'Subtítulo (Ex: A partir de R\$ 199)', 
                          filled: true, 
                          fillColor: Colors.black26, 
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none)
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    ElevatedButton.icon(
                      onPressed: _isUploading ? null : _uploadBanner,
                      icon: _isUploading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(AppTheme.colorBackground),
                              ),
                            )
                          : const Icon(Icons.upload_file),
                      label: Text(
                        _isUploading ? 'Enviando...' : 'Fazer Upload',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.colorAccent,
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 32),
          
          // Grid em tempo Real
          Expanded(
            child: StreamBuilder(
              stream: Stream.periodic(const Duration(seconds: 2)).asyncMap((_) => _supabase.from('banners').select().order('ordem', ascending: true)),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const Center(child: CircularProgressIndicator(color: AppTheme.colorAccent));
                
                final banners = snapshot.data as List<dynamic>;
                if (banners.isEmpty) return const Center(child: Text("Nenhuma Imagem Cadastrada", style: TextStyle(color: Colors.white54)));
                
                return GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 24,
                    mainAxisSpacing: 24,
                    childAspectRatio: 16/9,
                  ),
                  itemCount: banners.length,
                  itemBuilder: (context, index) {
                    final b = banners[index];
                    final isActive = b['ativo'] == true;
                    final titulo = b['titulo'] ?? '';
                    final subtitulo = b['subtitulo'] ?? '';
                    
                    return Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: isActive ? AppTheme.colorAccent : Colors.redAccent.withValues(alpha: 0.4), width: isActive ? 2 : 1),
                        image: DecorationImage(image: NetworkImage(b['image_url']), fit: BoxFit.cover, colorFilter: isActive ? null : const ColorFilter.mode(Colors.black54, BlendMode.darken)),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          if (titulo.isNotEmpty || subtitulo.isNotEmpty)
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(8),
                              decoration: const BoxDecoration(
                                color: Colors.black54,
                                borderRadius: BorderRadius.vertical(top: Radius.circular(14)),
                              ),
                              child: Text(
                                titulo.isNotEmpty ? titulo : subtitulo,
                                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            )
                          else
                            const SizedBox(),
                          Container(
                            color: Colors.black87,
                            padding: const EdgeInsets.all(8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit, color: Colors.white),
                                  onPressed: () => _editBannerText(b['id'], titulo, subtitulo),
                                  tooltip: "Editar Textos",
                                ),
                                IconButton(
                                  icon: Icon(isActive ? Icons.visibility : Icons.visibility_off, color: isActive ? AppTheme.colorAccent : Colors.white54),
                                  onPressed: () => _toggleActive(b['id'], isActive),
                                  tooltip: isActive ? "Ocultar da TV" : "Mostrar na TV",
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete, color: Colors.redAccent),
                                  onPressed: () => _deleteBanner(b['id']),
                                  tooltip: "Excluir",
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
