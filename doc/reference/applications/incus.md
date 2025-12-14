# Incus

Incusアプリケーションは[Zabbly安定板チャンネル](https://github.com/zabbly/incus)からのIncusの機能リリースの最新版を含みます。コンテナー、OCIイメージ、仮想マシンを稼働させるのに必要なすべてを含んでいます。

少なくとも1つのクライアント証明書をIncusのプリシードに渡す必要があります。これがないとAPIエンドポイントやインストールの後処理用のウェブUIにアクセスする際に認証ができません。

## デフォルト設定

Incusのシードの`apply_defaults`フィールドが`true`の場合、Incusアプリケーションは以下の初期化ステップを実行します：

* ZFSを使ったデフォルトの"local"ストレージプールをIncusで使うために作成します。このストレージプールはメインシステムドライブの空きスペースの残りすべてを使います。

* ローカルネットワークブリッジ`incusbr0`を作成します。

* シードで指定された信頼されたクライアント証明書を設定します。

* すべてのネットワークインターフェース上で8443番ポートでリッスンします。

## インストールシードの詳細

主なシードフィールドは以下のものがあります：

* `apply_defaults`: `true`に設定すると、Incusを設定する際に妥当なデフォルト値を適用します。

* `preseed`: Incusの`InitPreseed`設定オプションを参照する構造体。詳細はIncusの[API](https://github.com/lxc/incus/blob/main/shared/api/init.go)を参照してください。

## 追加の機能

メインのIncusアプリケーションを拡張する追加のアプリケーションが2つあります：

* `incus-ceph`: [Ceph](../services/ceph.md)クライアントサポートを追加
* `incus-linstor`: [Linstor](../services/linstor.md)のサテライトサポートを追加
