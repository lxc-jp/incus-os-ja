# インスタンスをホストネットワークに直接アタッチ

[Incus](../reference/applications/incus.md)をIncusOS上で動かす際、デフォルトではNATされたブリッジネットワーク`incusbr0`を使います：

```
gibmat@futurfusion:~$ incus network list
+----------+--------+---------+----------------+---------------------------+----------------------------+---------+---------+
|   NAME   |  TYPE  | MANAGED |      IPV4      |           IPV6            |        DESCRIPTION         | USED BY |  STATE  |
+----------+--------+---------+----------------+---------------------------+----------------------------+---------+---------+
| incusbr0 | bridge | YES     | 10.89.179.1/24 | fd42:e1a1:408f:710a::1/64 | Local network bridge (NAT) | 1       | CREATED |
+----------+--------+---------+----------------+---------------------------+----------------------------+---------+---------+
```

しかし、コンテナーや仮想マシンをホストネットワークに直接アタッチしたい場合もあります。これは`instances` [role](../reference/system/network.md)を適切なインターフェースあるいはボンドに割り当てることで簡単に実現できます。

まず、現在のIncusOSのネットワーク設定を取得します：

```
gibmat@futurfusion:~$ incus admin os system network show
WARNING: The IncusOS API and configuration is subject to change

config:
  interfaces:
  - addresses:
    - dhcp4
    - slaac
    hwaddr: 10:66:6a:1f:50:b7
    lldp: false
    name: enp5s0
    required_for_online: "no"
state:
  interfaces:
    enp5s0:
      addresses:
      - 10.234.136.193
      - fd42:3cfb:8972:3990:1266:6aff:fe1f:50b7
      hwaddr: 10:66:6a:1f:50:b7
      mtu: 1500
      roles:
      - management
      - cluster
      routes:
      - to: default
        via: 10.234.136.1
      speed: "-1"
      state: routable
      stats:
        rx_bytes: 60644
        rx_errors: 0
        tx_bytes: 113337
        tx_errors: 0
      type: interface
```

次に、`incus admin os system network edit`を実行してインターフェースまたはボンドを編集して適切なロールを追加します：

```
config:
  interfaces:
  - addresses:
    - dhcp4
    - slaac
    hwaddr: 10:66:6a:1f:50:b7
    lldp: false
    name: enp5s0
    required_for_online: "no"
    roles:
    - instances
```

設定の変更を反映したあと、アンマネージドのブリッジが現れます：

```
gibmat@futurfusion:~$ incus network list
+----------+--------+---------+----------------+---------------------------+----------------------------+---------+---------+
|   NAME   |  TYPE  | MANAGED |      IPV4      |           IPV6            |        DESCRIPTION         | USED BY |  STATE  |
+----------+--------+---------+----------------+---------------------------+----------------------------+---------+---------+
| enp5s0   | bridge | NO      |                |                           |                            | 0       |         |
+----------+--------+---------+----------------+---------------------------+----------------------------+---------+---------+
| incusbr0 | bridge | YES     | 10.89.179.1/24 | fd42:e1a1:408f:710a::1/64 | Local network bridge (NAT) | 1       | CREATED |
+----------+--------+---------+----------------+---------------------------+----------------------------+---------+---------+
```

このネットワークインターフェースを使ってマネージドのネットワークを作成します：

```
gibmat@futurfusion:~$ incus network create enp5s0 parent=enp5s0 --type=physical
gibmat@futurfusion:~$ incus network list
+----------+----------+---------+----------------+---------------------------+----------------------------+---------+---------+
|   NAME   |   TYPE   | MANAGED |      IPV4      |           IPV6            |        DESCRIPTION         | USED BY |  STATE  |
+----------+----------+---------+----------------+---------------------------+----------------------------+---------+---------+
| enp5s0   | physical | YES     |                |                           |                            | 0       | CREATED |
+----------+----------+---------+----------------+---------------------------+----------------------------+---------+---------+
| incusbr0 | bridge   | YES     | 10.89.179.1/24 | fd42:e1a1:408f:710a::1/64 | Local network bridge (NAT) | 1       | CREATED |
+----------+----------+---------+----------------+---------------------------+----------------------------+---------+---------+
```

これで、インスタンスをホストの物理ネットワークに直接接続するように設定できます：

```
gibmat@futurfusion:~$ incus launch images:debian/13 debian-nat
Launching debian-nat
gibmat@futurfusion:~$ incus launch images:debian/13 debian-direct --network enp5s0
Launching debian-direct
gibmat@futurfusion:~$ incus list
+---------------+---------+-----------------------+------------------------------------------------+-----------+-----------+
|     NAME      |  STATE  |         IPV4          |                      IPV6                      |   TYPE    | SNAPSHOTS |
+---------------+---------+-----------------------+------------------------------------------------+-----------+-----------+
| debian-direct | RUNNING | 10.234.136.199 (eth0) | fd42:3cfb:8972:3990:1266:6aff:fe71:14e0 (eth0) | CONTAINER | 0         |
+---------------+---------+-----------------------+------------------------------------------------+-----------+-----------+
| debian-nat    | RUNNING | 10.89.179.217 (eth0)  | fd42:e1a1:408f:710a:1266:6aff:fef6:4995 (eth0) | CONTAINER | 0         |
+---------------+---------+-----------------------+------------------------------------------------+-----------+-----------+
```

このネットワークをすべてのインスタンスのデフォルトとすることもできます：

```
gibmat@futurfusion:~$ incus profile device set default eth0 network=enp5s0
```
