2章 プログラムの意味
------------
TODO: 書く





------------

* キャンセルの一番簡単な方法
 * キャンセルフラグをタスクに持たせる  
 * // TODO コードのURL  
 * https://github.com/kamatama41/java-concurrency-07/blob/master/src/study/PrimeGenerator.java
 * 出来れば実演

* キャンセルされる側のタスクは、キャンセルの(how,when,what)を定義した、キャンセルポリシーを必ず持つ必要がある
 * タスクをどうやって(how)キャンセルするのか  
 * タスクをいつ(when)キャンセルするのか  
 * タスクのキャンセルに対してどんな(what)アクションを行うのか  

## 7-1-1 インタラプション
* 以下の例は、ブロッキングキューが満杯でputで処理待ちしている場合、キャンセルできない
 * // TODO コードのURL  
 * https://github.com/kamatama41/java-concurrency-07/blob/master/src/study/BrokenPrimeProducer.java
 * 出来れば実演
 * Javaのブロックメソッドはインタラプトをサポートしているので、それを使おう  

### Threadクラスのメソッドたち
| メソッド | 内容 |
|----------|--------------------------------|
| void interrupt() | インタラプテッドステータスをtrueにする |
| boolean isInterrupted() | 現在のインタラプテッドステータスを取得する |               
| static boolean interrupted() | 現在のスレッド（このメソッドを呼んだスレッド）のインタラプテッドステータスをクリアし、その前の値を返す |

### Threadインタラプションとは
* 実行中のスレッドに対して、割り込みをする訳ではない  
* 「あなたのご都合のよろしいときにお仕事を中断してください」とリクエストするだけ  
* 実際の処理はメソッドにゆだねられている  
 * 例外を投げる
  * リクエストは無視するがインタラプテッドステータスは保持して呼び出し側に処理をゆだねる
  * 完全無視(行儀わるい)  
  * など

## 7-1-2 インタラプションポリシー
* タスクはキャンセルポリシーを持つべきだが、 **スレッドはインタラプションポリシーを持つべき**
* タスクは基本的には自らのスレッドをもたないので、”ゲスト”である自分自身はインタラプションポリシーを持つべきではない  

### (例) ブロック系のライブラリ(Thread.sleep()とか)
* 一番リーズナブルなキャンセルポリシーを適応  
 * インタラプトを検知した場合は、InterruptedExceptionをthrowして呼び出し側にインタラプトを伝搬する  
* インタラプトを検知した場合の処理はいろいろある  
 * データの整合性を保持できるように処理した後に例外を投げる  
 * InterruptExceptionを投げられない場合はThread.currentThread().interrupt()でインタラプテッドステータスを保全する  
 * など  

- - -
**各スレッドに自分のインタラプションポリシーがあるので、（あなたが書く）タスクは、インタラプションがそのスレッドに取ってどんな意味があるのかを知っている場合意外は、スレッドにインタラプトしてはいけません。**
- - - 

➡　つまりインタラプトをどうするかはディベロッパーの自由

## 7-1-3 インタラプションへの応答
### InterruptionExceptionへの代表的な対応方法
* 例外を広める(呼び出し側に渡す)
* インタラプテッドステータスを復元して呼び出し、スタックの上の方がそれを処理するように書く
 * Thread#interrupted()  

- - -
**自分がどのスレッドで動かされているかが分からない場合(インタラプションポリシーを判定できない場合)、インタラプトをもみ消してはダメです！！**
- - -

### インタラプションに対してキャンセルがサポートされていない場合はの対処例
BlockingQueue#take()にはキャンセルがサポートされていないので、無限ループになる可能性がある  
(TODO なぜ無限ループになるか分からない・・・)
```java
public Task getNextTask(BlockingQueue<Task> queue) {
    boolean interrupted = false;
    try {
        while(true) {
            try {
                return queue.take();
            } catch (InterruptedException e) {
                interrupted = true;
                // このままループを続けて、再試行する
            }
        }
    } finally {
        if(interrupted) {
            Thread.currentThread().interrupt();
        }
    }
}
```

### キャンセルのインタラプション以外の使い方例
* ThreadPoolExecutorのワーカースレッドがインタラプトを検知
* スレッドプールがシャットダウンをチェック
 * ダウンしていたらプールの掃除をして終了
 * ダウンしていなかったらワーカースレッドを作成して、プール復元

## 7-1-4 例：実行時間の制限
### 自分が”ゲスト”のスレッドへのインタラプトをスケジューリングする、ダメな例
* 呼び出しスレッドのインタラプションポリシーを判断できない場合がある
 * タスクがインタラプションを無視する場合は無限に終わらない可能性あり
* runがinterruptのタスクが始まる前に終わってしまったら何が起こるか分からない

```java
private static final ScheduledExecutorService cancelExec = Executors.newScheduledThreadPool(3);

public static void timedRun(Runnable r, long timeout, TimeUnit unit) {
    final Thread taskThread = Thread.currentThread();
    cancelExec.schedule(new Runnable() {
        @Override
        public void run() {
            taskThread.interrupt();
        }
    }, timeout, unit);
    r.run();
}
```