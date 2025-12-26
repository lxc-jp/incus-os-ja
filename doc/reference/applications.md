# アプリケーション
IncusOSは自身ではネットワークをリッスンしません。
システムをネットワーク越しにアクセスし管理できるようにするために、プライマリーアプリケーションをインストールする必要があります。

プライマリーアプリケーションはネットワークをリッスンしユーザー認証を処理する責任があります。
そして自身のAPIを介してIncusOSの管理APIへのアクセスを提供します。

IncusOSは[追加の](applications/non-primary.md)（非プライマリーな）アプリケーションもサポートします。
これは（例えばデバッグのために）ベースシステムを拡張したり他のアプリケーションに追加の機能を提供したりできます。

```{toctree}
:maxdepth: 1

Incus </reference/applications/incus>
マイグレーションマネージャー </reference/applications/migration-manager>
オペレーションセンター </reference/applications/operations-center>

共通API </reference/applications/shared-api>

非プライマリーアプリケーション </reference/applications/non-primary>
```
