# マルチパス

マルチパスサービスはマルチパスストレージデバイスを設定できるようにします。

## 設定オプション

このサービスの完全なAPIの構造体は[オンライン](https://github.com/lxc/incus-os/blob/main/incus-osd/api/service_multipath.go)でご覧いただけます。

以下の設定オプションが設定できます：

* `enabled`: `true`の場合、Multipathサービスを有効化します。

* `wwns`: マルチパスを設定するためのストレージデバイスの{abbr}`WWN (World Wide Name)`の配列。これはコロンの区切り文字なしの小文字の16進数の文字列で、通常`3`の接頭辞がつきます。正しい形式は`incus admin os system storage show`の出力の`id`フィールドの下に、例えば`/dev/disk/by-id/scsi-<wwn>`のように表示されます。
