import 'package:flutter/material.dart';

class FeedScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          child: Column(
            children: [
              SizedBox(
                height: 100.0,
              ),
              SizedBox(
                height: 100.0,
              ),
              Text(
                "Feed Screen",
              ),
              SizedBox(
                height: 100.0,
              ),
              ElevatedButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Scaffold(
                      body: Center(
                        child: Text("New Screen Test"),
                      ),
                    ),
                  ),
                ),
                child: Text("Next Screen"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
