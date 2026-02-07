# ネットワーク

IncusOSはインターフェース、ボンド、VLAN、WireGuardで構成される複雑なネットワーク設定をサポートします。デフォルトでは、IncusOSは見つかった各デバイスを設定し、自動的にIPv4/IPv6アドレス、DNSとNTPの情報をローカルネットワークから取得します。より複雑なネットワーク設定は[インストールシード](../seed.md)で設定するか、インストール後にネットワークAPIで設定できます。

ネットワーク設定の追加／更新を反映する前に、基本的な確認が実行されます。チェックが失敗した場合、あるいはネットワークが正常に起動しないと`systemd-networkd`に報告された場合、IncusOSシステムが誤ってオフラインになってしまう危険性を最小限にするため、変更は取り消されます。

ネットワーク設定を変更すると、短時間システムがネットワーク越しに利用できない結果になるかもしれないことにご注意ください。

```{note}
IncusOSは各インターフェースとネットワークブリッジを自動的に構成します。これによりコンテナーと仮想マシンでそのままで簡単に使えるブリッジNICが設定されます。
```

## ロール

各インターフェース、ボンド、VLAN、WireGuardは1つ以上の_ロール_を割り当てることができ、それはIncusOSがネットワークデバイスをどのように使うかを制御するために使います：

* `cluster`: デバイスを内部のクラスター通信に使う
* `instances`: デバイスをIncusのコンテナーや仮想マシンで使えるようにする
* `management`: デバイスを管理に使う
* `storage`: デバイスをネットワークにアタッチされたストレージへの接続に使う

ロールが手動で設定されていない場合、IncusOSは`cluster`と`management`のロールをすべてのインターフェースに割り当てます。
`management`のロールのみが割り当てられている場合、`cluster`ロールが同じインターフェースに自動的に割り当てられます。

## 設定オプション

