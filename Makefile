include $(THEOS)/makefiles/common.mk

rwildcard=$(foreach d,$(wildcard $(1:=/*)),$(call rwildcard,$d,$2) $(filter $(subst *,%,$2),$d))

export ARCHS = armv7 arm64 arm64e
export TARGET = iphone:clang:13.1:9.0
SDKVERSION_armv7 = 11.2
APPLICATION_NAME = MobileHeaders

DEBUG=0
FINAL_PACKAGE=1

MobileHeaders_FILES = $(call rwildcard,.,*.m) $(call rwildcard,.,*.cpp) $(call rwildcard,.,*.mm) $(call rwildcard,.,*.c)
MobileHeaders_FRAMEWORKS = UIKit CoreGraphics
MobileHeaders_CFLAGS = -fobjc-arc -std=c++11

include $(THEOS_MAKE_PATH)/application.mk

after-install::
	install.exec "killall \"MobileHeaders\"" || true
