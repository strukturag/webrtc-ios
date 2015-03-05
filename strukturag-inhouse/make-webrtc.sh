#!/bin/bash

# Author: Yuriy Shevchuk
# Copyright: 2015, struktur AG

# This script builds fat WebRTC library for iOS.
# It is intended to be run from the same directory where 'src' dir of webrtc is.
# Idea from http://ninjanetic.com/how-to-get-started-with-webrtc-and-ios-without-wasting-10-hours-of-your-life/


LIBS_GENERIC="libjingle_peerconnection_objc.a \
libjingle_peerconnection.a \
libexpat.a \
libjsoncpp.a \
libcrssl.a \
libcrnspr.a \
libcrnss.a \
libnss_static.a \
libsqlite_regexp.a \
libicui18n.a \
libicuuc.a \
libicudata.a \
libcrnssckbi.a \
libjingle_media.a \
libyuv.a \
libusrsctplib.a \
libwebrtc_utility.a \
libaudio_coding_module.a \
libCNG.a \
libcommon_audio.a \
libsystem_wrappers.a \
libaudio_encoder_interface.a \
libG711.a \
libG722.a \
libiLBC.a \
libiSAC.a \
libaudio_decoder_interface.a \
libiSACFix.a \
libPCM16B.a \
libred.a \
libwebrtc_opus.a \
libopus.a \
libneteq.a \
libmedia_file.a \
libwebrtc_video_coding.a \
libwebrtc_i420.a \
libcommon_video.a \
libvideo_coding_utility.a \
libwebrtc_vp8.a \
libvpx.a \
libwebrtc_vp9.a \
libwebrtc.a \
libwebrtc_common.a \
libvideo_engine_core.a \
librtp_rtcp.a \
libpaced_sender.a \
libremote_bitrate_estimator.a \
libbitrate_controller.a \
libvideo_processing.a \
libvoice_engine.a \
libaudio_conference_mixer.a \
libaudio_processing.a \
libaudio_device.a \
librtc_sound.a \
libfield_trial_default.a \
libmetrics_default.a
librtc_xmllite.a \
librtc_xmpp.a \
librtc_base.a \
librtc_base_approved.a \
librtc_p2p.a \
libvideo_capture_module.a \
libvideo_capture_module_internal_impl.a \
libvideo_render_module.a \
libvideo_render_module_internal_impl.a \
libjingle_p2p.a \
libsrtp.a"

DEVICE_SPEC_LIBS="libyuv_neon.a libaudio_processing_neon.a"

ARMV7_SPECIFIC_LIBS="libcommon_audio_neon.a libisac_neon.a"

LIBS_DEVICE=`echo $LIBS_GENERIC $DEVICE_SPEC_LIBS`
LIBS_SIMULATOR=$LIBS_GENERIC


# Just a comment out of debug
if [ 1 -eq 0 ]; then
echo "---- generic libraries"
echo $LIBS_GENERIC
echo "----------------------"
echo "---- device specific libraries"
echo $DEVICE_SPEC_LIBS
echo "----------------------"
echo "---- device libraries"
echo $LIBS_DEVICE
echo "----------------------"
echo "---- simulator libraries"
echo $LIBS_SIMULATOR
echo "----------------------"
exit 0
fi # comment out END


function build_debug_sim64()
{
	echo "-- building AppRTCDemo for x86_64 sim Debug"
	export GYP_CROSSCOMPILE=1
	export GYP_DEFINES="OS=ios target_arch=x64 target_subarch=arm64"
	export GYP_GENERATOR_FLAGS="$GYP_GENERATOR_FLAGS output_dir=out_sim64"
	export GYP_GENERATORS="ninja"

	pushd src

	webrtc/build/gyp_webrtc
	ninja -C out_sim64/Debug-iphonesimulator AppRTCDemo
	popd

	echo "-- combining debug libraries for sim64"
	pushd src/out_sim64/Debug-iphonesimulator/
	rm -f libWebRTC-debug-sim64.a
	libtool -static -o libWebRTC-debug-sim64.a $LIBS_SIMULATOR
	popd
}


function build_release_sim64()
{
	echo "-- building AppRTCDemo for x86_64 sim Release"
	export GYP_CROSSCOMPILE=1
	export GYP_DEFINES="OS=ios target_arch=x64 target_subarch=arm64"
	export GYP_GENERATOR_FLAGS="$GYP_GENERATOR_FLAGS output_dir=out_sim64"
	export GYP_GENERATORS="ninja"

	pushd src

	webrtc/build/gyp_webrtc
	ninja -C out_sim64/Release-iphonesimulator AppRTCDemo
	popd

	echo "-- combining release libraries for sim64"
	pushd src/out_sim64/Release-iphonesimulator/
	rm -f libWebRTC-release-sim64.a libWebRTC-release-sim64-stripped.a
	libtool -static -o libWebRTC-release-sim64.a $LIBS_SIMULATOR
	strip -S -x -o libWebRTC-release-sim64-stripped.a -r libWebRTC-release-sim64.a
	popd
}


