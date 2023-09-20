LLVM_VERSION=$(notdir $(shell pwd))
MINIMUM_LLVM_PACKAGES=llvm-$(LLVM_VERSION).src.tar.xz clang-$(LLVM_VERSION).src.tar.xz # openmp-$(LLVM_VERSION).src.tar.xz
EXTRA_PACKAGES=#polly-$(LLVM_VERSION).src.tar.xz clang-tools-extra-$(LLVM_VERSION).src.tar.xz compiler-rt-$(LLVM_VERSION).src.tar.xz
PACKAGES=$(MINIMUM_LLVM_PACKAGES) $(EXTRA_PACKAGES) cmake-$(LLVM_VERSION).src.tar.xz
BACKENDS="all"  #"X86;ARM;RISCV"
TESTS="test" #"notest"
EXTRAS="extra"
EXTRA_CMAKE_OPTIONS=# "-DLLVM_INCLUDE_TESTS=OFF -DLLVM_INCLUDE_BENCHMARKS=OFF " 
LLVM_URL=https://github.com/llvm/llvm-project/releases/download/llvmorg-
CLANG_ADDR=clang-$(LLVM_VERSION).src.tar.xz


all: archive src
	./scripts/build.sh $(LLVM_VERSION) release "$(BACKENDS)" $(TESTS) "$(EXTRA_CMAKE_OPTIONS)"

archive:
	if test -e $@/llvm-$(LLVM_VERSION).src.tar.xz ; then mv archive/* ./ ; fi

llvm-$(LLVM_VERSION).src.tar.xz:
	wget -4 $(LLVM_URL)$(LLVM_VERSION)/$@

cmake-$(LLVM_VERSION).src.tar.xz:
	wget -4 $(LLVM_URL)$(LLVM_VERSION)/$@

clang-$(LLVM_VERSION).src.tar.xz:
	wget -4 -O clang-$(LLVM_VERSION).src.tar.xz $(LLVM_URL)$(LLVM_VERSION)/$(CLANG_ADDR)

polly-$(LLVM_VERSION).src.tar.xz:
	wget -4 $(LLVM_URL)$(LLVM_VERSION)/$@

clang-tools-extra-$(LLVM_VERSION).src.tar.xz:
	wget -4 $(LLVM_URL)$(LLVM_VERSION)/$@

compiler-rt-$(LLVM_VERSION).src.tar.xz:
	wget -4 $(LLVM_URL)$(LLVM_VERSION)/$@

openmp-$(LLVM_VERSION).src.tar.xz:
	wget -4 $(LLVM_URL)$(LLVM_VERSION)/$@

src: unpack
	ln -s llvm-$(LLVM_VERSION).src $@

print:
	echo $(LLVM_VERSION)

unpack: $(PACKAGES)
	./scripts/unpack.sh $(LLVM_VERSION) $(EXTRAS)

debug:
	./scripts/build.sh $(LLVM_VERSION) $@ "$(BACKENDS)" $(TESTS) "$(EXTRA_CMAKE_OPTIONS)"

clean_build:
	rm -rf `find ./ -name build`

clean: clean_build
	./scripts/clean.sh $(LLVM_VERSION)

uninstall:
	rm -rf release enable *.xz

.PHONY: archive clean clean_build debug unpack print release

