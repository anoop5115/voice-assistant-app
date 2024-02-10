import 'dart:convert';
import 'dart:html';

import 'package:speech_to_text/speech_to_text.dart';
import 'package:http/http.dart' as http;
import './secrets.dart';

// class OpenAiService {
//   Future<String?> isArtPrompt(String prompt) async {
//     try {
//       final res = await http.post(
//           Uri.parse('https://api.openai.com/v1/chat/completions'),
//           headers: {
//             "Content-Type": "application/json",
//             "Authorization": "Bearer $openAIAPIKey"
//           },
//           body: jsonEncode({
//             "model": "gpt-3.5-turbo",
//             "messages": [
//               {"role": "system", "content": "You are a helpful assistant."},
//               {
//                 "role": "user",
//                 "content":
//                     "Does this message  generate an AI picture similar? $prompt.Simply answer with a Yes or No"
//               }
//             ]
//           }));
//       print(res.body);
//       if (res.statusCode == 200) {
//         print("yaa");
//       }
//       return 'AI';
//     } catch (e) {
//       return e.toString();
//     }
//   }

//   Future<String?> chatgpt(String prompt) async {
//     return 'CHATGPT';
//   }

//   Future<String?> dalle(String prompt) async {
//     return 'DALL-E';
//   }
// }
import 'package:retry/retry.dart';

class OpenAiService {
  Future<String?> isArtPrompt(String prompt) async {
    try {
      final res = await retry(
        () async {
          return await http.post(
            Uri.parse('https://api.openai.com/v1/chat/completions'),
            headers: {
              "Content-Type": "application/json",
              "Authorization": "Bearer $openAIAPIKey",
            },
            body: jsonEncode({
              "model": "gpt-3.5-turbo",
              "messages": [
                {"role": "system", "content": "You are a helpful assistant."},
                {
                  "role": "user",
                  "content":
                      "Does this message generate an AI picture similar? $prompt. Simply answer with a Yes or No",
                },
              ],
            }),
          );
        },
        maxAttempts: 5, // Adjust the maximum number of retry attempts
        delayFactor: Duration(seconds: 5), // Adjust the delay between retries
      );

      if (res.statusCode == 200) {
        print("Success: ${res.body}");
        return 'AI';
      } else if (res.statusCode == 429) {
        print("Error: Rate Limit Exceeded");
        // Handle rate limit exceeded error, possibly by logging, informing the user, or taking appropriate action
        return null;
      } else if (res.statusCode == 402 &&
          res.body.contains("insufficient_quota")) {
        print("Error: Insufficient Quota");
        // Handle insufficient quota error
        return null;
      } else {
        print("Error: ${res.statusCode}, ${res.reasonPhrase}");
        // Handle other errors or return appropriate value
        return 'AI';
      }
    } catch (e) {
      print("Exception: $e");
      // Handle exceptions or return appropriate value
      return e.toString();
    }
  }
}
// import 'dart:convert';

// // import 'package:allen/secrets.dart';
// import 'package:http/http.dart' as http;
// import 'package:voice_assistant_app/secrets.dart';

// class OpenAIService {
//   final List<Map<String, String>> messages = [];

//   Future<String> isArtPromptAPI(String prompt) async {
//     try {
//       final res = await http.post(
//         Uri.parse('https://api.openai.com/v1/chat/completions'),
//         headers: {
//           'Content-Type': 'application/json',
//           'Authorization': 'Bearer $openAIAPIKey',
//         },
//         body: jsonEncode({
//           "model": "gpt-3.5-turbo",
//           "messages": [
//             {
//               'role': 'user',
//               'content':
//                   'Does this message want to generate an AI picture, image, art or anything similar? $prompt . Simply answer with a yes or no.',
//             }
//           ],
//         }),
//       );
//       print(res.body);
//       if (res.statusCode == 200) {
//         String content =
//             jsonDecode(res.body)['choices'][0]['message']['content'];
//         content = content.trim();

//         switch (content) {
//           case 'Yes':
//           case 'yes':
//           case 'Yes.':
//           case 'yes.':
//             final res = await dallEAPI(prompt);
//             return res;
//           default:
//             final res = await chatGPTAPI(prompt);
//             return res;
//         }
//       }
//       return 'An internal error occurred';
//     } catch (e) {
//       return e.toString();
//     }
//   }

//   Future<String> chatGPTAPI(String prompt) async {
//     messages.add({
//       'role': 'user',
//       'content': prompt,
//     });
//     try {
//       final res = await http.post(
//         Uri.parse('https://api.openai.com/v1/chat/completions'),
//         headers: {
//           'Content-Type': 'application/json',
//           'Authorization': 'Bearer $openAIAPIKey',
//         },
//         body: jsonEncode({
//           "model": "gpt-3.5-turbo",
//           "messages": messages,
//         }),
//       );

//       if (res.statusCode == 200) {
//         String content =
//             jsonDecode(res.body)['choices'][0]['message']['content'];
//         content = content.trim();

//         messages.add({
//           'role': 'assistant',
//           'content': content,
//         });
//         return content;
//       }
//       return 'An internal error occurred';
//     } catch (e) {
//       return e.toString();
//     }
//   }

//   Future<String> dallEAPI(String prompt) async {
//     messages.add({
//       'role': 'user',
//       'content': prompt,
//     });
//     try {
//       final res = await http.post(
//         Uri.parse('https://api.openai.com/v1/images/generations'),
//         headers: {
//           'Content-Type': 'application/json',
//           'Authorization': 'Bearer $openAIAPIKey',
//         },
//         body: jsonEncode({
//           'prompt': prompt,
//           'n': 1,
//         }),
//       );

//       if (res.statusCode == 200) {
//         String imageUrl = jsonDecode(res.body)['data'][0]['url'];
//         imageUrl = imageUrl.trim();

//         messages.add({
//           'role': 'assistant',
//           'content': imageUrl,
//         });
//         return imageUrl;
//       }
//       return 'An internal error occurred';
//     } catch (e) {
//       return e.toString();
//     }
//   }

//   static void isArtPrompt(String lastWords) {}
// }
