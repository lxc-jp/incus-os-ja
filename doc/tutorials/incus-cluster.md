# Incusクラスターの作成

IncusOSでIncusクラスターを設定するのは通常のLinuxシステムの場合と少し異なります。

これはほとんどのIncusクラスターの初期化と拡張は`incus admin init`で通常処理されるからです。このコマンドはIncusを稼働しているシステム上でのみ直接利用可能ですので、IncusOSの場合は使えません。

代わりにIncusOSでは、Incusサーバーをまず稼働させて、次にリモートとして追加し、最後に`incus cluster enable`と`incus cluster join`コマンドを使ってクラスターを構成します。

## 新しいクラスターの初期化
最初の工程はIncusOSでシステムを稼働させることです。

そのためには[通常のインストール手順](../getting-started/installation.md)に従ってください。その際、デフォルトのIncus設定を有効にしたイメージ（ウェブベースのイメージカスタマイザーでは`Apply default configuration`）を使ってください。

IncusOSシステムが起動したら、`incus remote add`コマンドを使ってIncusにリモートとして追加します。

ここまで来ると、以下のコマンドでクラスターを作成できます：

```
incus config set server1 cluster.https_address=10.0.0.10:8443
incus cluster enable server1: server1

incus remote add my-cluster 10.0.0.10:8443
incus remote remove server1
```

上記の手順は、すべてのクラスター内部の通信を行うIPアドレスを`10.0.0.10`に設定します。
次にクラスタリングを有効化し、初期のサーバー名を`server1`に設定します。
次にIncusのリモートを`my-cluster`という名前のクラスターに追加し、最後に古いサーバーのリモートを削除します。

## さらにサーバーを追加
追加のサーバーではデフォルトのIncus設定（ウェブベースのイメージカスタマイザーでは`Apply default configuration`）を有効に*しない*インストールイメージを使う必要があります。

これは参加するサーバーは既存のネットワークや定義済みのストレージプールを持てないので、デフォルト設定の一部としてこれら両方が作成されるので重要です。

サーバーがインストールされ`incus remote add`コマンドラインツールを使ってIncusにリモートして追加されると、以下のコマンドでクラスターに追加できます：

```
incus cluster join my-cluster: server2:
incus remote remove server2
incus cluster list my-cluster:
```

これで`server2`が`my-cluster`に参加し、次に、サーバーにある`server2`リモートを削除し、クラスター内のサーバーの概要を表示します。
