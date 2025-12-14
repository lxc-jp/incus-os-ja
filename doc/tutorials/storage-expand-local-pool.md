# "local"ストレージプールを拡張する

初回ブート時に、IncusOSはメインのシステムドライブに"local"という名前のストレージプールを自動で作成します。このプールはドライブの残りの空きスペースをすべて使います。（メインシステムドライブのパーティショニングの詳細については[こちら](../reference/partitioning-scheme.md)をご参照ください。）

同じサイズの2つのドライブを持つサーバーにIncusOSをインストールするのはよくあります。IncusOSは片方のドライブにインストールし、もう片方は使わないままになります。未使用のドライブに別のストレージプールを作成するよりも、2つめのドライブを使うように"local"ストレージドライブを自動的に拡張できます。2つめのドライブをRAID0（ストライピング）またはRAID1（ミラー）として設定できます。

## 制限

"local"プールにはいくつかの制限があります：

* メインシステムドライブのパーティションは"local"プールから削除できません
* "local"プールは削除できません
* "local"プールではRAID0とRAID1のみがサポートされます
* "local"プールは1つか2つのドライブで構成できます

### RAID1の追加の制限

* 2つめのドライブはメインシステムドライブと同じサイズである必要があります
* メインシステムドライブ上のパーティショニングレイアウトの都合により、プールの容量はドライブのサイズより約35GiB小さくなります

## 初期のシステム状態

このチュートリアルでは、サイズが50GiBのドライブが3つある前提とします。IncusOSをインストールしたけれど、システムにほかの変更は行っていないものとします。

システムの現在の設定を取得します：

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
    pool_allocated_space_in_bytes: 4.3008e+06
    raw_pool_size_in_bytes: 1.7716740096e+10
    state: ONLINE
    type: zfs-raid0
    usable_pool_size_in_bytes: 1.7716740096e+10
```

## RAID0

RAID0は"local"プールのサイズを最大にできますが、ドライブに障害が発生した場合にデータの冗長性はないという犠牲を払っています。

`incus admin os system storage edit`を実行して"local"プールに`/dev/disk/by-id/scsi-0QEMU_QEMU_HARDDISK_incus_disk1`を追加しましょう。設定は以下のようになります：

```
config:
  pools:
  - name: local
    type: zfs-raid0
    devices:
    - /dev/disk/by-id/scsi-0QEMU_QEMU_HARDDISK_incus_root-part11
    - /dev/disk/by-id/scsi-0QEMU_QEMU_HARDDISK_incus_disk1
```

保存して終了したら、IncusOSは変更を反映します。"local"ストレージプールの拡張を反映して更新されたストレージ設定は以下のようになります：

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
    member_pool: local
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
    - /dev/disk/by-id/scsi-0QEMU_QEMU_HARDDISK_incus_disk1
    - /dev/disk/by-id/scsi-0QEMU_QEMU_HARDDISK_incus_root-part11
    encryption_key_status: available
    name: local
    pool_allocated_space_in_bytes: 4.558848e+06
    raw_pool_size_in_bytes: 7.0866960384e+10
    state: ONLINE
    type: zfs-raid0
    usable_pool_size_in_bytes: 7.0866960384e+10
```

## RAID1

RAID1は"local"プールに書かれたデータをミラーし、1つのドライブで障害が発生してもデータを復元できます。

`incus admin os system storage edit`を実行して"local"プールに`/dev/disk/by-id/scsi-0QEMU_QEMU_HARDDISK_incus_disk1`を追加しましょう。設定は以下のようになります：

```
config:
  pools:
  - name: local
    type: zfs-raid1
    devices:
    - /dev/disk/by-id/scsi-0QEMU_QEMU_HARDDISK_incus_root-part11
    - /dev/disk/by-id/scsi-0QEMU_QEMU_HARDDISK_incus_disk1
```

```{note}
2つめのドライブを追加するのに加えて、タイプも`zfs-raid1`に変更していることに注意してください。
```

保存して終了したら、IncusOSは変更を反映します。"local"ストレージプールの拡張を反映して更新されたストレージ設定は以下のようになります： "local" storage pool:

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
    member_pool: local
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
    - /dev/disk/by-id/scsi-0QEMU_QEMU_HARDDISK_incus_disk1-part11
    - /dev/disk/by-id/scsi-0QEMU_QEMU_HARDDISK_incus_root-part11
    encryption_key_status: available
    name: local
    pool_allocated_space_in_bytes: 4.42368e+06
    raw_pool_size_in_bytes: 1.7716740096e+10
    state: ONLINE
    type: zfs-raid1
    usable_pool_size_in_bytes: 1.7716740096e+10
```

### 非システムドライブの障害を復旧

"local"ストレージプールに追加した2つめのドライブに障害が起きたと仮定しましょう。たまたまサーバーには3つめのドライブがありますので、障害が起きたドライブを置き換えるのに使えます。

再び`incus admin os system storage edit`を実行して`disk1`と`disk2`を置き換えます：

```
config:
  pools:
  - name: local
    type: zfs-raid1
    devices:
    - /dev/disk/by-id/scsi-0QEMU_QEMU_HARDDISK_incus_disk2
    - /dev/disk/by-id/scsi-0QEMU_QEMU_HARDDISK_incus_root-part11
```

保存して終了したら、IncusOSは変更を反映します。"local"プールにどれだけのデータが保管されていたかによって、ZFSがresilverを完了するまでに時間がかかるかもしれません。最終的にresilverが完了したら、システムのストレージの状態は以下のようになるでしょう：

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
    member_pool: local
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
    - /dev/disk/by-id/scsi-0QEMU_QEMU_HARDDISK_incus_disk2-part11
    - /dev/disk/by-id/scsi-0QEMU_QEMU_HARDDISK_incus_root-part11
    encryption_key_status: available
    name: local
    pool_allocated_space_in_bytes: 4.460544e+06
    raw_pool_size_in_bytes: 1.7716740096e+10
    state: ONLINE
    type: zfs-raid1
    usable_pool_size_in_bytes: 1.7716740096e+10
```

### 障害の起きたシステムドライブを復旧

メインシステムドライブで障害が起きた場合、"local"ストレージプールからデータを復旧できます。新しいドライブにIncusOSを再インストールした後、初回ブート時に2つめのドライブが物理的に存在する場合はIncusOSは"local"ストレージプールを復旧しようと試みます：

```
2025-11-18 18:05:22 INFO Bringing up the local storage
2025-11-18 18:05:22 INFO Attempting to recover storage pool 'local' using existing non-system drive
2025-11-18 18:05:23 INFO System is ready release=202511181747
```

これはプールを正常な状態にリストアーしますが、これはフレッシュなIncusOSのインストールですので前回作成した"local"ストレージプールの暗号鍵を渡す必要があります：

```
incus admin os system storage import-storage-pool -d '{"name":"local","type":"zfs","encryption_key":"QWJKYnRLGfyhj+OevRfgkdE6MW6PgAqR57tTi+8T+qA="}'
```

この手順のあと、"local"プールのデータは利用可能になり、毎回のブート時に自動的に復号化されます。

どのアプリケーションがインストールされているかによって、新しく再インストールしたシステムを完全にリストアーするために追加の手順が必要になるかもしれません。例えば、もしIncusがインストールされていたら、`incus admin recover`を実行して"local"プール内に保管されていたインスタンスを再び発掘する必要があるかもしれません。
