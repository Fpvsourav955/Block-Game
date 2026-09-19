import { GameSettingsState, CareerStats } from '../types';

const KEY_HIGH_SCORE = 'block_surge_web_high_score';
const KEY_SETTINGS = 'block_surge_web_settings';
const KEY_STATS = 'block_surge_web_stats';

export function loadStoredHighScore(): number {
  try {
    const val = localStorage.getItem(KEY_HIGH_SCORE);
    return val ? parseInt(val, 10) || 0 : 0;
  } catch {
    return 0;
  }
}

export function saveStoredHighScore(score: number): void {
  try {
    localStorage.setItem(KEY_HIGH_SCORE, score.toString());
  } catch {}
}

export function loadStoredSettings(): GameSettingsState {
  try {
    const raw = localStorage.getItem(KEY_SETTINGS);
    if (raw) return JSON.parse(raw);
  } catch {}
  return {
    soundEnabled: true,
    musicEnabled: true,
    vibrationEnabled: true,
  };
}

export function saveStoredSettings(settings: GameSettingsState): void {
  try {
    localStorage.setItem(KEY_SETTINGS, JSON.stringify(settings));
  } catch {}
}

export function loadStoredStats(): CareerStats {
  try {
    const raw = localStorage.getItem(KEY_STATS);
    if (raw) return JSON.parse(raw);
  } catch {}
  return {
    highScore: loadStoredHighScore(),
    totalGamesPlayed: 0,
    totalLinesCleared: 0,
    highestCombo: 0,
  };
}

export function saveStoredStats(stats: CareerStats): void {
  try {
    localStorage.setItem(KEY_STATS, JSON.stringify(stats));
  } catch {}
}

export function clearStoredData(): void {
  try {
    localStorage.removeItem(KEY_HIGH_SCORE);
    localStorage.removeItem(KEY_SETTINGS);
    localStorage.removeItem(KEY_STATS);
  } catch {}
}
