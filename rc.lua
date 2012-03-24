-- Standard awesome library
require("awful")
require("awful.autofocus")
require("awful.rules")
-- Theme handling library
require("beautiful")
-- Notification library
require("naughty")
-- Vicious widgets
require("vicious")
-- Hover calendar
require("cal")

-- {{{ Variable definitions
local altkey = "Mod1"
local modkey = "Mod4"

local home   = os.getenv("HOME")
local config = awful.util.getdir("config")
local exec   = awful.util.spawn
local scount = screen.count()

--terminal = "x-terminal-emulator"
local terminal = "urxvtcd"

-- Beautiful theme
beautiful.init(config .. "/tango-theme/tango.lua")

-- Table of layouts to cover with awful.layout.inc, order matters.
layouts =
{
	awful.layout.suit.floating,         -- 1
	awful.layout.suit.tile,             -- 2
	awful.layout.suit.tile.left,        -- 3
	awful.layout.suit.tile.bottom,      -- 4
	awful.layout.suit.tile.top,         -- 5
	awful.layout.suit.fair,             -- 6
	awful.layout.suit.fair.horizontal,  -- 7
	awful.layout.suit.spiral,           -- 8
	awful.layout.suit.spiral.dwindle,   -- 9
	awful.layout.suit.max,              -- 10
	--awful.layout.suit.max.fullscreen, -- 11
	--awful.layout.suit.magnifier       -- 12
}
-- }}}

-- {{{ Tags
-- Define a tag table which hold all screen tags.
tags = {
	names = {"www", "term", "msg", "float", "misc", "max"},
	layouts = {layouts[2], layouts[2], layouts[9], layouts[1], layouts[2], layouts[10]}
}
for s = 1, scount do
	if s == 1 then
		tags[s] = awful.tag(tags.names, s, tags.layouts)
	else
		tags[s] = awful.tag({ 1, 2, 3, 4, 5, 6, 7, 8, 9}, s, layouts[2])
	end
end
-- }}}

