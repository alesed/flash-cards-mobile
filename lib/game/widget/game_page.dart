import 'package:flashcards/navigation/widgets/custom_navigation_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class GamePage extends StatelessWidget {
  const GamePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Practising \"Biology\""),
        ),
        drawer: CustomNavigationDrawer(),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildCard(),
              SizedBox(
                height: 50,
              ),
              _buildButtons()
            ],
          ),
        ));
  }

  Widget _buildButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Spacer(),
        ElevatedButton(onPressed: () {}, child: Text("Yes")),
        Spacer(),
        ElevatedButton(onPressed: () {}, child: Text("No")),
        Spacer(),
      ],
    );
  }

  Widget _buildCard() {
    return Container(
      width: 300,
      height: 300,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
        onPressed: () {},
        child: Text(
          "asdfk",
          style: TextStyle(color: Colors.black),
        ),
      ),
    );
  }
}
