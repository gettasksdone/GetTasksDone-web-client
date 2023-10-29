import "package:flutter/material.dart";

void main() {
  runApp(const GTDWebClient());
}

class GTDWebClient extends StatelessWidget {
  const GTDWebClient({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text("Get Things Done!"),
      ),
      body: const Center(
        child: Text("This text is in the body!"),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          print("Button has been pressed!");
        },
      ),
      bottomNavigationBar: BottomNavigationBar(items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: "Home",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.business),
          label: "Business",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.school),
          label: "School",
        ),
      ]),
    ));
  }
}
