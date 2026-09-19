import 'dart:math';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import 'config/game_config.dart';
import 'config/animation_config.dart';
import 'models/block_piece.dart';
import 'models/game_state.dart';
import 'systems/board_system.dart';
import 'systems/piece_generator.dart';
import 'systems/scoring_system.dart';
import 'systems/combo_system.dart';
import 'systems/game_over_system.dart';
import 'systems/input_system.dart';
import 'components/board_component.dart';
import 'components/piece_tray_component.dart';
import 'components/piece_component.dart';
import 'components/particle_component.dart';
import 'components/score_component.dart';
import 'components/combo_component.dart';

typedef ScoreUpdateCallback = void Function(int score, int highScore, bool isNewRecord);
typedef GameOverCallback = void Function(int score, int highScore, int linesCleared, int maxCombo, bool isNewRecord);
typedef SoundTriggerCallback = void Function(String soundType);
typedef VibrationTriggerCallback = void Function(String vibrationType);

class BlockSurgeGame extends FlameGame with PanDetector {
  final int initialHighScore;
  final ScoreUpdateCallback onScoreUpdated;
  final GameOverCallback onGameOver;
  final SoundTriggerCallback onPlaySound;
  final VibrationTriggerCallback onVibrate;

  late final BoardSystem boardSystem;
  late final PieceGenerator pieceGenerator;
  late final ScoringSystem scoringSystem;
  late final ComboSystem comboSystem;
  late final GameSessionState sessionState;

  BoardComponent? boardComponent;
  PieceTrayComponent? trayComponent;
  late final ParticleManagerComponent particleManager;

  List<BlockPiece?> trayPieces = [null, null, null];
  DragState? activeDrag;
  PieceComponent? draggingPieceComponent;

  double boardPixelSize = 0.0;
  double trayHeight = 120.0;
  bool isClearingLines = false;

  BlockSurgeGame({
    required this.initialHighScore,
    required this.onScoreUpdated,
    required this.onGameOver,
    required this.onPlaySound,
    required this.onVibrate,
  }) {
    boardSystem = BoardSystem();
    pieceGenerator = PieceGenerator();
    scoringSystem = ScoringSystem(initialHighScore: initialHighScore);
    comboSystem = ComboSystem();
    sessionState = GameSessionState(highScore: initialHighScore);
  }

  @override
  Color backgroundColor() => const Color(0xFF0F1E4A);

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    particleManager = ParticleManagerComponent();
    add(particleManager);

