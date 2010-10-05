
-- Ion main configuration file
--
-- This file only includes some settings that are rather frequently altered.
-- The rest of the settings are in cfg_ioncore.lua and individual modules'
-- configuration files (cfg_modulename.lua). 
--
-- When any binding and other customisations that you want are minor, it is 
-- recommended that you include them in a copy of this file in ~/.ion3/.
-- Simply create or copy the relevant settings at the end of this file (from
-- the other files), recalling that a key can be unbound by passing 'nil' 
-- (without the quotes) as the callback. For more information, please see 
-- the Ion configuration manual available from the Ion Web page.
--

-- Set default modifiers. Alt should usually be mapped to Mod1 on
-- XFree86-based systems. The flying window keys are probably Mod3
-- or Mod4; see the output of 'xmodmap'.
-- These may be defined in /etc/default/ion3, loaded as cfg_debian.
dopath("cfg_debian")
META="Mod4+"
ALTMETA="Mod4+"

-- Terminal emulator
XTERM="xterm -ls -bg black -fg gray"

-- Some basic settings
ioncore.set{
    -- Maximum delay between clicks in milliseconds to be considered a
    -- double click.
    --dblclick_delay=250,

    -- For keyboard resize, time (in milliseconds) to wait after latest
    -- key press before automatically leaving resize mode (and doing
    -- the resize in case of non-opaque move).
    --kbresize_delay=1500,

    -- Opaque resize?
    --opaque_resize=false,

    -- Movement commands warp the pointer to frames instead of just
    -- changing focus. Enabled by default.
    --warp=true,
    
    -- Switch frames to display newly mapped windows
    --switchto=true,
    
    -- Default index for windows in frames: one of 'last', 'next' (for
    -- after current), or 'next-act' (for after current and anything with
    -- activity right after it).
    --frame_default_index='next',
    
    -- Auto-unsqueeze transients/menus/queries.
    --unsqueeze=true,
    
    -- Display notification tooltips for activity on hidden workspace.
    --screen_notify=true,
}


-- Load default settings. The file cfg_defaults loads all the files
-- commented out below, except mod_dock. If you do not want to load
-- something, comment out this line, and uncomment the lines corresponding
-- the the modules or configuration files that you want, below.
-- The modules' configuration files correspond to the names of the 
-- modules with 'mod' replaced by 'cfg'.
dopath("cfg_defaults")

-- Load configuration of the Ion 'core'. Most bindings are here.
--dopath("cfg_ioncore")

-- Load some kludges to make apps behave better.
--dopath("cfg_kludges")

-- Define some layouts. 
dopath("cfg_layouts")

-- Load some modules. Bindings and other configuration specific to modules
-- are in the files cfg_modulename.lua.
--dopath("mod_query")
--dopath("mod_menu")
--dopath("mod_tiling")
--dopath("mod_statusbar")
--dopath("mod_dock")
--dopath("mod_sp")


--
-- Common customisations
--

-- Uncommenting the following lines should get you plain-old-menus instead
-- of query-menus.

defbindings("WScreen", {
    kpress(META.."Shift+Tab", "ioncore.goto_next(_chld, 'left')", "_chld:non-nil"),

    kpress(META.."space", "mod_menu.menu(_, _sub, 'mainmenu', {big=false})"),
    kpress("XF86AudioRaiseVolume", "ioncore.exec_on(_, 'amixer -q set Master 5+ unmute')"),
    kpress("XF86AudioLowerVolume", "ioncore.exec_on(_, 'amixer -q set Master 5- unmute')"),
    kpress("XF86AudioMute", "ioncore.exec_on(_, 'amixer -q set Master toggle')"),

    
    --kpress(META.."Up", "ioncore.exec_on(_, '/usr/bin/banshee --play')"),
    --kpress(META.."Down", "ioncore.exec_on(_, '/usr/bin/banshee --pause')"),
    --kpress(META.."Right", "ioncore.exec_on(_, '/usr/bin/banshee --next')"),
    --kpress(META.."Left", "ioncore.exec_on(_, '/usr/bin/banshee --previous')"),

    submap(META.."K", {
        kpress("L", "ioncore.exec_on(_, ioncore.lookup_script('ion-lock'))"),
    }),

})


