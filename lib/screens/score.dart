// ignore_for_file: library_private_types_in_public_api

// import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:truco/widgets/bouncing_text.dart';
import 'package:truco/database/db.dart';
import 'package:truco/controllers/score_colors_state_maneger.dart';
// import 'package:truco/modals/editname.dart';
// import 'package:truco/modals/editname.dart';
import 'package:truco/screens/settings.dart';
import 'package:truco/utils/utils.dart';

class PlacarScreen extends StatefulWidget {
  final String equipe1;
  final String equipe2;
  final int pontuacaoEquipe1;
  final int pontuacaoEquipe2;
  final int partidaId;

  const PlacarScreen({
    super.key,
    required this.equipe1,
    required this.equipe2,
    required this.pontuacaoEquipe1,
    required this.pontuacaoEquipe2,
    required this.partidaId,
  });

  @override
  _PlacarScreenState createState() => _PlacarScreenState();
}

class _PlacarScreenState extends State<PlacarScreen> {
  late int pontuacaoEquipe1;
  late int pontuacaoEquipe2;
  int pontosBotaoTruco = 0;
  String? equipeVencedora;

  @override
  void initState() {
    super.initState();
    pontuacaoEquipe1 = widget.pontuacaoEquipe1;
    pontuacaoEquipe2 = widget.pontuacaoEquipe2;
    SystemChrome.setPreferredOrientations(DeviceOrientation.values);
  }

  @override
  void dispose() {
    super.dispose();
    // Opcional: Restaurar a orientação padrão ou travar novamente para outra tela
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  }

  void truco() {
    setState(() {
      if (pontosBotaoTruco >= 12) {
        pontosBotaoTruco = 0;
      }
      pontosBotaoTruco += 3;
    });
  }