    setupLayout();
    refillTray();
  }

  @override
  void onGameResize(Vector2 newSize) {
    super.onGameResize(newSize);
    setupLayout();
  }

  void setupLayout() {
    if (size.x <= 0 || size.y <= 0) return;

    final padding = 16.0;
    boardPixelSize = min(size.x - padding * 2, size.y * 0.55);
    final boardX = (size.x - boardPixelSize) / 2;
    final boardY = size.y * 0.16;

    if (boardComponent == null) {
      boardComponent = BoardComponent(
        boardSystem: boardSystem,
        position: Vector2(boardX, boardY),
        size: Vector2(boardPixelSize, boardPixelSize),
      );
      add(boardComponent!);
    } else {
      boardComponent!.position = Vector2(boardX, boardY);
      boardComponent!.size = Vector2(boardPixelSize, boardPixelSize);
    }

    final trayY = boardY + boardPixelSize + 32.0;
    final trayWidth = size.x - padding * 2;

    if (trayComponent == null) {
      trayComponent = PieceTrayComponent(
        pieces: trayPieces,
        cellSize: boardComponent!.cellSize,
        position: Vector2(padding, trayY),
        size: Vector2(trayWidth, trayHeight),
      );
      add(trayComponent!);
    } else {
      trayComponent!.position = Vector2(padding, trayY);
      trayComponent!.size = Vector2(trayWidth, trayHeight);
      trayComponent!.refreshSlots();
    }
  }

  void refillTray() {
    final newPieces = pieceGenerator.generateTray(boardSystem);
    for (int i = 0; i < 3; i++) {
      trayPieces[i] = newPieces[i];
    }
    trayComponent?.refreshSlots();
  }

  @override
  void onPanStart(DragStartInfo info) {
    if (sessionState.status == GameStatus.gameOver || isClearingLines) return;

    final touchPoint = info.eventPosition.global;
    if (trayComponent == null || boardComponent == null) return;

    final localTrayPos = touchPoint - trayComponent!.position;
    final slot = trayComponent!.getSlotAtPosition(localTrayPos);

    if (slot != null && trayPieces[slot] != null) {
      final piece = trayPieces[slot]!;
      sessionState.status = GameStatus.dragging;

      activeDrag = DragState(
        piece: piece,
        trayIndex: slot,
        currentTouchPosition: Offset(touchPoint.x, touchPoint.y),
        startTouchPosition: Offset(touchPoint.x, touchPoint.y),
      );

      trayComponent!.hideSlot(slot);

      draggingPieceComponent = PieceComponent(
        piece: piece,
        baseCellSize: boardComponent!.cellSize,
        position: Vector2(
          touchPoint.x - (piece.width * boardComponent!.cellSize) / 2,
          touchPoint.y - GameConfig.dragVerticalFingerOffset - (piece.height * boardComponent!.cellSize) / 2,
        ),
        renderScale: GameConfig.draggedPieceScale,
        isBeingDragged: true,
      );
      add(draggingPieceComponent!);

      onPlaySound('pickup');
      onVibrate('light');
    }
  }

  @override
  void onPanUpdate(DragUpdateInfo info) {
    if (activeDrag == null || draggingPieceComponent == null || boardComponent == null) return;

    final touchPoint = info.eventPosition.global;
    activeDrag!.currentTouchPosition = Offset(touchPoint.x, touchPoint.y);

    final displayPos = activeDrag!.displayPosition;
    draggingPieceComponent!.position = Vector2(
      displayPos.dx - (activeDrag!.piece.width * boardComponent!.cellSize) / 2,
      displayPos.dy - (activeDrag!.piece.height * boardComponent!.cellSize) / 2,
    );

    final localBoardPos = Vector2(displayPos.dx, displayPos.dy) - boardComponent!.position;
    final gridCoords = boardComponent!.getGridCoordinates(localBoardPos);

    if (gridCoords != null) {
      final (r, c) = gridCoords;
      final targetRow = r - (activeDrag!.piece.height / 2).floor();
      final targetCol = c - (activeDrag!.piece.width / 2).floor();

      final canPlace = boardSystem.canPlacePiece(activeDrag!.piece, targetRow, targetCol);
      activeDrag!.targetRow = targetRow;
      activeDrag!.targetCol = targetCol;
      activeDrag!.isValidTarget = canPlace;

      boardComponent!.updatePreview(
        piece: activeDrag!.piece,
        startRow: targetRow,
        startCol: targetCol,
        isValid: canPlace,
      );
    } else {
      activeDrag!.targetRow = null;
      activeDrag!.targetCol = null;
      activeDrag!.isValidTarget = false;
      boardComponent!.clearPreview();
    }
  }

  @override
  void onPanEnd(DragEndInfo info) {
    handleDragEnd();
  }

  @override
  void onPanCancel() {
    handleDragEnd();
  }

  void handleDragEnd() {
    if (activeDrag == null) return;

    final drag = activeDrag!;
    activeDrag = null;

    boardComponent?.clearPreview();

    if (drag.isValidTarget && drag.targetRow != null && drag.targetCol != null) {
      commitPlacement(drag);
    } else {
      trayComponent?.showSlot(drag.trayIndex);
      onPlaySound('cancel');
      onVibrate('light');
    }

    draggingPieceComponent?.removeFromParent();
    draggingPieceComponent = null;
    sessionState.status = GameStatus.playing;
  }

  Future<void> commitPlacement(DragState drag) async {
    final row = drag.targetRow!;
    final col = drag.targetCol!;
    final piece = drag.piece;

    boardSystem.placePiece(piece, row, col);
    trayPieces[drag.trayIndex] = null;
    trayComponent?.refreshSlots();

    for (final coord in piece.coordinates) {
      final r = row + coord.y;
      final c = col + coord.x;
      final rect = boardComponent!.getCellRect(r, c);
      particleManager.spawnPlacementParticles(
        boardComponent!.position + Vector2(rect.center.dx, rect.center.dy),
        piece.theme.glow,
      );
    }

    onPlaySound('place');
    onVibrate('light');

    final completedLines = boardSystem.checkCompletedLines();

    if (completedLines.hasClears) {
      isClearingLines = true;
      sessionState.status = GameStatus.clearing;

      boardSystem.markLinesClearing(completedLines);
      onPlaySound('clear');
      onVibrate('medium');

      for (final r in completedLines.rows) {
        for (int c = 0; c < GameConfig.boardDimension; c++) {
          final rect = boardComponent!.getCellRect(r, c);
          particleManager.spawnLineClearParticles(
            Rect.fromLTWH(
              boardComponent!.position.x + rect.left,
              boardComponent!.position.y + rect.top,
              rect.width,
              rect.height,
            ),
            piece.theme.highlight,
          );
        }
      }

      for (final c in completedLines.cols) {
        for (int r = 0; r < GameConfig.boardDimension; r++) {
          final rect = boardComponent!.getCellRect(r, c);
          particleManager.spawnLineClearParticles(
            Rect.fromLTWH(
              boardComponent!.position.x + rect.left,
              boardComponent!.position.y + rect.top,
              rect.width,
              rect.height,
            ),
            piece.theme.highlight,
          );
        }
      }

      await Future.delayed(AnimationConfig.lineClearing);
      boardSystem.executeClear(completedLines);
      isClearingLines = false;
    }

    final comboStatus = comboSystem.onMoveCompleted(linesCleared: completedLines.totalLines);

    if (comboStatus.comboMultiplier > 1) {
      particleManager.spawnComboStars(
        boardComponent!.position + Vector2(boardPixelSize / 2, boardPixelSize / 2),
        const Color(0xFF67E8F9),
      );
      add(ComboBannerComponent(
        label: comboStatus.label,
        multiplier: comboStatus.comboMultiplier,
        position: boardComponent!.position + Vector2(boardPixelSize * 0.1, boardPixelSize * 0.4),
      ));
      onPlaySound('combo');
      onVibrate('heavy');
    }

    final scoreResult = scoringSystem.registerPlacement(
      blockCount: piece.blockCount,
      linesCleared: completedLines.totalLines,
      comboCount: comboStatus.comboMultiplier,
    );

    sessionState.currentScore = scoreResult.newTotalScore;
    sessionState.highScore = scoringSystem.highScore;
    sessionState.linesCleared += completedLines.totalLines;

    add(FloatingScoreComponent(
      points: scoreResult.addedPoints,
      position: boardComponent!.position + Vector2(boardPixelSize / 2 - 30, boardPixelSize / 2),
    ));

    onScoreUpdated(
      sessionState.currentScore,
      sessionState.highScore,
      scoreResult.isNewHighScore,
    );

    if (scoreResult.isNewHighScore && !sessionState.isNewHighScore) {
      sessionState.isNewHighScore = true;
      onPlaySound('record');
    }

    if (trayPieces.every((p) => p == null)) {
      refillTray();
    }

    checkEndGame();
  }

  void checkEndGame() {
    final isOver = GameOverSystem.checkGameOver(
      trayPieces: trayPieces,
      boardSystem: boardSystem,
    );

    if (isOver) {
      sessionState.status = GameStatus.gameOver;
      onPlaySound('gameover');
      onGameOver(
        sessionState.currentScore,
        sessionState.highScore,
        sessionState.linesCleared,
        comboSystem.maxComboAchieved,
        sessionState.isNewHighScore,
      );
    }
  }

  void resetGame() {
    boardSystem.reset();
    scoringSystem.reset(sessionState.highScore);
    comboSystem.reset();
    sessionState.reset(sessionState.highScore);
    refillTray();
    boardComponent?.clearPreview();
    isClearingLines = false;
    onScoreUpdated(0, sessionState.highScore, false);
  }
}
