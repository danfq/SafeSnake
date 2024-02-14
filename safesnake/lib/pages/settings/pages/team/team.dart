import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:safesnake/util/models/team_member.dart';
import 'package:url_launcher/url_launcher.dart';

class Team extends StatelessWidget {
  const Team({super.key});

  @override
  Widget build(BuildContext context) {
    ///Team Members
    final List<TeamMember> teamMembers = [
      //Dan
      TeamMember(
        icon: Ionicons.ios_git_branch,
        name: "DanFQ",
        position: "Programmer",
        url: "https://github.com/danfq",
      ),

      //VEIGA
      TeamMember(
        icon: Ionicons.ios_brush,
        name: "VEIGA",
        position: "Design & iOS QA Testing",
        url: "https://instagram.com/veigadesigns",
      ),

      //Mati
      TeamMember(
        icon: Fontisto.test_tube_alt,
        name: "MatiFFQ",
        position: "Android QA Testing",
        url: "https://instagram.com/tide_ff",
      ),

      //Nês
      TeamMember(
        icon: Fontisto.test_tube_alt,
        name: "Inês Pratas",
        position: "iOS QA Testing",
        url: "https://instagram.com/seni_satarp",
      ),

      //Inês Costa
      TeamMember(
        icon: Fontisto.test_tube_alt,
        name: "Inês Costa",
        position: "iOS QA Testing",
        url: "https://instagram.com/1nescosta",
      ),
    ];

    //UI
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        title: Text("Team", style: Theme.of(context).textTheme.titleLarge),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Ionicons.ios_chevron_back),
        ),
      ),
      body: SafeArea(
        child: ListView.builder(
          physics: const BouncingScrollPhysics(),
          itemCount: teamMembers.length,
          itemBuilder: (context, index) {
            //Member
            final member = teamMembers[index];

            //UI
            return Padding(
              padding: const EdgeInsets.all(12.0),
              child: ListTile(
                leading: Icon(member.icon),
                title: Text(member.name),
                subtitle: Text(member.position),
                onTap: () async {
                  await launchUrl(Uri.parse(member.url));
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
