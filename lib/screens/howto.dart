import 'package:flutter/material.dart';
import 'package:qavexspidercardspremium/core/app_state.dart';
import 'package:qavexspidercardspremium/widgets/ui.dart';

class HowToScreen extends StatelessWidget {
  const HowToScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBuilder(
      builder: (context, s) => QxScaffold(
        title: 'How to Play',
        body: ListView(
          children: const [
            QxCard(
              child: Text('HOW TO PLAY\n\nGoal: clear all eight same-suit sequences from King down to Ace.\n\n- Ten columns are dealt from two full decks; one row is dealt from the stock to every column at a time.\n- Build columns downward in ANY suit (9 of hearts on 10 of spades is fine).\n- Only runs that are descending AND all one suit may move together as a stack.\n- Complete a King-to-Ace same-suit run and it lifts off the web by itself.\n- Only a King (or a stack led by a King) may fill an empty column.\n- The stock deals only while no column is empty.\n\nMODES\n- Classic: 10 columns, unlimited deal rows.\n- Timed Run: 15 minutes; leftover time becomes bonus points.\n- Daily Challenge: one seeded web per day; streaks earn bonus Web Chips.\n- Zen Table: no timer, free hints and undo.\n- Puzzle Levels: 24 curated webs with par scores; clear one to unlock the next.\n- Kids Mode: extra hints and gentle guidance from Arachna.\n- Practice: free play with auto-hints.',
                  style: TextStyle(fontSize: 15, height: 1.5)),
            ),
          ],
        ),
      ),
    );
  }
}
