import 'package:flutter/material.dart';
import 'package:truco/database/db.dart';
import 'package:truco/utils/app_colors.dart';
import 'package:truco/utils/app_images.dart';

class EditTeamName extends StatelessWidget {
  final int partidaId;
  final String equipeAtual;
  final TextEditingController equipeController;

  EditTeamName({
    Key? key,
    required this.partidaId,
    required this.equipeAtual,
  })  : equipeController = TextEditingController(text: equipeAtual),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: AppColors.confirmButtonModal),
        ),
        backgroundColor: AppColors.backgroundColor,
        icon: Image.asset(
          AppImages.botaoTruco,
          width: 60,
          height: 86,
        ),
        title: Text(
          'Alterar nome',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 20,
            color: Colors.white,
          ),
        ),
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
                controller: equipeController,
                decoration: InputDecoration(
                  labelText: 'Novo nome',
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
            const SizedBox(height: 10),
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
                    borderRadius: BorderRadius.circular(10),
                  ),
                  minimumSize: const Size(109, 35),
                ),
                onPressed: () {
                  Navigator.pop(context); // Fecha o modal sem alterar nada.
                },
                child: const Text(
                  'Cancelar',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(width: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.confirmButtonModal,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  minimumSize: const Size(109, 40),
                ),
                onPressed: () async {
                  final equipeName = equipeController.text.trim();

                  if (equipeName.isEmpty) {
                    // Exibe um alerta caso o campo esteja vazio.
                    _mostrarAlerta(
                      context,
                      'Erro',
                      'O nome da equipe não pode estar vazio.',
                    );
                    return;
                  }

                  try {
                    // Atualiza o nome da equipe no banco.
                    await DatabaseHelper()
                        .updateTeamName(partidaId, equipeAtual, equipeName);

                    Navigator.pop(context, equipeName); // Retorna o novo nome.
                  } catch (e) {
                    _mostrarAlerta(
                      context,
                      'Erro',
                      'Erro ao atualizar o nome da equipe.',
                    );
                  }
                },
                child: const Text(
                  'Confirmar',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
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
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
