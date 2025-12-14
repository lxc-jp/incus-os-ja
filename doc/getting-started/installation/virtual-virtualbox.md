# VirtualBoxの仮想マシン内にインストール

IncusOSはIncusの仮想マシン内にインストールできます。デフォルトのセキュアブートの鍵を適切にクリアするために一手間必要ですが、その後は通常どおりインストールできます。

## インストールメディアの取得

[IncusOSイメージの取得](../download.md)の手順に従ってください。このドキュメントではISOイメージを使うことを前提とします。

## 仮想マシンを作成する

仮想マシンを作成します。OSディストリビューションを"Debian"に設定します。

![VirtualBox VMでISOを設定](../../images/virtualbox-vm-configure-iso.png)

### セキュアブートとTPMの設定

IncusOSではセキュアブートとv2.0のTPMが必要です。仮想マシンを設定する際は、"System"セクションで以下のように設定してください（"Expert"モードが必要）：

* TPMのバージョンを2.0にします

* Featuresでは"UEFI"と"Secure Boot"にチェックをつけます

![VirtualBox VMでセキュアブートとTPMを設定](../../images/virtualbox-vm-configure-secure-boot-tpm.png)

### CPU、メモリー、ネットワーク、ローカルストレージ

仮想マシンのCPUとメモリをお好みに合わせて設定し、少なくとも1つのネットワークインターフェースを追加します。

メインのシステムドライブは50GiB以上にすることを忘れないでください。

## IncusOSのインストール

### デフォルトのセキュアブートの鍵をクリアー

初回ブート時、VirtualBoxは仮想マシンがブートに失敗というエラーを表示します。"Cancel"を押してメッセージを閉じ、仮想マシンのウィンドウにフォーカスがあることを確認してから何かキーを押すとブートマネージャーに入ります。

![VirtualBox VMの初回起動時のエラー](../../images/virtualbox-vm-first-boot-error.png)

ブートマネージャーに入ったら`Device Manager > Secure Boot Configuration`に移動し`Reset Secure Boot Keys`を選択します。リセットを確認し、`F10`を押して変更を保存し、仮想マシンを再起動します。

![VirtualBox VMでセキュアブートの鍵をクリアー](../../images/virtualbox-vm-clearing-secure-boot-keys.png)

### インストールを実行

セキュアブートの鍵をクリアーした後仮想マシンを再起動したら、IncusOSがインストールを開始します。

![VirtualBox VMでIncusOSをインストール](../../images/virtualbox-vm-install.png)

インストールが完了したら、仮想マシンを停止しCDROMデバイスを取り除きます。

![VirtualBox VMでインストール完了](../../images/virtualbox-vm-install-complete.png)

## IncusOSを使い始めます

仮想マシンを起動すると、IncusOSが初回ブート時の設定を実行します。完了したら、[システムにアクセス](../access.md)の手順に従ってください。

![VirtualBox VMでIncusOSを実行](../../images/virtualbox-vm-incusos-running.png)
