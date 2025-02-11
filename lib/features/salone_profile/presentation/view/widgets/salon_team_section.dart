import 'package:beautilly/core/utils/constant/font_manger.dart';
import 'package:beautilly/core/utils/constant/styles_manger.dart';
import 'package:beautilly/core/utils/theme/app_colors.dart';
import 'package:beautilly/features/salone_profile/domain/entities/salon_profile.dart';
import 'package:beautilly/features/salone_profile/presentation/view/widgets/outline_with_icon.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:beautilly/core/utils/common/staff_gallery_dialog.dart';

class SalonTeamSection extends StatelessWidget {
  final List<Staff> staff;

  const SalonTeamSection({
    super.key,
    required this.staff,
  });

  @override
  Widget build(BuildContext context) {
    if (staff.isEmpty) return const SizedBox();

    return Container(
      margin: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          OutlineWithIcon(
            icon: Icons.groups_rounded,
            title: 'فريق العمل',
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 180,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: staff.length,
              itemBuilder: (context, index) {
                return _buildTeamMemberCard(context, staff[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTeamMemberCard(BuildContext context, Staff member) {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          useSafeArea: false,
          builder: (context) => StaffGalleryDialog(
            staff: staff,
            initialIndex: staff.indexOf(member),
          ),
        );
      },
      child: Container(
        width: 140,
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.05),
             
            ),
          ],
        ),
        child: Column(
          children: [
            // Member Image
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(12),
              ),
              child: CachedNetworkImage(
                imageUrl: member.image,
                height: 100,
                width: double.infinity,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  height: 100,
                  color: Colors.grey[300],
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
                errorWidget: (context, url, error) => Container(
                  height: 100,
                  color: Colors.grey[300],
                  child: const Icon(Icons.person),
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Member Info
            Text(
              member.name,
              style: getBoldStyle(
                fontSize: FontSize.size16,
                fontFamily: FontConstant.cairo,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              member.role,
              style: getMediumStyle(
                color: AppColors.grey,
                fontSize: FontSize.size14,
                fontFamily: FontConstant.cairo,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TeamMember {
  final String name;
  final String role;
  final String image;
  final double rating;

  TeamMember({
    required this.name,
    required this.role,
    required this.image,
    required this.rating,
  });
}

final List<TeamMember> teamMembers = [
  TeamMember(
    name: 'Sarah Johnson',
    role: 'Hair Stylist',
    image: 'assets/images/team_1.jpg',
    rating: 4.9,
  ),
  TeamMember(
    name: 'Emma Davis',
    role: 'Makeup Artist',
    image: 'assets/images/team_1.jpg',
    rating: 4.8,
  ),
  TeamMember(
    name: 'Linda Wilson',
    role: 'Nail Artist',
    image: 'assets/images/team_1.jpg',
    rating: 4.7,
  ),
  TeamMember(
    name: 'Maria Garcia',
    role: 'Beautician',
    image: 'assets/images/team_1.jpg',
    rating: 4.9,
  ),
];
