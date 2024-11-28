import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();

  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, 'truco.db');

    return await openDatabase(
      path,
      version: 2, // Atualize a versão para 2
      onCreate: _onCreate,
      onUpgrade: _onUpgrade, // Adicione o suporte a upgrades
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE partidas (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        equipe1 TEXT NOT NULL,
        equipe2 TEXT NOT NULL,
        pontuacao_equipe1 INTEGER NOT NULL DEFAULT 0,
        pontuacao_equipe2 INTEGER NOT NULL DEFAULT 0,
        data TEXT NOT NULL,
        status TEXT NOT NULL DEFAULT 'em andamento'
      )
    ''');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      // Atualize a tabela na versão 2
      await db.execute(
          'ALTER TABLE partidas ADD COLUMN status TEXT NOT NULL DEFAULT "em andamento"');
    }
  }

  Future<int> insertPartida(Map<String, dynamic> partida) async {
    final db = await database;
    return await db.insert('partidas', partida);
  }

  Future<List<Map<String, dynamic>>> getPartidas() async {
    final db = await database;
    return await db.query('partidas', orderBy: 'data DESC');
  }

  Future<void> deletePartidas() async {
    final db = await database;
    await db.delete('partidas');
  }

  Future<void> updatePontuacao(
      int id, int pontuacaoEquipe1, int pontuacaoEquipe2) async {
    final db = await database;

    await db.update(
      'partidas',
      {
        'pontuacao_equipe1': pontuacaoEquipe1,
        'pontuacao_equipe2': pontuacaoEquipe2,
      },
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<Map<String, dynamic>?> getUltimaPartida() async {
    final db = await database;

    // Busca a última partida ordenada pela data (mais recente primeiro)
    final result = await db.query(
      'partidas',
      orderBy: 'data DESC',
      limit: 1,
    );

    return result.isNotEmpty ? result.first : null;
  }

  Future<void> atualizarPontuacao(
      int partidaId, int pontuacaoEquipe1, int pontuacaoEquipe2) async {
    final db = await database;

    await db.update(
      'partidas',
      {
        'pontuacao_equipe1': pontuacaoEquipe1,
        'pontuacao_equipe2': pontuacaoEquipe2,
      },
      where: 'id = ?',
      whereArgs: [partidaId],
    );
  }
}
