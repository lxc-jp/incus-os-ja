# NVMe

NVMeサービスはファイバーチャネルまたはTCP越しのリモートのNVMeストレージデバイスに接続できるようにします。

## 設定オプション

このサービスの完全なAPIの構造体は[オンライン](https://github.com/lxc/incus-os/blob/main/incus-osd/api/service_nvme.go)でご覧いただけます。

以下の設定オプションが設定できます：

* `enabled`: `true`の場合、NVMeサービスを有効かします。

* `targets`: NVMeターゲットの配列。各要素はアドレス、ポート、トランスポートタイプで構成されます。
