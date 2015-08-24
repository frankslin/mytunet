# 使用 MyTunet 安全吗？ #

所有网络通信，MyTunet 与官方 TUNet 完全一致。在网络通信的数据流上， MyTunet 和官方 TUNet 的安全性等价。

保存密码登录时，MyTunet 并不保存用户的原始密码。原始密码在第一次被输入后就被立刻从内存中销毁，登录全过程中不再需要原始密码（官方 TUNet 也是如此）。当然， MyTunet 必须保留通过原始密码生成的一些信息，MyTunet 会把这些信息通过 Windows Crypt 加密系统进行加密，加密方式是与当前 Windows 用户相关联的。也就是说，只有当前的 Windows 用户才可获得这些敏感信息，并可保证这些信息不被恶意窃取。

# MyTunet for Windows 的状态图标具体是什么含义？ #

  * 灰色的花朵 : 无可用状态信息。这时候 MyTunet 处于空闲状态。
  * 红色的“8”: 当前正在进行与 802.1x 端口认证有关的操作。
  * 紫色的花朵 : 当前正在进行与 打开校园连网权限 有关的操作。
  * 绿色的花朵 : 当前正在进行与 打开国内（受限）连网权限有关的操作。
  * 黄色的花朵 : 当前正在进行与 打开国际（无限制）连网权限有关的操作。
  * 如果图标稳定显示（无闪烁），表示已经完成了这个操作。
  * 如果图标在闪烁，则表示这个操作正在进行中。

# 如何使用多帐户快速切换功能？ #

首先介绍 MyTunet 中关于帐户的的几个概念：
  * 登录信息：用户登录所需要的用户名/密码等各种资料
  * 用户帐户：一个帐户保存着一个套登录信息。包括用户名、密码、登录方式等等。
  * 当前帐户：就是在 MyTunet 主界面里显示的一系列登录信息。

**注意：“当前帐户”并不是一个永久的帐户。每次选不同的用户帐户登录后，“当前帐户”的信息都是这个用户帐户的信息。而且，修改“当前帐户”的信息并不改变任何用户帐户信息。简单地说，“当前帐户”只是进行最后一次登录的用户帐户的一个拷贝。**

如果您想进一步弄清这个问题，只要试一试就可以了:) 现在切入正题：

  1. 添加/删除/修改 用户帐户。
    * 点“配置”按钮，进入“配置”对话窗。其中“帐户列表”就是用于管理用户帐户的。
    * 建立新帐户：在“帐户”输入框里输入帐户名（这个随便了，可以自己起名字）。然后输入“用户名”“密码”等信息，并点“保存”，这个用户帐户就建立了。
    * 删除帐户：在“帐户”下拉列表里选一个想删除的用户帐户，然后点“删除”，就这么简单。
    * 修改帐户：在“帐户”下拉列表里选一个想修改的用户帐户，然后修改所需要修改的信息，修改完后千万别忘了点“保存”哦！
  1. 快速切换帐户登录。
    * 方法一：在 Windows 任务栏托盘区（就是右边的那些图标区，用鼠标右键点 MyTunet 的图标，在“帐户列表”里选一个就可以了。
    * 方法二：在 MyTunet 主界面里也可以切换登录帐户。点“用户名”下拉框，然后可以看到一些帐户列表，选一个，则 MyTunet 会把选择的这个用户帐户的登录信息拷贝成当前帐户。然后再点登录就可以了。

两种方法有什么不同呢？如果您已经登录了，方法一不需要注销就可以直接切换，而方法二则必须先点“注销”后才能再“登录”。


# MyTunet 运行时提示“无法找到 mytunetdll.dll” ，怎么处理？ #
可能是因为驱动程序没有成功安装造成的。虽然 MyTunet 会自动尝试安装驱动程序，但在个别机器上仍可能会安装失败。可以尝试如下解决方案：
  1. 下载最新的 MyTunet 并解压缩到新的目录（不要覆盖原来的，否则容易出现问题）
  1. 如果仍然有问题，请到 http://www.mytunet.com 下载 WinPCap 的驱动程序并安装 （注：这个文件的一个较旧版本在官方 TUNet\drivers 目录中也存在，理论上，安装后应该解决所有问题）
  1. 如果还有问题，可以手动删除以前安装的驱动程序（下述位置），再安装 WinPCap 的驱动程序，或者运行 MyTunet 以自动安装驱动程序。
```
%windir%\system32\drivers\npf.sys
%windir%\system32\wpcap.dll
%windir%\system32\packet.dll
%windir%\system32\wanpacket.dll
```
  1. 如果仍然有问题，请联系我们。


# MyTunet 运行时提示“无法获取网卡列表” ，怎么解决？ #

很可能您正在使用 64位 AMD 处理器和 Windows XP，并不幸地遇到了 MyTunet 的 bug。请及时将错误的具体情况反馈给我们。或者，您可以简单地从 http://www.mytunet.com 下载一份 WinPCap for AMD64 的驱动程序。


# 什么是服务？如何把 MyTunet 安装为服务？ #

首先解释一下什么是\*服务**（如果您很熟悉，请跳过这一段）：**服务\*程序是一种特殊的 Windows 程序，它可以在系统刚启动的时候就被运行。也就是说，即使用户还没登录 Windows，只要开机后 Windows 正常加载，**服务\*程序就会自动运行。这类程序一般用于提供网络服务等，所以就称为“服务”（Service）了。**

MyTunet 目前支持安装为一个服务，其服务程序是 MyTunetSvc.exe，安装成功后服务名是“MyTunetSvc”。 当然，您并不需要知道它到底是如何工作的，在 MyTunet 的主界面中，您可以轻松完成对 MyTunet 服务的各种操作。

请注意，MyTunet 的普通应用模式和服务模式是不能同时启用的。如果你安装了 MyTunetSvc 服务，那么 MyTunet 的所有操作都会依靠服务来进行，而不再是在主程序里进行操作了。

并且，安装 MyTunetSvc 服务后，与普通模式会有以下不同：

  * 开机后会自动连网，而不是登录 Windows 运行 MyTunet 程序后才连网。
  * 不再支持“最低余额警告保护”功能。
  * 对登录认证的各种重试操作都不再依靠用户设置，而由服务自己决定。
  * MyTunet 主程序只起到“控制器”的作用，即只负责控制服务的运行，而不再亲自过问连网事宜。使用服务模式后，仅退出 MyTunet 主程序并不会中断当前的连网，想中断当前连网，必须点击主程序上的“注销”按钮，或停止 MyTunetSvc 服务。

安装 MyTunetSvc 服务的操作很简单，点“配置”，再点“安装 MyTunet 服务”即可。服务安装后，即可在 MyTunet 主程序中对服务进行控制。

并且，只要运行了 MyTunet 主程序，服务会把信息反馈给主程序。如果 MyTunetSvc 服务没找到正在运行的 MyTunet 主程序，它将忽略反馈信息。

**说明：除非您确实需要服务所提供的这些功能，强烈建议您不要采取服务模式来连网！**