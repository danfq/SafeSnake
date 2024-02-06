import 'package:flutter/cupertino.dart';

///Team Member
class TeamMember {
  ///Icon
  final IconData icon;

  ///Name
  final String name;

  ///Position
  final String position;

  ///URL
  final String url;

  ///Team Member
  TeamMember({
    required this.icon,
    required this.name,
    required this.position,
    required this.url,
  });
}
