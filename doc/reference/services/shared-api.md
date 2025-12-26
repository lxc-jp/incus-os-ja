# 共通API

IncusOSの各サービスは、状態と設定の取得、設定の更新、必要に応じてサービスを強制的にリセットするために使える共通のAPIを持っています。

## サービスの状態と設定を取得

```
incus admin os service show <name>
```

## サービスの設定を編集

```
incus admin os service edit <name>
```

## アプリケーションをリセット

必要なら、サービスを以下のコマンドで強制的にリセットできます。

```
incus admin os service reset <name>
```
