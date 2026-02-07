# Microsoft Hyper-V仮想マシン内にインストール

IncusOSはMicrosoft Hyper-V仮想マシン内にインストールできます。サポートされている仮想化プラットフォームの中で、正しく設定するのが断然に一番難しいのがHyper-Vです。

```{warning}
Microsoft Hyper-Vはカスタムのセキュアブートキーの登録をサポートしません。このため[セキュアブートを無効にする](../../reference/installing-without-secureboot.md)必要があり、結果としてセキュリティーが劣化した状態になります。これが意味することを完全に理解した場合にのみ以下に進んでください。
```

## インストールメディアを取得

[IncusOSイメージを取得](../download.md)する手順に従ってください。Hyper-VではUSB (IMG)インストールイメージを使う必要があります。CD-ROM (ISO)イメージは動作 _しません_。

インストールシードは`security.missing_secure_boot = true`を含む必要があります。ウェブベースのカスタマイザーUIを使う場合は、"Advanced settings"セクションでこの設定をできます。

![advancedインストールオプションでHyper-V VMを設定](../../images/hyperv-vm-download-advanced.png)

## インストールメディアを変換

Hyper-Vはrawディスクイメージをサポートしないので、USBインスールメディアをダウンロード後、Hyper-Vが使える形式にインストールイメージを変換する必要があります：

```
qemu-img convert IncusOS_202512302047.img -O vhdx -o subformat=dynamic IncusOS_202512302047.vhdx
```

## 仮想マシンを作成

仮想マシンを作成し、インストールオプションを選択する際に、"Install an operating system later"を選びます。

![Hyper-V VMの仮想マシンを設定](../../images/hyperv-vm-configure-vm.png)

仮想マシンが作成されたら、設定を開いて`.vhdx`イメージを2番目の仮想ハードディスクとして追加します。

![Hyper-V VMのインストールディスクを設定](../../images/hyperv-vm-configure-install-disk.png)

### セキュアブートとTPMの設定

IncusOSはv2.0 TPMに依存しています。上で述べたようにHyper-V仮想マシン内でIncusOSを動かすにはセキュアブートを無効にする必要があります。仮想マシンを設定する際に、"Security"セクションで以下のように選択してください：

* "Enable Secure Boot"のチェックを外す

* "Enable Trusted Platform Module"にチェックをつける

![Hyper-V VMのセキュアブートとTPMを設定](../../images/hyperv-vm-configure-secure-boot-tpm.png)

### CPU、メモリ、ネットワーク、ローカルストレージ

仮想マシンのCPUとメモリをお好みで設定し、最低1つのネットワークインターフェースを追加してください。

メインシステムドライブを50GiB以上にする必要があることを忘れないでください。

## IncusOSのインストール

仮想マシンを起動します。IncusOSが起動する際、セキュアブートが無効になっていることに対する警告が表示されます。

![Hyper-V VM起動時の警告](../../images/hyperv-vm-boot-warning.png)

インストールを開始する前に、この警告メッセージが30秒間表示されます。

![Hyper-V VMインストール時の警告](../../images/hyperv-vm-install-warning.png)

その後ようやく、IncusOSのインストールが始まります。

![Hyper-V VM内でIncusOSをインストール](../../images/hyperv-vm-install.png)

インストールが完了したら、仮想マシンを停止し、2番目のハードディスクを取り外します。

![Hyper-V VM内でインストール完了](../../images/hyperv-vm-install-complete.png)

## IncusOSを使い始めます

仮想マシンを起動すると、IncusOSは初回のブート時に設定を行います。完了したら[システムへアクセス](../access.md)の手順に従ってください。

セキュアブートが無効化されているため、システムのセキュリティが劣化している状態であることに対する警告がヘッダーに目立つように表示されます。

![Hyper-V VM内でIncusOSを稼働](../../images/hyperv-vm-incusos-running.png)
