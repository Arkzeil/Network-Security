git clone https://chromium.googlesource.com/chromium/tools/depot_tools.git
export PATH="${HOME}/depot_tools:$PATH"
mkdir ~/chromium && cd ~/chromium
fetch --no-history --nohooks chromium
cd src/
./build/install-build-deps.sh
gclient runhooks

gclient sync --with_branch_heads --with_tags
git fetch origin
git tag
git checkout tags/109.0.5414.74
gclient sync --with_branch_heads --with_tags

gn gen out/test

gn args out/test
ninja -C out/test base_unittests
out/test/base_unittests \
--gtest_filter=ToolsSanityTest.DISABLED_AddressSanitizerLocalOOBCrashTest \
--gtest_also_run_disabled_tests
autoninja -C out/test/ chrome

rm -rf /tmp/abcd1234;out/test/chrome  --user-data-dir=/tmp/abcd1234 http://localhost:8080/poc3.html