defbindings("WMPlex.toplevel", {
    kpress(META.."M", "mod_menu.menu(_, _sub, 'ctxmenu')"),

    kpress(META.."KP_Enter", "mod_query.query_exec(_)"),
    kpress(META.."grave", "mod_menu.grabmenu(_, _sub, 'focuslist')"),

})


-- Main menu
defmenu("mainmenu", {
    menuentry("Run...",         "mod_query.query_exec(_)"),
    menuentry("Terminal",       "ioncore.exec_on(_, 'xterm -ls -bg black -fg gray')"),
    --menuentry("Firefox",
    --    "ioncore.exec_on(_, '/usr/bin/firefox-3.0 -ProfileManager -no-remote')"),
    menuentry("Firefox", "ioncore.exec_on(_, '/usr/bin/firefox')"),
    menuentry("Chrome", "ioncore.exec_on(_, '/usr/bin/google-chrome --enable-plugins')"),
    menuentry("Pidgin", "ioncore.exec_on(_, '/usr/bin/pidgin')"),
    menuentry("Pandora", "ioncore.exec_on(_, '/opt/Pandora/bin/Pandora')"),
    menuentry("Banshee", "ioncore.exec_on(_, '/usr/bin/banshee')"),
    menuentry("Audacious", "ioncore.exec_on(_, '/usr/bin/audacious')"),
    menuentry("wicd", "ioncore.exec_on(_, '/usr/bin/wicd-client -n')"),
    menuentry("Mnemosyne", "ioncore.exec_on(_, '/usr/bin/mnemosyne')"),
    menuentry("Lock screen",
              "ioncore.exec_on(_, ioncore.lookup_script('ion-lock'))"),
    menuentry("Help",           "mod_query.query_man(_)"),
    menuentry("About Ion",      "mod_query.show_about_ion(_)"),
    submenu("Styles",           "stylemenu"),
    submenu("Debian",           "Debian"),
    submenu("Session",          "sessionmenu"),
})

-- Moves the current window to the left or right (as determined by dirstr,
-- which is passed to ioncore.navi_next()). Has the side effect of clearing any
-- preexisting tags.
function move_window_to(_, _sub, dirstr)
     ioncore.tagged_clear()
     WRegion.set_tagged(_sub, 'true')
     ioncore.tagged_attach(ioncore.navi_next(_, dirstr))
     ioncore.goto_next(_, dirstr)
end

defbindings("WMPlex.toplevel", {
    kpress(META.."bracketleft", "move_window_to(_, _sub, 'left')"),
    kpress(META.."bracketright", "move_window_to(_, _sub, 'right')"),
    kpress(META.."Shift+bracketleft", "move_window_to(_, _sub, 'up')"),
    kpress(META.."Shift+bracketright", "move_window_to(_, _sub, 'down')"),
})



--[exec] (XTerm) {xterm -ls} </usr/share/pixmaps/xterm-color_32x32.xpm>
--[exec] (XTerm-nologin) {xterm} </usr/share/pixmaps/xterm-color_32x32.xpm>
--[exec] (Mnemosyne) {mnemosyne}
--[exec] (Audacious) {/usr/bin/audacious} </usr/share/pixmaps/audacious.xpm>
--[exec] (Pidgin) {/usr/bin/pidgin} </usr/share/pixmaps/pidgin-menu.xpm>
--[exec] (Gnomebaker) {/usr/bin/gnomebaker} </usr/share/pixmaps/gnomebaker.xpm>
--[exec] (texmaker) {/usr/bin/texmaker} </usr/share/app-install/icons/texmaker.xpm>
--[exec] (smplayer) {/usr/bin/smplayer} </usr/share/pixmaps/smplayer.xpm>
--[exec] (transmisison) {/usr/bin/transmisison} </usr/share/pixmaps/transmission.xpm>
--[exec] (Gnome Control Center) {/usr/bin/gnome-control-center} <>
