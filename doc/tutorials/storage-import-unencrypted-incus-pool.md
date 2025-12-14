# 暗号化されていないプールから既存のIncusのインスタンスをインポート

シナリオ：既存のサーバーでインスタンス用に設定された暗号化されていないZFSストレージプールでIncusを稼働しています。IncusOSをインストールし、IncusOSで管理されている暗号化されたストレージボリュームに既存のインスタンスをまいグレーとします。

事前条件：

* Incusで使われている暗号化されていない既存のZFSストレージプール
* 新しいZFSストレージプールを作成するための1つ以上のドライブ

## 既存のIncusの設定

このチュートリアルでは既存のZFSストレージプールは`oldpool`という名前であるとします。プールの設定については暗号化されていないということ以外は特に気にしません：

```
bash-5.2# zfs get encryption oldpool
NAME     PROPERTY    VALUE        SOURCE
oldpool  encryption  off          default
```

Incusは`incus`と呼ばれるストレージプールとしてZFSプールを設定しています：

```
gibmat@futurfusion:~$ incus storage list
+-------+--------+--------------------------------------+---------+---------+
| NAME  | DRIVER |             DESCRIPTION              | USED BY |  STATE  |
+-------+--------+--------------------------------------+---------+---------+
| incus | zfs    |                                      | 4       | CREATED |
+-------+--------+--------------------------------------+---------+---------+
| local | zfs    | Local storage pool (on system drive) | 3       | CREATED |
+-------+--------+--------------------------------------+---------+---------+
```

サーバー上には2つのインスタンスがあります：

```
gibmat@futurfusion:~$ incus list
+-------------+---------+-----------------------+--------------------------------------------------+-----------------+-----------+
|    NAME     |  STATE  |         IPV4          |                       IPV6                       |      TYPE       | SNAPSHOTS |
+-------------+---------+-----------------------+--------------------------------------------------+-----------------+-----------+
| debian13    | RUNNING | 10.79.37.82 (eth0)    | fd42:6e71:c59b:9a92:1266:6aff:fe87:2cc (eth0)    | CONTAINER       | 0         |
+-------------+---------+-----------------------+--------------------------------------------------+-----------------+-----------+
| debian13-vm | RUNNING | 10.79.37.185 (enp5s0) | fd42:6e71:c59b:9a92:1266:6aff:fe63:ab3c (enp5s0) | VIRTUAL-MACHINE | 0         |
+-------------+---------+-----------------------+--------------------------------------------------+-----------------+-----------+
```

IncusOSをインストールするためにシステムの電源を落とす前にすべてのインスタンスを確実に停止してください：

```
gibmat@futurfusion:~$ for instance in $(incus list --columns n --format compact,noheader); do incus stop $instance; done
```

## IncusOSをインストールし暗号化されたストレージボリュームを作成

サーバー上で[IncusOSをインストールする手順](../getting-started/installation.md)に従ってください。

IncusOSをインストールしたら、IncusOS APIでZFSプール`newpool`を作成します。このチュートリアルでは簡単のためプールは単一のドライブを使うものとしますが、より複雑で堅牢なプールの設定も可能です。

`oldpool`は`/dev/disk/by-id/scsi-0QEMU_QEMU_HARDDISK_incus_disk1`上に存在し`newpool`は`/dev/disk/by-id/scsi-0QEMU_QEMU_HARDDISK_incus_disk2`上に作られます。

システムの現在のストレージ設定は以下のとおりです：

```
gibmat@futurfusion:~$ incus admin os system storage show
WARNING: The IncusOS API and configuration is subject to change

config: {}
state:
  drives:
  - boot: false
    bus: scsi
    capacity_in_bytes: 5.36870912e+10
    id: /dev/disk/by-id/scsi-0QEMU_QEMU_HARDDISK_incus_disk1
    model_family: QEMU
    model_name: QEMU HARDDISK
    remote: false
    removable: false
    serial_number: incus_disk1
  - boot: false
    bus: scsi
    capacity_in_bytes: 5.36870912e+10
    id: /dev/disk/by-id/scsi-0QEMU_QEMU_HARDDISK_incus_disk2
    model_family: QEMU
    model_name: QEMU HARDDISK
    remote: false
    removable: false
    serial_number: incus_disk2
  - boot: true
    bus: scsi
    capacity_in_bytes: 5.36870912e+10
    id: /dev/disk/by-id/scsi-0QEMU_QEMU_HARDDISK_incus_root
    member_pool: local
    model_family: QEMU
    model_name: QEMU HARDDISK
    remote: false
    removable: false
    serial_number: incus_root
  pools:
  - devices:
    - /dev/disk/by-id/scsi-0QEMU_QEMU_HARDDISK_incus_root-part11
    encryption_key_status: available
    name: local
    pool_allocated_space_in_bytes: 4.288512e+06
    raw_pool_size_in_bytes: 1.7716740096e+10
    state: ONLINE
    type: zfs-raid0
    usable_pool_size_in_bytes: 1.7716740096e+10
    volumes:
    - name: incus
      quota_in_bytes: 0
      usage_in_bytes: 2.768896e+06
      use: '-'
```

