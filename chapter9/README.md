# テーマ
P307に書いてあったこと
「コストの小さな近似を使うことでコストの高い計算に振るまいについて情報を得る」

# プログラムを実行しないでプログラムに関する情報をみつけたい
* ソースコードから予測しても、正しい答えは得られないことが多い
* 実行するのが確実だが、うまくいかないこともある
  * 実行時まで不明な情報を扱う可能性が高い e.g. 外部パラメータ
  * 結果を返さずに永久に実行を続ける可能性がある
  * コストが高く付いたり、都合が悪いパターンがある e.g. ミサイル発射

↓

やっぱりプログラムを実行することなく、プログラムに関する情報を見つけたいよね

↓

抽象解釈

# 抽象解釈
詳細を捨てる

e.g.
* 地図でルート計画を立てる
* 正数と負数の計算
* スタブやモック

# 静的意味論
代表的な例：型システム

# コードの例

# ここからは個人的な見解
JS界でもTypeScriptがあったり、FacebookがFlow(http://flowtype.org/)を
作ってたりと、型に対する需要が増えている感がある。
型がないLL言語でも、安心して動かすために最終的にはテストをゴリゴリ
書かねばならないし、型は一定規模以上のソフトウェアにはあったほうがよいのだろう・・・

