import 'package:blackforesttools/widgets/custom_text_form_field.dart';
import 'package:blackforesttools/utilities/enums.dart';
import 'package:flutter/material.dart';

mixin APAViewMixin<T extends StatefulWidget> on State<T> {
  static const String apaTitle =
      'A U T O M A T I C   P R A I S E   A P P L I C A T I O N';
  static const String apaEndpoint = 'apa';

  late final CustomTextFormField promptField;
  late final String defaultPrompt;
  late final int _mode;

  late String prompt;

  Map<String, dynamic> get payload => {
        'mode': _mode,
        'prompt': prompt,
      };

  void apaViewMixin(APAModes mode) {
    _mode = mode.index;

    switch (mode) {
      case APAModes.channel:
        defaultPrompt =
            'Make a praise of a maximum of 25 words off of a youtube channel description starting with the phrase "I specially like how...". If the description is too short a video transcript will also be provided (all in the same message). The channel description, and if necessary, a video transcript, will be provided on the following message, the first paragraph being the channel description.';
        break;
      case APAModes.instagram:
        defaultPrompt =
            'Make a praise of a maximum of 25 words off of the info of an Instagram user. In the following message you will be provided with the Instagram user\'s info, which contains the user handle, the user bio, and the caption of the user\'s latest five posts. The praise must begin with "I specially like how...". The praise must be in first person, as if you were talking to the Instagram user in question.';
        break;
      case APAModes.tiktok:
        defaultPrompt =
            'Make a praise of a maximum of 25 words off of the info of a TikTok account. In the following message you will be provided with the TikTok account\'s info, which contains the username, the user bio, and the title of the user\'s latest five posts. The praise must begin with "I specially like how...". The praise must be in first person, as if you were talking to the TikTok account user in question.';
        break;
      case APAModes.video:
        defaultPrompt =
            'Make a praise of a maximum of 25 words off of a youtube video transcript that will be provided on the following message, it must contain specific references from the video, starting with the phrase "I specially like how...".';
        break;
    }

    prompt = defaultPrompt;

    promptField = CustomTextFormField(
      hintText: 'prompt...',
      validator: (inputPrompt) {
        if (inputPrompt == null || inputPrompt.isEmpty) {
          return 'Please enter a ChatGPT prompt';
        }

        setState(() {
          prompt = inputPrompt;
        });

        return null;
      },
      initialValue: defaultPrompt,
    );
  }
}
