import XMonad
import XMonad.Actions.CycleWS (nextWS, prevWS)
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers
import XMonad.Layout.NoBorders(smartBorders)
import XMonad.Layout.PerWorkspace
import XMonad.Layout.SimplestFloat
import XMonad.Util.EZConfig(additionalKeys)

myManageHook = composeAll . concat $
              [ [ className =? c --> doFloat | c <- cFloats ]
              , [ title =? t --> doFloat | t <- tFloats ]]
              where cFloats = [ ]
                    tFloats = [ "Firefox Preferences", "Downloads", "Add-on", "Rename", "create"]


myConfig = ewmh def
         { manageHook = myManageHook <+> manageHook def
         , handleEventHook = handleEventHook def <+> fullscreenEventHook
         , layoutHook = smartBorders $ onWorkspace "float" simplestFloat $ (avoidStruts $ layoutHook def)
         , terminal = "urxvt"
         , borderWidth = 0
         , modMask = mod4Mask  -- modkey is now windows key
         } `additionalKeys`
         [ ((mod4Mask .|. shiftMask, xK_l), spawn "xscreensaver-command -lock") -- Lock screen with win + shift + L
         , ((mod4Mask .|. shiftMask, xK_p), spawn "sleep 0.2; pushd ~/screenshots/ ; scrot -s ; popd") -- Take screenshot of window with win + shift + p
         , ((mod4Mask, xK_p), spawn "pushd ~/screenshots/ ; scrot ; popd") -- Take screenshot of screen with win + p
         , ((mod4Mask, xK_Left), prevWS)
         , ((mod4Mask, xK_Right), nextWS)
         , ((mod4Mask, xK_r), spawn "rofi -show run")
         ]


--main = xmonad $ emwh def {} =<< statusBar myBar myPP toggleStrutsKey myConfig
main = xmonad =<< statusBar myBar myPP toggleStrutsKey myConfig

myBar = "xmobar"

myPP = xmobarPP { ppCurrent = xmobarColor "green" "" . wrap "<" ">" . shorten 68 }

toggleStrutsKey XConfig { XMonad.modMask = modMask } = (modMask, xK_f)

