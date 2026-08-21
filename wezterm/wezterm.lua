local wezterm                    = require 'wezterm'
local act                        = wezterm.action

local config                     = wezterm.config_builder()

-- ── Font ──────────────────────────────────────────────────────────────────
config.font                      = wezterm.font("GoMono Nerd Font")
config.font_size                 = 11.0

config.warn_about_missing_glyphs = false

-- ── Theme ─────────────────────────────────────────────────────────────────
config.color_scheme              = "Everforest Dark Hard (Gogh)"

-- Everforest Dark Hard palette (used for tab bar / pane border styling below)
local ef                         = {
  bg0    = "#272e33",
  bg1    = "#2e383c",
  bg2    = "#374145",
  bg3    = "#414b50",
  bg_vis = "#4c3743",
  fg     = "#d3c6aa",
  red    = "#e67e80",
  orange = "#e69875",
  yellow = "#dbbc7f",
  green  = "#a7c080",
  aqua   = "#83c092",
  blue   = "#7fbbb3",
  purple = "#d699b6",
  grey0  = "#7a8478",
  grey1  = "#859289",
  grey2  = "#9da9a0",
}

-- rgba() variants at the same opacity as window_background_opacity, so the
-- tab bar blends with the transparent window instead of showing as a
-- separate opaque block
local function rgba(hex, alpha)
  local r, g, b = hex:match("#(%x%x)(%x%x)(%x%x)")
  return string.format("rgba(%d, %d, %d, %s)", tonumber(r, 16), tonumber(g, 16), tonumber(b, 16), alpha)
end

-- ── Transparency ──────────────────────────────────────────────────────────
config.window_background_opacity                  = 0.90
config.text_background_opacity                    = 1.0
-- macOS-only; ignored elsewhere. Gives frosted-glass blur behind the opacity.
config.macos_window_background_blur               = 20

-- ── Window ────────────────────────────────────────────────────────────────
config.window_padding                             = {
  left   = 8,
  right  = 8,
  top    = 8,
  bottom = 8,
}

config.window_decorations                         = "NONE"

config.initial_cols                               = 220
config.initial_rows                               = 50

-- ── Tab bar ───────────────────────────────────────────────────────────────
config.enable_tab_bar                             = true
config.use_fancy_tab_bar                          = true
config.tab_bar_at_bottom                          = true
config.tab_max_width                              = 32
config.hide_tab_bar_if_only_one_tab               = false
config.show_new_tab_button_in_tab_bar             = true
config.show_tab_index_in_tab_bar                  = true
config.switch_to_last_active_tab_when_closing_tab = true

-- Fancy tab bar / titlebar styling, tuned to Everforest Dark Hard.
-- NOTE: when the tab bar is at the TOP, WezTerm renders it as an integrated
-- titlebar, which composites window_frame colors on top of the window's own
-- opacity a second time. Using rgba() here (as the bottom tab bar does)
-- washes it out, so plain opaque hex is used instead.
config.window_frame                               = {
  font                 = wezterm.font { family = "GoMono Nerd Font", weight = "Bold" },
  font_size            = 10.5,
  active_titlebar_bg   = ef.bg0,
  inactive_titlebar_bg = ef.bg0,
}

config.colors                                     = {
  tab_bar = {
    background = rgba(ef.bg0, 0.90),

    active_tab = {
      bg_color  = rgba(ef.bg2, 0.95),
      fg_color  = ef.green,
      intensity = "Bold",
      italic    = false,
    },
    inactive_tab = {
      bg_color = rgba(ef.bg0, 0.90),
      fg_color = ef.grey1,
    },
    inactive_tab_hover = {
      bg_color = rgba(ef.bg1, 0.90),
      fg_color = ef.fg,
      italic   = false,
    },
    new_tab = {
      bg_color = rgba(ef.bg0, 0.90),
      fg_color = ef.grey1,
    },
    new_tab_hover = {
      bg_color = rgba(ef.bg2, 0.95),
      fg_color = ef.aqua,
    },
  },

  -- Pane split-line / border color (visible now that wezterm owns splits)
  split = ef.bg3,
}

-- Numbered, padded tab titles: " 1 nvim " style, active tab gets a green
-- accent bar so it reads clearly against Everforest's muted palette.
wezterm.on('format-tab-title', function(tab, tabs, panes, config, hover)
  local index = tab.tab_index + 1
  local title = tab.active_pane.title
  -- trim long titles
  if #title > 20 then
    title = title:sub(1, 17) .. "..."
  end
  local label = string.format(" %d  %s ", index, title)

  if tab.is_active then
    return {
      { Background = { Color = rgba(ef.bg2, 0.95) } },
      { Foreground = { Color = ef.green } },
      { Text = label },
    }
  end
  if hover then
    return {
      { Background = { Color = rgba(ef.bg1, 0.90) } },
      { Foreground = { Color = ef.fg } },
      { Text = label },
    }
  end
  return {
    { Background = { Color = rgba(ef.bg0, 0.90) } },
    { Foreground = { Color = ef.grey1 } },
    { Text = label },
  }
end)

