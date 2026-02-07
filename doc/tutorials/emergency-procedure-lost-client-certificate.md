# クライアント証明書の紛失に対する緊急処置

信頼されたクライアント証明書／鍵ペアーを紛失するとIncusOS APIへのアクセスができなくなります。デフォルトでは、Incusはクライアント証明書を`~/.config/incus/`に保管しており、中身は適切にバックアップされているはずです。

新しい信頼されたクライアント証明書を手動で登録することもできます。そうすればIncusOSサーバーへのアクセスを復元できます。

## 要件

* Incusサーバーの暗号化リカバリーキー、初回ブート時に自動で生成されたかあるいはAPIでカスタムで設定したもの、を持っている必要があります。このリカバリーキーがないとメインのIncusOSパーティションを復号することが不可能となり、IncusOSを再インストールするしか選択肢がありません。

* IncusOSサーバーへの物理（コンソール）アクセスができること。

* 下記の手順ではIncusOS状にIncusがインストールされており、クライアント認証を処理する責任があるアプリケーションであるということを前提としています。マイグレーションマネージャーやオペレーションセンターでのリカバリーステップは下記の手順とは異なり、このドキュメントでは扱いません。

## 手順

1. 新しいクライアント証明書／鍵ペアーを生成します。これは`incus remote get-client-certificate`で簡単にできます。新しいクライアントの機密情報を確実にバックアップしてください。🙂 証明書を後の工程で使うためUSBメモリーや他のリムーバブルメディアにコピーしてください。

1. IncusOSサーバーでセキュアブートを無効化します。証明書のクリアーはせずに、セキュアブートを無効にするだけにします。具体的な手順はメーカーごとに異なります。

1. IncusOSサーバー状でお好みのLinuxのライブイメージを起動します。`cryptsetup`コマンドが利用可能なモダンなイメージであれば大丈夫です。

1. IncusOSのルートパーティションを復号してマウントします。ここではメインシステムドライブが`/dev/sda`であることを前提とします。実際のシステムに合わせて適宜調整してください。

    ```
    cryptsetup luksOpen /dev/sda10 sda10_crypt
    mkdir -p /mnt/incusos/
    mount /dev/mapper/sda10_crypt /mnt/incusos/
    ```

1. 新しいクラインと証明書を登録するためにIncusデータベースのホットフィクスパッチを準備します。

   ```
   CERT="/path/to/new/client.crt"
   CERT_CONTENTS=$(cat $CERT)
   FINGERPRINT=$(openssl x509 -in $CERT -noout -fingerprint -sha256 | tr -d ":" | sed "s/sha256 Fingerprint=//")

   echo "INSERT INTO certificates (fingerprint, type, name, certificate) VALUES (\"$FINGERPRINT\", 1, \"new-client-cert\", \"$CERT_CONTENTS\");" > /mnt/incusos/var/lib/incus/database/patch.global.sql
   ```

1. IncusOSルートパーティションをマウント解除します。

   ```
   umount /mnt/incusos/
   cryptsetup luksClose /dev/mapper/sda10_crypt
   ```

1. IncusOSサーバーのセキュアブートを再び有効にします。

1. 再起動すると、IncusOSは正常に起動し、新しいクライアント証明書で認証できます。
