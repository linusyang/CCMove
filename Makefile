TARGET = iphone:clang:latest:7.0
ARCHS = armv7 arm64
GO_EASY_ON_ME = 1

include theos/makefiles/common.mk

TWEAK_NAME = CCMove
CCMove_FILES = Tweak.xm
CCMove_LIBRARIES = substrate
CCMove_FRAMEWORKS = UIKit

include $(THEOS_MAKE_PATH)/tweak.mk

VERSION.INC_BUILD_NUMBER = 2

stage::
	find "$(THEOS_STAGING_DIR)" -type f \( -iname "*.strings" -o -iname "*.plist" \) -exec plutil -convert binary1 {} \;
