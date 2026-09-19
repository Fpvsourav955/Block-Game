import React from 'react';
import { Volume2, VolumeX, Music, Smartphone, Trash2, X, Info, ShieldCheck } from 'lucide-react';
import { GameSettingsState, CareerStats } from '../types';

interface SettingsModalProps {
  isOpen: boolean;
  onClose: () => void;
  settings: GameSettingsState;
  onUpdateSettings: (newSettings: GameSettingsState) => void;
  stats: CareerStats;
  onResetData: () => void;
}

export const SettingsModal: React.FC<SettingsModalProps> = ({
  isOpen,
  onClose,
  settings,
  onUpdateSettings,
  stats,
  onResetData,
}) => {
  if (!isOpen) return null;

  return (
    <div
      id="settings-modal-backdrop"
      className="fixed inset-0 z-50 flex items-center justify-center p-4 bg-black/75 backdrop-blur-sm animate-[fadeIn_0.2s_ease-out]"
      onClick={onClose}
    >
      <div
        id="settings-card"
        className="w-full max-w-sm rounded-[24px] bg-[#1E293B] border border-[#334155] p-5 shadow-2xl flex flex-col gap-4 text-white relative animate-[scaleUp_0.2s_ease-out]"
        onClick={(e) => e.stopPropagation()}
      >
        {/* Header */}
        <div className="flex items-center justify-between border-b border-[#334155] pb-3">
          <h2 className="text-xl font-black tracking-wide font-['Fredoka'] text-white">
            SETTINGS
          </h2>
          <button
            onClick={onClose}
            className="w-8 h-8 rounded-full bg-[#334155]/60 hover:bg-[#334155] active:scale-95 flex items-center justify-center text-slate-300 hover:text-white transition-all"
          >
            <X className="w-5 h-5" />
          </button>
        </div>

        {/* Audio Toggles */}
        <div className="flex flex-col gap-2.5">
          <div className="text-xs font-bold text-slate-400 uppercase tracking-wider">
            Audio &amp; Feedback
          </div>

          <div className="flex items-center justify-between p-3 rounded-xl bg-[#0F172A] border border-[#334155]/60">
            <div className="flex items-center gap-3">
              {settings.soundEnabled ? (
                <Volume2 className="w-5 h-5 text-emerald-400" />
              ) : (
                <VolumeX className="w-5 h-5 text-slate-500" />
              )}
              <span className="font-semibold text-sm">Sound Effects</span>
            </div>
            <button
              onClick={() =>
                onUpdateSettings({ ...settings, soundEnabled: !settings.soundEnabled })
              }
              className={`w-12 h-6 rounded-full transition-colors relative p-0.5 ${
                settings.soundEnabled ? 'bg-emerald-500' : 'bg-slate-700'
              }`}
            >
              <div
                className={`w-5 h-5 rounded-full bg-white transition-transform ${
                  settings.soundEnabled ? 'translate-x-6' : 'translate-x-0'
                }`}
              />
            </button>
          </div>

          <div className="flex items-center justify-between p-3 rounded-xl bg-[#0F172A] border border-[#334155]/60">
            <div className="flex items-center gap-3">
              <Music className={`w-5 h-5 ${settings.musicEnabled ? 'text-cyan-400' : 'text-slate-500'}`} />
              <span className="font-semibold text-sm">Music Soundtrack</span>
            </div>
            <button
              onClick={() =>
                onUpdateSettings({ ...settings, musicEnabled: !settings.musicEnabled })
              }
              className={`w-12 h-6 rounded-full transition-colors relative p-0.5 ${
                settings.musicEnabled ? 'bg-cyan-500' : 'bg-slate-700'
              }`}
            >
              <div
                className={`w-5 h-5 rounded-full bg-white transition-transform ${
                  settings.musicEnabled ? 'translate-x-6' : 'translate-x-0'
                }`}
              />
            </button>
          </div>

          <div className="flex items-center justify-between p-3 rounded-xl bg-[#0F172A] border border-[#334155]/60">
            <div className="flex items-center gap-3">
              <Smartphone className={`w-5 h-5 ${settings.vibrationEnabled ? 'text-amber-400' : 'text-slate-500'}`} />
              <span className="font-semibold text-sm">Haptic Feedback</span>
            </div>
            <button
              onClick={() =>
                onUpdateSettings({ ...settings, vibrationEnabled: !settings.vibrationEnabled })
              }
              className={`w-12 h-6 rounded-full transition-colors relative p-0.5 ${
                settings.vibrationEnabled ? 'bg-amber-500' : 'bg-slate-700'
              }`}
            >
              <div
                className={`w-5 h-5 rounded-full bg-white transition-transform ${
                  settings.vibrationEnabled ? 'translate-x-6' : 'translate-x-0'
                }`}
              />
            </button>
          </div>
        </div>

        {/* Career Stats */}
        <div className="flex flex-col gap-2">
          <div className="text-xs font-bold text-slate-400 uppercase tracking-wider">
            Game Statistics
          </div>
          <div className="grid grid-cols-3 gap-2 p-3 rounded-xl bg-[#0F172A] border border-[#334155]/60 text-center">
            <div>
              <div className="text-xs text-slate-400">Games</div>
              <div className="text-base font-black text-white">{stats.totalGamesPlayed}</div>
            </div>
            <div className="border-x border-slate-800">
              <div className="text-xs text-slate-400">Lines</div>
              <div className="text-base font-black text-cyan-400">{stats.totalLinesCleared}</div>
            </div>
            <div>
              <div className="text-xs text-slate-400">Top Combo</div>
              <div className="text-base font-black text-amber-400">x{stats.highestCombo}</div>
            </div>
          </div>
        </div>

        {/* Data Actions */}
        <div className="flex flex-col gap-2 pt-1 border-t border-[#334155]">
          <button
            onClick={() => {
              if (window.confirm('Reset all saved scores and settings back to default?')) {
                onResetData();
              }
            }}
            className="w-full py-2.5 px-3 rounded-xl bg-red-950/40 hover:bg-red-900/60 border border-red-800/50 text-red-300 font-bold text-xs flex items-center justify-center gap-2 active:scale-98 transition-all"
          >
            <Trash2 className="w-4 h-4 text-red-400" />
            <span>Reset Game Records &amp; Data</span>
          </button>
        </div>

        {/* Footer info */}
        <div className="flex items-center justify-between text-[11px] text-slate-400 pt-1">
          <div className="flex items-center gap-1">
            <ShieldCheck className="w-3.5 h-3.5 text-emerald-400" />
            <span>100% Offline Safe</span>
          </div>
          <div className="flex items-center gap-1">
            <Info className="w-3.5 h-3.5 text-slate-400" />
            <span>Block Surge v1.0.0</span>
          </div>
        </div>
      </div>
    </div>
  );
};
