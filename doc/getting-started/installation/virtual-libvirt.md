# libvirtの仮想マシン内にインストール

IncusOSはlibvirtの仮想マシン内に簡単にインストールできます。

## インストールメディアの取得

[IncusOSイメージの取得](../download.md)の手順に従ってください。このドキュメントではISOイメージを使うことを前提とします。

## 仮想マシンを作成する

````{tabs}

```{group-tab} コマンドライン

仮想マシンを作成します。

    virt-install -n IncusOS \
        --os-variant=debian13 \
        --ram=4096 \
        --vcpus=1 \
        --disk path=/var/lib/libvirt/images/IncusOS.qcow2,bus=sata,size=50 \
        --cdrom /home/gibmat/Downloads/IncusOS_202511070055.iso \
        --tpm backend.type=emulator,backend.version=2.0,model=tpm-crb \
        --boot loader=/usr/share/OVMF/OVMF_CODE_4M.secboot.fd,loader_ro=yes,loader_type=pflash,nvram_template=/usr/share/OVMF/OVMF_VARS_4M.fd

```

```{group-tab} グラフィカルインターフェース

仮想マシンを作成します。オペレーティングシステムを"Debian 13"に設定します。

![libvirt VMでISOを設定](../../images/libvirt-ui-vm-configure-iso.png)

仮想マシンを起動する前に、追加の設定が必要です。

![libvirt VMでカスタマイズの設定](../../images/libvirt-ui-vm-configure-customize.png)

`OVMF_CODE_4M.secboot.fd` UEFIファームウェアーを選択します。

![libvirt VMでセキュアブートを設定](../../images/libvirt-ui-vm-configure-secure-boot.png)

メインの仮想ディスクのバスを`SATA`に変更します。

![libvirt VMで仮想ディスクを設定](../../images/libvirt-ui-vm-configure-virtual-disk.png)

TPMデバイスを追加します。

![libvirt VMでTPMを設定](../../images/libvirt-ui-vm-configure-tpm.png)

```

````

### セキュアブートとTPMの設定

IncusOSではセキュアブートとTPMが必要です。仮想マシンを設定する際は、以下のように設定してください：

* `OVMF_CODE_4M.secboot.fd` UEFIファームウェアーオプションを選択します

* 仮想のTPM 2.0デバイスを追加します

### CPU、メモリー、ネットワーク、ローカルストレージ

仮想マシンのCPUとメモリをお好みに合わせて設定し、少なくとも1つのネットワークインターフェースを追加します。

メインのシステムドライブは50GiB以上にすることを忘れないでください。

## IncusOSのインストール

````{tabs}

```{group-tab} コマンドライン

`virt-install`を実行すると自動で仮想マシンを起動し、インストールメディアからセキュアブートの必要な鍵をロードして再起動します。libvirtは仮想マシンの再起動後にCDROMを取り出しますが、インストールができるように再びアタッチする必要があります。

![libvirt VMでインストールメディアがない状態](../../images/libvirt-cli-vm-no-install-media.png)

CDROMイメージを再びアタッチし、インストールを開始するために仮想マシンを再起動します。

    virsh attach-disk IncusOS /home/gibmat/Downloads/IncusOS_202511070055.iso sdb --type=cdrom
    virsh reset IncusOS

![libvirt VMでIncusOSをインストール中](../../images/libvirt-cli-vm-install.png)

インストールが完了したら、CDROMデバイスをを取り除いて仮想マシンを再起動します。

    virsh change-media IncusOS sdb --eject
    virsh reset IncusOS

![libvirt VMでインストール完了](../../images/libvirt-cli-vm-install-complete.png)

```

```{group-tab} グラフィカルインターフェース

仮想マシンを起動すると、インストールメディアからセキュアブートの必要な鍵をロードして再起動します。libvirtは仮想マシンの再起動後にCDROMを取り出しますが、インストールができるように再びアタッチする必要があります。

![libvirt VMでインストールメディアがない状態](../../images/libvirt-ui-vm-no-install-media.png)

CDROMイメージを再びアタッチし、ブートデバイスの一覧にCDROMがあることを確認し、仮想マシンを再起動してインストールを開始します。

![libvirt VMでCDROMを再びアタッチ](../../images/libvirt-ui-vm-reattach-cdrom.png)

![libvirt VMのブートオーダー](../../images/libvirt-ui-vm-boot-order.png)

![libvirt VMでIncusOSをインストール中](../../images/libvirt-ui-vm-install.png)

インストールが完了したら、CDROMデバイスを取り外して仮想マシンを停止します。irtual machine.

![libvirt VMにインストール完了](../../images/libvirt-ui-vm-install-complete.png)

```

````

## IncusOSを使い始めます

````{tabs}

```{group-tab} コマンドライン

仮想マシンを起動すると、IncusOSが初回ブート時の設定を実行します。

![libvirt VMがIncusOSを実行](../../images/libvirt-cli-vm-incusos-running.png)

```

```{group-tab} グラフィカルインターフェース

仮想マシンを起動すると、IncusOSが初回ブート時の設定を実行します。

![libvirt VMがIncusOSを実行](../../images/libvirt-ui-vm-incusos-running.png)

```

````

完了したら、[システムにアクセス](../access.md)の手順に従ってください。
