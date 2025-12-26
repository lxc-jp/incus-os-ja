# パーティショニング手法

IncusOSは`systemd-repart`を使って初回ブート時にメインシステムドライブに自動的にパーティションを作成します。パーティションテーブルのレイアウトは以下のようになります：

    EFI ESP (2GiB)
    seed data (100MiB)
    A-side root partition signing (16kiB)
    A-side root partition hashes (100MiB)
    A-side root partition (1GiB)
    B-side root partition signing (16KiB)
    B-side root partition hashes (100Mib)
    B-side root partition (1GiB
    LUKS encrypted swap (4GiB)
    LUKS encrypted ext4 system data (25 GiB)
    ZFS encrypted pool "local" (remaining space)

## A／Bアップデート

EFI ESPパーティションは2つの異なる署名されたUKIイメージを持ち、それぞれがA-あるいはB-側のルートパーティションに対応します。OSの更新がインストールされる際、起動する際に使用していない側のUKIが更新され、対応する署名、ハッシュ、データパーティションがアトミックに更新されます。再起動時に`systemd-boot`が更新されたUKIを自動で選びます。

## シードデータパーティション

シードデータパーティションはインストールや[ファクトリーリセット](system/backup.md)に使われます。

## 暗号化されたパーティション

ユーザーデータを持つパーティションは暗号化されます。スワップとext4システムパーティションはともに暗号化され、通常の運用では起動時にTPMにより自動的にロック解除されます。何らかの理由でロック解除が失敗した場合、リカバリーキーを提供することでシステムを起動できます。

IncusOSで作成される各ZFSプールはランダムに生成された鍵で暗号化されます。これらの鍵は暗号化されたシステムパーティションに保管されます。

暗号鍵は[セキュリティーAPI](system/security.md)で取得できます。

### システムパーティション

システムパーティションはイミュータブルなIncusOSイメージに含まれないすべてのシステムデータを保持します。

### "local" ZFSプール

"local" ZFSプールはメインシステムドライブの残りのスペースすべてを使います。これはアプリケーションで使うことができ、例えば、Incusがインストールされる場合、コンテナーや仮想マシンのためのデフォルトストレージプールとして使う`local/incus`データセットを作成します。
