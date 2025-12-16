% Include content from [../CONTRIBUTING.md](../CONTRIBUTING.md)
```{include} ../CONTRIBUTING.md
```

## ローカルでのビルド
IncusOSはローカルでビルドできます。IncusOSの新機能の開発や検証に特別に興味のあるユーザーだけがこれを行う必要があります。

現時点ではDebian 13システム上でのみIncusOSのビルドをサポートしていますが、他のDebianのリリースやUbuntuなどのDebian派生ディストリビューションでもビルドできるかもしれません。

GitHubからレポジトリをクローンした後、単に以下のコマンドを実行します：

    make

デフォルトでは、ビルドは`mkosi.output/`ディレクトリー内にrawイメージを生成します。このイメージはUSBメモリーに書くのに適しています。（仮想）CD-ROMデバイスから起動する必要がある場合、ISOイメージをビルドすることもできます：

    make build-iso

## テスト
Incus仮想マシン内でローカルでビルドしたrawイメージをテストするには、以下のコマンドを実行します：

    make test

IncusOSがインストールを完了し仮想マシンで稼働中になった後、アプリケーションをロードするには以下のコマンドを実行します：

    make test-applications

更新のプロセスをテストするには、新しいイメージをビルドし以下のコマンドで更新します：

    make
    make test-update

## デバッグ

IncusOSがIncus仮想マシン内で稼働する場合、システムのデバッグを容易にするために稼働中のシステム内に`exec`できます：

    incus exec test-incus-os bash

また仮想マシンにカスタムの`incus-osd`バイナリーを簡単にサイドロードすることもできます。
ルートディスクからの実行は許可されないので、メモリファイルシステムが必要です：

    incus exec test-incus-os -- mkdir -p /root/dev/
    incus exec test-incus-os -- mount -t tmpfs tmpfs /root/dev/

ひとたび配置されたら、新しいバイナリーをビルドできます：

    cd ./incus-osd/
    go build ./cmd/incus-osd/

そして最後にバイナリーを配置しシステムに実行させます：

    incus exec test-incus-os -- umount -l /usr/local/bin/incus-osd || true
    incus exec test-incus-os -- rm -f /root/dev/incus-osd
    incus file push ./incus-osd test-incus-os/root/dev/
    incus exec test-incus-os -- mount -o bind /root/dev/incus-osd /usr/local/bin/incus-osd
    incus exec test-incus-os -- pkill -9 incus-osd

最後の2ステップは新しいバイナリーをビルドと実行したい都度繰り返すことができます。
最初のステップはシステムが再起動するたびに毎回実行する必要があります。

デバッグする際、基本的なテキストエディター（`nano`）などのさまざまな有用なツールを含む`debug`アプリケーションをインストールするとよいでしょう。

    incus exec test-incus-os bash
    curl --unix-socket /run/incus-os/unix.socket socket/1.0/applications -X POST -d '{"name": "debug"}'
