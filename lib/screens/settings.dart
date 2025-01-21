import "package:flutter/material.dart";
import "package:flutter/widgets.dart";
import "package:truco/screens/personalization.dart";
import "package:truco/utils/app_colors.dart";
import "package:truco/utils/app_images.dart";
import "package:truco/utils/utils.dart";

class Settings extends StatelessWidget {
  static const String screenName = "/settings";
  const Settings({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Theme(
          data: Theme.of(context).copyWith(
            iconTheme: const IconThemeData(color: Colors.white),
          ),
          child: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        centerTitle: true,
        title: const Text('Configurações'),
      ),
      body: Column(
        children: [
          Row(children: [
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
              child: GestureDetector(
                  onTap: () {
                    navigatorKey.currentState!
                        .pushNamed(Personalization.screenName);
                  },
                  child: Container(
                      width: 350,
                      height: 50,
                      child: ColoredBox(
                        color: Colors.transparent,
                        child: Row(children: [
                          Image.asset(AppImages.personalizationIcon),
                          const SizedBox(width: 30),
                          const Text(
                            'Personalização',
                            style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                                fontWeight: FontWeight.w400),
                          ),
                        ]),
                      ))),
            ),
          ]),
        ],
      ),
    );
  }
}