-- {{{ Wibox
--
-- {{{ Widgets configuration
--
-- {{{ Reusable separator
separator = widget({ type = "imagebox" })
separator.image = image(beautiful.widget_sep)
-- }}}

-- {{{ CPU usage and temperature
cpuicon = widget({ type = "imagebox" })
cpuicon.image = image(beautiful.widget_cpu)
cpugraph  = awful.widget.graph()
tzswidget = widget({ type = "textbox" })
tzswidget:buttons(awful.util.table.join(
-- TODO: implement tooltip popup 
	awful.button({ }, 1, function () exec (terminal .. " -e zsh -c 'less /proc/acpi/ibm/fan'") end)
))

-- Graph properties
cpugraph:set_width(40):set_height(14)
cpugraph:set_background_color(beautiful.fg_off_widget)
cpugraph:set_gradient_angle(0):set_gradient_colors({
   beautiful.fg_end_widget, beautiful.fg_center_widget, beautiful.fg_widget
})
cpugraph.widget:buttons(awful.util.table.join(
  awful.button({ }, 1, function () exec(terminal .. " -e htop") end)
))
vicious.register(cpugraph,  vicious.widgets.cpu,      "$1")
vicious.register(tzswidget, vicious.widgets.thermal, " $1C", 19, "thermal_zone0")
-- }}}

-- {{{ Battery state
baticon = widget({ type = "imagebox" })
baticon.image = image(beautiful.widget_bat)
batwidget = widget({ type = "textbox" })
vicious.register(batwidget, vicious.widgets.bat, "$1$2%", 61, "BAT0")
batwidget:buttons(awful.util.table.join(
-- TODO: implement tooltip popup
	awful.button({ }, 1, function () exec (terminal .. " -e zsh -c 'sudo tlp-stat | grep BAT | less -'") end)
))
-- }}}

-- {{{ Memory usage
memicon = widget({ type = "imagebox" })
memicon.image = image(beautiful.widget_mem)
membar = awful.widget.progressbar()
membar:set_vertical(true):set_ticks(true)
membar:set_height(12):set_width(8):set_ticks_size(2)
membar:set_background_color(beautiful.fg_off_widget)
membar:set_gradient_colors({ beautiful.fg_widget,
   beautiful.fg_center_widget, beautiful.fg_end_widget
})
vicious.register(membar, vicious.widgets.mem, "$1", 13)
-- }}}

-- {{{ File system usage
fsicon = widget({ type = "imagebox" })
fsicon.image = image(beautiful.widget_fs)
fs = {
  b = awful.widget.progressbar(), r = awful.widget.progressbar(),
  h = awful.widget.progressbar(), s = awful.widget.progressbar()
}
for _, w in pairs(fs) do
  w:set_vertical(true):set_ticks(true)
  w:set_height(14):set_width(5):set_ticks_size(2)
  w:set_border_color(beautiful.border_widget)
  w:set_background_color(beautiful.fg_off_widget)
  w:set_gradient_colors({ beautiful.fg_widget,
     beautiful.fg_center_widget, beautiful.fg_end_widget
  })
  w.widget:buttons(awful.util.table.join(
    awful.button({ }, 1, function () exec("nautilus --no-desktop", false) end)
  ))
end
vicious.cache(vicious.widgets.fs)
vicious.register(fs.b, vicious.widgets.fs, "${/ used_p}", 599)
vicious.register(fs.r, vicious.widgets.fs, "${/home used_p}",     599)
vicious.register(fs.h, vicious.widgets.fs, "${/mnt/bay used_p}", 599)
vicious.register(fs.s, vicious.widgets.fs, "${/media/ext used_p}", 599)
-- }}}

-- {{{ Network usage
dnicon = widget({ type = "imagebox" })
upicon = widget({ type = "imagebox" })
dnicon.image = image(beautiful.widget_net)
upicon.image = image(beautiful.widget_netup)
netwidget = widget({ type = "textbox" })
vicious.register(netwidget, vicious.widgets.net,
    function(widget, args)
        down = 0.0
        up = 0.0
        for k,v in pairs(args) do
            if k:find("down_kb", -8) then
                down = down + v
            elseif k:find("up_kb", -6) then
                up = up + v
            end
        end
        return string.format('<span color="' .. beautiful.fg_netdn_widget ..'">%.1f</span> <span color="' .. beautiful.fg_netup_widget ..'">%.1f</span>', down, up)
    end)
-- }}}

-- {{{ Mail subject
mailicon = widget({ type = "imagebox" })
mailicon.image = image(beautiful.widget_mail)
mailwidget = widget({ type = "textbox" })
local maildir = home .. "/Mail"
vicious.register(mailwidget, vicious.widgets.mdir, "$1", 181,
	{maildir .. "/GMX", maildir .. "/Uni", maildir .. "/CS", home .. "/Google", home .. "/Invader", 15})
mailwidget:buttons(awful.util.table.join(
  awful.button({ }, 1, function () exec(terminal .. " -e mutt -y") end),
  awful.button({ }, 3, function () vicious.force({mailwidget,}) end)
))
-- }}}

-- {{{ Volume level
volicon = widget({ type = "imagebox" })
volicon.image = image(beautiful.widget_vol)
volbar    = awful.widget.progressbar()
volwidget = widget({ type = "textbox" })
volbar:set_vertical(true):set_ticks(true)
volbar:set_height(12):set_width(8):set_ticks_size(2)
volbar:set_background_color(beautiful.fg_off_widget)
volbar:set_gradient_colors({ beautiful.fg_widget,
   beautiful.fg_center_widget, beautiful.fg_end_widget
})
vicious.cache(vicious.widgets.volume)
vicious.register(volbar,    vicious.widgets.volume,  "$1",  2, "Master")
vicious.register(volwidget, vicious.widgets.volume,
    function(widget, args)
        sign = "%"
        if args[2] == "♩" then
            sign = "M"
        end
        return string.format(" %d%s", args[1], sign)
    end, 2, "Master")
volbar.widget:buttons(awful.util.table.join(
    awful.button({ }, 4, function () volume("up") end),
    awful.button({ }, 5, function () volume("down") end),
    awful.button({ }, 1, function () volume("mute") end),
    --awful.button({ }, 3, function () exec("pavucontrol") end)
    awful.button({ }, 3, function () exec("gnome-control-center sound") end)
))
volwidget:buttons(volbar.widget:buttons())
-- }}}

-- {{{ Date and time
dateicon = widget({ type = "imagebox" })
dateicon.image = image(beautiful.widget_date)
datewidget = widget({ type = "textbox" })
vicious.register(datewidget, vicious.widgets.date, "%d.%m. %R", 61)
cal.register(datewidget, "<span color='red'><b>%s</b></span>")
-- }}}

-- {{{ System tray
systray = widget({ type = "systray" })
-- }}}
-- }}}

-- {{{ Wibox initialisation
wibox     = {}
promptbox = {}
layoutbox = {}
taglist   = {}
taglist.buttons = awful.util.table.join(
	awful.button({ },        1, awful.tag.viewonly),
	awful.button({ modkey }, 1, awful.client.movetotag),
	awful.button({ },        3, awful.tag.viewtoggle),
	awful.button({ modkey }, 3, awful.client.toggletag),
	awful.button({ },        4, awful.tag.viewnext),
	awful.button({ },        5, awful.tag.viewprev
))

mytasklist = {}
mytasklist.buttons = awful.util.table.join(
	awful.button({ }, 1, function (c)
		if c == client.focus then
			c.minimized = true
		else
			if not c:isvisible() then
				awful.tag.viewonly(c:tags()[1])
			end
			-- This will also un-minimize
			-- the client, if needed
			client.focus = c
			c:raise()
		end
	end),
	awful.button({ }, 3, function ()
		if instance then
			instance:hide()
			instance = nil
		else
			instance = awful.menu.clients({ width=250 })
		end
	end),
	awful.button({ }, 4, function ()
		awful.client.focus.byidx(1)
		if client.focus then client.focus:raise() end
	end),
	awful.button({ }, 5, function ()
		awful.client.focus.byidx(-1)
		if client.focus then client.focus:raise() end
	end)
)

for s = 1, scount do
	-- Create a promptbox
	promptbox[s] = awful.widget.prompt({ layout = awful.widget.layout.horizontal.leftright })
	-- Create a layoutbox
	layoutbox[s] = awful.widget.layoutbox(s)
	layoutbox[s]:buttons(awful.util.table.join(
		awful.button({ }, 1, function () awful.layout.inc(layouts,  1) end),
		awful.button({ }, 3, function () awful.layout.inc(layouts, -1) end),
		awful.button({ }, 4, function () awful.layout.inc(layouts,  1) end),
		awful.button({ }, 5, function () awful.layout.inc(layouts, -1) end)
	))

	-- Create the taglist
	taglist[s] = awful.widget.taglist(s, awful.widget.taglist.label.all, taglist.buttons)

	-- Create a tasklist widget
	mytasklist[s] = awful.widget.tasklist(
		function(c) return awful.widget.tasklist.label.currenttags(c, s) end, mytasklist.buttons
	)

	-- Create the wibox
	wibox[s] = awful.wibox({ 
		screen = s, fg = beautiful.fg_normal, height = 12,
		bg = beautiful.bg_normal, position = "top", 
		border_color = beautiful.border_focus,
		border_width = beautiful.border_width
	})
	-- Add widgets to the wibox
	wibox[s].widgets = {
		{ taglist[s], layoutbox[s], separator, promptbox[s],
			["layout"] = awful.widget.layout.horizontal.leftright
		},
		separator, datewidget, dateicon,
		separator, fs.s.widget, fs.h.widget, fs.r.widget, fs.b.widget, fsicon,
		separator, batwidget, baticon,
		separator, membar.widget, memicon,
		separator, tzswidget, cpugraph.widget, cpuicon,
		separator, volwidget,  volbar.widget, volicon,
		s == 1 and separator or nil,
		s == 1 and systray or nil,
		separator, mailwidget, mailicon,
		separator, upicon, netwidget, dnicon,
		separator, mytasklist[s], ["layout"] = awful.widget.layout.horizontal.rightleft
	}
end
-- }}}
-- }}}

