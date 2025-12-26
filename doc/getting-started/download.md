# イメージの取得
ISOとrawイメージが[Linux Containers {abbr}`CDN (Content Delivery Network)`](https://images.linuxcontainers.org/os/)で配布されています。

IncusOSは従来のインストーラーは提供しておらず、インストール中に設定の詳細とデフォルトを指定するために[インストール・シード](../reference/seed.md)に依存しています。
このインストール・シードは手動で作成することもできますし、あるいは以下に記載する2つのユーティリティーのいずれかを使って作成を自動化することももできます。

IncusOSのインストールイメージを取得するユーザーフレンドリーな方法が2つあります：

- ウェブベースのカスタマイズツール
- コマンドラインのフラッシャーツール

どちらの場合も、最初に使用する信頼済みのクライアント証明書を指定する必要があります。

クライアント証明書は以下のコマンドを実行することで取得できます。

    incus remote get-client-certificate

```{tip}
Incusのクライアントをインストール済みではない場合、GitHub上の最新の[Incus release](https://github.com/lxc/incus/releases/latest/)からLinux、MacOS、Windowsのスタティックリンク版の実行ファイルをダウンロードできます。あなたのオペレーティングシステムとアーキテクチャーにあった`bin.<os>.incus.<arch>`のバイナリーを選んでください。
```

## IncusOSカスタマイザー

ウェブベースの[IncusOS customizer](https://incusos-customizer.linuxcontainers.org/ui/)がIncusOSのインストールイメージを取得するもっともユーザーフレンドリーな方法です。ウェブページ上でいくつかのシンプルな選択をしたら、すぐに使えるインストールイメージをダウンロードします。

## フラッシャーツール

ウェブベースのカスタマイザーがサポートするより多くのインストール・シードのカスタマイズが必要な上級ユーザーのためにフラッシャーツールを提供しています。

```{note}
現時点では、フラッシャーツールはLinuxシステム向けにのみ提供しています。
```

Goコンパイラーがインストール済みのシステムで以下のコマンドを使ってビルドできます：

    go install github.com/lxc/incus-os/incus-osd/cmd/flasher-tool@latest
    flasher-tool

実行すると、最初に使用したいイメージ形式を聞くプロンプトが表示されますので`iso`（デフォルト）あるいは`img`（raw）ディスクイメージを選んでください。ISOはハイブリッドイメージではありませんので、USBメモリーからブートしたい場合は`img`ディスクイメージ形式を選ぶ必要があることにご注意ください。

次にフラッシャーツールはLinux ContainersのCDNに接続し最新のリリースをダウンロードします。

ダウンロードしたら、インタラクティブなメニューが表示されインストールオプションをカスタマイズできます。

インストール中にIncusによって信頼される証明書を得るには、以下のようにIncusシードを提供する必要があります。証明書はあなたの証明書で置き換えてください。

```
apply_defaults: true
preseed:
    certificates:
        - name: demo
          type: client
          certificate: |
            -----BEGIN CERTIFICATE-----
            MIIB4TCCAWagAwIBAgIQVrBNb+LgEvX/aDNNOLM2iTAKBggqhkjOPQQDAzA4MRkw
            FwYDVQQKExBMaW51eCBDb250YWluZXJzMRswGQYDVQQDDBJnaWJtYXRAZnV0dXJm
            dXNpb24wHhcNMjUwNjA1MTgwODAwWhcNMzUwNjAzMTgwODAwWjA4MRkwFwYDVQQK
            ExBMaW51eCBDb250YWluZXJzMRswGQYDVQQDDBJnaWJtYXRAZnV0dXJmdXNpb24w
            djAQBgcqhkjOPQIBBgUrgQQAIgNiAAS8Tsj87gyhkR6gUoTa9dooWhwApI9MlsZS
            M9HkNdgLG+0d2yU3JXru4AbCD+pslsL5mnSjbmF7BhqSAT0opQtyFMfB7hrCJkVB
            nnebLNOqzrOVnxYqnD1HnfKo6RVmXpGjNTAzMA4GA1UdDwEB/wQEAwIFoDATBgNV
            HSUEDDAKBggrBgEFBQcDAjAMBgNVHRMBAf8EAjAAMAoGCCqGSM49BAMDA2kAMGYC
            MQC/Y4nAuV09z/zeh0aN+XV+kI9WLnITFprSHREIaES3r49cTkpoV8wFCwdLjbSb
            NwECMQCx5H/H3hyXJen3uLbqRxTzw5jjx1M4dO4fru+VmoOKmTSmKVq3r2j449iD
            GrzY7EQ=
            -----END CERTIFICATE-----
```

イメージを書き出して終了したら、そのイメージでIncusOSをインストールできます。

フラッシャーツールではさまざまなコマンドライン引数を指定できますので、スクリプト内から自動的な方法で使うこともできます。
