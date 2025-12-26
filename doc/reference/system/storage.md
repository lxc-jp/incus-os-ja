# ストレージ

IncusOSでは複雑なZFSストレージプールを設定できます。各プールはプール内のデータを保護するためにランダムに生成された鍵で自動的に暗号化されます。暗号鍵はシステムのセキュリティーステートから取得できます。

ストレージプールを作成する際、IncusOSはローカルのデバイスあるいはiSCSIのような[サービス](../services.md)経由で利用可能なリモートのデバイスを使えます。

既存のストレージプールにデバイスを追加、削除、置き換えることもできます。これは現在のプール設定を取得し、対応する構造体に変更を加えて、IncusOSに変更結果を提示することで実現できます。

```{note}
暗号化されていないZFSストレージプールはサポートされません。IncusOSは暗号化されたプールのみ作成し、既存の暗号化されていないプールのインポートも拒否します。

これにより暗号化されたプールから暗号化されていないプールへ機密情報を誤って流出することを防ぎます。
```

## 設定オプション

設定フィールドは[`SystemStorageConfig`構造体](https://github.com/lxc/incus-os/blob/main/incus-osd/api/system_storage.go)で定義されています。

以下の設定オプションが設定できます：

* `pools`: 1つ以上のユーザー定義のストレージプール定義の配列。

```{note}
プールにデバイスを指定する際、順序が重要です。IncusOSはAPIで受け取ったデバイスのリストを比較する際、どのデバイスをプールに追加、削除、置換するかを決定するために使用するソート済みリストを常に返します。別の言い方をすると`"devices": ["/dev/sda", "/dev/sdb"]` != `"devices": ["/dev/sdb", "/dev/sda"]`です。
```

### 例

4つのデバイス、1つのキャッシュデバイス、1つのログデバイスでZFS raidz1として`mypool`というストレージプールを作成します：

```
{
    "pools": [
        {"name":"mypool",
         "type":"zfs-raidz1",
         "devices":["/dev/sdb","/dev/sdc","/dev/sdd","/dev/sde"],
         "cache":["/dev/sdf"],
         "log":["/dev/sdg"]}
    ]
}
```

故障したデバイス`/dev/sdb`を`/dev/sdh`で置き換えます：

```
{
    "pools": [
        {"name":"mypool",
         "type":"zfs-raidz1",
         "devices":["/dev/sdh","/dev/sdc","/dev/sdd","/dev/sde"],
         "cache":["/dev/sdf"],
         "log":["/dev/sdg"]}
    ]
}
```

安全なストレージのプール暗号鍵を取得します（base64エンコード形式）：

```
$ incus admin os system security show
[snip]
state:
  pool_recovery_keys:
    local: vIAKUWSxK5GrNrkn60kjEXh2M4WZdtX+hcyhx0W8q7U=
    mypool: zh9gkAgGsKenO48y7dwNg6aBFaD6OoedgSlSsivEq0Q=
```

## ストレージプールの削除

```{warning}
ストレージプールを削除するとプール内のすべてのデータの回復不能な消失をもたらします。
```

`mypool`ストレージプールを削除するには以下のコマンドを実行します。

```
incus admin os system storage delete-pool -d '{"name":"mypool"}'
```

## ドライブの消去

```{warning}
ドライブを消去するとドライブ上のすべてのデータの回復不能な消失をもたらします。
```

`scsi-0QEMU_QEMU_HARDDISK_incus_disk`ドライブを消去する際は、IDで指定する必要がありますが、以下のコマンドを実行します。

```
./incus admin os system storage wipe-drive -d '{"id":"/dev/disk/by-id/scsi-0QEMU_QEMU_HARDDISK_incus_disk"}'
```

## 既存の暗号化されたプールのインポート

既存のストレージプールをインポートする場合、データが利用可能になる前に暗号鍵をIncusOSに伝える必要があります。暗号パスフレーズを入力するプロンプトを表示する方法がないため、生の暗号鍵を使うZFSプールのみがインポートできます。BASE64エンコードされた暗号鍵を使って`mypool`ストレージプールをインポートするには以下のコマンドを実行します。

```
incus admin os system storage import-storage-pool -d '{"name":"mypool","type":"zfs","encryption_key":"THp6YZ33zwAEXiCWU71/l7tY8uWouKB5TSr/uKXCj2A="}'
```

## ボリュームの管理

ストレージプール内にボリュームを作成と削除できます。

各ボリュームはそれぞれ固有の情報を持ちます：

* 名前
* クォータ（バイトで指定、0は無制限）
* 用途（`incus`または`linstor`）

ボリュームのリストはストレージの状態データ内で直接見ることができます。

ボリュームの作成と削除はコマンドラインで以下のように実行できます：

```
incus admin os system storage create-volume -d '{"pool":"local","name":"my-volume","use":"linstor"}'
incus admin os system storage delete-volume -d '{"pool":"local","name":"my-volume"}'
```

```{note}
IncusOSは`local`ストレージプールをセットアップする際に`incus`ボリュームを自動で作成します。
```
