# {abbr}`OVN (Open Virtual Network)`

[{abbr}`OVN (Open Virtual Network)`](https://www.ovn.org/)はOVNソフトウェア定義ネットワークを設定できるようにします。

## 設定オプション

このサービスの完全なAPIの構造体は[オンライン](https://github.com/lxc/incus-os/blob/main/incus-osd/api/service_ovn.go)でご覧いただけます。

以下の設定オプションが設定できます：

* `enabled`: `true`の場合、OVNサービスを有効化します。

* `ic_chassis`: シャーシが相互接続ゲートウェイして使用されるかを示すBoolean。

* `database`: 設定のためにシステムが接続すべきOVNデータベース。

* `tls_client_certificate`: PEMエンコードされたクライアント証明書。

* `tls_client_key`: PEMエンコードされたクライアント鍵。

* `tls_ca_certificate`: PEMエンコードされたCA証明書。

* `tunnel_address`: `tunnel_protocol`で指定されたカプセル化種別を使ってこのノードに接続する際にシャーシが使うべきIPアドレス。複数のカプセル化IPがカンマ区切りリストで指定できます。

* `tunnel_protocol`: シャーシがこのノードに接続する際に使うべきカプセル化種別。複数のカプセル化種別がカンマ区切りリストで指定できます。
