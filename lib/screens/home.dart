import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:truco/database/db.dart';
import 'package:truco/modals/novojogo-modal.dart';
import 'package:truco/screens/score.dart';
import 'package:truco/utils/app_colors.dart';
import 'package:truco/utils/app_images.dart';

class HomeScreen extends StatefulWidget {
  static const String screenName = "/home";

  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<Map<String, dynamic>>> _partidasFuture;

  @override
  void initState() {
    super.initState();
    _carregarPartidas();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
  }

  @override
  void dispose() {
    // Restaurar a orientação padrão ao sair da tela
    SystemChrome.setPreferredOrientations(DeviceOrientation.values);
    super.dispose();
  }

  void _carregarPartidas() {
    setState(() {
      _partidasFuture = DatabaseHelper().getPartidas();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Truco!'),
          centerTitle: true,
        ),
        body: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  _buildCarousel(context),
                  const SizedBox(height: 50),
                  Container(
                      width: 330,
                      height: 338,
                      padding:
                          const EdgeInsets.only(top: 10, left: 10, right: 10),
                      decoration: BoxDecoration(
                        color: AppColors.appBarColor, //mudar depois
                        borderRadius: BorderRadius.circular(30),
                      ),
                      clipBehavior: Clip.hardEdge,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const Padding(
                            padding:
                                EdgeInsets.only(left: 10, top: 10, bottom: 15),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Últimas partidas",
                                style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          Expanded(
                            child: RefreshIndicator(
                              onRefresh: () async {
                                _carregarPartidas();
                              },
                              child: FutureBuilder<List<Map<String, dynamic>>>(
                                future: _partidasFuture,
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const Center(
                                        child: CircularProgressIndicator());
                                  }

                                  if (snapshot.hasError) {
                                    return const Center(
                                        child:
                                            Text('Erro ao carregar partidas'));
                                  }

                                  if (!snapshot.hasData ||
                                      snapshot.data!.isEmpty) {
                                    return const Center(
                                        child: Text(
                                      'Nenhuma partida registrada.',
                                      style: TextStyle(color: Colors.white),
                                    ));
                                  }

                                  final partidas = snapshot.data!;
                                  return ListView.separated(
                                    separatorBuilder: (context, index) =>
                                        const Divider(
                                      color: Colors.white,
                                      thickness: 1,
                                      indent: 10,
                                      endIndent: 10,
                                      height: 1,
                                    ),
                                    itemCount: partidas.length,
                                    itemBuilder: (context, index) {
                                      final partida = partidas[index];
                                      return Card(
                                        color: AppColors
                                            .appBarColor, //mudar depois
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            children: [
                                              Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      '${partida['equipe1']}',
                                                      style: TextStyle(
                                                          fontSize: 17,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color: partida[
                                                                      'pontuacao_equipe1'] >
                                                                  partida[
                                                                      'pontuacao_equipe2']
                                                              ? Colors.white
                                                              : AppColors
                                                                  .scoreText),
                                                    ),
                                                    Text(
                                                      '${partida['pontuacao_equipe1']}',
                                                      style: TextStyle(
                                                          fontSize: 17,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color: partida[
                                                                      'pontuacao_equipe1'] >
                                                                  partida[
                                                                      'pontuacao_equipe2']
                                                              ? Colors.white
                                                              : AppColors
                                                                  .scoreText),
                                                    )
                                                  ]),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    '${partida['equipe2']}',
                                                    style: TextStyle(
                                                        fontSize: 17,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: partida[
                                                                    'pontuacao_equipe2'] >
                                                                partida[
                                                                    'pontuacao_equipe1']
                                                            ? Colors.white
                                                            : AppColors
                                                                .scoreText),
                                                  ),
                                                  Text(
                                                    '${partida['pontuacao_equipe2']}',
                                                    style: TextStyle(
                                                        fontSize: 17,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: partida[
                                                                    'pontuacao_equipe2'] >
                                                                partida[
                                                                    'pontuacao_equipe1']
                                                            ? Colors.white
                                                            : AppColors
                                                                .scoreText),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      )),
                ],
              ),
            );
          },
        ));
  }

  Widget _buildCarousel(BuildContext context) {
    final pageController = PageController(
      viewportFraction: 0.6, // Define a largura relativa de cada item
    );

    return SizedBox(
      height: 287,
      child: PageView.builder(
        controller: pageController,
        physics: const BouncingScrollPhysics(),
        itemCount: 2, // Número de itens no carrossel
        itemBuilder: (context, index) {
          return AnimatedBuilder(
            animation: pageController,
            builder: (context, child) {
              // Calcula a posição do item em relação ao índice ativo
              double value = 0.0;
              if (pageController.position.haveDimensions) {
                value = pageController.page! - index;
                value = (1 - value.abs()).clamp(0.0, 1.0);
              } else {
                value = index == 0 ? 1.0 : 0.0;
              }

              // Define a escala e a opacidade baseadas no valor calculado
              return Transform.scale(
                scale: 0.8 + (value * 0.2), // Escala para itens destacados
                child: Opacity(
                  opacity: 0.5 + (value * 0.5), // Suaviza a transição
                  child: child,
                ),
              );
            },
            child: _buildCarouselItem(
              context,
              imagePath: index == 0
                  ? AppImages.completedCardNewGame
                  : AppImages.completedCardContinue,
              onTap: index == 0
                  ? () => _mostrarNovoJogoModal(context)
                  : () async {
                      final ultimaPartida =
                          await DatabaseHelper().getUltimaPartida();
                      if (ultimaPartida == null) {
                        _mostrarAlerta(context, 'Erro',
                            'Nenhuma partida encontrada para continuar.');
                        return;
                      }
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PlacarScreen(
                            equipe1: ultimaPartida['equipe1'],
                            equipe2: ultimaPartida['equipe2'],
                            pontuacaoEquipe1:
                                ultimaPartida['pontuacao_equipe1'],
                            pontuacaoEquipe2:
                                ultimaPartida['pontuacao_equipe2'],
                            partidaId: ultimaPartida['id'],
                          ),
                        ),
                      );
                    },
            ),
          );
        },
      ),
    );
  }

  Widget _buildCarouselItem(BuildContext context,
      {required String imagePath, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(imagePath, height: 287, width: 221),
        ],
      ),
    );
  }

  void _mostrarNovoJogoModal(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (context) {
        return NovoJogoModal();
      },
    );
    _carregarPartidas(); // Atualiza a lista após criar uma nova partida
  }

  void _mostrarAlerta(BuildContext context, String titulo, String mensagem) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(titulo),
          content: Text(mensagem),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
