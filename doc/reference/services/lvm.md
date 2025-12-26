# LVM

LVMサービスはクラスターのLVMストレージバックエンドを設定できるようにします。

## 設定オプション

このサービスの完全なAPIの構造体は[オンライン](https://github.com/lxc/incus-os/blob/main/incus-osd/api/service_lvm.go)でご覧いただけます。

以下の設定オプションが設定できます：

* `enabled`: `true`の場合、LVMサービスを有効化します。

* `system_id`: クラスター内でユニークなホストの識別子。
