import '../models/banner_model.dart';
import '../models/store_config_model.dart';
import '../models/promotion_model.dart';
import '../models/testimonial_model.dart';

final mockBanners = [
  BannerModel(
    id: '1',
    titulo: 'Coleção Verão 2026',
    subtitulo: 'A partir de R\$ 199,90',
    imageUrl: 'https://images.unsplash.com/photo-1572635196237-14b3f281503f?auto=format&fit=crop&q=80',
    ativo: true,
    ordem: 1,
  ),
  BannerModel(
    id: '2',
    titulo: 'Óculos de Grau Premium',
    subtitulo: 'Lentes Anti-reflexo Grátis',
    imageUrl: 'https://images.unsplash.com/photo-1591076482161-42ce6da69f67?auto=format&fit=crop&q=80',
    ativo: true,
    ordem: 2,
  ),
  BannerModel(
    id: '3',
    titulo: 'Manutenção e Consertos',
    subtitulo: 'Temos laboratório próprio',
    imageUrl: 'https://images.unsplash.com/photo-1511499767150-a48a237f0083?auto=format&fit=crop&q=80',
    ativo: true,
    ordem: 3,
  ),
];

final mockStoreConfig = StoreConfigModel(
  id: '1',
  nome: 'Ótica SOS',
  endereco: 'Morada Nova, CE',
  whatsapp: '(88) 99999-9999',
  horario: 'Seg–Sex 8h–18h',
  instagram: '@oticasos_ce',
  logoUrl: null,
);

final mockPromotion = PromotionModel(
  title: 'QUiNZENA DO ÓCULOS DE SOL\n(50% OFF NO SEGUNDO PAR)',
  endDate: DateTime.now().add(const Duration(days: 14, hours: 5, minutes: 23)),
);

final mockTestimonials = [
  TestimonialModel(
    author: 'Maria Fernanda',
    text: '"Atendimento maravilhoso! Ajustaram minha armação antiga e comprei uma nova lindíssima. Recomendo muito a equipe de Morada Nova!"',
    rating: 5,
  ),
  TestimonialModel(
    author: 'João Carlos',
    text: '"Preço justo e uma variedade enorme de óculos. As lentes ficaram prontas rápido, e o grau veio certinho."',
    rating: 5,
  ),
  TestimonialModel(
    author: 'Ana Clara',
    text: '"Sempre levo meus óculos para consertar aqui. Mão de obra de primeira e as peças ficam novinhas!"',
    rating: 5,
  ),
];
