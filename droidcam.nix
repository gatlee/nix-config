{ stdenv, fetchzip, pkgconfig, ffmpeg, gtk3-x11, libjpeg, libusbmuxd, alsaLib, speex }:

stdenv.mkDerivation rec {
  pname = "droidcam";
  version = "0";
  
  src = fetchzip {
    url = "https://github.com/dev47apps/droidcam/archive/refs/tags/v1.7.2.zip";
    sha256 = "0w7zkcp2sfwia62jsm2vl2g0f0zcnaj1jfp9qmcs4q1jlj9v2vl6";
  };

  sourceRoot = "source/droidcam-1.7.2";

  buildInputs = [ pkgconfig ];
  nativeBuildInputs = [ ffmpeg gtk3-x11 libusbmuxd alsaLib libjpeg speex ];

  postPatch = ''
    sed -i -e 's:/opt/libjpeg-turbo:${libjpeg.out}:' Makefile
    sed -i -e 's:$(JPEG_DIR)/lib`getconf LONG_BIT`:${libjpeg.out}/lib:' Makefile
    sed -i -e 's:libturbojpeg.a:libturbojpeg.so:' Makefile
    
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp droidcam droidcam-cli $out/bin/
  '';

  meta = with stdenv.lib; {
    description = "DroidCam Linux client";
    homepage = https://github.com/aramg/droidcam;
  };
}