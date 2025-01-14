import 'package:beautilly/features/tailoring_requests/data/models/tailoring_request.dart';

final List<TailoringRequest> dummyRequests = [
  TailoringRequest(
    id: '1',
    clientName: 'سارة أحمد',
    clientImage: 'assets/images/onboarding2.png',
    designImage: 'assets/images/test2.png',
    height: 165,
    weight: 60,
    size: 'M',
    fabrics: [
      FabricDetail(type: 'حرير', color: '0xFFFF0000'),
      FabricDetail(type: 'قطن', color: '0xFF00FF00'),
    ],
    executionDays: 7,
    description: 'فستان سهرة مع تطريز يدوي',
    createdAt: DateTime.now(),
    status: 'accepted',
  ),
  TailoringRequest(
    id: '2',
    clientName: 'سارة أحمد',
    clientImage: 'assets/images/onboarding2.png',
    designImage: 'assets/images/test2.png',
    height: 165,
    weight: 60,
    size: 'M',
    fabrics: [
      FabricDetail(type: 'حرير', color: '0xFFFF0000'),
      FabricDetail(type: 'قطن', color: '0xFF00FF00'),
    ],
    executionDays: 7,
    description: 'فستان سهرة مع تطريز يدوي',
    createdAt: DateTime.now(),
    status: 'pending',
  ),
  // يمكن إضافة المزيد من الطلبات التجريبية
];
