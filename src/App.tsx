import React, { useState, useEffect, useRef, useCallback } from 'react';
import { Play, Code2, RefreshCw } from 'lucide-react';
import {
  BOARD_DIM,
  DRAG_FINGER_OFFSET_Y,
  POINTS_PER_BLOCK,
  POINTS_PER_LINE,
  MULTI_LINE_BONUS_MULTIPLIER,
  COMBO_BASE_BONUS,
} from './game/constants';
import { BlockPiece, BoardCellData, DragState, CareerStats, GameSettingsState } from './types';
import {
  createEmptyGrid,
  canPlacePiece,
  placePieceOnGrid,
  findCompletedLines,
  markLinesForClearing,
  executeClearOnGrid,
} from './game/boardEngine';
import { generatePieceTray } from './game/pieceGenerator';
import { audioEngine } from './services/audioEngine';
import {
  loadStoredHighScore,
  saveStoredHighScore,
  loadStoredSettings,
  saveStoredSettings,
  loadStoredStats,
  saveStoredStats,
  clearStoredData,
} from './services/storage';
import { TopHUD } from './components/TopHUD';
import { GameBoard } from './components/GameBoard';
import { PieceTray } from './components/PieceTray';
import { BlockCell } from './components/BlockCell';
import { ParticleCanvas, ParticleCanvasHandle } from './components/ParticleCanvas';
import { ComboBanner } from './components/ComboBanner';
import { SettingsModal } from './components/SettingsModal';
import { GameOverModal } from './components/GameOverModal';
import { FlutterProjectViewer } from './components/FlutterProjectViewer';