function build_debug_sim()
{
	echo "-- building AppRTCDemo for ia32 sim Debug"
	export GYP_CROSSCOMPILE=1
	export GYP_DEFINES="OS=ios target_arch=ia32"
	export GYP_GENERATOR_FLAGS="$GYP_GENERATOR_FLAGS output_dir=out_sim"
	export GYP_GENERATORS="ninja"

	pushd src

	webrtc/build/gyp_webrtc
	ninja -C out_sim/Debug-iphonesimulator AppRTCDemo
	popd

	echo "-- combining debug libraries for sim"
	pushd src/out_sim/Debug-iphonesimulator/
	rm -f libWebRTC-debug-sim.a
	libtool -static -o libWebRTC-debug-sim.a $LIBS_SIMULATOR
	popd
}


function build_release_sim()
{
	echo "-- building AppRTCDemo for ia32 sim Release"
	export GYP_CROSSCOMPILE=1
	export GYP_DEFINES="OS=ios target_arch=ia32"
	export GYP_GENERATOR_FLAGS="$GYP_GENERATOR_FLAGS output_dir=out_sim"
	export GYP_GENERATORS="ninja"

	pushd src

	webrtc/build/gyp_webrtc
	ninja -C out_sim/Release-iphonesimulator AppRTCDemo
	popd

	echo "-- combining release libraries for sim"
	pushd src/out_sim/Release-iphonesimulator/
	rm -f libWebRTC-release-sim.a libWebRTC-release-sim-stripped.a
	libtool -static -o libWebRTC-release-sim.a $LIBS_SIMULATOR
	strip -S -x -o libWebRTC-release-sim-stripped.a -r libWebRTC-release-sim.a
	popd
}


function build_debug_armv7()
{
	echo "-- building AppRTCDemo for armv7 Debug"
	export GYP_CROSSCOMPILE=1
	export GYP_DEFINES="OS=ios target_arch=arm arm_version=7"
	export GYP_GENERATOR_FLAGS="$GYP_GENERATOR_FLAGS output_dir=out_ios"
	export GYP_GENERATORS="ninja"

	pushd src

	webrtc/build/gyp_webrtc
	ninja -C out_ios/Debug-iphoneos AppRTCDemo
	popd

	echo "-- combining debug libraries for armv7"
	pushd src/out_ios/Debug-iphoneos/
	rm -f libWebRTC-debug-armv7.a
	libtool -static -o libWebRTC-debug-armv7.a $LIBS_DEVICE $ARMV7_SPECIFIC_LIBS
	popd
}


function build_release_armv7()
{
	echo "-- building AppRTCDemo for armv7 Release"
	export GYP_CROSSCOMPILE=1
	export GYP_DEFINES="OS=ios target_arch=arm arm_version=7"
	export GYP_GENERATOR_FLAGS="$GYP_GENERATOR_FLAGS output_dir=out_ios"
	export GYP_GENERATORS="ninja"

	pushd src

	webrtc/build/gyp_webrtc
	ninja -C out_ios/Release-iphoneos AppRTCDemo
	popd

	echo "-- combining release libraries for armv7"
	pushd src/out_ios/Release-iphoneos/
	rm -f libWebRTC-release-armv7.a libWebRTC-release-armv7-stripped.a
	libtool -static -o libWebRTC-release-armv7.a $LIBS_DEVICE $ARMV7_SPECIFIC_LIBS
	strip -S -x -o libWebRTC-release-armv7-stripped.a -r libWebRTC-release-armv7.a
	popd
}


function build_debug_arm64()
{
	echo "-- building AppRTCDemo for arm64 Debug"
	export GYP_CROSSCOMPILE=1
	export GYP_DEFINES="OS=ios target_arch=arm64 target_subarch=arm64"
	export GYP_GENERATOR_FLAGS="$GYP_GENERATOR_FLAGS output_dir=out_ios64"
	export GYP_GENERATORS="ninja"

	pushd src

	webrtc/build/gyp_webrtc
	ninja -C out_ios64/Debug-iphoneos AppRTCDemo
	popd

	echo "-- combining debug libraries for arm64"
	pushd src/out_ios64/Debug-iphoneos/
	rm -f libWebRTC-debug-arm64.a
	libtool -static -o libWebRTC-debug-arm64.a $LIBS_DEVICE
	popd
}


