--
-- An example, simple ~/.xmonad/xmonad.hs file.
-- It overrides a few basic settings, reusing all the other defaults.
--

import XMonad
import XMonad.Util.EZConfig(additionalKeys)

main = do
    xmonad $ defaultConfig
        { modMask            = mod4Mask
        , terminal           = "urxvt -ls -bg black -fg gray +sb"
        , borderWidth        = 1
        , normalBorderColor  = "#cccccc"
        , focusedBorderColor = "#cd8b00" } `additionalKeys`
        [ ((mod4Mask .|. shiftMask, xK_z), spawn "/usr/bin/xscreensaver-command -lock")
        ]
