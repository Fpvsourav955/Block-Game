import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import '../game/block_blast_game.dart';
import '../services/storage_service.dart';
import '../services/audio_service.dart';
import '../services/vibration_service.dart';
import '../widgets/score_display.dart';
import 'game_over_screen.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late final BlockSurgeGame _game;
  int _currentScore = 0;
  int _highScore = 0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initGame();
  }

  Future<void> _initGame() async {
    final high = await StorageService.loadHighScore();
    _highScore = high;

    _game = BlockSurgeGame(
      initialHighScore: high,
      onScoreUpdated: (score, newHigh, isNewRecord) {
        setState(() {
          _currentScore = score;
          _highScore = newHigh;
        });
        if (isNewRecord) {
          StorageService.saveHighScore(newHigh);
        }
      },
      onGameOver: (score, high, lines, combo, isNewRecord) {
        StorageService.recordGameSession(linesCleared: lines, combo: combo);
        if (isNewRecord) {
          StorageService.saveHighScore(high);
        }
        _showGameOverModal(score, high, lines, combo, isNewRecord);
      },
      onPlaySound: (type) {
        switch (type) {
          case 'pickup':
            AudioService.playPickup();
            break;
          case 'place':
            AudioService.playPlace();
            break;
          case 'clear':
            AudioService.playClear();
            break;
          case 'combo':
            AudioService.playCombo();
            break;
          case 'record':
            AudioService.playRecord();
            break;
          case 'gameover':
            AudioService.playGameOver();
            break;
          case 'cancel':
            AudioService.playCancel();
            break;
        }
      },
      onVibrate: (type) {
        switch (type) {
          case 'light':
            VibrationService.light();
            break;
          case 'medium':
            VibrationService.medium();
            break;
          case 'heavy':
            VibrationService.heavy();
            break;
        }
      },
    );

    setState(() => _isLoading = false);
  }

  void _showGameOverModal(int score, int high, int lines, int combo, bool isNewRecord) {
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.75),
      builder: (ctx) => GameOverModal(
        score: score,
        highScore: high,
        linesCleared: lines,
        maxCombo: combo,
        isNewRecord: isNewRecord,
        onPlayAgain: () {
          Navigator.pop(ctx);
          _game.resetGame();
        },
        onHome: () {
          Navigator.pop(ctx);
          Navigator.pop(context);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: Color(0xFF0F1E4A),
        body: Center(
          child: CircularProgressIndicator(color: Color(0xFF38BDF8)),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFF0F1E4A),
      body: SafeArea(
        child: Stack(
          children: [
            Positioned.fill(
              child: GameWidget(game: _game),
            ),
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: ScoreDisplay(
                currentScore: _currentScore,
                highScore: _highScore,
                onSettingsPressed: () {
                  Navigator.pushNamed(context, '/settings');
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
