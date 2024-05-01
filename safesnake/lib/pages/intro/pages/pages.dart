import 'package:introduction_screen/introduction_screen.dart';
import 'package:safesnake/util/animations/handler.dart';
import 'package:safesnake/util/data/local.dart';
import 'package:safesnake/util/services/strings/handler.dart';

///Intro Pages
class IntroPages {
  ///All Pages
  static List<PageViewModel> all(String lang) => [
        //Welcome
        PageViewModel(
          image: AnimationsHandler.asset(animation: "corn"),
          title: Strings.intro["title_1"][lang],
          body: Strings.intro["body_1"][lang],
        ),

        //Share Your Feelings
        PageViewModel(
          image: AnimationsHandler.asset(animation: "share"),
          title: Strings.intro["title_2"][lang],
          body: Strings.intro["body_2"][lang],
        ),

        //Ask for Help
        PageViewModel(
          image: AnimationsHandler.asset(animation: "help"),
          title: Strings.intro["title_3"][lang],
          body: Strings.intro["body_3"][lang],
        ),
      ];
}
