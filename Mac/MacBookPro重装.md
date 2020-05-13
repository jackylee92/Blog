[TOC]

# MacBookPro重装

* 准备：U盘（8G）

* App Store中下载macOS High Sierra

* 磁盘工具中抹除U盘中所有文件 选择（Mac OS 扩展 （日志式））

* 终端执行：系统版本(macOS High Sierra.app) 8G以上 U盘，普通8G不行

  ````
  sudo /Applications/Install\ {系统版本}/Contents/Resources/createinstallmedia --volume /Volumes/{U盘名称} --applicationpath /Applications/Install\{系统版本} --nointeraction
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



sudo /Applications/Install\ macOS\ High\ Sierra.app/Contents/Resources/createinstallmedia --volume /Volumes/你的硬盘名 --applicationpath /Applications/Install\ macOS\ High\ Sierra.app