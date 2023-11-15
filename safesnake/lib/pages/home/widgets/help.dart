import 'package:dough/dough.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:safesnake/util/models/loved_one.dart';

class AskForHelp extends StatefulWidget {
  const AskForHelp({super.key, required this.lovedOnes});

  ///Loved Ones
  final List<LovedOne> lovedOnes;

  @override
  State<AskForHelp> createState() => _AskForHelpState();
}

class _AskForHelpState extends State<AskForHelp> {
  ///Dummy Loved Ones
  List<LovedOne> dummyLovedOnes = [
    LovedOne(
      name: "danfq",
      email: "danfquerido@gmail.com",
      fcmID: "",
    ),
    LovedOne(
      name: "danfq",
      email: "danfquerido@gmail.com",
      fcmID: "",
    ),
    LovedOne(
      name: "danfq",
      email: "danfquerido@gmail.com",
      fcmID: "",
    ),
    LovedOne(
      name: "danfq",
      email: "danfquerido@gmail.com",
      fcmID: "",
    ),
    LovedOne(
      name: "danfq",
      email: "danfquerido@gmail.com",
      fcmID: "",
    ),
    LovedOne(
      name: "danfq",
      email: "danfquerido@gmail.com",
      fcmID: "",
    ),
    LovedOne(
      name: "danfq",
      email: "danfquerido@gmail.com",
      fcmID: "",
    ),
    LovedOne(
      name: "danfq",
      email: "danfquerido@gmail.com",
      fcmID: "",
    ),
    LovedOne(
      name: "danfq",
      email: "danfquerido@gmail.com",
      fcmID: "",
    ),
    LovedOne(
      name: "danfq",
      email: "danfquerido@gmail.com",
      fcmID: "",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 30.0),
      child: PressableDough(
        child: GestureDetector(
          onTap: () {
            //Show Help Menu
            showModalBottomSheet(
              context: context,
              showDragHandle: true,
              builder: (context) {
                return Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(14.0),
                      topRight: Radius.circular(14.0),
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      //Top
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          //Title
                          Padding(
                            padding: const EdgeInsets.only(left: 20.0),
                            child: Text(
                              "Ask for Help",
                              style: Theme.of(context).textTheme.headlineSmall,
                            ),
                          ),

                          //Notify All
                          Padding(
                            padding: const EdgeInsets.only(right: 20.0),
                            child: TextButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Theme.of(context).cardColor,
                              ),
                              child: const Text("Notify All"),
                            ),
                          ),
                        ],
                      ),

                      //Spacing
                      const SizedBox(height: 20.0),

                      //Loved Ones
                      dummyLovedOnes.isNotEmpty
                          ? ConstrainedBox(
                              constraints: const BoxConstraints(
                                maxHeight: 240.0,
                              ),
                              child: GridView.count(
                                physics: const BouncingScrollPhysics(),
                                padding: const EdgeInsets.all(12.0),
                                crossAxisCount: 2,
                                crossAxisSpacing: 10.0,
                                mainAxisSpacing: 10.0,
                                childAspectRatio: 10 / 3,
                                children: dummyLovedOnes.map(
                                  (lovedOne) {
                                    return GestureDetector(
                                      onTap: () {
                                        //Set
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Theme.of(context).cardColor,
                                          borderRadius: BorderRadius.circular(
                                            14.0,
                                          ),
                                        ),
                                        child: Center(
                                          child: Text(
                                            lovedOne.name,
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ).toList(),
                              ),
                            )
                          : const Padding(
                              padding: EdgeInsets.all(40.0),
                              child: Center(
                                child: Text(
                                  "You need to add some Loved Ones first!",
                                ),
                              ),
                            ),

                      //Spacing
                      const SizedBox(height: 40.0),
                    ],
                  ),
                );
              },
            );
          },
          child: CircleAvatar(
            backgroundColor: const Color(0xFFE91E63),
            radius: 100.0,
            child: Center(
              child: SvgPicture.asset(
                "assets/icons/heart.svg",
                width: 120.0,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
