-- Tango awesome theme

-- {{{ Main
theme = {}
theme.dir       = awful.util.getdir("config") .. "/tango-theme"
theme.wallpaper_cmd = { theme.dir .. "background/background-pony-salute-pale.png" }
-- }}}

-- {{{ Styles
theme.font      = "monaco 8"

-- {{{ Colors
theme.fg_normal = "#eeeeec"
theme.fg_focus  = "#e9b96e"
theme.fg_urgent = "#ef2929"
theme.bg_normal = "#555753"
theme.bg_focus  = "#2e3436"
theme.bg_urgent = theme.bg_normal
-- }}}

-- {{{ Borders
theme.border_width  = 1
theme.border_focus  = "#888a85"
theme.border_normal = theme.border_focus
theme.border_marked = theme.border_focus
-- }}}

-- {{{ Titlebars
theme.titlebar_bg_focus  = theme.bg_normal
theme.titlebar_bg_normal = theme.bg_normal
-- }}}

-- {{{ Widgets
theme.fg_widget        = "#8ae234"
theme.fg_center_widget = "#e9b96e"
theme.fg_end_widget    = theme.fg_urgent
theme.fg_off_widget    = theme.bg_focus
theme.fg_netup_widget  = "#73d216"
theme.fg_netdn_widget  = "#e9b96e"
theme.bg_widget        = theme.bg_normal
theme.border_widget    = theme.bg_normal
-- }}}

-- {{{ Icons
--
-- {{{ Taglist icons
theme.taglist_squares_sel   = theme.dir .. "/icons/taglist/selected.png"
theme.taglist_squares_unsel = theme.dir .. "/icons/taglist/unselected.png"
-- }}}

-- {{{ Tasklist icons
theme.tasklist_floating_icon = theme.dir .. "/icons/tasklist/floating.png"
-- }}}

-- {{{ Layout icons
theme.layout_tile       = theme.dir .. "/icons/layouts/tile.png"
theme.layout_tileleft   = theme.dir .. "/icons/layouts/tileleft.png"
theme.layout_tilebottom = theme.dir .. "/icons/layouts/tilebottom.png"
theme.layout_tiletop    = theme.dir .. "/icons/layouts/tiletop.png"
theme.layout_fairv      = theme.dir .. "/icons/layouts/fairv.png"
theme.layout_fairh      = theme.dir .. "/icons/layouts/fairh.png"
theme.layout_spiral     = theme.dir .. "/icons/layouts/spiral.png"
theme.layout_dwindle    = theme.dir .. "/icons/layouts/dwindle.png"
theme.layout_max        = theme.dir .. "/icons/layouts/max.png"
theme.layout_fullscreen = theme.dir .. "/icons/layouts/fullscreen.png"
theme.layout_magnifier  = theme.dir .. "/icons/layouts/magnifier.png"
theme.layout_floating   = theme.dir .. "/icons/layouts/floating.png"
-- }}}

-- {{{ Widget icons
theme.widget_cpu    = theme.dir .. "/icons/cpu.png"
theme.widget_bat    = theme.dir .. "/icons/battery.png"
theme.widget_mem    = theme.dir .. "/icons/memory.png"
theme.widget_fs     = theme.dir .. "/icons/disk.png"
theme.widget_net    = theme.dir .. "/icons/down.png"
theme.widget_netup  = theme.dir .. "/icons/up.png"
theme.widget_mail   = theme.dir .. "/icons/mail.png"
theme.widget_vol    = theme.dir .. "/icons/volume.png"
theme.widget_date   = theme.dir .. "/icons/calendar.png"
theme.widget_sep    = theme.dir .. "/icons/separator.png"
-- }}}

-- {{{ Titlebar icons
theme.titlebar_close_button_focus  = theme.dir .. "/icons/titlebar/close_focus.png"
theme.titlebar_close_button_normal = theme.dir .. "/icons/titlebar/close_normal.png"

theme.titlebar_ontop_button_focus_active    = theme.dir .. "/icons/titlebar/ontop_focus_active.png"
theme.titlebar_ontop_button_normal_active   = theme.dir .. "/icons/titlebar/ontop_normal_active.png"
theme.titlebar_ontop_button_focus_inactive  = theme.dir .. "/icons/titlebar/ontop_focus_inactive.png"
theme.titlebar_ontop_button_normal_inactive = theme.dir .. "/icons/titlebar/ontop_normal_inactive.png"

theme.titlebar_sticky_button_focus_active    = theme.dir .. "/icons/titlebar/sticky_focus_active.png"
theme.titlebar_sticky_button_normal_active   = theme.dir .. "/icons/titlebar/sticky_normal_active.png"
theme.titlebar_sticky_button_focus_inactive  = theme.dir .. "/icons/titlebar/sticky_focus_inactive.png"
theme.titlebar_sticky_button_normal_inactive = theme.dir .. "/icons/titlebar/sticky_normal_inactive.png"

theme.titlebar_floating_button_focus_active    = theme.dir .. "/icons/titlebar/floating_focus_active.png"
theme.titlebar_floating_button_normal_active   = theme.dir .. "/icons/titlebar/floating_normal_active.png"
theme.titlebar_floating_button_focus_inactive  = theme.dir .. "/icons/titlebar/floating_focus_inactive.png"
theme.titlebar_floating_button_normal_inactive = theme.dir .. "/icons/titlebar/floating_normal_inactive.png"

theme.titlebar_maximized_button_focus_active    = theme.dir .. "/icons/titlebar/maximized_focus_active.png"
theme.titlebar_maximized_button_normal_active   = theme.dir .. "/icons/titlebar/maximized_normal_active.png"
theme.titlebar_maximized_button_focus_inactive  = theme.dir .. "/icons/titlebar/maximized_focus_inactive.png"
theme.titlebar_maximized_button_normal_inactive = theme.dir .. "/icons/titlebar/maximized_normal_inactive.png"
-- }}}
-- }}}

return theme
