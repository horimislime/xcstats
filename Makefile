TEMPORARY_FOLDER?=./xcstats-build
PREFIX?=/usr/local

SWIFT_BUILD_FLAGS=--disable-sandbox -c release
EXECUTABLE_NAME=xcstats
BUILD_OUTPUT_PATH=$(shell swift build $(SWIFT_BUILD_FLAGS) --show-bin-path)
PORTABLE_ZIP_NAME=$(TEMPORARY_FOLDER)/xcstats_portable.zip

all: build

clean:
	rm -f "$(OUTPUT_PACKAGE)"
	rm -rf "$(TEMPORARY_FOLDER)"
	rm -f "$(PORTABLE_ZIP_NAME)"
	swift package clean

clean_xcode:
	$(BUILD_TOOL) $(XCODEFLAGS) -configuration Test clean

build:
	swift build $(SWIFT_BUILD_FLAGS)

install: build
	mkdir -p "$(PREFIX)/bin"
	mkdir -p "$(PREFIX)/lib"
	cp -f "$(BUILD_OUTPUT_PATH)/$(EXECUTABLE_NAME)" "$(PREFIX)/bin/$(EXECUTABLE_NAME)"
	cp -f "$(BUILD_OUTPUT_PATH)/libSwiftSyntax.dylib" "$(PREFIX)/lib/libSwiftSyntax.dylib"

uninstall:
	rm "$(PREFIX)/bin/$(EXECUTABLE_NAME)"
	rm "$(PREFIX)/lib/libSwiftSyntax.dylib"

xcodeproj:
	swift package generate-xcodeproj

portable_zip: build
	mkdir -p "$(TEMPORARY_FOLDER)"
	cp -f "$(EXECUTABLE_PATH)" "$(TEMPORARY_FOLDER)/$(EXECUTABLE_NAME)"
	cp -f "LICENSE" "$(TEMPORARY_FOLDER)"
	(cd "$(TEMPORARY_FOLDER)"; zip -yr - "$(EXECUTABLE_NAME)" "LICENSE") > "$(PORTABLE_ZIP_NAME)"
