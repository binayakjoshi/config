local wezterm    = require 'wezterm'
local act        = wezterm.action

local config     = wezterm.config_builder()

-- ── Font ──────────────────────────────────────────────────────────────────
config.font      = wezterm.font("GoMono Nerd Font")
config.font_size = 11.0


config.warn_about_missing_glyphs     = false

-- ── Theme ─────────────────────────────────────────────────────────────────
config.color_scheme                  = "Everforest Dark Hard (Gogh)"

-- ── Window ────────────────────────────────────────────────────────────────
config.window_padding                = {
  left   = 8,
  right  = 8,
  top    = 8,
  bottom = 8,
}
-- ── Transparency ─────────────────────────────────────────────────────────
config.window_background_opacity     = 0.90
config.window_decorations            = "NONE"

config.initial_cols                  = 220
config.initial_rows                  = 50

-- ── Tab bar ───────────────────────────────────────────────────────────────
config.enable_tab_bar                = false
config.use_fancy_tab_bar             = false
config.tab_bar_at_bottom             = true -
config.tab_max_width                 = 32

-- ── Scrollback ────────────────────────────────────────────────────────────
config.scrollback_lines              = 8000

-- ── Performance / feel ────────────────────────────────────────────────────
config.animation_fps                 = 1
config.max_fps                       = 120

config.cursor_blink_ease_in          = "Constant"
config.cursor_blink_ease_out         = "Constant"

-- ── Cursor ────────────────────────────────────────────────────────────────
config.default_cursor_style          = "SteadyBlock"

-- ── Terminal identity ─────────────────────────────────────────────────────
config.term                          = "wezterm"

-- ── Keyboard encoding ─────────────────────────────────────────────────────
config.enable_kitty_keyboard         = true

-- ── Clipboard & encoding ──────────────────────────────────────────────────
config.canonicalize_pasted_newlines  = "LineFeed"

-- ── Bell ──────────────────────────────────────────────────────────────────
config.audible_bell                  = "Disabled"
config.visual_bell                   = {
  fade_in_duration_ms  = 0,
  fade_out_duration_ms = 0,
}

-- ── Mouse ─────────────────────────────────────────────────────────────────
-- Hide pointer while typing (less distraction in nvim)
config.hide_mouse_cursor_when_typing = true

-- Right-click pastes (matches Konsole muscle memory)
config.mouse_bindings                = {
  {
    event  = { Down = { streak = 1, button = "Right" } },
    mods   = "NONE",
    action = act.PasteFrom "Clipboard",
  },
}

-- ── Key bindings (tmux-first, minimal WezTerm keys) ──────────────────────
config.keys                          = {
  -- Clipboard (Ctrl+Shift+C/V, same as Konsole)
  { key = "c", mods = "CTRL|SHIFT", action = act.CopyTo "Clipboard" },
  { key = "v", mods = "CTRL|SHIFT", action = act.PasteFrom "Clipboard" },

  -- New OS window (opens in home dir)
  {
    key    = "n",
    mods   = "CTRL|SHIFT",
    action = act.SpawnCommandInNewWindow { cwd = wezterm.home_dir },
  },

  -- Font size (Konsole-style shortcuts)
  { key = "=", mods = "CTRL",       action = act.IncreaseFontSize },
  { key = "-", mods = "CTRL",       action = act.DecreaseFontSize },
  { key = "0", mods = "CTRL",       action = act.ResetFontSize },

  -- Quick config reload (no restart needed)
  { key = "r", mods = "CTRL|SHIFT", action = act.ReloadConfiguration },

  -- Suppress the debug overlay (pass Ctrl+Shift+L through to tmux/nvim)
  { key = "l", mods = "CTRL|SHIFT", action = act.DisableDefaultAssignment },
}

return config
