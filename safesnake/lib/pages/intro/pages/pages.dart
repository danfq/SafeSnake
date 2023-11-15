import 'package:introduction_screen/introduction_screen.dart';
import 'package:safesnake/util/animations/handler.dart';

///Intro Pages
class IntroPages {
  ///All Pages
  static List<PageViewModel> all = [
    //Welcome
    PageViewModel(
      image: AnimationsHandler.asset(animation: "corn"),
      title: "Hi! I'm Corn!",
      body: "I will do my best to keep you safe.",
    ),

    //Share Your Feelings
    PageViewModel(
      image: AnimationsHandler.asset(animation: "share"),
      title: "Share Your Feelings",
      body: "Your loved ones can help too, of course.",
    ),

    //Ask for Help
    PageViewModel(
      image: AnimationsHandler.asset(animation: "help"),
      title: "Ask For Help",
      body: "There's no shame in it.\nWe all struggle sometimes!",
    ),
  ];
}
