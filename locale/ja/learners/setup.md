---
title: セットアップ
---

## ローカルのセットアップ

これらの指示に従って、コンピュータに必要なソフトウェアをインストールしてください。

- [最新バージョンの R をダウンロードしてインストール](https://www.r-project.org/)。
- [RStudio をダウンロードしてインストール](https://www.rstudio.com/products/rstudio/download/#download)。RStudio は R の使用を容易にするアプリケーション（統合開発環境または IDE）であり、[Quarto](https://quarto.org/) 出版システムを含む多くの便利な追加機能を提供します。コンピュータ用の無料デスクトップ版が必要です。
- 以下のコマンドを使用して必要な R パッケージをインストールしてください：

```r
install.packages(
  c(
    "conflicted",
    "crew",
    "palmerpenguins",
    "quarto",
    "tarchetypes",
    "targets",
    "tidyverse",
    "visNetwork"
  )
)
```
