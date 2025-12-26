# {abbr}`USBIP (USB over IP)`

[{abbr}`USBIP (USB over IP)`](https://usbip.sourceforge.net/)サービスはIP越しにリモートのUSBデバイスへのアクセスを提供します。

## 設定オプション

このサービスの完全なAPIの構造体は[オンライン](https://github.com/lxc/incus-os/blob/main/incus-osd/api/service_usbip.go)でご覧いただけます。

以下の設定オプションが設定できます：

* `targets`: USBIPターゲットの配列。各要素はアドレスとバスIDから構成されます。
