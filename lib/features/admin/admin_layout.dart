import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme.dart';
import 'dashboard_admin.dart';
import 'banners_admin.dart';
import 'testimonials_admin.dart';
import 'login_screen.dart';

class AdminLayout extends StatefulWidget {
  const AdminLayout({super.key});

  @override
  State<AdminLayout> createState() => _AdminLayoutState();
}

class _AdminLayoutState extends State<AdminLayout> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const DashboardAdminScreen(),
    const BannersAdminScreen(),
    const TestimonialsAdminScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<AuthState>(
      stream: Supabase.instance.client.auth.onAuthStateChange,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            backgroundColor: AppTheme.colorBackground,
            body: Center(
              child: CircularProgressIndicator(color: AppTheme.colorAccent),
            ),
          );
        }

        final session = snapshot.data?.session;
        if (session == null) {
          return const LoginScreen();
        }

        return Scaffold(
          backgroundColor: AppTheme.colorBackgroundLight,
          body: Row(
            children: [
              // Nav Bar Menu Lateral
              Container(
                width: 280,
                decoration: BoxDecoration(
                  color: AppTheme.colorBackground,
                  border: Border(right: BorderSide(color: Colors.white.withValues(alpha: 0.05), width: 1)),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withValues(alpha: 0.5), blurRadius: 16)
                  ]
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header Logo
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 48.0),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: AppTheme.colorAccent.withValues(alpha: 0.1),
                              shape: BoxShape.circle,
                            ),
                            child: Image.asset('assets/logo.png', width: 32, height: 32, fit: BoxFit.contain),
                          ),
                          const SizedBox(width: 16),
                          Text('SOS Admin', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold, letterSpacing: 1.5)),
                        ],
                      ),
                    ),
                    
                    // Menus
                    _buildNavItem(0, Icons.dashboard_outlined, 'Dashboard'),
                    _buildNavItem(1, Icons.photo_library_outlined, 'Banners / Vitrine'),
                    _buildNavItem(2, Icons.forum_outlined, 'Feedbacks Clientes'),
                    
                    const Spacer(),
                    
                    // Footer
                    Padding(
                      padding: const EdgeInsets.all(32.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                           InkWell(
                             onTap: () async {
                               await Supabase.instance.client.auth.signOut();
                               if (context.mounted) {
                                 context.go('/');
                               }
                             },
                             borderRadius: BorderRadius.circular(8),
                             child: Padding(
                               padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                               child: Row(
                                 children: [
                                   const Icon(Icons.logout, color: Colors.redAccent, size: 20),
                                   const SizedBox(width: 8),
                                   Text('Sair', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.redAccent, fontWeight: FontWeight.bold)),
                                 ],
                               ),
                             ),
                           ),
                           const SizedBox(height: 16),
                           Text('© 2026 Ótica SOS', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.white38)),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              
              // Estação de Conteúdo
              Expanded(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: _pages[_selectedIndex],
                ),
              ),
            ],
          ),
        );
      }
    );
  }

  Widget _buildNavItem(int index, IconData icon, String title) {
    final isSelected = _selectedIndex == index;
    return InkWell(
      onTap: () => setState(() => _selectedIndex = index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white.withValues(alpha: 0.03) : Colors.transparent,
          border: Border(left: BorderSide(color: isSelected ? AppTheme.colorAccent : Colors.transparent, width: 4)),
        ),
        child: Row(
          children: [
            Icon(icon, color: isSelected ? AppTheme.colorAccent : Colors.white54, size: 24),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.white54,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
