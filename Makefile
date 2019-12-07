include $(THEOS)/makefiles/common.mk
export ARCHS = armv7 arm64
export TARGET = iphone:clang:9.2:9.0
APPLICATION_NAME = MobileHeaders

MobileHeaders_FILES = $(wildcard *.m)
MobileHeaders_FRAMEWORKS = UIKit CoreGraphics
MobileHeaders_CFLAGS = -w -fobjc-arc

include $(THEOS_MAKE_PATH)/application.mk

after-install::
	install.exec "killall \"MobileHeaders\"" || true