インターフェース、ボンド、VLAN、WireGuardはかなり多くの設定オプションがあります。多くの設定は自己記述的で[API定義](https://github.com/lxc/incus-os/blob/main/incus-osd/api/system_network.go)で見ることができます。

注目すべき1つの機能はハードウェアーアドレス（MAC）の取り扱いです。インターフェースとボンドはハードウェアーアドレスに設定を関連付けますが、2つの方法で設定できます：

* 生のMAC: `10:66:6a:e5:6a:1c`のようにハードウェアーアドレスを直接指定する。

* インターフェース名: `enp5s0`のようにインターフェース名を指定すると、起動時にIncusOSはそのMACアドレスを取得し設定内の値を置き換えようとします。これは単一の[インストールシード](../seed.md)だけで複数の物理構成が同じサーバーにIncusOSをインストールする際に便利です。

以下の設定オプションが設定できます：

* `interfaces`: システムで設定すべき0個以上のインターフェース。

* `bonds`: システムで設定すべき0個以上のボンド。

* `vlans`: システムで設定すべき0個以上のVLAN。

* `wireguard`: システムで設定すべき0個以上のWireGuardインターフェース。

* `dns`: オプションで、システムのカスタムDNS情報を設定。

* `proxy`: オプションで、システムのプロキシーを設定。

* `time`: オプションで、システムのカスタムのNTPサーバーとタイムゾーンを設定。

### ファイアウォール

IncusOSはインターフェースに基本的な内向きのファイアウォールをサポートします。
これは`firewall_rules`にルール（アクション、送信元アドレス、プロトコル、ポート）のリストを設定することで行えます。

ユーザー提供のルールに加えて、IncusOSは基本的なルール（`icmp`、`icmpv6`、確立されたコネクション）のサブセットを常に許可します。

### 例

#### アドレス設定

2つのネットワークインターフェース、1つはIPv4もう1つはIPv6アドレスを設定します：

```yaml
config:
  interfaces:
  - name: "ip4iface"
    hwaddr: "enp5s0"
    addresses:
    - "dhcp4"

  - name: "ip6iface"
    hwaddr: "enp6s0"
    addresses:
    - "slaac"
```

ネットワークインターフェースに2つの静的なIPアドレスを設定します。静的IPアドレスを指定する際は、CIDRマスクを含める必要があります。

```yaml
config:
  interfaces:
  - name: "enp5s0"
    hwaddr: "enp5s0"

    addresses:
    - "10.234.136.100/24"
    - "fd42:3cfb:8972:3990::100/64"

    routes:
    - to: "0.0.0.0/0"
      via: "10.234.136.1"
    - to: "::/0"
      via: "fd42:3cfb:8972:3990::1"

  dns:
    nameservers:
    - "10.234.136.1"
```

#### VLAN

MTUを9000としLLDPを有効にした2つのインターフェースで構成されるアクティブ・バックアップのボンドの上にVLANをID 123で設定します：

```yaml
config:
  bonds:
  - name: "management"
    mode: "active-backup"
    mtu: 9000
    lldp: true

    members:
    - "enp5s0"
    - "enp6s0"

    roles:
    - "management"
    - "instances"

  vlans:
  - name: "uplink"
    parent: "management"
    id: 123

    addresses:
    - "dhcp4"
    - "slaac"
```

#### WireGuard

2つのピアーにWireGuardインターフェースを設定します（private_keyの指定はオプショナルで空の場合は作成されます）：

```yaml
config:
  wireguard:
  - name: "wg0"
    port: 51820
    private_key: "AE1SCwtkp8ruDYlUa9x9wsoTzEOePl3P9sMdFFa9PmI="

    addresses:
    - "10.234.234.100/24"
    - "fd42:3cfb:8972:abcd::100/64"

    routes:
    - to: "10.234.110.0/24"
      via: "10.234.234.110"

    peers:
    - allowed_ips:
      - "10.234.234.110/24"
      - "fd42:3cfb:8972:abcd::110/64"
      - "10.234.110.0/24"
      endpoint: "10.102.89.110:51820"
      public_key: "rJhRcAtHUldTAA/J+TPQPQpr6G9C2Arf5FiTVwjOYCE="

    - allowed_ips:
      - "10.234.234.120/24"
      - "fd42:3cfb:8972:abcd::120/64"
      persistent_keepalive: 30
      public_key: "qPYSgwaJe0VZb4M8smTPpd2rfKHz0X0ypq54ZY4ATVQ="
```

#### DNS、NTP、タイムゾーン

カスタムのDNS、NTP、タイムゾーンをIncusOSに設定します：

```yaml
config:
  dns:
    hostname: "server01"
    domain: "example.com"

    search_domains:
    - "example.com"
    - "example.org"

    nameservers:
    - "ns1.example.com"
    - "ns2.example.com"

  time:
    ntp_servers:
    - "ntp.example.com"

    timezone: "America/New_York"
```

#### プロキシー

IncusOSに簡単な匿名のHTTP(S)のプロキシーを設定します：

```yaml
config:
  proxy:
    servers:
      example-proxy:
        host: "proxy.example.com:8080"
        auth: "anonymous"
```

IncusOSに`*.example.com`を例外とし`*.bad-domain.hacker`は完全にブロックする認証されたHTTP(S)プロキシーを設定します：

```yaml
config:
  proxy:
    servers:
      example-proxy:
        host: "proxy.example.com:8080"
        use_tls: true
        auth: "basic"
        username: "myuser"
        password: "mypassword"

    rules:
    - destination: "*.example.com|example.com"
      target: "direct"

    - destination: "*.bad-domain.hacker|bad-domain.hacker"
      target: "none"

    - destination: "*"
      target: "example-proxy"
```

IncusOSにKerberos認証を使う認証されたHTTP(S)プロキシーを設定します：

```yaml
config:
  proxy:
    servers:
      example-proxy:
        host: "proxy.example.com:8080"
        use_tls: true
        auth: "kerberos"
        realm: "auth.example.com"
        username: "myuser"
        password: "mypassword"
```
