GO_EASY_ON_ME = 1
export ARCHS = armv7 armv7s arm64
export TARGET = iphone:clang::8.1
THEOS_BUILD_DIR = Packages

include theos/makefiles/common.mk

TWEAK_NAME = FullSwitch
FullSwitch_FILES = Tweak.xm CKBlurView.m
FullSwitch_FRAMEWORKS = UIKit CoreGraphics QuartzCore
ARCHS = armv7 arm64

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 backboardd"
SUBPROJECTS += fullswitch
include $(THEOS_MAKE_PATH)/aggregate.mk
