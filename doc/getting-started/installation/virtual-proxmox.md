# Proxmoxの仮想マシン内にインストール

IncusOSはProxmoxの仮想マシン内に簡単にインストールできます。

## インストールメディアの取得とインポート

[IncusOSイメージの取得](../download.md)の手順に従ってください。このドキュメントではISOイメージを使うことを前提とします。

ダウンロードが完了したら、ISOイメージをProxmoxのストレージにアップロードします。

![Proxmox ISO image import](../../images/proxmox-import-iso.png)

## 仮想マシンを作成する

仮想マシンを作成してISOイメージを追加します。

![Proxmox VMでISOを設定](../../images/proxmox-vm-configure-iso.png)

### セキュアブートとTPMの設定

IncusOSではセキュアブートとv2.0のTPMが必要です。仮想マシンを設定する際は、以下のように設定してください：

* BIOSは"OVMF (UEFI)"に設定します

* "Pre-Enroll keys"のチェックを外します。
   * これによりIncusOSのインストーラーがセキュアブートの必要な鍵を自動で登録できるようになります。

* "Add TPM"にチェックをつけてバージョンを"v2.0"に設定します。

![Proxmox VMでセキュアブートとTPMを設定](../../images/proxmox-vm-configure-secure-boot-tpm.png)

### CPU、メモリー、ネットワーク、ローカルストレージ

仮想マシンのCPUとメモリをお好みに合わせて設定し、少なくとも1つのネットワークインターフェースを追加します。

メインのシステムドライブは50GiB以上にすることを忘れないでください。

## IncusOSのインストール

仮想マシンを起動すると、IncusOSがインストールを開始します。

![Proxmox VMにIncusOSをインストール](../../images/proxmox-vm-install.png)

インストールが完了したら、仮想マシンを停止しCDROMデバイスを取り外します。

![Proxmox VMにインストール完了](../../images/proxmox-vm-install-complete.png)

## IncusOSを使い始めます

仮想マシンを起動すると、IncusOSが初回ブート時の設定を実行します。完了したら、[システムにアクセス](../access.md)の手順に従ってください。

![Proxmox VMIncusOSを実行](../../images/proxmox-vm-incusos-running.png)
