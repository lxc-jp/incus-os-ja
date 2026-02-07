# カーネル

IncusOSではカーネルレベルの設定を調節するための限られた設定のノブを公開しています。変更が完全に発行するためにはシステムの再起動が必要かもしれません。

## 設定オプション

設定フィールドは[`SystemKernelConfig`構造体](https://github.com/lxc/incus-os/blob/main/incus-osd/api/system_kernel.go)で定義されます。

以下の設定オプションが設定できます：

* `blacklist_modules`: ブラックリストする1つ以上のカーネルモジュールのリスト。通常PCIデバイスを通過して仮想マシンに渡す際に有用です。

* `network`: システムのネットワーク設定に影響を与えるために`sysctl`の値を変更します
   * `buffer_size`: オプショナル。`net.ipv4.tcp_rmem`、`net.ipv4.tcp_wmem`、`net.core.rmem_max`、`net.core.wmem_max`の`sysctl`フィールドを設定する際に使うバッファーの最大サイズを設定します。

   * `queuing_discipline`: オプショナル。`net.core.default_qdisc` `sysctl`フィールドの値を設定します。

   * `tcp_congestion_algorithm`: オプショナル。システムで使われるTCPの輻輳制御のアルゴリズムを設定します。デフォルトは`bbr`です。

* `pci`: PCIデバイス設定を変更します。
   * `passthrough`: 仮想マシンにパススルーする1つ以上のPCIデバイスを設定します：
      * `vendor_id`: PCIベンダーID
      * `product_id`: PCIプロダクトID
      * `pci_address`: オプショナル。指定すると、指定したPCIデバイスを既存のドライバーからバインド解除し、再起動することなしに仮想マシンにパススルーするように設定します。