-- {{{ Mouse bindings
root.buttons(awful.util.table.join(
	awful.button({ }, 4, awful.tag.viewnext),
	awful.button({ }, 5, awful.tag.viewprev)
))
-- }}}

-- {{{ Key bindings
globalkeys = awful.util.table.join(
		awful.key({ modkey,           }, "Left",   awful.tag.viewprev       ),
		awful.key({ modkey,           }, "Right",  awful.tag.viewnext       ),
		awful.key({ modkey,           }, "Escape", awful.tag.history.restore),

		awful.key({ modkey,           }, "j",
			function ()
				awful.client.focus.byidx(1)
				if client.focus then client.focus:raise() end
			end),
		awful.key({ modkey,           }, "k",
			function ()
				awful.client.focus.byidx(-1)
				if client.focus then client.focus:raise() end
			end),

		-- Layout manipulation
		awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end),
		awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end),
		awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative( 1) end),
		awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end),
		awful.key({ modkey,           }, "u", awful.client.urgent.jumpto),
		awful.key({ modkey,           }, "Tab",
			function ()
				awful.client.focus.history.previous()
				if client.focus then
					client.focus:raise()
				end
			end),

		-- Standard program
		awful.key({ modkey,           }, "Return", function () exec(terminal) end),
		-- awful.key({ modkey,           }, "BackSpace", function () exec("firefox") end),
		awful.key({ modkey,           }, "BackSpace", function () exec("chromium-browser") end),
		awful.key({ modkey, "Control" }, "r", awesome.restart),
		awful.key({ modkey, "Shift"   }, "q", awesome.quit),

		awful.key({ modkey,           }, "l",     function () awful.tag.incmwfact( 0.05)    end),
		awful.key({ modkey,           }, "h",     function () awful.tag.incmwfact(-0.05)    end),
		awful.key({ modkey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1)      end),
		awful.key({ modkey, "Shift"   }, "l",     function () awful.tag.incnmaster(-1)      end),
		awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1)         end),
		awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1)         end),
		awful.key({ modkey            }, "p",     function () awful.layout.inc(layouts,  1) end),
		awful.key({ modkey, "Shift"   }, "p",     function () awful.layout.inc(layouts, -1) end),

		awful.key({ modkey, "Control" }, "n", awful.client.restore),

		-- Prompt
		awful.key({ modkey },            "space", function () promptbox[mouse.screen]:run() end),

		awful.key({ modkey }, "x",
			function ()
				awful.prompt.run({ prompt = "Run Lua code: " },
					mypromptbox[mouse.screen].widget,
					awful.util.eval, nil,
					awful.util.getdir("cache") .. "/history_eval")
			end),

		-- Nautilus
		awful.key({ }, "XF86Launch1", function () exec("nautilus --no-desktop")  end),

		-- Liferea
		awful.key({ }, "Pause", function () exec("liferea") end),

		-- Screenshot
		--awful.key({ }, "Print", function () exec("import Screenshot.jpg") end),
		awful.key({ }, "Print", function () exec(home .. "/.local/bin/screenshot") end),

		-- Volume
		--awful.key({ }, "XF86AudioLowerVolume", function () volume("down") end),
		--awful.key({ }, "XF86AudioRaiseVolume", function () volume("up") end),
		--awful.key({ }, "XF86AudioMute", function () volume("mute") end),
	
		-- Display
		awful.key({ }, "XF86Display", function () exec("toggle-monitor")  end)
)

