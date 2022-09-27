export LD_LIBRARY_PATH=/opt/aarch64-rockchip-linux-gnu/lib64:$LD_LIBRARY_PATH
cd build
make -j 4
make install
cd ..
echo "start push to rk3588:192.168.1.146,please wait"
scp  -r ./deepsort_install ema@192.168.1.146:/home/ema/Project/
# scp  -r ./data ema@192.168.1.146:/home/ema/Project/deepsort_install
# adb push ./install /root
