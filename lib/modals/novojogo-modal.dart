import 'package:flutter/material.dart';
import 'package:truco/database/db.dart';
import 'package:truco/screens/score.dart';
import 'package:truco/utils/app_colors.dart';
import 'package:truco/utils/app_images.dart';

class NovoJogoModal extends StatelessWidget {
  final TextEditingController equipe1Controller = TextEditingController();
  final TextEditingController equipe2Controller = TextEditingController();

  NovoJogoModal({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(color: AppColors.confirmButtonModal)),
        backgroundColor: AppColors.backgroundColor,
        icon: Image.asset(
          AppImages.botaoTruco,
          width: 60,
          height: 86,
        ),
        title: Text('Nome das equipes',
            style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 20,
                color: Colors.white)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 242,
              height: 40,
              child: TextField(
                cursorColor: AppColors.cancelButtonModal,
                textAlignVertical: TextAlignVertical.center,
                style: TextStyle(color: Colors.white),
                controller: equipe1Controller,
                decoration: InputDecoration(
                  labelText: 'Equipe 1',
                  labelStyle: TextStyle(color: Colors.white),
                  hintText: 'Ex: Os melhorzin',
                  hintStyle: TextStyle(color: AppColors.hintTextColor),
                  filled: true,
                  fillColor: AppColors.scoreContainer,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: AppColors.scoreContainer),
                  ),
                  contentPadding: EdgeInsets.symmetric(horizontal: 16),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              width: 242,
              height: 40,
              child: TextField(
                cursorColor: AppColors.cancelButtonModal,
                textAlignVertical: TextAlignVertical.center,
                style: TextStyle(color: Colors.white),
                controller: equipe2Controller,
                decoration: InputDecoration(
                  labelText: 'Equipe 2',
                  labelStyle: TextStyle(color: Colors.white),
                  hintText: 'Ex: Os melhorzin',
                  hintStyle: TextStyle(color: AppColors.hintTextColor),
                  filled: true,
                  fillColor: AppColors.scoreContainer,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: AppColors.scoreContainer),
                  ),
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                ),
              ),
            )
          ],
        ),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                style: TextButton.styleFrom(
                    backgroundColor: AppColors.cancelButtonModal,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    minimumSize: Size(109, 35)),
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  'Cancelar',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600),
                ),
              ),
              const SizedBox(
                width: 20,
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.confirmButtonModal,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    minimumSize: Size(109, 40)),
                onPressed: () async {
                  final equipe1 = equipe1Controller.text.trim();
                  final equipe2 = equipe2Controller.text.trim();

                  if (equipe1.isEmpty || equipe2.isEmpty) {
                    _mostrarAlerta(context, 'Erro',
                        'Os nomes das equipes não podem estar vazios.');
                    return;
                  }

                  final partida = {
                    'equipe1': equipe1,
                    'equipe2': equipe2,
                    'data': DateTime.now().toIso8601String(),
                    'pontuacao_equipe1': 0,
                    'pontuacao_equipe2': 0,
                    'status': 'em andamento',
                  };

                  int partidaId = await DatabaseHelper().insertPartida(partida);

                  Navigator.pop(context); // Fecha o modal
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PlacarScreen(
                        equipe1: equipe1,
                        equipe2: equipe2,
                        partidaId: partidaId,
                        pontuacaoEquipe1: 0,
                        pontuacaoEquipe2: 0,
                      ),
                    ),
                  );
                },
                child: Text('Confirmar',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600)),
              )
            ],
          )
        ],
      ),
    );
  }

  void _mostrarAlerta(BuildContext context, String titulo, String mensagem) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(titulo),
          content: Text(mensagem),
          actions: [
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
