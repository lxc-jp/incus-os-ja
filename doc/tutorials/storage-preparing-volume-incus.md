# Incus用にストレージボリュームを用意

IncusOSはランダムに生成した暗号鍵を使って暗号化したストレージプールを作成します。これらの鍵はメインシステムドライブに保管され、TPMによる暗号化で保護されます。これにより各ストレージプールに保管されたすべてのデータに強い保護を提供します。

各ストレージプールは1つ以上のボリュームを持てます。ストレージボリュームはストレージのクォータを強制するのに使ったり、特定のアプリケーション用に特別に設定できます。

捨てレージボリュームを作成し、Incusのようなアプリケーションで使えるようにするのはとても簡単です。

```{warning}
Incusは[直接ストレージプールを作成](https://linuxcontainers.org/incus/docs/main/howto/storage_pools/)できます。しかし、このプールは**暗号化されず**IncusOSで管理されません。このため、IncusOS APIを使ってストレージプールを作成し、それを下記の手順でIncusに公開することを強く推奨します。
```

## ストレージプールを作成

[ストレージプールAPI](../reference/system/storage.md)は複雑なプールを作成するオプションを提供します。このチュートリアルは簡単のため単一のドライブを使います。

`/dev/disk/by-id/scsi-0QEMU_QEMU_HARDDISK_incus_disk1`デバイスを使い`my-pool`というプールを作りたいとすると、`incus admin os system storage edit`を実行して以下のプール設定を追加します：

```
config:
  pools:
    - name: my-pool
      type: zfs-raid0
      devices:
      - /dev/disk/by-id/scsi-0QEMU_QEMU_HARDDISK_incus_disk1
```

その後、新しいプールが作られますが、未使用の状態です：

```
gibmat@futurfusion:~$ incus admin os system storage show
WARNING: The IncusOS API and configuration is subject to change

[snip]

state:
  pools:
  - devices:
    - /dev/disk/by-id/scsi-0QEMU_QEMU_HARDDISK_incus_disk1
    encryption_key_status: available
    name: my-pool
    pool_allocated_space_in_bytes: 724992
    raw_pool_size_in_bytes: 5.3150220288e+10
    state: ONLINE
    type: zfs-raid0
    usable_pool_size_in_bytes: 5.3150220288e+10
    volumes: []
```

## ボリュームを作成

Incusで使うための`my-volume`という新しいストレージボリュームを作成します：

```
gibmat@futurfusion:~$ incus admin os system storage create-volume -d '{"pool":"my-pool","name":"my-volume","use":"incus"}'
gibmat@futurfusion:~$ incus admin os system storage show
WARNING: The IncusOS API and configuration is subject to change

[snip]

state:
  pools:
  - devices:
    - /dev/disk/by-id/scsi-0QEMU_QEMU_HARDDISK_incus_disk1
    encryption_key_status: available
    name: my-pool
    pool_allocated_space_in_bytes: 1.04448e+06
    raw_pool_size_in_bytes: 5.3150220288e+10
    state: ONLINE
    type: zfs-raid0
    usable_pool_size_in_bytes: 5.3150220288e+10
    volumes:
    - name: my-volume
      quota_in_bytes: 0
      usage_in_bytes: 196608
      use: incus
```

## ボリュームをIncusで使えるようにする

最後に、ストレージボリュームをIncusが使えるように追加するのは簡単です：

```
gibmat@futurfusion:~$ incus storage create incusos-volume zfs source=my-pool/my-volume
Storage pool incusos-volume created
gibmat@futurfusion:~$ incus storage list
+----------------+--------+--------------------------------------+---------+---------+
|      NAME      | DRIVER |             DESCRIPTION              | USED BY |  STATE  |
+----------------+--------+--------------------------------------+---------+---------+
| local          | zfs    | Local storage pool (on system drive) | 3       | CREATED |
+----------------+--------+--------------------------------------+---------+---------+
| incusos-volume | zfs    |                                      | 0       | CREATED |
+----------------+--------+--------------------------------------+---------+---------+
```
