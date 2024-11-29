## 自用的一些盒子系统。

Armbian_22.11.0-trunk_Aml-s805_jammy_5.9.0和Armbian_24.03_Aml-s812_jammy_5.9.0为玩客云5.9内核系统。

带burn的为线刷包,默认用户: root, 默认密码: 1234。

其它为s905l3a系列系统。

均编译好了docker。


## s905l3a系列安装及升级 Armbian 的相关说明

选择和你的盒子型号对应的 Armbian 系统，不同设备的使用方法查看对应的说明。

编译时加入docker。MINIMAL=yes

- ### 安装 Armbian 到 EMMC

 `Amlogic` 和 `Allwinner` 平台，使用 [Rufus](https://rufus.ie/) 或者 [balenaEtcher](https://www.balena.io/etcher/) 等工具将系统写入 USB 里，然后把写好系统的 USB 插入盒子。登录 Armbian 系统 (默认用户: root, 默认密码: 1234) → 输入命令：

```shell
armbian-install
```

| 可选参数  | 默认值   | 选项     | 说明                |
| -------  | ------- | ------  | -----------------   |
| -m       | no      | yes/no  | 使用主线 u-boot |
| -a       | yes     | yes/no  | 使用 [ampart](https://github.com/7Ji/ampart) 分区表调整工具 |
| -l       | no      | yes/no  | 显示全部设备列表 |

举例: `armbian-install -m yes -a no`

- ### 更新 Armbian 内核

登录 Armbian 系统 → 输入命令：

```shell
# 使用 root 用户运行 (sudo -i)
# 如果不指定参数，将更新为最新版本。
armbian-update