function build_release_arm64()
{
	echo "-- building AppRTCDemo for arm64 Release"
	export GYP_CROSSCOMPILE=1
	export GYP_DEFINES="OS=ios target_arch=arm64 target_subarch=arm64"
	export GYP_GENERATOR_FLAGS="$GYP_GENERATOR_FLAGS output_dir=out_ios64"
	export GYP_GENERATORS="ninja"

	pushd src

	webrtc/build/gyp_webrtc
	ninja -C out_ios64/Release-iphoneos AppRTCDemo
	popd

	echo "-- combining release libraries for arm64"
	pushd src/out_ios64/Release-iphoneos/
	rm -f libWebRTC-release-arm64.a libWebRTC-release-arm64-stripped.a
	libtool -static -o libWebRTC-release-arm64.a $LIBS_DEVICE
	strip -S -x -o libWebRTC-release-arm64-stripped.a -r libWebRTC-release-arm64.a
	popd
}


# -------------- build with simulator -----------------
function combine_webrtc_fat_debug()
{
	echo "-- creating fat debug library"
	mkdir -p built-libs
	lipo -create src/out_ios64/Debug-iphoneos/libWebRTC-debug-arm64.a \
	 			 src/out_ios/Debug-iphoneos/libWebRTC-debug-armv7.a \
	 			 src/out_sim/Debug-iphonesimulator/libWebRTC-debug-sim.a \
	 			 src/out_sim64/Debug-iphonesimulator/libWebRTC-debug-sim64.a \
	 	 -output built-libs/libWebRTC-fat-debug.a

  	echo "-- created fat library libWebRTC-fat-debug.a in built-libs"
}


function build_webrtc_fat_debug()
{
	echo "-- building webrtc fat Debug"
	build_debug_arm64
	build_debug_armv7
	build_debug_sim
	build_debug_sim64

	combine_webrtc_fat_debug
}


function combine_webrtc_fat_release()
{
	echo "-- creating fat library"
	mkdir -p built-libs
	lipo -create src/out_ios64/Release-iphoneos/libWebRTC-release-arm64-stripped.a \
				 src/out_ios/Release-iphoneos/libWebRTC-release-armv7-stripped.a \
				 src/out_sim/Release-iphonesimulator/libWebRTC-release-sim-stripped.a \
				 src/out_sim64/Release-iphonesimulator/libWebRTC-release-sim64-stripped.a \
		 -output built-libs/libWebRTC-fat-release.a

  	echo "-- created fat library libWebRTC-fat-release.a in built-libs"
}


function build_webrtc_fat_release()
{
	echo "-- building webrtc fat Debug"
	build_release_arm64
	build_release_armv7
	build_release_sim
	build_release_sim64

	combine_webrtc_fat_release
}
# -------------- build with simulator END-----------------


# -------------- build without simulator -----------------
function combine_webrtc_fat_debug_nosim()
{
	echo "-- creating fat debug library without simulator"
	mkdir -p built-libs
	lipo -create src/out_ios64/Debug-iphoneos/libWebRTC-debug-arm64.a \
	 			 src/out_ios/Debug-iphoneos/libWebRTC-debug-armv7.a \
	 	 -output built-libs/libWebRTC-fat-debug.a

  	echo "-- created fat library libWebRTC-fat-debug.a in built-libs"
}


function build_webrtc_fat_debug_nosim()
{
	echo "-- building webrtc fat Debug without simulator"
	build_debug_arm64
	build_debug_armv7

	combine_webrtc_fat_debug_nosim
}


function combine_webrtc_fat_release_nosim()
{
	echo "-- creating fat library without simulator"
	mkdir -p built-libs
	lipo -create src/out_ios64/Release-iphoneos/libWebRTC-release-arm64-stripped.a \
				 src/out_ios/Release-iphoneos/libWebRTC-release-armv7-stripped.a \
		 -output built-libs/libWebRTC-fat-release.a

  	echo "-- created fat library libWebRTC-fat-release.a in built-libs"
}


function build_webrtc_fat_release_nosim()
{
	echo "-- building webrtc fat Release without simulator"
	build_release_arm64
	build_release_armv7

	combine_webrtc_fat_release_nosim
}
# -------------- build without simulator  END-----------------

function build_fatty() {
  build_webrtc_fat_debug && build_webrtc_fat_release
}


function build_fatty_nosim() {
  build_webrtc_fat_debug_nosim && build_webrtc_fat_release_nosim
}


# If no parameters were given run build_fatty
# Otherwise run the function specified by the first parameter on the command line
if [ $# -eq 0 ] ; then
    echo "No arguments supplied. Running build_fatty_nosim, which builds all (fat libs for debug and release)."
    build_fatty_nosim
else
	$@
fi




