
rwildcard=$(foreach d,$(wildcard $(1:=/*)),$(call rwildcard,$d,$2) $(filter $(subst *,%,$2),$d))
all:
	clang -isysroot /Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS12.1.sdk -l"c++" -fobjc-arc -c -arch arm64e -fpic $(call rwildcard,.,*.m) $(call rwildcard,.,*.cpp) $(call rwildcard,.,*.mm) $(call rwildcard,.,*.c)
