### [TOC]

# MacBookPro重装

* 准备：U盘（8G）

* App Store中下载macOS High Sierra

* 磁盘工具中抹除U盘中所有文件 选择（Mac OS 扩展 （日志式））

* 终端执行：

  ````
  sudo /Applications/Install\ macOS\ High\ Sierra.app/Contents/Resources/createinstallmedia --volume /Volumes/你的硬盘名 --applicationpath /Applications/Install\ macOS\ High\ Sierra.app
  ````

  出现：

  ````
  If you wish to continue type (Y) then press return: y
  Erasing Disk: 0%... 10%... 20%... 30%...100%...
  Copying installer files to disk...
  Copy complete.
  Making disk bootable...
  Copying boot files...
  Copy complete.
  Done.
  ````