-- ── Pane borders/split visuals ────────────────────────────────────────────
config.inactive_pane_hsb             = {
  saturation = 0.85,
  brightness = 0.6,
}

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
config.hide_mouse_cursor_when_typing = true

config.mouse_bindings                = {
  {
    event  = { Down = { streak = 1, button = "Right" } },
    mods   = "NONE",
    action = act.PasteFrom "Clipboard",
  },
}

-- ── Key bindings ───────────────────────────────────────────────────────────
-- No leader key, no tmux-style prefix table. Splits, tabs, closing panes,
-- zoom, tab switching, etc. all use WezTerm's own built-in defaults
-- (CTRL+SHIFT+"/%,  CTRL+SHIFT+W, CTRL+SHIFT+Z, CTRL+TAB, CTRL+SHIFT+1..9,
-- CTRL+SHIFT+Space for QuickSelect, CTRL+SHIFT+X for copy mode, etc).
-- The only custom bindings kept are the ones WezTerm doesn't provide
-- out of the box, plus vim-style hjkl for pane navigation/resizing.
config.keys                          = {
  -- OS clipboard (Ctrl+Shift+C/V)
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

  -- Quick config reload
  { key = "r", mods = "CTRL|SHIFT", action = act.ReloadConfiguration },

  -- Suppress debug overlay (pass through to nvim/shell)
  { key = "l", mods = "CTRL|SHIFT", action = act.DisableDefaultAssignment },

  ------------------------------------------------------------------------
  -- Vim-style pane navigation (no leader, just ALT+hjkl)
  ------------------------------------------------------------------------
  { key = "h", mods = "ALT",        action = act.ActivatePaneDirection "Left" },
  { key = "j", mods = "ALT",        action = act.ActivatePaneDirection "Down" },
  { key = "k", mods = "ALT",        action = act.ActivatePaneDirection "Up" },
  { key = "l", mods = "ALT",        action = act.ActivatePaneDirection "Right" },

  -- Vim-style pane resizing (ALT+SHIFT+hjkl, single press per nudge)
  { key = "h", mods = "ALT|SHIFT",  action = act.AdjustPaneSize { "Left", 3 } },
  { key = "j", mods = "ALT|SHIFT",  action = act.AdjustPaneSize { "Down", 3 } },
  { key = "k", mods = "ALT|SHIFT",  action = act.AdjustPaneSize { "Up", 3 } },
  { key = "l", mods = "ALT|SHIFT",  action = act.AdjustPaneSize { "Right", 3 } },

  -- Copy mode (vi-style movement/selection, see key_tables.copy_mode below)
  { key = "x", mods = "CTRL|SHIFT", action = act.ActivateCopyMode },
}

-- WezTerm's built-in copy_mode table already gives you vi-style movement
-- and visual selection/yank — this override just tweaks it slightly.
config.key_tables                    = {
  copy_mode = {
    { key = "Escape", mods = "NONE",  action = act.CopyMode "Close" },
    { key = "q",      mods = "NONE",  action = act.CopyMode "Close" },
    { key = "h",      mods = "NONE",  action = act.CopyMode "MoveLeft" },
    { key = "j",      mods = "NONE",  action = act.CopyMode "MoveDown" },
    { key = "k",      mods = "NONE",  action = act.CopyMode "MoveUp" },
    { key = "l",      mods = "NONE",  action = act.CopyMode "MoveRight" },
    { key = "0",      mods = "NONE",  action = act.CopyMode "MoveToStartOfLine" },
    { key = "$",      mods = "SHIFT", action = act.CopyMode "MoveToEndOfLineContent" },
    { key = "w",      mods = "NONE",  action = act.CopyMode "MoveForwardWord" },
    { key = "b",      mods = "NONE",  action = act.CopyMode "MoveBackwardWord" },
    { key = "g",      mods = "NONE",  action = act.CopyMode "MoveToScrollbackTop" },
    { key = "G",      mods = "SHIFT", action = act.CopyMode "MoveToScrollbackBottom" },
    { key = "v",      mods = "NONE",  action = act.CopyMode { SetSelectionMode = "Cell" } },
    { key = "V",      mods = "SHIFT", action = act.CopyMode { SetSelectionMode = "Line" } },
    { key = "v",      mods = "CTRL",  action = act.CopyMode { SetSelectionMode = "Block" } },
    {
      key    = "y",
      mods   = "NONE",
      action = act.Multiple {
        { CopyTo = "ClipboardAndPrimarySelection" },
        { CopyMode = "Close" },
      }
    },
  },
}

return config
