# IncusOSのインストール
それがIncusサーバーを稼働させる最適な環境であるため、IncusOSはモダンな物理ハードウェアー上で稼働するように設計されています。

ですが、評価やデバッグがしやすいように、仮想マシン内部で稼働させることもサポートしています。
一般に、[ハードウェアー要件](requirements.md)に合致すればどんな物理環境あるいは仮想環境でも大丈夫です。そう断った上で、可能な限り一般的なストレージとネットワークアダプター、NVMe、VirtIOあるいはIntel仮想デバイスをお勧めします。

```{note}
仮想マシンでは、ストレージドライブは`VirtIO-scsi`ドライバーを使うように設定するのがよいです。
`VirtIO-blk`を使うとドライブが物理ドライブと違ってドライブがIncusOSに見えないため動作しません。
```

## サポートされるプラットフォーム

```{toctree}
:maxdepth: 1

ハードウェアー上でのインストール </getting-started/installation/physical>
Incus上でのインストール </getting-started/installation/virtual-incus>
libvirt上でのインストール </getting-started/installation/virtual-libvirt>
Proxmox上でのインストール </getting-started/installation/virtual-proxmox>
VirtualBox上でのインストール </getting-started/installation/virtual-virtualbox>
VMware上でのインストール </getting-started/installation/virtual-vmware>
```

## サポートされないプラットフォーム

現在のところ、MicrosoftのHyper-V上にIncusOSインストールはできません。これは仮想プラットフォームがカスタムのセキュアブートキーをサポートしないためです。
