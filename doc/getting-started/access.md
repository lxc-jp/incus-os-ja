# システムへのアクセス

```{note}
この手順はIncusOSがIncusアプリケーションとデプロイされていることを前提としています。

オペレーションセンターやマイグレーションマネージャーを使用している場合は、それぞれのコマンドラインクライアントやウェブUIを代わりに使ってください。
```

## IPアドレスの取得
IncusOSシステムにアクセスするための最初のステップとしてそのIPアドレスを取得します。
稼働中のシステムの画面の一番下を見るとIPアドレスがわかります。

![IncusOS稼働中の画面](../images/incusos-started.png)

以下のドキュメントではIncusOSシステムのIPアドレスとして`192.0.2.100`を使用します。

## IncusOSへの接続

`````{tabs}

````{group-tab} コマンドライン
インストールが完了したら、network configurationのフッターにIPアドレス一覧が表示されます。1つ選んでIncusOSをリモートのIncusサーバーとして追加してください：

    $ incus remote add IncusOS 192.0.2.100
    Certificate fingerprint: 80d569e9244a421f3a3d60d46631eb717f8a0a480f2f23ee729a4c1c016875f7
    ok (y/n/[fingerprint])? y

    $ incus remote list
    +-----------------+------------------------------------+---------------+-------------+--------+--------+--------+
    |      NAME       |                URL                 |   PROTOCOL    |  AUTH TYPE  | PUBLIC | STATIC | GLOBAL |
    +-----------------+------------------------------------+---------------+-------------+--------+--------+--------+
    | IncusOS         | https://192.0.2.100:8443           | incus         | tls         | NO     | NO     | NO     |
    +-----------------+------------------------------------+---------------+-------------+--------+--------+--------+
    | images          | https://images.linuxcontainers.org | simplestreams | none        | YES    | NO     | NO     |
    +-----------------+------------------------------------+---------------+-------------+--------+--------+--------+
    | local (current) | unix://                            | incus         | file access | NO     | YES    | NO     |
    +-----------------+------------------------------------+---------------+-------------+--------+--------+--------+

リモートが追加されたら、ほかのIncusサーバーと同じように対話操作できます：

    $ incus launch images:debian/trixie IncusOS:trixie
    Launching trixie

    $ incus list
    +---------------+---------+------------------------+--------------------------------------------------+-----------------+-----------+
    |     NAME      |  STATE  |          IPV4          |                       IPV6                       |      TYPE       | SNAPSHOTS |
    +---------------+---------+------------------------+--------------------------------------------------+-----------------+-----------+
    | test-incus-os | RUNNING | 10.25.170.1 (incusbr0) | fd42:612d:f700:5f6e::1 (incusbr0)                | VIRTUAL-MACHINE | 0         |
    |               |         | 192.0.2.100 (enp5s0)   | fd42:3cfb:8972:3990:1266:6aff:feab:9439 (enp5s0) |                 |           |
    +---------------+---------+------------------------+--------------------------------------------------+-----------------+-----------+

    $ incus list IncusOS:
    +--------+---------+----------------------+------------------------------------------------+-----------+-----------+
    |  NAME  |  STATE  |         IPV4         |                      IPV6                      |   TYPE    | SNAPSHOTS |
    +--------+---------+----------------------+------------------------------------------------+-----------+-----------+
    | trixie | RUNNING | 10.25.170.218 (eth0) | fd42:612d:f700:5f6e:1266:6aff:fe39:d31f (eth0) | CONTAINER | 0         |
    +--------+---------+----------------------+------------------------------------------------+-----------+-----------+
````

````{group-tab} ウェブインターフェース
ウェブでアクセスできるIncus UIも使えます。

これを使うには、イメージ作成時に指定したクライアント証明書をウェブブラウザーにユーザー証明書としてインポートする必要があります。

```{tip}
ユーザー証明書を追加する正確な手順はブラウザーやオペレーティングシステムによって異なりますが、一般的にはPKCS#12証明書をウェブブラウザーの証明書ストアーにインポートする手順が含まれます。

PKCS#12証明書は以下のコマンドによりIncusクライアントの鍵／証明書ペアーを生成できます。

    openssl pkcs12 -export -inkey ~/.config/incus/client.key -in ~/.config/incus/client.crt -out ~/.config/incus/client.pfx
```

ユーザー証明書がインポートされたら、`https://192.0.2.100:8443`でUIにアクセスできます。

![稼働中のインスタンスがあるIncus UI](../images/incus-webui-instances.png)
````

`````

## 暗号リカバリーキーの取得

IncusOSは暗号リカバリーキーをまだ取得していない場合警告を表示します。
以下のコマンドで暗号リカバリーキーを取得できます。キーはどこか安全な場所に保管するようにしてください！

```{note}
この手順は現時点ではコマンドラインクライアントでのみ実行できます。
```

```
$ incus admin os system security show
WARNING: The IncusOS API and configuration is subject to change

config:
  encryption_recovery_keys:
  - fkrjjenn-tbtjbjgh-jtvvchjr-ctienevu-crknfkvi-vjlvblhl-kbneribu-htjtldch
state:
  encrypted_volumes:
  - state: unlocked (TPM)
    volume: root
  - state: unlocked (TPM)
    volume: swap
  encryption_recovery_keys_retrieved: true
  pool_recovery_keys:
    local: F7zrtdHEaivKqofZbVFs2EeANyK77DbLi6Z8sqYVhr0=
  secure_boot_certificates:
  - fingerprint: 26dce4dbb3de2d72bd16ae91a85cfeda84535317d3ee77e0d4b2d65e714cf111
    issuer: CN=Incus OS - Secure Boot E1,O=Linux Containers
    subject: CN=Incus OS - Secure Boot PK R1,O=Linux Containers
    type: PK
  - fingerprint: 9a42866f496834bde7e1b26a862b1e1b6dea7b78b91a948aecfc4e6ef79ea6c1
    issuer: CN=Incus OS - Secure Boot E1,O=Linux Containers
    subject: CN=Incus OS - Secure Boot KEK R1,O=Linux Containers
    type: KEK
  - fingerprint: 21b6f423cf80fe6c436dfea0683460312f276debe2a14285bfdc22da2d00fc20
    issuer: CN=Incus OS - Secure Boot E1,O=Linux Containers
    subject: CN=Incus OS - Secure Boot 2025 R1,O=Linux Containers
    type: db
  - fingerprint: 2243c49fcf6f84fe670f100ecafa801389dc207536cb9ca87aa2c062ddebfde5
    issuer: CN=Incus OS - Secure Boot E1,O=Linux Containers
    subject: CN=Incus OS - Secure Boot 2026 R1,O=Linux Containers
    type: db
  secure_boot_enabled: true
  tpm_status: ok

```
