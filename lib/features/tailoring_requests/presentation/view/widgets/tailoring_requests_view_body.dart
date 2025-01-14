import 'package:beautilly/features/tailoring_requests/data/dummy_data.dart';
import 'package:beautilly/features/tailoring_requests/presentation/view/widgets/tailoring_request_card.dart';
import 'package:flutter/material.dart';

class TailoringRequestsViewBody extends StatelessWidget {
  const TailoringRequestsViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: dummyRequests.length,
      itemBuilder: (context, index) {
        return TailoringRequestCard(
          request: dummyRequests[index],
        );
      },
    );
  }
}
