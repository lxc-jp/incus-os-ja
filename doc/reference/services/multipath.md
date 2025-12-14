# マルチパス

マルチパスサービスはマルチパスストレージデバイスを設定できるようにします。

## 設定オプション

このサービスの完全なAPIの構造体は[オンライン](https://github.com/lxc/incus-os/blob/main/incus-osd/api/service_multipath.go)でご覧いただけます。

以下の設定オプションが設定できます：

* `enabled`: `true`の場合、Multipathサービスを有効化します。

* `wwns`: マルチパスを設定するための{abbr}`WWN (World Wide Name)`の配列。
