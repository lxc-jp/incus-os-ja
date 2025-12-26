# インストールシード
IncusOSはインストールのプロセスを自動化するために「インストールシード」に依存しています。

このシートは通常[イメージの取得](../getting-started/download.md)の際に自動で生成されます。

より高度な用途には、下記の情報を使ってあなた自身のシードデータを提供できます。

## 形式と配置
インストールシードは1つ以上のJSONまたはYAMLの設定ファイルからなる単なるtarアーカイブです。
tarファイルはインストールイメージの第2パーティションの先頭に直接かかれます。
実行時に、IncusOSは第2パーティションからインストールシードの読み取りを試み、そこにあるデータをインストールプロセス中に使います。

あるいは、ユーザーが提供するシードのパーティションをインストールイメージとは無関係に提供できます。
パーティションのラベルは`SEED_DATA`である必要がありUSBドライブはFATまたはISOイメージとしてフォーマットされている必要があります。
tarアーカイブを読むのとは違い、インストールのロジックはマウントされたファイルシステムからJSONあるいはYAMLの設定ファイルを直接読もうと試みます。
インストールの完了時に、マシンからシードドライブを切断するかどうかはユーザー次第です。
IncusOSは起動時にシードデータがまだ存在する場合は混乱することでしょう。
（インストールプロセスは最終インストールからデードデータのtarアーカイブを消去しますが、ユーザー提供のシードにはこれはできません。）

## シードの中身
現時点では以下の設定ファイルが認識されます：

### `install.{json,yml,yaml}`
空であってもこのファイルが存在すれば、IncusOSはインストールプロセスを発動します。

この構造体は[`api/seed/install.go`](https://github.com/lxc/incus-os/blob/main/incus-osd/api/seed/install.go)で定義されています：

- `force_install`: trueの場合、パーティションが既に存在していてもターゲットデバイスにインストオールします。警告：これはデータ消失を引き起こすかもしれません！

- `force_reboot`: trueの場合、インストール後にインストールメディアの除去を待たずに再起動します。

- `target`: オプショナルでインストールのターゲットデバイスを決定するのに使うセレクター。指定されない場合、IncusOSはインストール時に未使用のドライブが1つあることを期待します。

### `applications.{json,yml,yaml}`
このファイルはIncusOSが稼働した後にどのアプリケーションをインストールするかを指定します。

この構造体は[`api/seed/applications.go`](https://github.com/lxc/incus-os/blob/main/incus-osd/api/seed/applications.go)で定義されています：

- `applications`: インストールするアプリケーションの配列を保持します。現時点でサポートされているアプリケーションは`incus`、`migration-manager`、`operations-center`のみです。

### `incus.{json,yml,yaml}`
このファイルはIncusのプリシード情報を指定します。

この構造体は[`api/seed/incus.go`](https://github.com/lxc/incus-os/blob/main/incus-osd/api/seed/incus.go)で定義され、Incusの[`InitPreseed` API](https://github.com/lxc/incus/blob/main/shared/api/init.go)を参照しています。

- `apply_defaults`: trueの場合、Incusのインストール時にだどうなデフォルト値のセットを自動で適用します。

- `preseed`: インストール時にIncusに渡される追加のプリシード情報。

### `network.{json,yml,yaml}`
このファイルはIncusOSが起動する際に適用すべきネットワーク設定を指定します。
未指定の場合、IncusOSは各ネットワークインターフェースに自動的な{abbr}`DHCP (Dynamic Host Configuration Protocol)`／{abbr}`SLAAC (Stateless Address Configuration)`を試みます。

使用される構造体は[ネットワークAPIの構造体](https://github.com/lxc/incus-os/blob/main/incus-osd/api/system_network.go)です。

### `migration-manager.{json,yml,yaml}`
このファイルはマイグレーションマネージャーのプリシード情報を指定します。

この構造体は[`api/seed/migration_manager.go`](https://github.com/lxc/incus-os/blob/main/incus-osd/api/seed/migration_manager.go)で定義され、マイグレーションマネージャーの[`system` API](https://github.com/FuturFusion/migration-manager/blob/main/shared/api/system.go)を参照しています。

### `operations-center.{json,yml,yaml}`
このファイルはオペレーションセンターのプリシード情報を指定します。

この構造体は[`api/seed/operations_center.go`](https://github.com/lxc/incus-os/blob/main/incus-osd/api/seed/operations_center.go)で定義され、オペレーションセンターの[`system` API](https://github.com/FuturFusion/operations-center/blob/main/shared/api/system.go)を参照しています。

### `provider.{json,yml,yaml}`
このファイルはプロバイダーを設定するためのプリシード情報を指定します。これはIncusOSの更新とアプリケーションを取得するのに使われます。

使用される構造体は[provider APIの構造体](https://github.com/lxc/incus-os/blob/main/incus-osd/api/system_provider.go)です。