export default function App() {
  const [activeTab, setActiveTab] = useState<'game' | 'code'>('game');
  const [grid, setGrid] = useState<BoardCellData[][]>(createEmptyGrid);
  const [trayPieces, setTrayPieces] = useState<(BlockPiece | null)[]>([null, null, null]);
  const [score, setScore] = useState(0);
  const [highScore, setHighScore] = useState(0);
  const [linesClearedTotal, setLinesClearedTotal] = useState(0);
  const [comboCount, setComboCount] = useState(0);
  const [maxComboInGame, setMaxComboInGame] = useState(0);
  const [comboLabel, setComboLabel] = useState('');
  const [isNewRecord, setIsNewRecord] = useState(false);
  const [isGameOver, setIsGameOver] = useState(false);
  const [isSettingsOpen, setIsSettingsOpen] = useState(false);
  const [dragState, setDragState] = useState<DragState | null>(null);

  const [settings, setSettings] = useState<GameSettingsState>(loadStoredSettings);
  const [careerStats, setCareerStats] = useState<CareerStats>(loadStoredStats);

  const boardRef = useRef<HTMLDivElement | null>(null);
  const particleCanvasRef = useRef<ParticleCanvasHandle | null>(null);

  // Sync settings with audio engine
  useEffect(() => {
    audioEngine.soundEnabled = settings.soundEnabled;
    audioEngine.musicEnabled = settings.musicEnabled;
    audioEngine.vibrationEnabled = settings.vibrationEnabled;
    saveStoredSettings(settings);
  }, [settings]);

  // Initial setup
  useEffect(() => {
    const savedHigh = loadStoredHighScore();
    setHighScore(savedHigh);
    startNewGame(savedHigh);
  }, []);

  const startNewGame = useCallback((currHigh = highScore) => {
    const empty = createEmptyGrid();
    setGrid(empty);
    setScore(0);
    setComboCount(0);
    setMaxComboInGame(0);
    setComboLabel('');
    setLinesClearedTotal(0);
    setIsNewRecord(false);
    setIsGameOver(false);
    setDragState(null);

    const initialPieces = generatePieceTray(empty);
    setTrayPieces(initialPieces);
  }, [highScore]);

  // Pointer drag handling
  const handlePiecePointerDown = (index: number, e: React.PointerEvent) => {
    if (isGameOver) return;
    const piece = trayPieces[index];
    if (!piece) return;

    audioEngine.playPickup();
    audioEngine.vibrate(20);

    setDragState({
      piece,
      trayIndex: index,
      currentX: e.clientX,
      currentY: e.clientY,
      targetRow: null,
      targetCol: null,
      isValid: false,
    });
  };

  useEffect(() => {
    if (!dragState) return;

    const handlePointerMove = (e: PointerEvent) => {
      const displayX = e.clientX;
      const displayY = e.clientY - DRAG_FINGER_OFFSET_Y;

      const boardEl = boardRef.current;
      let targetRow: number | null = null;
      let targetCol: number | null = null;
      let isValid = false;

      if (boardEl) {
        const boardRect = boardEl.getBoundingClientRect();
        if (
          displayX >= boardRect.left &&
          displayX <= boardRect.right &&
          displayY >= boardRect.top &&
          displayY <= boardRect.bottom
        ) {
          const innerSize = boardRect.width - 16;
          const cellSize = innerSize / BOARD_DIM;
          const localX = displayX - boardRect.left - 8;
          const localY = displayY - boardRect.top - 8;

          const centerCol = Math.floor(localX / cellSize);
          const centerRow = Math.floor(localY / cellSize);

          targetRow = centerRow - Math.floor(dragState.piece.height / 2);
          targetCol = centerCol - Math.floor(dragState.piece.width / 2);

          isValid = canPlacePiece(grid, dragState.piece, targetRow, targetCol);
        }
      }

      setDragState((prev) =>
        prev
          ? {
              ...prev,
              currentX: e.clientX,
              currentY: e.clientY,
              targetRow,
              targetCol,
              isValid,
            }
          : null
      );
    };

    const handlePointerUp = () => {
      if (!dragState) return;

      const { piece, trayIndex, targetRow, targetCol, isValid } = dragState;

      if (isValid && targetRow !== null && targetCol !== null) {
        // Place piece
        audioEngine.playPlace();
        audioEngine.vibrate(30);

        // Spawn placement particles
        if (particleCanvasRef.current) {
          particleCanvasRef.current.spawnPlacement(
            dragState.currentX,
            dragState.currentY - DRAG_FINGER_OFFSET_Y,
            piece.theme.glow
          );
        }

        const newGrid = placePieceOnGrid(grid, piece, targetRow, targetCol);
        const updatedTray = [...trayPieces];
        updatedTray[trayIndex] = null;

        // Check lines
        const completedLines = findCompletedLines(newGrid);

        if (completedLines.rows.length > 0 || completedLines.cols.length > 0) {
          // Lines completed!
          audioEngine.playClear();
          audioEngine.vibrate(50);

          const markedGrid = markLinesForClearing(newGrid, completedLines);
          setGrid(markedGrid);

          // Particle shards
          if (particleCanvasRef.current && boardRef.current) {
            const boardRect = boardRef.current.getBoundingClientRect();
            const cellSize = (boardRect.width - 16) / BOARD_DIM;
            const clearItems: { x: number; y: number; width: number; height: number; color: string }[] = [];

            completedLines.rows.forEach((r) => {
              for (let c = 0; c < BOARD_DIM; c++) {
                clearItems.push({
                  x: boardRect.left + 8 + c * cellSize,
                  y: boardRect.top + 8 + r * cellSize,
                  width: cellSize,
                  height: cellSize,
                  color: piece.theme.highlight,
                });
              }
            });

            completedLines.cols.forEach((c) => {
              for (let r = 0; r < BOARD_DIM; r++) {
                clearItems.push({
                  x: boardRect.left + 8 + c * cellSize,
                  y: boardRect.top + 8 + r * cellSize,
                  width: cellSize,
                  height: cellSize,
                  color: piece.theme.highlight,
                });
              }
            });

            particleCanvasRef.current.spawnLineClear(clearItems);
          }

          // Delay for clear sweep animation
          setTimeout(() => {
            const clearedGrid = executeClearOnGrid(newGrid, completedLines);
            setGrid(clearedGrid);

            const totalLinesNow = completedLines.rows.length + completedLines.cols.length;
            const newCombo = comboCount + 1;
            setComboCount(newCombo);
            if (newCombo > maxComboInGame) {
              setMaxComboInGame(newCombo);
            }

            // Combo label
            let label = '';
            if (totalLinesNow === 1) {
              label = newCombo > 1 ? `COMBO x${newCombo}` : 'CLEAR!';
            } else if (totalLinesNow === 2) {
              label = newCombo > 1 ? `DOUBLE x${newCombo}` : 'DOUBLE CLEAR!';
            } else if (totalLinesNow === 3) {
              label = newCombo > 1 ? `TRIPLE x${newCombo}` : 'TRIPLE CLEAR!';
            } else {
              label = newCombo > 1 ? `MEGA x${newCombo}` : 'MEGA CLEAR!';
            }
            setComboLabel(label);

            if (newCombo > 1) {
              audioEngine.playCombo(newCombo);
              audioEngine.vibrate([40, 30, 60]);
              if (particleCanvasRef.current && boardRef.current) {
                const b = boardRef.current.getBoundingClientRect();
                particleCanvasRef.current.spawnComboStars(b.left + b.width / 2, b.top + b.height / 2);
              }
            }

            setTimeout(() => setComboLabel(''), 900);

            // Scoring
            let pts = piece.coordinates.length * POINTS_PER_BLOCK;
            pts += totalLinesNow * POINTS_PER_LINE;
            if (totalLinesNow > 1) {
              pts += (totalLinesNow - 1) * totalLinesNow * MULTI_LINE_BONUS_MULTIPLIER;
            }
            if (newCombo > 1) {
              pts += (newCombo - 1) * COMBO_BASE_BONUS;
            }

            const newTotalScore = score + pts;
            setScore(newTotalScore);
            setLinesClearedTotal((prev) => prev + totalLinesNow);

            let newRecordNow = isNewRecord;
            if (newTotalScore > highScore) {
              setHighScore(newTotalScore);
              saveStoredHighScore(newTotalScore);
              if (!newRecordNow) {
                setIsNewRecord(true);
                newRecordNow = true;
                audioEngine.playRecord();
                if (particleCanvasRef.current) {
                  particleCanvasRef.current.spawnConfetti();
                }
              }
            }

            // Refill tray if needed
            let activeTray = updatedTray;
            if (updatedTray.every((p) => p === null)) {
              activeTray = generatePieceTray(clearedGrid);
              setTrayPieces(activeTray);
            } else {
              setTrayPieces(updatedTray);
            }

            // Game over check
            checkGameOverStatus(clearedGrid, activeTray, newTotalScore, newRecordNow);
          }, 240);
        } else {
          // No lines cleared -> reset combo
          setGrid(newGrid);
          setComboCount(0);

          let pts = piece.coordinates.length * POINTS_PER_BLOCK;
          const newTotalScore = score + pts;
          setScore(newTotalScore);

          let newRecordNow = isNewRecord;
          if (newTotalScore > highScore) {
            setHighScore(newTotalScore);
            saveStoredHighScore(newTotalScore);
            if (!newRecordNow) {
              setIsNewRecord(true);
              newRecordNow = true;
              audioEngine.playRecord();
              if (particleCanvasRef.current) {
                particleCanvasRef.current.spawnConfetti();
              }
            }
          }

          // Refill tray if empty
          let activeTray = updatedTray;
          if (updatedTray.every((p) => p === null)) {
            activeTray = generatePieceTray(newGrid);
            setTrayPieces(activeTray);
          } else {
            setTrayPieces(updatedTray);
          }

          checkGameOverStatus(newGrid, activeTray, newTotalScore, newRecordNow);
        }
      } else {
        // Invalid release -> return to tray
        audioEngine.playCancel();
        audioEngine.vibrate(15);
      }

      setDragState(null);
    };

    window.addEventListener('pointermove', handlePointerMove);
    window.addEventListener('pointerup', handlePointerUp);
    window.addEventListener('pointercancel', handlePointerUp);

    return () => {
      window.removeEventListener('pointermove', handlePointerMove);
      window.removeEventListener('pointerup', handlePointerUp);
      window.removeEventListener('pointercancel', handlePointerUp);
    };
  }, [dragState, grid, trayPieces, score, highScore, comboCount, maxComboInGame, isNewRecord]);

  const checkGameOverStatus = (
    currentGrid: BoardCellData[][],
    currentTray: (BlockPiece | null)[],
    finalScore: number,
    isRecord: boolean
  ) => {
    const remainingPieces = currentTray.filter((p): p is BlockPiece => p !== null);
    if (remainingPieces.length === 0) return;

    let hasAnyValidMove = false;
    for (const piece of remainingPieces) {
      for (let r = 0; r <= BOARD_DIM - piece.height; r++) {
        for (let c = 0; c <= BOARD_DIM - piece.width; c++) {
          if (canPlacePiece(currentGrid, piece, r, c)) {
            hasAnyValidMove = true;
            break;
          }
        }
        if (hasAnyValidMove) break;
      }
      if (hasAnyValidMove) break;
    }

    if (!hasAnyValidMove) {
      setTimeout(() => {
        setIsGameOver(true);
        audioEngine.playGameOver();

        const updatedStats: CareerStats = {
          highScore: Math.max(highScore, finalScore),
          totalGamesPlayed: careerStats.totalGamesPlayed + 1,
          totalLinesCleared: careerStats.totalLinesCleared + linesClearedTotal,
          highestCombo: Math.max(careerStats.highestCombo, maxComboInGame),
        };
        setCareerStats(updatedStats);
        saveStoredStats(updatedStats);
      }, 350);
    }
  };

  const handleResetData = () => {
    clearStoredData();
    setHighScore(0);
    setCareerStats({
      highScore: 0,
      totalGamesPlayed: 0,
      totalLinesCleared: 0,
      highestCombo: 0,
    });
    startNewGame(0);
    setIsSettingsOpen(false);
  };

  return (
    <div className="relative min-h-screen w-full bg-[#070D1E] text-slate-100 flex flex-col items-center justify-between font-['Plus_Jakarta_Sans',sans-serif] overflow-hidden select-none">
      {/* Background Gradient Artwork */}
      <div className="fixed inset-0 pointer-events-none bg-[radial-gradient(ellipse_80%_60%_at_50%_0%,#1E3A8A_0%,#0F1E4A_50%,#070E24_100%)] opacity-90" />

      {/* Mode Switcher Navigation Header */}
      <header className="relative z-20 w-full max-w-2xl px-4 py-2 flex items-center justify-between border-b border-slate-800/80 bg-slate-950/60 backdrop-blur-md">
        <div className="flex items-center gap-2">
          <div className="w-7 h-7 rounded-lg bg-gradient-to-br from-cyan-400 to-blue-600 flex items-center justify-center shadow-[0_0_12px_rgba(6,182,212,0.6)] font-['Fredoka'] font-black text-white text-sm">
            BS
          </div>
          <div>
            <h1 className="font-extrabold text-white text-sm tracking-wide font-['Fredoka'] leading-none">
              BLOCK SURGE
            </h1>
            <p className="text-[10px] text-slate-400 leading-tight">
              Android Production Flame Game Engine
            </p>
          </div>
        </div>

        {/* Tab Controls */}
        <div className="flex items-center gap-1.5 p-1 rounded-xl bg-slate-900 border border-slate-800">
          <button
            onClick={() => setActiveTab('game')}
            className={`flex items-center gap-1.5 px-3 py-1 rounded-lg text-xs font-bold transition-all ${
              activeTab === 'game'
                ? 'bg-gradient-to-r from-blue-600 to-indigo-600 text-white shadow-md'
                : 'text-slate-400 hover:text-white'
            }`}
          >
            <Play className="w-3.5 h-3.5" />
            <span>Play Game</span>
          </button>
          <button
            onClick={() => setActiveTab('code')}
            className={`flex items-center gap-1.5 px-3 py-1 rounded-lg text-xs font-bold transition-all ${
              activeTab === 'code'
                ? 'bg-gradient-to-r from-emerald-600 to-teal-600 text-white shadow-md'
                : 'text-slate-400 hover:text-white'
            }`}
          >
            <Code2 className="w-3.5 h-3.5" />
            <span>Android Studio Project &amp; Source</span>
          </button>
        </div>
      </header>

      {/* Main View Area */}
      <main className="relative z-10 w-full flex-1 flex flex-col items-center justify-center p-2 sm:p-4">
        {activeTab === 'code' ? (
          <FlutterProjectViewer />
        ) : (
          /* Mobile Phone Frame / Portrait Game Container */
          <div
            id="mobile-phone-frame"
            className="relative w-full max-w-[430px] aspect-[9/19] max-h-[880px] rounded-[36px] bg-[#0A1329] border-[6px] border-[#172554] shadow-[0_24px_64px_rgba(0,0,0,0.8),0_0_0_1px_rgba(255,255,255,0.08)] overflow-hidden flex flex-col justify-between py-2"
          >
            {/* Ambient Background Glow inside phone */}
            <div className="absolute inset-0 bg-gradient-to-b from-[#1E3A8A]/30 via-transparent to-[#0F1E4A]/40 pointer-events-none" />

            {/* Canvas Particle Overlay */}
            <ParticleCanvas ref={particleCanvasRef} />

            {/* Top HUD */}
            <TopHUD
              score={score}
              highScore={highScore}
              comboCount={comboCount}
              onOpenSettings={() => setIsSettingsOpen(true)}
            />

            {/* 8x8 Board Container with snap preview */}
            <div className="relative flex-1 flex items-center justify-center py-1">
              <GameBoard
                grid={grid}
                previewPiece={dragState?.piece || null}
                previewRow={dragState?.targetRow || null}
                previewCol={dragState?.targetCol || null}
                previewValid={dragState?.isValid || false}
                boardRef={boardRef}
              />
              <ComboBanner label={comboLabel} multiplier={comboCount} />
            </div>

            {/* Bottom 3-Piece Tray */}
            <div className="relative z-20">
              <PieceTray
                pieces={trayPieces}
                draggedIndex={dragState?.trayIndex ?? null}
                onPiecePointerDown={handlePiecePointerDown}
              />
            </div>

            {/* Dragged Floating Piece Component */}
            {dragState && (
              <div
                className="fixed z-50 pointer-events-none -translate-x-1/2 -translate-y-1/2"
                style={{
                  left: dragState.currentX,
                  top: dragState.currentY - DRAG_FINGER_OFFSET_Y,
                }}
              >
                <div
                  className="grid gap-[3px] scale-110 drop-shadow-[0_12px_24px_rgba(0,0,0,0.6)] animate-pulse"
                  style={{
                    gridTemplateColumns: `repeat(${dragState.piece.width}, minmax(0, 1fr))`,
                    gridTemplateRows: `repeat(${dragState.piece.height}, minmax(0, 1fr))`,
                  }}
                >
                  {Array.from({ length: dragState.piece.height }).map((_, r) =>
                    Array.from({ length: dragState.piece.width }).map((_, c) => {
                      const hasBlock = dragState.piece.coordinates.some(
                        (coord) => coord.x === c && coord.y === r
                      );
                      return (
                        <div key={`${r}-${c}`} className="w-[32px] h-[32px] sm:w-[38px] sm:h-[38px]">
                          {hasBlock && <BlockCell theme={dragState.piece.theme} />}
                        </div>
                      );
                    })
                  )}
                </div>
              </div>
            )}
          </div>
        )}
      </main>

      {/* Bottom Footer info bar */}
      <footer className="relative z-10 w-full py-2 px-4 text-center text-xs text-slate-500 border-t border-slate-900 bg-slate-950/60 backdrop-blur-sm flex items-center justify-center gap-4">
        <span>Block Surge © 2026 • Production Android Flutter &amp; Flame</span>
        {activeTab === 'game' && (
          <button
            onClick={() => startNewGame()}
            className="flex items-center gap-1 text-slate-400 hover:text-white transition-colors"
          >
            <RefreshCw className="w-3.5 h-3.5" />
            <span>Restart Game</span>
          </button>
        )}
      </footer>

      {/* Settings Modal */}
      <SettingsModal
        isOpen={isSettingsOpen}
        onClose={() => setIsSettingsOpen(false)}
        settings={settings}
        onUpdateSettings={setSettings}
        stats={careerStats}
        onResetData={handleResetData}
      />

      {/* Game Over Modal */}
      <GameOverModal
        isOpen={isGameOver}
        score={score}
        highScore={highScore}
        linesCleared={linesClearedTotal}
        maxCombo={maxComboInGame}
        isNewRecord={isNewRecord}
        onPlayAgain={() => startNewGame()}
        onHome={() => startNewGame()}
      />
    </div>
  );
}