clientkeys = awful.util.table.join(
	awful.key({ modkey,           }, "f",      function (c) c.fullscreen = not c.fullscreen  end),
	awful.key({ modkey,           }, "s",      function (c) c.sticky = not c.sticky          end),
	awful.key({ modkey, "Shift"   }, "c",      function (c) c:kill()                         end),
	awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ),
	awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end),
	awful.key({ modkey,           }, "o",      awful.client.movetoscreen                        ),
	awful.key({ modkey, "Shift"   }, "r",      function (c) c:redraw()                       end),
	awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop            end),
	awful.key({ modkey,           }, "n",
		function (c)
			-- The client currently has the input focus, so it cannot be
			-- minimized, since minimized clients can't have the focus.
			c.minimized = true
		end),
	awful.key({ modkey,           }, "m",
		function (c)
			c.maximized_horizontal = not c.maximized_horizontal
			c.maximized_vertical   = not c.maximized_vertical
		end),
	awful.key({ modkey, "Shift" }, "t",
		function (c)
			if   c.titlebar then awful.titlebar.remove(c)
			else awful.titlebar.add(c, { modkey = modkey }) end
		end),
	awful.key({ modkey, "Shift" }, "f", 
		function (c) 
			if awful.client.floating.get(c)
			then awful.client.floating.delete(c);    awful.titlebar.remove(c)
			else awful.client.floating.set(c, true); awful.titlebar.add(c) end
		end)
)

