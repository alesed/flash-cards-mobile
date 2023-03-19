import 'package:flashcards/features/auth/pages/login_page.dart';
import 'package:flashcards/features/home/pages/home_page.dart';
import 'package:flashcards/features/sets/pages/sets_page.dart';
import 'package:flashcards/features/statistics/pages/statistics_page.dart';
import 'package:flutter/material.dart';

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
