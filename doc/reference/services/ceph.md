# Ceph

[Ceph](https://ceph.io/)サービスはCephストレージクラスターに接続できるようにします。このサービスを有効にするには、Incusに加えて`incus-ceph`アプリケーションのインストールが必要です。

## 設定オプション

このサービスの完全なAPIの構造体は[オンライン](https://github.com/lxc/incus-os/blob/main/incus-osd/api/service_ceph.go)でご覧いただけます。

以下の設定オプションが設定できます：

* `enabled`: `true`の場合、Cephサービスを有効化します。

* `clusters`: 接続先のCephクラスターのマップ。
