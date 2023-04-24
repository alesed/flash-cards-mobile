import 'package:flashcards/features/sets/models/accessibility.dart';
import 'package:flashcards/features/sets/models/sets_filter.dart';
import 'package:flashcards/features/sets/pages/sets_upsert_page.dart';
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
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (_) => SetsUpsertPage()));
            },
            child: const Icon(Icons.add),
          ),
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
          body: TabBarView(children: [
            SetList(
              setsFilter: SetsFilter(
                  accessibility: Accessibility.private, justOwn: true),
            ),
            SetList(
              setsFilter: SetsFilter(
                  accessibility: Accessibility.public, justOwn: false),
            ),
          ]),
        ));
  }
}