  Future<void> _salvarPontuacao() async {
    await DatabaseHelper().atualizarPontuacao(
      widget.partidaId,
      pontuacaoEquipe1,
      pontuacaoEquipe2,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    return Scaffold(
      body: Stack(
        children: [
          isLandscape ? _buildLandscapeLayout() : _buildPortraitLayout(),
          if (equipeVencedora != null)
            Center(
              child: BouncingText(
                winnerTeam: "${equipeVencedora!} venceu!",
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildEquipePlacar(
      String equipe, int pontuacao, Function(int) onAtualizarPontuacao) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(equipe,
            style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white)),
        SizedBox(height: 20),
        Container(
            width: 220,
            height: 120,
            decoration: BoxDecoration(
              color: AppColors.scoreContainer,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      // botao de subtrair
                      onPressed: () => {
                        if (pontuacao > 0) onAtualizarPontuacao(pontuacao - 1)
                      },
                      icon: Container(
                        decoration: BoxDecoration(
                          color: AppColors.scoreButton,
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: Icon(
                          Icons.remove,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Container(
                      // placar
                      width: 120,
                      height: 50,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: AppColors.scoreButton,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(pontuacao.toString(),
                          style: TextStyle(fontSize: 32, color: Colors.white)),
                    ),
                    IconButton(
                      // botao de adicionar
                      onPressed: () {
                        if (pontuacao < 12) {
                          onAtualizarPontuacao(pontuacao + 1);
                        }
                        if (pontosBotaoTruco > 0 && pontuacao < 11) {
                          onAtualizarPontuacao(pontosBotaoTruco + pontuacao);
                        }

                        setState(() {
                          pontosBotaoTruco = 0;
                        });
                      },
                      icon: Container(
                        decoration: BoxDecoration(
                          color: AppColors.scoreButton,
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: Icon(
                          Icons.add,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Text('Pontos',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 27,
                        fontWeight: FontWeight.w600)),
              ],
            )),
      ],
    );
  }

  Widget _buildEquipePlacarPortrait(
      String equipe, int pontuacao, Function(int) onAtualizarPontuacao) {
    if (pontuacao == 12) {
      return BouncingText(
        winnerTeam: (pontuacaoEquipe1 > pontuacaoEquipe2)
            ? widget.equipe1
            : widget.equipe2,
      );
    }
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Consumer<ScoreColorsStateManeger>(
            builder: (context, scoreColorsStateManeger, child) {
          return Container(
              width: 220,
              height: 120,
              decoration: BoxDecoration(
                color: scoreColorsStateManeger
                    .defaultColor, // tenho que mudar aqui a cor
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        // botao de subtrair
                        onPressed: () => {
                          if (pontuacao > 0) onAtualizarPontuacao(pontuacao - 1)
                        },
                        icon: Container(
                          decoration: BoxDecoration(
                            color: AppColors.scoreButton,
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: Icon(
                            Icons.remove,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Container(
                        // placar
                        width: 120,
                        height: 50,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: AppColors.scoreButton,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(pontuacao.toString(),
                            style:
                                TextStyle(fontSize: 32, color: Colors.white)),
                      ),
                      IconButton(
                        // botao de adicionar
                        onPressed: () {
                          // função de incrementar com o truco
                          if (pontuacao < 12) {
                            onAtualizarPontuacao(pontuacao + 1);
                          }
                          if (pontosBotaoTruco > 0 && pontuacao < 11) {
                            onAtualizarPontuacao(pontosBotaoTruco + pontuacao);
                          }

                          setState(() {
                            pontosBotaoTruco = 0;
                          });
                        },
                        icon: Container(
                          decoration: BoxDecoration(
                            color: AppColors.scoreButton,
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: Icon(
                            Icons.add,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Text('Pontos',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 27,
                          fontWeight: FontWeight.w600)),
                ],
              ));
        }),
        SizedBox(height: 60),
        Text(equipe,
            style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white)),
      ],
    );
  }

  Widget _buildPortraitLayout() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        RotatedBox(
          quarterTurns: 2, // 180 graus
          child: _buildEquipePlacarPortrait(widget.equipe1, pontuacaoEquipe1,
              (novaPontuacao) {
            setState(() => pontuacaoEquipe1 = novaPontuacao);
            _salvarPontuacao();
          }),
        ),
        SizedBox(height: 40),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: 50,
              height: 1,
              color: Colors.white,
            ),
            IconButton(
                iconSize: 45,
                onPressed: () => Navigator.pop(context),
                icon: Container(
                    decoration: BoxDecoration(
                      color: AppColors.scoreButton,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(Icons.home_rounded, color: Colors.white))),
            Container(
              width: 12,
              height: 1,
              color: Colors.white,
            ),
            Center(
                child: GestureDetector(
                    onTap: () {
                      setState(() {
                        truco();
                      });
                    },
                    child: pontosBotaoTruco == 0
                        ? (Image.asset(AppImages.botaoTruco, width: 120))
                        : Text('+$pontosBotaoTruco',
                            style:
                                TextStyle(fontSize: 32, color: Colors.white)))),
            Container(
              width: 12,
              height: 1,
              color: Colors.white,
            ),
            IconButton(
                iconSize: 45,
                onPressed: () =>
                    {navigatorKey.currentState?.pushNamed(Settings.screenName)},
                icon: Container(
                    decoration: BoxDecoration(
                      color: AppColors.scoreButton,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(Icons.settings, color: Colors.white))),
            Container(
              width: 50,
              height: 1,
              color: Colors.white,
            ),
          ],
        ),
        SizedBox(height: 40),
        _buildEquipePlacarPortrait(widget.equipe2, pontuacaoEquipe2,
            (novaPontuacao) {
          setState(() => pontuacaoEquipe2 = novaPontuacao);
          _salvarPontuacao();
        }),
      ],
    );
  }

  Widget _buildLandscapeLayout() {
    // if (pontuacaoEquipe1 == 12 || pontuacaoEquipe2 == 12) {
    //   return BouncingText(
    //     winnerTeam: (pontuacaoEquipe1 > pontuacaoEquipe2)
    //         ? widget.equipe1
    //         : widget.equipe2,
    //   );
    // }
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        RotatedBox(
          quarterTurns: 0, // 180 graus
          //placar da equipe 1 horizontal
          child: pontuacaoEquipe1 == 12
              ? BouncingText(winnerTeam: widget.equipe1)
              : _buildEquipePlacar(widget.equipe1, pontuacaoEquipe1,
                  (novaPontuacao) {
                  setState(() => pontuacaoEquipe1 = novaPontuacao);
                  _salvarPontuacao();
                }),
        ),
        SizedBox(width: 40),
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: 1,
              height: 50,
              color: Colors.white,
            ),
            IconButton(
                iconSize: 45,
                onPressed: () => Navigator.pop(context),
                icon: Container(
                    decoration: BoxDecoration(
                      color: AppColors.scoreButton,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(Icons.home_rounded, color: Colors.white))),
            Container(
              width: 1,
              height: 12,
              color: Colors.white,
            ),
            Center(
              child: GestureDetector(
                  onTap: () {
                    setState(() {
                      truco();
                    });
                  },
                  child: pontosBotaoTruco == 0
                      ? (Image.asset(AppImages.botaoTruco, width: 120))
                      : Text('+$pontosBotaoTruco',
                          style: TextStyle(fontSize: 32, color: Colors.white))),
            ),
            Container(
              width: 1,
              height: 12,
              color: Colors.white,
            ),
            IconButton(
                iconSize: 45,
                onPressed: () =>
                    {navigatorKey.currentState?.pushNamed(Settings.screenName)},
                icon: Container(
                    decoration: BoxDecoration(
                      color: AppColors.scoreButton,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(Icons.settings, color: Colors.white))),
            Container(
              width: 1,
              height: 50,
              color: Colors.white,
            ),
          ],
        ),
        SizedBox(width: 40),
        //placar da equipe 2 horizontal
        RotatedBox(
          quarterTurns: 0,
          child: pontuacaoEquipe2 == 12
              ? BouncingText(winnerTeam: widget.equipe2)
              : _buildEquipePlacar(widget.equipe2, pontuacaoEquipe2,
                  (novaPontuacao) {
                  setState(() => pontuacaoEquipe2 = novaPontuacao);
                  _salvarPontuacao();
                }),
        )
      ],
    );
  }
}
