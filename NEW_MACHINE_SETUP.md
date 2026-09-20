# New Machine Setup

## macOS Bootstrap

1. Install OS updates
2. Settings
    * General
        * Software Update - Check that automatic updates are disabled
        * Storage
            * Applications - Remove any unwanted apps
            * Music Creationg - Remove library
    * Appearance
        * Appearance - Light
        * Liquid Glass - Clear
        * Theme
            * Color - Green
            * Text highlight color - Green
            * Icon & widget style - Default
            * Folder color - Automatic
        * Show scroll bars - When scrolling
    * Destkop & Dock
        * Dock
            * Size - Decrease
            * Maginification - Off
            * Minimize windows using - Scale Effect
            * Minimize windows into application icon - On
            * Automatically hide and show the Dock - On
            * Show suggested and recent apps in Dock - Off
            * Delete apps
        * Windows
            * Prefer tabs when opening documents - Never
            * Turn off all tile settings (Becuse I use AeroSpace)
        * Mission Control
            * Automatically rearrange Spaces based on most recent use - Off
            * Group windows by applicaton - On (Because I use AeroSpace)
            * Displays have separate Spaces - Off (Because I use AeroSpace)
    * Displays
        * Automatically adjust brightness - Off
    * Menu Bar
        * Clock - Display the time with seconds - On
        * Wi-Fi - On
        * Bluetooth - On
        * Battery - Show Percentage - On
        * Display - Always Show
        * Sound - Always Show
        * Now Playing - Show When Active
        * Reorder icons with Cmd + Drag
    * Wallpaper
        * Custom Color - Black
    * Notifications
        * Show Notifications: when display is sleeping and when screen is locked - Off
    * Lock Screen
        * Require password after screen saver begins or display is turned off - Immediately
    * Touch ID & Password
        * Apple Watch - Use Apple Watch to unlock your applications and your Mac - On
    * Game Center
        * Sign off
    * iCloud
        * Messages - Use on this Mac - Off
        * Mail - Off
    * Keyboard
        * Key repeat rate - Fast
        * Delay until repeat - Short
        * Keyboard navigation - On
        * Keyboard Shortcuts
            * Mission Control
                * Mission Control, Quick Note, Game Overlay - Off
            * Modifier Keys
                * Caps Lick - Control
    * Trackpad
        * Point & Click
            * Tracking speed - 2 short of Fast
            * Look up & data detectors - Off
3. Install [Google Chrome](https://www.google.com/chrome/)
4. Install [Ghostty](https://ghostty.org/download)
5. Install Xcode command line tools. Run `xcode-select --install`
6. Install [Homebrew](https://brew.sh/)

## Machine Config

1. Generate [SSH Key and add to Github](https://docs.github.com/en/authentication/connecting-to-github-with-ssh)
2. Run `brew bundle install --file=~/code/machine-config/Brewfile`
3. Run `./kronning.sh`
