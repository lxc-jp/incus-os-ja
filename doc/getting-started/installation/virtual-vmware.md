# VMwareの仮想マシン内にインストール

vSphereを使っている場合IncusOSはVMwareの仮想マシン内に簡単にインストールできます。

```{note}
IncusOSは仮想TPMデバイスの使用が必要です。このためvSphereの利用が必要でスタンドアロンのESXiでは要件を満たせません。
```

## キープロバイダーを設定

VMwareで仮想TPMデバイスを使えるようにするには、vSphereに適切なキープロバイダーを作る必要があります。

![キープロバイダーのリスト](../../images/vsphere-tpm-list.png)

キープロバイダーがない場合は、新たにネイティブのキープロバイダーを作成します。

![キープロバイダーの作成](../../images/vsphere-tpm-create.png)

次にそれをバックアップして初期化を完了します。

![キープロバイダーのバックアップ](../../images/vsphere-tpm-backup.png)

キープロバイダーを作成したことで仮想マシンにTPMデバイスをアタッチできるようになります。

![キープロバイダーが準備完了](../../images/vsphere-tpm-ready.png)

## ネットワークの設定

IncusOSはネストしたコンテナーと仮想マシンを動かす必要があるため、仮想マシンが内側のブリッジを使えるようにするためにVMwareのネットワークセキュリティーポリシーをかなり緩める必要があります。

![ネットワーク設定](../../images/vsphere-network.png)

## インストールメディアの取得とインポート

[IncusOSイメージの取得](../download.md)の手順に従ってください。このドキュメントではISOイメージを使うことを前提とします。

ダウンロードが完了したら、VMwareのデータストアーにISOイメージをアップロードします。

![VMwareのデータストアーにISOをアップロード](../../images/vsphere-upload-vm.png)

## 仮想マシンを作成する

名前と場所を選びます。

![VMの名前と場所を設定](../../images/vsphere-create-vm1.png)

仮想マシンを稼働させるサーバーを選択します。

![サーバーを設定](../../images/vsphere-create-vm2.png)

ルートディスクのデータストアーを選択します。

![データストアーを選択](../../images/vsphere-create-vm3.png)

互換性レベルを選択します（デフォルトでOK）。

![互換性レベルを選択](../../images/vsphere-create-vm4.png)

`Linux`を選択しオペレーティングシステムは`Other 6.x or later Linux (64-bit)`にします。

![オペレーティングシステムを選択](../../images/vsphere-create-vm5.png)

仮想マシンのハードウェアーをカスタマイズします。推奨する変更は以下のとおりです：

- 少なくとも4つのCPUと4GiBのRAM
- NVMeコントローラーを追加
- ルートディスクのサイズを50GiBに設定してNVMeコントローラーにアタッチ
- SCSIコントローラーをデタッチ（使われないため）
- TPMモジュールをアタッチ
- アップロード済みのISOイメージをCDROMデバイスにアタッチし、起動時に接続されるように設定

![仮想マシンをカスタマイズ](../../images/vsphere-create-vm6.png)

オプションタブの`Boot Options`で`Secure Boot`を忘れずに有効にしてください。

![セキュアブートを有効化](../../images/vsphere-create-vm7.png)

追加オプションのタブで、以下のエントリーを追加します：

- `uefi.secureBoot.kekDefault.file0`を`secureboot-KEK-R1.der`に設定
- `uefi.secureBoot.dbDefault.file0`を`secureboot-2025-R1.der`に設定
- `uefi.secureBoot.dbDefault.file1`を`secureboot-2026-R1.der`に設定

そして仮想マシンの作成を完了します。

```{note}
この時点では仮想マシンを起動しないでください。セキュアブートの設定が異常になってしまいます。
```

## セキュアブートの鍵をアップロード
データベースビューを開いて仮想マシンのフォルダーを開きます。

[`https://images.linuxcontainers.org/os/keys/`](https://images.linuxcontainers.org/os/keys/)を開いて以下の鍵をダウンロードします：

- `secureboot-KEK-R1.der`
- `secureboot-2025-R1.der`
- `secureboot-2026-R1.der`

ダウンロード出来たら、これらのファイルを仮想マシンのフォルダーにアップロードします。

![セキュアブートの鍵をアップロード](../../images/vsphere-upload-keys.png)

## IncusOSのインストール

仮想マシンを起動すると、IncusOSがインストールを開始します。

```{note}
VMwareは起動時にカーネルイメージのハッシュ値を算出するのに非常に長い時間がかかります。
このため約3分間は真っ黒な画面になりますが、その後ブートローダーのメッセージが表示されます。
```

![インストール](../../images/vsphere-install.png)

インストールが完了したら、仮想マシンを停止し設定を編集してCDROMデバイスを切断します。

![ISOをデタッチ](../../images/vsphere-detach-iso.png)

## IncusOSを使い始めます

仮想マシンを起動すると、IncusOSが初回ブート時の設定を実行します。完了したら、[システムにアクセス](../access.md)の手順に従ってください。

![インストールされたシステム](../../images/vsphere-installed.png)
