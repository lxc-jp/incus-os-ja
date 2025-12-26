# Incusの仮想マシン内にインストール

IncusOSはIncusの仮想マシン内に簡単にインストールできます。

## インストールメディアの取得とインポート

[IncusOSイメージの取得](../download.md)の手順に従ってください。このドキュメントではISOイメージを使うことを前提とします。

ダウンロードが完了したら、ISOイメージをIncusのストレージにインポートします。

````{tabs}

```{group-tab} コマンドライン

    incus storage volume import default Downloads/IncusOS_202511050158.iso IncusOS_202511050158.iso --type=iso

```

```{group-tab} ウェブインターフェース

![Incus ISOイメージのインポート](../../images/incus-webui-import-iso.png)

```

````

## 仮想マシンを作成する

````{tabs}

```{group-tab} コマンドライン

仮想マシンを作成してISOイメージを取り付けます。

    incus init --empty --vm IncusOS \
        -c security.secureboot=false \
        -c limits.cpu=1 \
        -c limits.memory=4GiB \
        -d root,size=50GiB
    incus config device add IncusOS vtpm tpm
    incus config device add IncusOS boot-media disk pool=default source=IncusOS_202511050158.iso boot.priority=10

```

```{group-tab} ウェブインターフェース

仮想マシンを作成してISOイメージを取り付けます。

![Incus VMでISOを設定](../../images/incus-webui-vm-configure-iso.png)

`Enable secureboot (VMs only)`をfalseに設定します。名前が少し紛らわしいですが、セキュアブートの鍵なしで仮想マシンがブートするように設定し、IncusOSのインストーラーが必要なセキュアブートの鍵を自動的に登録できるようにします。

![Incus VMでセキュアブートを設定](../../images/incus-webui-vm-configure-secure-boot.png)

TPMデバイスを追加します。

![Incus VMでTPMを設定](../../images/incus-webui-vm-configure-tpm.png)

```

````

### セキュアブートとTPMの設定

IncusOSではセキュアブートとv2.0のTPMが必要です。仮想マシンを設定する際は、以下のように設定してください：

* （Microsoftの）デフォルトのセキュアブートの鍵の読み込みを無効化し、IncusOSが自身の鍵を登録できるように`security.secureboot=false`と設定します

* 仮想のTPMデバイスを追加します

### CPU、メモリー、ネットワーク、ローカルストレージ

仮想マシンのCPUとメモリをお好みに合わせて設定し、少なくとも1つのネットワークインターフェースを追加します。

メインのシステムドライブは50GiB以上にすることを忘れないでください。

## IncusOSのインストール

````{tabs}

```{group-tab} コマンドライン

仮想マシンを起動すると、IncusOSがインストールを開始します。

    incus start IncusOS

セキュアブートの鍵が登録されるまで数秒待って、仮想マシンのコンソールにアタッチします。

    incus console IncusOS --type=vga

![Incus VMにIncusOSをインストール](../../images/incus-cli-vm-install.png)

インストールが完了したら、仮想マシンを停止しCDROMデバイスを取り外します。

    incus stop IncusOS
    incus config device remove IncusOS boot-media

![Incus VMにインストール完了](../../images/incus-cli-vm-install-complete.png)

```

```{group-tab} ウェブインターフェース

仮想マシンを起動すると、IncusOSがインストールを開始します。

![Incus VMにIncusOSをインストール](../../images/incus-webui-vm-install.png)

インストールが完了したら、"Detach ISO"をクリックしてCDROMデバイスを取り外して仮想マシンを停止します。

![Incus VMにインストール完了](../../images/incus-webui-vm-install-complete.png)

```

````

## IncusOSを使い始めます

````{tabs}

```{group-tab} コマンドライン

仮想マシンを起動すると、IncusOSが初回ブート時の設定を実行します。

    incus start IncusOS --console=vga

![Incus VMがIncusOSを実行](../../images/incus-cli-vm-incusos-running.png)

```

```{group-tab} ウェブインターフェース

仮想マシンを起動すると、IncusOSが初回ブート時の設定を実行します。

![Incus VMがIncusOSを実行](../../images/incus-webui-vm-incusos-running.png)

```

````

完了したら、[システムにアクセス](../access.md)の手順に従ってください。
