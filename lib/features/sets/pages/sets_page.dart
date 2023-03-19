import 'package:flashcards/features/sets/widgets/set_list.dart';
import 'package:flashcards/widgets/custom_navigation_drawer.dart';
import 'package:flutter/material.dart';

class SetsPage extends StatelessWidget {
  const SetsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          drawer: CustomNavigationDrawer(),
          appBar: AppBar(
              title: Text("Card sets"),
              bottom: const TabBar(tabs: [
                Tab(
                  text: "Own sets",
                ),
                Tab(
                  text: "Public sets",
                ),
              ])),
          body: const TabBarView(children: [
            SetList(),
            Text("dataosdifjoa"),
          ]),
        ));
  }
}