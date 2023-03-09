#!/bin/bash

set -e
cd $(dirname $0)

REMOTE_TAG=${REMOTE_TAG:-f8c9335} # This is latest commit on master branch at 20220120

# Clone 
if [[ ! -d repo ]]; then
    git clone https://github.com/RAKWireless/rak_common_for_gateway repo
    #git clone https://github.com/Sheng2216/rak_common_for_gateway_fork.git repo
fi

# Check out tag
pushd repo
git checkout ${REMOTE_TAG}

# Apply patches
if [ -f ../${REMOTE_TAG}.patch ]; then
    echo "Applying ${REMOTE_TAG}.patch ..."
    git apply ../${REMOTE_TAG}.patch
fi

# Build
pushd lora
FOLDERS=(rak7243 rak2246 rak2247_usb rak2247_spi rak2287 rak5146)
for FOLDER in ${FOLDERS[@]}; do
    pushd $FOLDER
    ./install.sh
    popd
done
popd


# Get out of repo folder
popd

git clone https://github.com/Sheng2216/rak_common_for_gateway_new_fork.git new_repo

cp -r new_repo/lora/rak2246/global_conf repo/lora/rak2246/global_conf
cp -r new_repo/lora/rak2247_spi/global_conf repo/lora/rak2247_spi
cp -r new_repo/lora/rak2247_usb/global_conf repo/lora/rak2247_usb
cp -r new_repo/lora/rak2287/global_conf_i2c repo/lora/rak2287
cp -r new_repo/lora/rak2287/global_conf_uart repo/lora/rak2287
cp -r new_repo/lora/rak2287/global_conf_usb repo/lora/rak2287
cp -r new_repo/lora/rak5146/global_conf_i2c repo/lora/rak5146
cp -r new_repo/lora/rak5146/global_conf_uart repo/lora/rak5146
cp -r new_repo/lora/rak5146/global_conf_usb repo/lora/rak5146
cp -r new_repo/lora/rak7243/global_conf_i2c repo/lora/rak7243
cp -r new_repo/lora/rak7243/global_conf_uart repo/lora/rak7243
rm -rf new_repo
