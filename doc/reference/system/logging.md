# ロギング

IncusOSはリモートのsyslogサーバーにログ出力するように設定できます。

## 設定オプション

設定フィールドは[`SystemLoggingSyslog`構造体](https://github.com/lxc/incus-os/blob/main/incus-osd/api/system_logging.go)で定義されています。

以下の設定オプションが設定できます：
\
* `address`: リモートのsyslogサーバーのIPアドレス。

* `protocol`: リモートのsyslogサーバーに接続する際に使用するプロトコル。

* `log_format`: 使用するログエントリーの形式。
