---
title: "はじめに"
teaching: 10
exercises: 2
---

:::::::::::::::::::::::::::::::::::::: questions 

- 再現性を重視すべき理由は何ですか？
- `targets` はどのようにして再現性の達成を助けますか？

::::::::::::::::::::::::::::::::::::::::::::::::

::::::::::::::::::::::::::::::::::::: objectives

- 再現性が科学にとってなぜ重要なのかを説明する
- 再現性を高める `targets` の機能について説明する

::::::::::::::::::::::::::::::::::::::::::::::::

::::::::::::::::::::::::::::::::::::: {.instructor}

エピソードの概要: 再現性の概念と `targets` を使用する理由や対象者について紹介する

:::::::::::::::::::::::::::::::::::::

## 再現性とは何ですか？

再現性とは、他の人（将来の自分自身を含む）があなたの分析を再現できる能力のことです。

科学的な分析の結果に自信を持つためには、それらが再現可能でなければなりません。

しかし、再現性は二元的な概念（再現不可能 vs. 再現可能）ではなく、**再現性が低い**から**再現性が高い**までのスケールがあります。

`targets` は分析を **より再現性の高いもの** にするために大きく貢献します。

再現性をさらに高めるために使用できる他の方法としては、Docker、conda、renv などのツールを使用してコンピューティング環境を管理することがありますが、このワークショップではそれらを扱う時間がありません。

## `targets` とは何ですか？

`targets` は、Will Landau によって開発および維持されている R プログラミング言語向けのワークフローマネジメントパッケージです。

`targets` の主な機能には以下が含まれます：

- ワークフローの**自動化**
- ワークフローのステップの**キャッシング**
- ワークフローのステップの**バッチ作成**
- ワークフローのレベルでの**並列化**

これにより、以下のことが可能になります：

- 他の作業をした後にプロジェクトに戻り、混乱や何をしていたかを思い出すことなくすぐに作業を再開できる
- ワークフローを変更した場合、変更の影響を受ける部分のみを再実行できる
- 個々の関数を変更することなくワークフローを大規模に拡張できる

... そしてもちろん、他の人があなたの分析を再現するのに役立ちます。

## 誰が `targets` を使用すべきですか？

`targets` はワークフローマネジメントソフトウェアの唯一のものではありません。
類似のツールは数多く存在し、それぞれに異なる機能やユースケースがあります。
例えば、[snakemake](https://snakemake.readthedocs.io/en/stable/) は Python 向けの人気のあるワークフローツールであり、[`make`](https://www.gnu.org/software/make/) は長い歴史を持つ Bash スクリプトの自動化ツールです。
`targets` は特に R と連携するように設計されているため、主に R を使用する場合、または R を使用する予定がある場合に最も適しています。
他のツールを主に使用する場合は、代替手段を検討することをお勧めします。

このワークショップの**目標**は、**R で再現可能なデータ分析を行うために `targets` の使い方を学ぶ**ことです。

## さらに情報を得るには

`targets` は高度なパッケージであり、このワークショップでカバーできる以上に学ぶことがたくさんあります。

`targets` の学習を続けるためのおすすめリソースは以下の通りです：

- `targets` の作者である Will Landau による [The `targets` R package user manual](https://books.ropensci.org/targets/) は、`targets` に真剣に興味がある人にとって必読とすべきです。
- [The `targets` discussion board](https://github.com/ropensci/targets/discussions) は質問をしたり助けを得たりするのに最適な場所です。ただし、質問をする前に必ず [help のポリシーを読む](https://books.ropensci.org/targets/help.html) ことを確認してください。
- [The `targets` package webpage](https://docs.ropensci.org/targets/) には、すべての `targets` 関数のドキュメントが含まれています。
- [The `tarchetypes` package webpage](https://docs.ropensci.org/tarchetypes/) には、すべての `tarchetypes` 関数のドキュメントが含まれています。`tarchetypes` はほぼ確実に `targets` と一緒に使用するため、両方を参照することをお勧めします。
- [Reproducible computation at scale in R with `targets`](https://github.com/wlandau/targets-tutorial) は、Keras を用いて顧客の離脱を分析する Will Landau によるチュートリアルです。
- [Recorded talks](https://github.com/ropensci/targets#recorded-talks) および [example projects](https://github.com/ropensci/targets#example-projects) は、`targets` の README に記載されています。

## 例示データセットについて

このワークショップでは、南極のパルマー群島の島々で観察された成体の採餌アデリーペンギン、チンストラップペンギン、ジェンツーペンギンの測定データを分析します。

データは `palmerpenguins` R パッケージから入手可能です。データに関する詳細情報は `?palmerpenguins` を実行することで得られます。

![`palmerpenguins` データセットの3種のペンギン。アートワーク：@allison_horst.](https://allisonhorst.github.io/palmerpenguins/reference/figures/lter_penguins.png)

分析の目標は、線形モデルを使用してくちばしの長さと深さの関係を明らかにすることです。

このレッスンを通じて分析を段階的に構築しますが、最終版は <https://github.com/joelnitta/penguins-targets> で見ることができます。

::::::::::::::::::::::::::::::::::::: keypoints 

- 科学的分析の結果に自信を持つためには、他の人（将来の自分自身を含む）がそれを再現できなければならない
- `targets` はワークフローの自動化によって再現性の達成を助ける
- `targets` は R プログラミング言語と連携するように設計されている
- このワークショップの例示データセットには、南極のペンギンの測定データが含まれている

::::::::::::::::::::::::::::::::::::::::::::::::
