import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  TextEditingController _textController = TextEditingController();
  List<Widget> messagesWidgets = [];
  bool awaitingUserResponse = false;
  int currentQuestionIndex = 0;

  // Map to store user responses
  Map<String, String> userResponses = {};

  List<Map<String, dynamic>> chatData = [
    {
      'question': 'What are your preferred pronouns?',
      'options': [
        {'text': 'He/Him', 'nextQuestion': 'So let\'s get to know you better , What are your food preferences?'},
        {'text': 'She/Her', 'nextQuestion': 'So let\'s get to know you better , What are your food preferences?'},
        {'text': 'They/Them', 'nextQuestion': 'So let\'s get to know you better , What are your food preferences?'},
        {'text': 'Other', 'nextQuestion': 'So let\'s get to know you better , What are your food preferences?'},
      ],
    },
    {
      'question': 'So let\'s get to know you better , What are your food preferences?',
      'options': [
        {'text': 'Veg', 'nextQuestion': 'Great !! You got a lot of veggies'},
        {'text': 'Non-veg', 'nextQuestion': 'Yum !! Deliciousness in every bite'},
        {'text': 'Vegan!!', 'nextQuestion': 'Go Green ! Go Vegan Right ?'},
      ],
    },
    {
      'question': 'Great !! You got a lot of veggies ,How do you prefer to shed calories?',
      'options': [
        {'text': 'I exercise Daily', 'nextQuestion': 'Yo , got a hard working pal with me , Work that body So what Kind of exercise do you do ?'},
        {'text': 'I exercise 2-3 times a week', 'nextQuestion': 'Dedication and Consistency makes it possible , damn !! What other sports do you enjoy?'},
        {'text': 'I exercise once a week', 'nextQuestion': 'Keep Going to make it a habit ! Any particular reason you play less often?'},
        {'text': 'I seldom Exercise', 'nextQuestion': 'I think you still need to find your source of exercise , am I right'},
      ],
    },
    {
      'question': 'So what Kind of exercise do you do ?',
      'nextQuestion': 'Speaking of which, what is your preferred mode of transport daily?',
    },
    {
      'question': 'Speaking of which, what is your preferred mode of transport daily?',
      'options': [
        {'text': 'Public', 'nextQuestion': 'Next question based on public transport'},
        {'text': 'Private', 'nextQuestion': 'Next question based on private transport'},
        {'text': 'Walking', 'nextQuestion': 'Next question based on walking'},
      ],
    },
    // Add more questions and options as needed
  ];

  @override
  void initState() {
    super.initState();
    showNewQuestion();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Getting to know you better ')),
        backgroundColor: Colors.green,
      ),
      body: Stack(
        children: [
          // Background Image
          Image.asset(
            'assets/images.jpeg', 
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          // Chat Interface
          Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: messagesWidgets.length,
                  itemBuilder: (context, index) => messagesWidgets[index],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _textController,
                        enabled: awaitingUserResponse,
                        decoration: InputDecoration(
                          hintText: awaitingUserResponse
                              ? 'Type your response...'
                              : 'Select an option...',
                          fillColor: Colors.white,
                          filled: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () {
                        _handleUserInput();
                        _textController.clear();
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.green,
                      ),
                      child: Text(awaitingUserResponse ? 'Send' : 'Select'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _handleUserInput() {
    if (awaitingUserResponse) {
      String userResponse = _textController.text;
      if (userResponse.isNotEmpty) {
        _sendMessage(userResponse);
        userResponses[chatData[currentQuestionIndex - 1]['question']] = userResponse;
        showNewQuestion();
      }
    } else {
      _handleOptionSelection();
    }
  }

  void _handleOptionSelection() {
    String selectedOption = _textController.text;
    _sendMessage('You selected: $selectedOption');

    userResponses[chatData[currentQuestionIndex]['question']] = selectedOption;

    Map<String, dynamic> optionData = chatData[currentQuestionIndex]['options']
        .firstWhere((option) => option['text'] == selectedOption);

    String nextQuestion = optionData['nextQuestion'];

    if (nextQuestion != null) {
      awaitingUserResponse = true;
      currentQuestionIndex++;
      showNewQuestion();
    } else {
      awaitingUserResponse = false;
      setState(() {
        messagesWidgets = List.from(messagesWidgets);
      });
    }
  }

  void _sendMessage(String message) {
    messagesWidgets.add(createChatBox(message, true));
    setState(() {
      messagesWidgets = List.from(messagesWidgets);
    });
  }

  Widget createChatBox(String text, bool isUser) {
    return Align(
      alignment: isUser ? Alignment.topRight : Alignment.topLeft,
      child: FractionallySizedBox(
        widthFactor: 2 / 3,
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          padding: EdgeInsets.all(12.0),
          decoration: BoxDecoration(
            color: isUser ? Colors.green : Colors.lightGreen[100],
            borderRadius: BorderRadius.circular(8.0),
            border: Border.all(
              color: Colors.green,
              width: 2.0,
            ),
          ),
          child: Text(
            text,
            style: TextStyle(
              color: isUser ? Colors.white : Colors.black,
              fontWeight: FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }

  Widget createOptionButton(String optionText, String nextQuestion) {
    return Align(
      alignment: Alignment.topLeft,
      child: FractionallySizedBox(
        widthFactor: 2 / 3,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          child: ElevatedButton(
            onPressed: () {
              _sendMessage(optionText);
              if (nextQuestion != null) {
                currentQuestionIndex++;
                showNewQuestion();
              }
            },
            style: ElevatedButton.styleFrom(
              primary: Colors.lightGreen[100],
            ),
            child: Text(optionText),
          ),
        ),
      ),
    );
  }

  void showNewQuestion() {
    if (currentQuestionIndex < chatData.length) {
      String botQuestion = chatData[currentQuestionIndex]['question'];
      List<Map<String, dynamic>> botOptions = List.from(chatData[currentQuestionIndex]['options']);

      messagesWidgets.add(createChatBox(botQuestion, false));

      for (Map<String, dynamic> option in botOptions) {
        messagesWidgets.add(createOptionButton(option['text'], option['nextQuestion']));
      }

      setState(() {
        messagesWidgets = List.from(messagesWidgets);
        awaitingUserResponse = true;
      });
    } else {
      _sendMessage('End of questions.');
      print('User Responses: $userResponses');
    }
  }
}
