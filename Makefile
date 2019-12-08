include $(THEOS)/makefiles/common.mk

export ARCHS = armv7 arm64 arm64e
export TARGET = iphone:clang:13.1:9.0
SDKVERSION_armv7 = 11.2
APPLICATION_NAME = MobileHeaders

DEBUG=0
FINAL_PACKAGE=1

MobileHeaders_FILES = $(wildcard *.m)
MobileHeaders_FRAMEWORKS = UIKit CoreGraphics
MobileHeaders_CFLAGS = -w -fobjc-arc

include $(THEOS_MAKE_PATH)/application.mk

after-install::
	install.exec "killall \"MobileHeaders\"" || true
