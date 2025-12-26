# プロバイダー

IncusOSは設定されたプロバイダーから[更新](update.md)を受け取ります。2つのプロバイダーがサポートされます：

* `images`: デフォルトのIncusOSプロバイダー。[Linuxコンテナーの{abbr}`CDN (Content Delivery Network)`](https://images.linuxcontainers.org/os/)から更新を取得します。

* `operations-center`: [オペレーションセンター](../applications/operations-center.md)で制御されるマネージド環境にIncusOSがデプロイされた場合、`operations-center`プロバイダーを使うように設定されます。これにより、制限された環境やインターネットアクセスを持たない物理的に隔離された環境でも、管理者がすべてのIncusOSシステムを集中管理できるようにします。

## 設定オプション

設定フィールドは[`SystemProviderConfig`構造体](https://github.com/lxc/incus-os/blob/main/incus-osd/api/system_provider.go)で定義されています。

以下の設定オプションが設定できます：

* `name`: プロバイダーの名前。`images`、`operations-center`、`local`のいずれか。`local`はIncusOSの開発者が使う想定です。

* `config`: プロバイダー固有のキーバリューペア設定のマップ。
