# added command to remove the build folder after the installation, added optimization arguments
install:
	swift build -c release -Xswiftc -cross-module-optimization -Xlinker -dead_strip_dylibs
	install .build/release/sitrep /usr/local/bin/sitrep
	rm -r .build
