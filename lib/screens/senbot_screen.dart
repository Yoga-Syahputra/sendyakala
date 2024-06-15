import 'package:flutter/material.dart';

class Topic {
  final String name;
  final List<QuestionAnswer> questions;

  Topic({required this.name, required this.questions});
}

class QuestionAnswer {
  final String question;
  final String answer;

  QuestionAnswer({required this.question, required this.answer});
}

final List<Topic> topics = [
  Topic(
    name: 'Self-Improvement',
    questions: [
      QuestionAnswer(
        question: 'How can I improve my productivity?',
        answer: 'Consider setting clear goals, creating a schedule, and eliminating distractions.',
      ),
      QuestionAnswer(
        question: 'What are some good habits to develop?',
        answer: 'Developing habits like regular exercise, reading, and mindfulness can significantly improve your quality of life.',
      ),
      // Add more questions as needed
    ],
  ),
  // Add more topics as needed
];

class SenBotScreen extends StatefulWidget {
  const SenBotScreen({Key? key}) : super(key: key);

  @override
  _SenBotScreenState createState() => _SenBotScreenState();
}

class _SenBotScreenState extends State<SenBotScreen> {
  final TextEditingController _controller = TextEditingController();
  List<String> messages = [];
  bool hasGreeted = false;
  Topic? selectedTopic;
  int questionIndex = 0;

  final List<String> greetings = ['SenBot', 'Hello', 'Hi', 'Hey there'];
  final List<String> reAskPhrases = [
    'Next',
    'Another question',
    'I\'d like to ask more questions',
    'Can I ask again?'
  ];
  final List<String> switchTopicPhrases = [
    'Another topic',
    'Return to menu',
    'Switch topic'
  ];
  final List<String> endConversationPhrases = [
    'Thank you',
    'Thank you for the advice',
    'That\'s enough thanks!'
  ];
  final List<String> senBotMeaningPhrases = [
    'What is SenBot?',
    'What does SenBot stand for?',
    'I wonder what SenBot means'
  ];

  void handleMessage(String message) {
    if (!hasGreeted && greetings.contains(message)) {
      setState(() {
        messages.add('You: $message');
        messages.add('SenBot: Hello! How can I help you today? Here are some topics you can ask about:');
        messages.add('Topics: ${topics.map((topic) => topic.name).join(', ')}');
        hasGreeted = true;
      });
    } else if (hasGreeted && selectedTopic == null) {
      Topic? topic = topics.firstWhere((t) => t.name == message, orElse: () => Topic(name: '', questions: []));
      if (topic.name.isNotEmpty) {
        setState(() {
          selectedTopic = topic;
          messages.add('You: $message');
          messages.add('SenBot: Great choice! Here are some questions you can ask:');
          messages.addAll(topic.questions.map((qa) => qa.question));
        });
      }
    } else if (selectedTopic != null) {
      if (reAskPhrases.contains(message)) {
        if (questionIndex < selectedTopic!.questions.length - 1) {
          questionIndex++;
          setState(() {
            messages.add('You: $message');
            messages.add('SenBot: ${selectedTopic!.questions[questionIndex].question}');
          });
        } else {
          setState(() {
            messages.add('SenBot: You have asked all the questions in this topic. Please select another topic or end the conversation.');
          });
        }
      } else if (switchTopicPhrases.contains(message)) {
        setState(() {
          selectedTopic = null;
          questionIndex = 0;
          messages.add('You: $message');
          messages.add('SenBot: Here are some topics you can ask about:');
          messages.add('Topics: ${topics.map((topic) => topic.name).join(', ')}');
        });
      } else if (endConversationPhrases.contains(message)) {
        setState(() {
          messages.add('You: $message');
          messages.add('SenBot: Thank you for chatting with me. Have a great day!');
          hasGreeted = false;
          selectedTopic = null;
          questionIndex = 0;
        });
      } else if (senBotMeaningPhrases.contains(message)) {
        setState(() {
          messages.add('You: $message');
          messages.add('SenBot: SenBot is your friendly assistant for mental well-being and self-improvement.');
        });
      } else {
        QuestionAnswer? qa = selectedTopic!.questions.firstWhere((qa) => qa.question == message, orElse: () => QuestionAnswer(question: '', answer: ''));
        if (qa.question.isNotEmpty) {
          setState(() {
            messages.add('You: $message');
            messages.add('SenBot: ${qa.answer}');
          });
        } else {
          setState(() {
            messages.add('SenBot: I\'m sorry, I didn\'t understand that. Please select from the available questions or use one of the provided phrases.');
          });
        }
      }
    } else {
      setState(() {
        messages.add('SenBot: I\'m sorry, I didn\'t understand that. Please start the conversation with a greeting.');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SenBot'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              reverse: true,
              itemCount: messages.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: Text(messages[index]),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.8),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: 'Type a message...',
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (value) {
                      handleMessage(value);
                      _controller.clear();
                    },
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    handleMessage(_controller.text);
                    _controller.clear();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
