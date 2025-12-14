# REST API

```{note}
IncusOS APIは通常は[Incus](applications/incus.md)のようなインストールされたアプリケーションを通してプロキシーされます。

APIで手動で操作する場合、IncusOSのエンドポイントに正しくアクセスするには`/os/`を前につける必要があります。例えば、アプリケーションの一覧を得るには`curl https://1.2.3.4:8443/os/1.0/applications`と実行します。
```

```{warning}
IncusOSのデバッグAPIはAPIの安定性は無保証であり、通常の毎日の運用では使うべきではありません。
```

<link rel="stylesheet" type="text/css" href="../../_static/swagger-ui/swagger-ui.css" ></link>
<link rel="stylesheet" type="text/css" href="../../_static/swagger-override.css" ></link>
<div id="swagger-ui"></div>

<script src="../../_static/swagger-ui/swagger-ui-bundle.js" charset="UTF-8"> </script>
<script src="../../_static/swagger-ui/swagger-ui-standalone-preset.js" charset="UTF-8"> </script>
<script>
window.onload = function() {
  // Begin Swagger UI call region
  const ui = SwaggerUIBundle({
    url: window.location.pathname +"../../rest-api.yaml",
    dom_id: '#swagger-ui',
    deepLinking: true,
    presets: [
      SwaggerUIBundle.presets.apis,
      SwaggerUIStandalonePreset
    ],
    plugins: [],
    validatorUrl: "none",
    defaultModelsExpandDepth: -1,
    supportedSubmitMethods: []
  })
  // End Swagger UI call region

  window.ui = ui
}
</script>
