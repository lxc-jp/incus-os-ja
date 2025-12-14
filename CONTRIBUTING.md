# 貢献する
## プルリクエスト

このプロジェクトへの変更はGitHub上でプルリクエストとして提案してください：
[`https://github.com/lxc/incus-os`](https://github.com/lxc/incus-os)

提案された変更はそこでコードレビューを経てmainブランチにマージされます。

## 行動規範

貢献する際、以下の場所にある行動規範に従う必要があります：
[`https://github.com/lxc/incus-os/blob/main/CODE_OF_CONDUCT.md`](https://github.com/lxc/incus-os/blob/main/CODE_OF_CONDUCT.md)

## ライセンスと著作権

デフォルトでは、このプロジェクトへの貢献はApache 2.0ライセンスになります。

変更の著者が自身のコード著作権保持者のままとなります（著作権の譲渡なし）。

## Large Language Models (LLMs)やAIツールの使用禁止

このプロジェクトへの貢献は人間やスタンダードな予測可能なツール（スクリプト、フォーマッターなど）でなされることを期待しています。

すべての貢献者は彼らが貢献するコードについて判断し、特定のアプローチをとっている理由を説明できることを私たちは期待します。

LLMや同様の予測ツールは微妙な問題を含む質の低いコードを大量に生成し、最初から人手で書いたコードをデバッグするよりもメンテナーがより長時間を費やすことになってしまうという迷惑な傾向があります。

IncuSOSの貢献でLLMや同様のツールの使用を隠そうとする試みは影響を受ける変更を取り消し、プロジェクトから追放される結果をもたらします。

## 開発者起源証明書

このプロジェクトへの貢献の追跡性を改善するため、私たちはDCO 1.1を使い、ブランチへのすべての変更に対して「サイン・オフ（sign-off）」を使います。

サイン・オフは単にコミットの説明の最後に置かれる単純な行で、それによりあなたがコミットを書いたか、あるいはコミットをオープンソースの貢献として手渡すことを証明します。

> Developer Certificate of Origin
> Version 1.1
>
> Copyright (C) 2004, 2006 The Linux Foundation and its contributors.
> 660 York Street, Suite 102,
> San Francisco, CA 94110 USA
>
> Everyone is permitted to copy and distribute verbatim copies of this
> license document, but changing it is not allowed.
>
> Developer's Certificate of Origin 1.1
>
> By making a contribution to this project, I certify that:
>
> (a) The contribution was created in whole or in part by me and I
>     have the right to submit it under the open source license
>     indicated in the file; or
>
> (b) The contribution is based upon previous work that, to the best
>     of my knowledge, is covered under an appropriate open source
>     license and I have the right under that license to submit that
>     work with modifications, whether created in whole or in part
>     by me, under the same open source license (unless I am
>     permitted to submit under a different license), as indicated
>     in the file; or
>
> (c) The contribution was provided directly to me by some other
>     person who certified (a), (b) or (c) and I have not modified
>     it.
>
> (d) I understand and agree that this project and the contribution
>     are public and that a record of the contribution (including all
>     personal information I submit with it, including my sign-off) is
>     maintained indefinitely and may be redistributed consistent with
>     this project or the open source license(s) involved.

（訳注：日本語参照訳が https://developercertificate.opensource.jp/ にあります）

有効なサイン・オフの行の例は：

```
Signed-off-by: Random J Developer <random@developer.org>
```

本名と有効なe-mailアドレスを使ってください。
申し訳ありませんが、仮名や匿名の貢献は認めません。

たとえそれが大きなセットの一部だったとしても、私たちは各コミットを個々に著者がサイン・オフすることを要求します。
`git commit -s`が便利に使えます。
