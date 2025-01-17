import 'package:beautilly/features/tailoring_requests/data/dummy_data.dart';
import 'package:beautilly/features/tailoring_requests/presentation/view/widgets/tailoring_request_card.dart';
import 'package:flutter/material.dart';

class TailoringRequestsViewBody extends StatelessWidget {
  final bool isMyRequests;

  const TailoringRequestsViewBody({
    super.key,
    required this.isMyRequests,
  });

  @override
  Widget build(BuildContext context) {
    // يمكنك هنا تصفية الطلبات حسب نوعها
    final requests = isMyRequests
        ? dummyRequests.where((request) => request.isMyRequest).toList()
        : dummyRequests.where((request) => !request.isMyRequest).toList();

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: ListView.builder(
        key: ValueKey<bool>(isMyRequests),
        padding: const EdgeInsets.all(16),
        itemCount: requests.length,
        itemBuilder: (context, index) {
          return TailoringRequestCard(
            request: requests[index],
          );
        },
      ),
    );
  }
}
