import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:truco/controllers/score_colors_state_maneger.dart';
import 'package:truco/utils/app_colors.dart';

class Personalization extends StatefulWidget {
  static const String screenName = "/personalization";
  const Personalization({super.key});

  @override
  State<Personalization> createState() => _PersonalizationState();
}

class _PersonalizationState extends State<Personalization> {
  bool _isExpanded = false;

  final List<Color> colors = [
    AppColors.scoreContainer,
    Colors.red,
    Colors.yellow,
    Colors.green,
    Colors.blue,
  ];

  final List<String> colorNames = [
    'Cor padrão',
    'Vermelho',
    'Amarelo',
    'Verde',
    'Azul',
  ];

  @override
  Widget build(BuildContext context) {
    final scoreColorsState = Provider.of<ScoreColorsStateManeger>(context);
    final selectedColor = scoreColorsState.defaultColor;

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
          title: const Text('Personalização'),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          child: Column(
            children: [
              ExpansionTile(
                leading: const Icon(
                  Icons.color_lens_outlined,
                  color: Colors.white,
                ),
                trailing: Icon(
                  _isExpanded ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                  color: _isExpanded ? Colors.white : Colors.grey,
                ),
                title: const Text(
                  'Cores do placar',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                initiallyExpanded: _isExpanded,
                onExpansionChanged: (expanded) {
                  setState(() {
                    _isExpanded = expanded;
                  });
                },
                children: [
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: colors.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundColor: colors[index],
                        ),
                        title: Text(
                          colorNames[index],
                          style: const TextStyle(
                              fontSize: 18, color: Colors.white),
                        ),
                        trailing: Icon(
                          selectedColor == colors[index]
                              ? Icons.radio_button_checked_rounded
                              : Icons.radio_button_unchecked_rounded,
                          color: Colors.white,
                        ),
                        onTap: () {
                          // Atualiza a cor selecionada no Provider
                          scoreColorsState.changeColor(colors[index]);
                        },
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ));
  }
}
