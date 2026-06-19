-- Streamlined WezTerm configuration - maintains all functionality
local wezterm = require "wezterm"
local act = wezterm.action
local config = wezterm.config_builder()

-- Color scheme (tab bar + titlebar derive colors from this)
config.color_scheme = "Github Dark (Gogh)"
local scheme = wezterm.color.get_builtin_schemes()[config.color_scheme]

-- Keybindings (aligned with Ghostty)
config.keys = {}

-- ALT: primary actions
for _, v in ipairs({
  {"Enter", act.SplitHorizontal{domain='CurrentPaneDomain'}},
  {"w", act.CloseCurrentPane{confirm=true}},
  {"t", act.SpawnTab'CurrentPaneDomain'},
  {"LeftArrow", act.ActivateTabRelative(-1)},
  {"RightArrow", act.ActivateTabRelative(1)},
  {"c", act.CopyTo'ClipboardAndPrimarySelection'},
  {"v", act.PasteFrom'Clipboard'},
  {"=", act.IncreaseFontSize},
  {"-", act.DecreaseFontSize},
  {"0", act.ResetFontSize},
}) do table.insert(config.keys, {mods="ALT", key=v[1], action=v[2]}) end

-- ALT+SHIFT: pane navigation & split management
for _, v in ipairs({
  {"Enter", act.SplitVertical{domain='CurrentPaneDomain'}},
  {"LeftArrow", act.ActivatePaneDirection'Left'},
  {"RightArrow", act.ActivatePaneDirection'Right'},
  {"z", act.TogglePaneZoomState},
  {"=", act.PaneSelect{mode='SwapWithActive'}},
}) do table.insert(config.keys, {mods="ALT|SHIFT", key=v[1], action=v[2]}) end

-- ALT+UP/DOWN: pane navigation (no conflict with tabs)
for _, v in ipairs({
  {"UpArrow", act.ActivatePaneDirection'Up'},
  {"DownArrow", act.ActivatePaneDirection'Down'},
}) do table.insert(config.keys, {mods="ALT", key=v[1], action=v[2]}) end

-- ALT+1-8: goto tab
for i = 0, 7 do table.insert(config.keys, {mods="ALT", key=tostring(i+1), action=act.ActivateTab(i)}) end

-- CTRL+SHIFT+ALT: move tabs (matches Ghostty)
for _, v in ipairs({
  {"LeftArrow", act.MoveTabRelative(-1)},
  {"RightArrow", act.MoveTabRelative(1)},
}) do table.insert(config.keys, {mods="CTRL|SHIFT|ALT", key=v[1], action=v[2]}) end

-- Font configuration
config.font = wezterm.font_with_fallback({
  {family='Lilex Nerd Font Mono', weight='Regular'},
  {family='SauceCodePro Nerd Font Mono', weight='Regular'}
})
config.font_size = 17
config.line_height = 1.1
config.cell_width = 1.02
config.window_frame = {
  font = wezterm.font{family='Lilex Nerd Font Mono', weight='Regular', style='Italic'},
  font_size = 12.0,
  active_titlebar_bg = scheme.background
}

-- Performance settings
config.max_fps = 120
config.animation_fps = 1
config.window_background_opacity = 0.98
config.enable_scroll_bar = false
config.use_fancy_tab_bar = true
config.hide_tab_bar_if_only_one_tab = false
config.warn_about_missing_glyphs = false
-- Auto-detect Wayland based on environment
local is_wayland = os.getenv("WAYLAND_DISPLAY") ~= nil or
                   os.getenv("XDG_SESSION_TYPE") == "wayland"
config.enable_wayland = is_wayland
config.front_end = "OpenGL"
config.prefer_egl = true
config.freetype_load_target = "Light"
config.freetype_render_target = "HorizontalLcd"

config.colors = {
  tab_bar = {
    background=scheme.background, inactive_tab_edge=scheme.ansi[1],
    active_tab={bg_color=scheme.ansi[5], fg_color=scheme.background, intensity="Bold"},
    inactive_tab={bg_color=scheme.background, fg_color=scheme.brights[1]},
    inactive_tab_hover={bg_color=scheme.ansi[1], fg_color=scheme.ansi[5]},
    new_tab={bg_color=scheme.background, fg_color=scheme.ansi[5], intensity="Bold"},
    new_tab_hover={bg_color=scheme.ansi[1], fg_color=scheme.ansi[2]}
  }
}

-- Mouse bindings
config.mouse_bindings = {
  {event={Down={streak=1, button="Right"}}, mods="NONE", action=act.CopyTo("Clipboard")},
  {event={Down={streak=1, button="Middle"}}, mods="NONE", action=act.SplitHorizontal{domain="CurrentPaneDomain"}},
  {event={Down={streak=1, button="Middle"}}, mods="SHIFT", action=act.CloseCurrentPane{confirm=false}}
}

return config
