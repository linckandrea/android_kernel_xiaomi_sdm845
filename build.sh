mkdir -p out
make O=out clean
make O=out mrproper

branch=$(git symbolic-ref --short HEAD)
branch_name=$(git rev-parse --abbrev-ref HEAD)
last_commit=$(git rev-parse --verify --short=8 HEAD)
export LOCALVERSION="-Armonia-Kernel-${branch_name}/${last_commit}"

make O=out ARCH=arm64 Armonia_beryllium_full_defconfig

PATH=""$HOME"/Android-dev/toolchains/aosp-clang/clang-r522817/bin:"$HOME"/Android-dev/toolchains/aosp-clang/aarch64-linux-android-4.9/bin:"$HOME"/Android-dev/toolchains/aosp-clang/arm-linux-androideabi-4.9/bin:${PATH}" \
make -j$(nproc --all) O=out \
                      ARCH=arm64 \
                      SUBARCH=arm64 \
                      CC=clang \
                      CLANG_TRIPLE=aarch64-linux-gnu- \
                      CROSS_COMPILE=aarch64-linux-android- \
                      CROSS_COMPILE_ARM32=arm-linux-androideabi- \
                      HOSTCFLAGS="-fuse-ld=lld -Wno-unused-command-line-argument" \
                      LLVM=1 \
                      LLVM_IAS=1


rm ./AnyKernel3/beryllium/*.zip
rm ./AnyKernel3/beryllium/Image.gz-dtb
cp ./out/arch/arm64/boot/Image.gz-dtb ./AnyKernel3/beryllium
cd ./AnyKernel3/beryllium
zip -r9 ArmoniaKernel-"beryllium"-"$branch"-"$last_commit".zip * -x .git README.md *placeholder

cd ..
cd ..
echo THE END