-- Compute the maximum number of digit we need, limited to 9
keynumber = 0
for s = 1, scount do
	keynumber = math.min(9, math.max(#tags[s], keynumber));
end

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it works on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, keynumber do
	globalkeys = awful.util.table.join(globalkeys,
		awful.key({ modkey }, "#" .. i + 9,
			function ()
				local screen = mouse.screen
				if tags[screen][i] then
					awful.tag.viewonly(tags[screen][i])
				end
			end),
		awful.key({ modkey, "Control" }, "#" .. i + 9,
			function ()
				local screen = mouse.screen
				if tags[screen][i] then
					awful.tag.viewtoggle(tags[screen][i])
				end
			end),
		awful.key({ modkey, "Shift" }, "#" .. i + 9,
			function ()
				if client.focus and tags[client.focus.screen][i] then
					awful.client.movetotag(tags[client.focus.screen][i])
				end
			end),
		awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
			function ()
				if client.focus and tags[client.focus.screen][i] then
					awful.client.toggletag(tags[client.focus.screen][i])
				end
			end))
end

clientbuttons = awful.util.table.join(
	awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
	awful.button({ modkey }, 1, awful.mouse.client.move),
	awful.button({ modkey }, 3, awful.mouse.client.resize)
)

-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Rules
awful.rules.rules = {
	-- All clients will match this rule.
	{ rule = { },
		properties = { border_width = beautiful.border_width,
									 border_color = beautiful.border_normal,
									 focus = true,
									 keys = clientkeys,
									 buttons = clientbuttons } },
	{ rule = { class = "MPlayer" },
		properties = { floating = true } },
	{ rule = { class = "gimp" },
		properties = { floating = true } },
	{ rule = { class = "Evolution" },
		properties = { tag = tags[1][6] } },
	{ rule = { class = "Gpodder" },
		properties = { tag = tags[1][5] } },
	{ rule = { class = "Pidgin" },
		properties = { tag = tags[1][3] } },
	{ rule = { class = "Skype" },
		properties = { tag = tags[1][3] } },
	{ rule = { class = "Liferea" },
		properties = { tag = tags[1][1], switchtotag = true, floating = true, maximized_horizontal = true, maximized_vertical = true, }, callback = awful.titlebar.add  },
	{ rule = { class = "Rhythmbox" },
		properties = { tag = tags[1][6], switchtotag = true} },
	{ rule = { class = "Plugin-container" },
		properties = { floating = true } },
	{ rule = { class = "Exe" },
		properties = { floating = true } },
	{ rule = { class = "Easytag" },
		properties = { floating = true } },
	{ rule = { instance = "Toplevel" },
		properties = { floating = true } },
	{ rule = { name = "Terminator Preferences" },
		properties = { floating = true } },
}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.add_signal("manage", function (c, startup)
	-- Add a titlebar
	--awful.titlebar.add(c, { modkey = modkey })
	if awful.client.floating.get(c)
	or awful.layout.get(c.screen) == awful.layout.suit.floating then
		if   c.titlebar then awful.titlebar.remove(c)
		else awful.titlebar.add(c, {modkey = modkey}) end
	end

	-- Enable sloppy focus
	c:add_signal("mouse::enter", function(c)
		if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
		and awful.client.focus.filter(c) then
			client.focus = c
		end
	end)

	if not startup then
		-- Set the windows at the slave,
		-- i.e. put it at the end of others instead of setting it master.
		-- awful.client.setslave(c)

		-- Put windows in a smart way, only if they does not set an initial position.
		if not c.size_hints.user_position and not c.size_hints.program_position then
			awful.placement.no_overlap(c)
			awful.placement.no_offscreen(c)
		end
	end
end)

client.add_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.add_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
-- }}}

-- Functions {{{
scard = 0
schannel = "Master"
function volume(arg)
	if arg == "up" then
		exec("amixer -q -c " .. scard .. " sset " .. schannel .. " 5%+")
	elseif arg == "down" then
		exec("amixer -q -c " .. scard .. " sset " .. schannel .. " 5%-")
	elseif arg == "mute" then
		exec("amixer -q -c " .. scard .. " sset " .. schannel .. " toggle")
	end
	vicious.force({volbar, volwidget})
end
-- }}}

require("lfs") 
-- {{{ Run programm once
local function processwalker()
	local function yieldprocess()
		for dir in lfs.dir("/proc") do
			-- All directories in /proc containing a number, represent a process
			if tonumber(dir) ~= nil then
				local f, err = io.open("/proc/"..dir.."/cmdline")
				if f then
					local cmdline = f:read("*all")
					f:close()
					if cmdline ~= "" then
						coroutine.yield(cmdline)
					end
				end
			end
		end
	end
	return coroutine.wrap(yieldprocess)
end

local function run_once(process, cmd)
	assert(type(process) == "string")
	local regex_killer = {
		["+"]  = "%+", ["-"] = "%-",
		["*"]  = "%*", ["?"]  = "%?" }

	for p in processwalker() do
		if p:find(process:gsub("[-+?*]", regex_killer)) then
			return
		end
	end
	return exec(cmd or process)
end
-- }}}

-- Startup {{{
exec("killall nautilus")
run_once("/usr/sbin/thinkfan")
run_once("dropboxd")
run_once("gpodder")
run_once("chromium-browser")
run_once("skype")
run_once("pidgin")
run_once("liferea")
exec(home .. "/.local/bin/export_x_info")
-- }}}