`newpool`を作成します:

```
gibmat@futurfusion:~$ incus admin os system storage edit
```

```
config:
  pools:
  - name: newpool
    devices:
    - /dev/disk/by-id/scsi-0QEMU_QEMU_HARDDISK_incus_disk2
    type: zfs-raid0
```

Incusが`newpool`で使用するストレージボリュームを作成します：

```
gibmat@futurfusion:~$ incus admin os system storage create-volume -d '{"pool":"newpool","name":"incus","use":"incus"}'
```

ZFSプールとボリュームが確かに作られたことを確認します：

```
gibmat@futurfusion:~$ incus admin os system storage show
WARNING: The IncusOS API and configuration is subject to change

config: {}
state:
  drives:
  - boot: false
    bus: scsi
    capacity_in_bytes: 5.36870912e+10
    id: /dev/disk/by-id/scsi-0QEMU_QEMU_HARDDISK_incus_disk1
    model_family: QEMU
    model_name: QEMU HARDDISK
    remote: false
    removable: false
    serial_number: incus_disk1
  - boot: false
    bus: scsi
    capacity_in_bytes: 5.36870912e+10
    id: /dev/disk/by-id/scsi-0QEMU_QEMU_HARDDISK_incus_disk2
    member_pool: newpool
    model_family: QEMU
    model_name: QEMU HARDDISK
    remote: false
    removable: false
    serial_number: incus_disk2
  - boot: true
    bus: scsi
    capacity_in_bytes: 5.36870912e+10
    id: /dev/disk/by-id/scsi-0QEMU_QEMU_HARDDISK_incus_root
    member_pool: local
    model_family: QEMU
    model_name: QEMU HARDDISK
    remote: false
    removable: false
    serial_number: incus_root
  pools:
  - devices:
    - /dev/disk/by-id/scsi-0QEMU_QEMU_HARDDISK_incus_root-part11
    encryption_key_status: available
    name: local
    pool_allocated_space_in_bytes: 4.288512e+06
    raw_pool_size_in_bytes: 1.7716740096e+10
    state: ONLINE
    type: zfs-raid0
    usable_pool_size_in_bytes: 1.7716740096e+10
    volumes:
    - name: incus
      quota_in_bytes: 0
      usage_in_bytes: 2.768896e+06
      use: '-'
  - devices:
    - /dev/disk/by-id/scsi-0QEMU_QEMU_HARDDISK_incus_disk2
    encryption_key_status: available
    name: newpool
    pool_allocated_space_in_bytes: 835584
    raw_pool_size_in_bytes: 5.3150220288e+10
    state: ONLINE
    type: zfs-raid0
    usable_pool_size_in_bytes: 5.3150220288e+10
    volumes:
    - name: incus
      quota_in_bytes: 0
      usage_in_bytes: 196608
      use: incus
```

## Incusのストレージプールを作成

次に、今作成したストレージボリュームを使って`incus_new`というIncusのストレージプールを作成します：

```
gibmat@futurfusion:~$ incus storage create incus_new zfs source=newpool/incus
Storage pool incus_new created
gibmat@futurfusion:~$ incus storage list
+-----------+--------+--------------------------------------+---------+---------+
|   NAME    | DRIVER |             DESCRIPTION              | USED BY |  STATE  |
+-----------+--------+--------------------------------------+---------+---------+
| incus_new | zfs    |                                      | 0       | CREATED |
+-----------+--------+--------------------------------------+---------+---------+
| local     | zfs    | Local storage pool (on system drive) | 3       | CREATED |
+-----------+--------+--------------------------------------+---------+---------+

```

