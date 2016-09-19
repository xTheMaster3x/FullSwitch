ARCHS = armv7 arm64
TARGET = iphone:clang:latest:latest
CFLAGS = -fobjc-arc
LDFLAGS = -F$(THEOS)/frameworks

include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = FullSwitch
FullSwitch_FILES = FullSwitch.mm $(shell find $(THEOS)/include/SettingsKit -name '*.m')
FullSwitch_INSTALL_PATH = /Library/PreferenceBundles
FullSwitch_FRAMEWORKS = UIKit MessageUI Social QuartzCore CoreGraphics
FullSwitch_PRIVATE_FRAMEWORKS = Preferences

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)cp $(THEOS)/include/SettingsKit/Resources/*.png $(THEOS_STAGING_DIR)/Library/PreferenceBundles/FullSwitch.bundle/$(ECHO_END)
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/FullSwitch.plist$(ECHO_END)
