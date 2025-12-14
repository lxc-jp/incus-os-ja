# Linstor

[Linstor](https://linbit.com/linstor/)サービスはLinstor環境に接続できるようにします。このサービスを有効化するには、Incusに加えて`incus-linstor`アプリケーションのインストールが必要です。

## 設定オプション

このサービスの完全なAPIの構造体は[オンライン](https://github.com/lxc/incus-os/blob/main/incus-osd/api/service_linstor.go)でご覧いただけます。

以下の設定オプションが設定できます：

* `enabled`: `true`の場合、Linstorサービスを有効化します。

* `listen_address`: リッスンするアドレスとポート（デフォルトではすべてのアドレス）。

* `tls_server_certificate`: TLS利用時に使用するサーバー証明書。

* `tls_server_key`: TLS利用時に使用するサーバー鍵。

* `tls_trusted_certificates`: TLS利用時に信頼する証明書のリスト。
