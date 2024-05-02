{ lib
, pkgs
, stdenv
, fetchFromGitHub
, pcre2
, sqlite
, ncurses
, readline
, zlib
, bzip2
, autoconf
, automake
, curl
, buildPackages
, tzdata
}:

stdenv.mkDerivation rec {
  pname = "lnav";
  version = "0.12.2";

  src = fetchFromGitHub {
    owner = "tstack";
    repo = "lnav";
    rev = "v${version}";
    sha256 = "sha256-grEW3J50osKJzulNQFN7Gir5+wk1qFPc/YaT+EZMAqs=";
  };

  patches = [
  (pkgs.writeText "tzdatadir.patch" ''
--- a/src/third-party/date/src/tz.cpp	(revision f521c7fedace3f41635cedd822fa1c98f20065f7)
+++ b/src/third-party/date/src/tz.cpp	(date 1714663056765)
@@ -350,7 +350,7 @@
     struct stat sb;
     using namespace std;
 #  ifndef __APPLE__
-    CONSTDATA auto tz_dir_default = "/usr/share/zoneinfo";
+    CONSTDATA auto tz_dir_default = "${tzdata}/share/zoneinfo";
     CONSTDATA auto tz_dir_buildroot = "/usr/share/zoneinfo/uclibc";

     // Check special path which is valid for buildroot with uclibc builds

  '')
  ];

  postPatch = ''
    substituteInPlace Makefile.am \
      --replace "SUBDIRS = tools src test" "SUBDIRS = tools src"
  '';

  enableParallelBuilding = true;

  strictDeps = true;
  depsBuildBuild = [ buildPackages.stdenv.cc ];
  nativeBuildInputs = [
    autoconf
    automake
    zlib
    curl.dev
  ];
  buildInputs = [
    bzip2
    ncurses
    pcre2
    readline
    sqlite
    curl
    tzdata
  ];

  preConfigure = ''
    ./autogen.sh
  '';

  meta = with lib; {
    homepage = "https://github.com/tstack/lnav";
    description = "The Logfile Navigator";
    longDescription = ''
      The log file navigator, lnav, is an enhanced log file viewer that takes
      advantage of any semantic information that can be gleaned from the files
      being viewed, such as timestamps and log levels. Using this extra
      semantic information, lnav can do things like interleaving messages from
      different files, generate histograms of messages over time, and providing
      hotkeys for navigating through the file. It is hoped that these features
      will allow the user to quickly and efficiently zero in on problems.
    '';
    downloadPage = "https://github.com/tstack/lnav/releases";
    license = licenses.bsd2;
    maintainers = with maintainers; [ dochang ];
    platforms = platforms.unix;
    mainProgram = "lnav";
  };

}
