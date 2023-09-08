import 'package:flutter/material.dart';
import 'package:unichat_ai/constants/topic_list.dart';
import 'package:unichat_ai/pages/messaging.dart';
import 'package:unichat_ai/constants/api_consts.dart';
import 'package:unichat_ai/services/global_state.dart';
import 'package:unichat_ai/widgets/bottom_menu.dart';

class MenuPage extends StatefulWidget {
  static String topicContent = "";
  final Function(String)? updateTopicCallback;
  MenuPage({this.updateTopicCallback});

  @override
  _MenuPageState createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  late List<Map<String, String>> topics = [];

  @override
  void initState() {
    super.initState();
    _fetchTopics();
  }

  _fetchTopics() async {
    topics = await readTopicsFromFile();
    setState(() {});  // Rebuild the widget
  }

  void _selectTopic(int index) {
    try {
    GlobalState().clearMessageList();
    MenuPage.topicContent = topics[index]['content'] ?? '';
    BottomMenuRibbon.cachedMessengerPage = MessengerPage(topicContent: MenuPage.topicContent);
    print("2: ${BottomMenuRibbon.cachedMessengerPage!.topicContent}");
    
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BottomMenuRibbon.cachedMessengerPage!,
      ),
    );
    } catch (e, stacktrace) {
    print("Exception during build: $e");
    print(stacktrace);
  }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: topics.isNotEmpty
          ? GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 1.5,
            crossAxisSpacing: 8.0,
            mainAxisSpacing: 8.0,
          ),
          itemCount: topics.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                //String selectedTopicContent = topics[index]['content'] ?? '';
                _selectTopic(index);
              },
              child: Card(
                color: Colors.grey[300],
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Center(
                    child: Text(
                      topics[index]['title'] ?? '',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        )
        : Center(child: CircularProgressIndicator()),
      );
    
  }
}