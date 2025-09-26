{...}: {
  services.zapret = {
    enable = true;
    params = [
      "--filter-tcp=80 <HOSTLIST>"
      "--dpi-desync=fake,fakedsplit"
      "--dpi-desync-autottl=2"
      "--dpi-desync-fooling=ts"
      "--new"
      "--filter-tcp=443"
      "--dpi-desync=fake,multidisorder"
      "--dpi-desync-fooling=badseq"
      "--dpi-desync-split-pos=midsld"
      "--dpi-desync-fake-tls=0x00000000"
    ];
    whitelist = [
      "googleusercontent.com"
      "accounts.google.com"
      "googleadservices.com"
      "googlevideo.com"
      "gvt1.com"
      "jnn-pa.googleapis.com"
      "play.google.com"
      "wide-youtube.l.google.com"
      "youtu.be"
      "youtube-nocookie.com"
      "youtube-ui.l.google.com"
      "youtube.com"
      "youtube.googleapis.com"
      "youtubeembeddedplayer.googleapis.com"
      "youtubei.googleapis.com"
      "yt-video-upload.l.google.com"
      "yt.be"
      "ytimg.com"
      "ggpht.com"
    ];
  };
}
