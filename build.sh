
DEF_DMG_NAME='Device-Xplore.dmg'
DEF_DMG_PATH=build/$DEF_DMG_NAME

flutter build macos

rm $DEF_DMG_PATH
appdmg dmg/config.json $DEF_DMG_PATH