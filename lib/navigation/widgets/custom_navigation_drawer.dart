import 'package:flashcards/auth/widgets/login_page.dart';
import 'package:flashcards/navigation/widgets/home_page.dart';
import 'package:flashcards/sets/widget/sets_page.dart';
import 'package:flashcards/statistics/widget/statistics_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class CustomNavigationDrawer extends StatelessWidget {
  const CustomNavigationDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(padding: EdgeInsets.zero, children: [
        const DrawerHeader(
          child: Text('Drawer header'),
          decoration: BoxDecoration(color: Colors.grey),
        ),
        ListTile(
          title: Text("Home"),
          leading: Icon(Icons.home),
          onTap: () {
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const HomePage()));
          },
        ),
        ListTile(
          title: Text('Statistics'),
          leading: Icon(Icons.auto_graph),
          onTap: () {
            Navigator.pop(context);
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const StatisticsPage()));
          },
        ),
        ListTile(
          title: Text('Sets'),
          leading: Icon(Icons.rectangle_rounded),
          onTap: () {
            Navigator.pop(context);
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const SetsPage()));
          },
        ),
        ListTile(
            leading: Icon(Icons.logout),
            title: Text(
              "Logout",
              style: TextStyle(color: Colors.red),
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const LoginPage()));
            })
      ]),
    );
  }
}