## `incus admin recover`を使って既存のインスタンスをインポート

```{note}
IncusOSのようなリモートサーバーに対して`incus admin recover`を実行するには、Incusのバージョン6.19以降が必要です。
```

```
gibmat@futurfusion:~$ incus admin recover
This server currently has the following storage pools:
 - incus_new (backend="zfs", source="newpool/incus")
 - local (backend="zfs", source="local/incus")
Would you like to recover another storage pool? (yes/no) [default=no]: yes
Name of the storage pool: incus
Name of the storage backend (dir, zfs): zfs
Source of the storage pool (block device, volume group, dataset, path, ... as applicable): oldpool
Additional storage pool configuration property (KEY=VALUE, empty when done):
Would you like to recover another storage pool? (yes/no) [default=no]:
The recovery process will be scanning the following storage pools:
 - EXISTING: "incus_new" (backend="zfs", source="newpool/incus")
 - EXISTING: "local" (backend="zfs", source="local/incus")
 - NEW: "incus" (backend="zfs", source="oldpool")
Would you like to continue with scanning for lost volumes? (yes/no) [default=yes]:
Scanning for unknown volumes...
The following unknown storage pools have been found:
 - Storage pool "incus" of type "zfs"
The following unknown volumes have been found:
 - Container "debian13" on pool "incus" in project "default" (includes 0 snapshots)
 - Virtual-Machine "debian13-vm" on pool "incus" in project "default" (includes 0 snapshots)
Would you like those to be recovered? (yes/no) [default=no]: yes
Starting recovery...
```

## 既存のインスタンスを新しいストレージボリュームに移動

新旧のZFSプールが準備できたので、インスタンスを暗号化されていない`oldpool`から暗号化されている`newpool`に移動できます：

```
gibmat@futurfusion:~$ for instance in $(incus list --columns n --format compact,noheader); do incus move $instance $instance --storage incus_new; done
```

完了したら、古いIncusのストレージプールを削除します：

```
gibmat@futurfusion:~$ incus storage delete incus
Storage pool incus deleted
gibmat@futurfusion:~$ incus storage list
+-----------+--------+--------------------------------------+---------+---------+
|   NAME    | DRIVER |             DESCRIPTION              | USED BY |  STATE  |
+-----------+--------+--------------------------------------+---------+---------+
| incus_new | zfs    |                                      | 2       | CREATED |
+-----------+--------+--------------------------------------+---------+---------+
| local     | zfs    | Local storage pool (on system drive) | 3       | CREATED |
+-----------+--------+--------------------------------------+---------+---------+
```

## インスタンスを起動し稼働していることを確認

これでIncusOSのサーバーにマイグレートされたインスタンスを暗号化されたストレージボリュームを使って開始できます：

```
gibmat@futurfusion:~$ for instance in $(incus list --columns n --format compact,noheader); do incus start $instance; done
gibmat@futurfusion:~$ incus list
+-------------+---------+-----------------------+------------------------------------------------+-----------------+-----------+
|    NAME     |  STATE  |         IPV4          |                      IPV6                      |      TYPE       | SNAPSHOTS |
+-------------+---------+-----------------------+------------------------------------------------+-----------------+-----------+
| debian13    | RUNNING | 10.119.172.82 (eth0)  | fd42:d040:6b43:6e18:1266:6aff:fe87:2cc (eth0)  | CONTAINER       | 0         |
+-------------+---------+-----------------------+------------------------------------------------+-----------------+-----------+
| debian13-vm | RUNNING | 10.119.172.185 (eth0) | fd42:d040:6b43:6e18:1266:6aff:fe63:ab3c (eth0) | VIRTUAL-MACHINE | 0         |
+-------------+---------+-----------------------+------------------------------------------------+-----------------+-----------+

```

## 古いディスクを消去

最後に、古い暗号化されていないプールを構成していたディスクを消去できます：

```
gibmat@futurfusion:~$ incus admin os system storage wipe-drive -d '{"id":"/dev/disk/by-id/scsi-0QEMU_QEMU_HARDDISK_incus_disk1"}'
WARNING: The IncusOS API and configuration is subject to change

Are you sure you want to wipe the drive? (yes/no) [default=no]: yes
```

完了したらディスクは別のプールを作成したり既存のプールを拡張するのに使えます。あるいはIncusOSサーバーから物理的に取り外すこともできます。
