import 'package:flutter/material.dart';

class SalonTeamSection extends StatelessWidget {
  const SalonTeamSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Our Team',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 180,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: teamMembers.length,
              itemBuilder: (context, index) {
                return _buildTeamMemberCard(teamMembers[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTeamMemberCard(TeamMember member) {
    return Container(
      width: 140,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
          ),
        ],
      ),
      child: Column(
        children: [
          // Member Image
          Container(
            height: 100,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(12),
              ),
              image: DecorationImage(
                image: AssetImage(member.image),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Member Info
          Text(
            member.name,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            member.role,
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 14,
            ),
          ),
        ],
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
