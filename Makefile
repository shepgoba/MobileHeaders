include $(THEOS)/makefiles/common.mk

rwildcard=$(foreach d,$(wildcard $(1:=/*)),$(call rwildcard,$d,$2) $(filter $(subst *,%,$2),$d))

export ARCHS = armv7 arm64 arm64e
export TARGET = iphone:clang:13.1:9.0

export DEBUG = 0
export FINAL_PACKAGE = 1

SDKVERSION_armv7 = 11.2
APPLICATION_NAME = iHeaders

iHeaders_FILES = $(call rwildcard,.,*.m) $(call rwildcard,.,*.cpp) $(call rwildcard,.,*.mm) $(call rwildcard,.,*.c)
iHeaders_FRAMEWORKS = UIKit WebKit
iHeaders_LIBRARIES = LzmaSDKObjC
iHeaders_CFLAGS += -fobjc-arc

include $(THEOS_MAKE_PATH)/application.mk

after-install::
	install.exec "killall \"iHeaders\"" || true
