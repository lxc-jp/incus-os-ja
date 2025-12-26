# Tailscale

[Tailscale](https://tailscale.com/)サービスはTailscale VPNクライアントを設定できるようにします。

## 設定オプション

このサービスの完全なAPIの構造体は[オンライン](https://github.com/lxc/incus-os/blob/main/incus-osd/api/service_tailscale.go)でご覧いただけます。

以下の設定オプションが設定できます：

* `enabled`: `true`の場合、Tailscaleサービスを有効化します。

* `login_server`: Tailscaleログインサーバー。

* `auth_key`: Tailscale認証鍵。

* `accept_routes`: `true`の場合、ルートを受け付けます。

* `advertised_routes`: 広告するルートの配列。

* `serve_enabled`: `true`の場合、`localhost:8443`（たいていはIncusアプリケーション）を[Tailscale Serve](https://tailscale.com/kb/1242/tailscale-serve)経由で公開します。

* `serve_port`: HTTPSサーバーを公開するTCPポート、例えば`443`はIncusアプリケーションを`https://{hostname}.{tailnet}.ts.net:443/`で公開します。

```{warning}
Tailscale Serveを有効に数rには事前にダッシュボードでHTTPS証明書の設定が必要です（[ドキュメント](https://tailscale.com/kb/1153/enabling-https#configure-https)）
```
