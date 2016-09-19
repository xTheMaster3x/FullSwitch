GO_EASY_ON_ME = 1
ARCHS ?= armv7 arm64
TARGET = iphone:clang

include theos/makefiles/common.mk

BUNDLE_NAME = FullSwitch
FullSwitch_FILES = FullSwitch.xm Credits.xm
FullSwitch_INSTALL_PATH = /Library/PreferenceBundles
FullSwitch_FRAMEWORKS = UIKit Twitter CoreGraphics
FullSwitch_PRIVATE_FRAMEWORKS = Preferences

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/FullSwitch.plist$(ECHO_END)
