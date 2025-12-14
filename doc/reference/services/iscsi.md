# iSCSI

iSCSIサービスはTCP越しにリモートのiSCSIストレージデバイスに接続できるようにします。

## 設定オプション

このサービスの完全なAPIの構造体は[オンライン](https://github.com/lxc/incus-os/blob/main/incus-osd/api/service_iscsi.go)でご覧いただけます。

以下の設定オプションが設定できます：

* `enabled`: `true`の場合、iSCSIサービスを有効化します。

* `targets`: iSCSIターゲットの配列。各要素はアドレス、ポート、iSCSIターゲットで構成されます。
