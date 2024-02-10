import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:voice_assistant_app/featurebox.dart';
import 'package:voice_assistant_app/openapi_service.dart';
import 'package:voice_assistant_app/pallette.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final speechToText = SpeechToText();
  String lastWords = '';
  final OpenAiService openAiService = OpenAiService();
  @override
  void initState() {
    super.initState();
    initSpeechToText();
    // TODO: implement initState
    super.initState();
  }

  Future<void> initSpeechToText() async {
    speechToText.initialize();
    setState(() {});
  }

  Future<void> startListening() async {
    await speechToText.listen(onResult: onSpeechResult);
    setState(() {});
  }

  Future<void> stopListening() async {
    await speechToText.stop();
    setState(() {});
  }

  /// This is the callback that the SpeechToText plugin calls when
  /// the platform returns recognized words.
  void onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      lastWords = result.recognizedWords;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black45,
          shadowColor: Colors.white,
          leading: Icon(Icons.menu),
          title: Text("javad"),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Column(children: [
            Container(
              padding: EdgeInsets.only(top: 30),
              // width: double.maxFinite,
              child: Stack(
                children: [
                  Center(
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: Pallete.assistantCircleColor),
                    ),
                  ),
                  Center(
                    child: Container(
                      height: 100,
                      width: 100,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image: AssetImage(
                                  "assets/images/virtualAssistant.png"))),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              child: Text(
                "What can I do for you?",
                style: TextStyle(
                    fontSize: 30,
                    color: Pallete.mainFontColor,
                    fontFamily: 'Cera Pro'),
              ),
              margin: EdgeInsets.only(left: 30, top: 20, right: 30),
              padding: const EdgeInsets.only(
                  left: 20, right: 20, top: 10, bottom: 10),
              decoration: BoxDecoration(
                  border: Border.all(color: Pallete.borderColor),
                  borderRadius:
                      BorderRadius.circular(20).copyWith(topLeft: Radius.zero)),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              padding: EdgeInsets.only(left: 10),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "here are few commands....",
                  style: TextStyle(
                      fontFamily: 'Cera Pro',
                      color: Pallete.mainFontColor,
                      fontSize: 20),
                ),
              ),
            ),
            Column(
              children: [
                FeatureBox(
                  color: Pallete.firstSuggestionBoxColor,
                  htext: "hi dude SBHSKJSXNZKL;ASSOZ;NKSZN;SNSKLSKLN",
                  descriptiontext: "chatgpt",
                ),
                FeatureBox(
                  color: Pallete.secondSuggestionBoxColor,
                  htext:
                      "orm various tasks using voice commands. We will demonstrate how to integrate ChatGPT, a state-of-the-art natural language processing model",
                  descriptiontext: "chatgpt",
                ),
                FeatureBox(
                  color: Pallete.thirdSuggestionBoxColor,
                  htext:
                      "orm various tasks using voice commands. We will demonstrate how to integrate ChatGPT, a state-of-the-art natural language processing model",
                  descriptiontext: "DALL E",
                )
              ],
            )
          ]),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            if (await speechToText.hasPermission &&
                speechToText.isNotListening) {
              await startListening();
            } else if (speechToText.isListening) {
              openAiService.isArtPrompt(lastWords);
              await stopListening();
            } else {
              initSpeechToText();
            }
            print(lastWords);
          },
          child: Icon(Icons.mic),
        ),
      ),
    );
  }
}
