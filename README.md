<p align="center"><img src="https://res.cloudinary.com/dtfbvvkyp/image/upload/v1566331377/laravel-logolockup-cmyk-red.svg" width="400"></p>

<p align="center">
<a href="https://travis-ci.org/laravel/framework"><img src="https://travis-ci.org/laravel/framework.svg" alt="Build Status"></a>
<a href="https://packagist.org/packages/laravel/framework"><img src="https://poser.pugx.org/laravel/framework/d/total.svg" alt="Total Downloads"></a>
<a href="https://packagist.org/packages/laravel/framework"><img src="https://poser.pugx.org/laravel/framework/v/stable.svg" alt="Latest Stable Version"></a>
<a href="https://packagist.org/packages/laravel/framework"><img src="https://poser.pugx.org/laravel/framework/license.svg" alt="License"></a>
</p>

# 0. アプリケーション名  
自己紹介アプリ  
  
# 1. アプリケーションの概要  
  
各々が自由にグループを作り、所属し、その中でプロフィールを共有する。（レスポンシブ対応）  
アプリケーションURL [https://www.intro-app.link/](https://www.intro-app.link/)  

![intro-app_movie_1](https://user-images.githubusercontent.com/39019484/109376922-0f1b9880-790b-11eb-9114-872c36b14f01.gif)

# 1.　特に見てほしいポイント  
  
## 1-1. インフラ（AWS)の構築  
  
インフラに実際の現場でも積極的に使用されているAWSを選び、構築してみました。  
  
ただEC2だけ使用するのではなく、ECSによってアプリを立ち上げました。  
**開発環境(Docker)で作成した自前のイメージをECRへプッシュさせ、ECSを使用してそのイメージをコンテナ化させました。**  
  
**データベースにはRDSを使用し、外部からのアクセスを防ぐためにプライベートサブネットで覆いました。**  
  
CloudWatchでコンテナ内のログを出力させ、デバッグに役立てました。  
  
**S3に環境変数のキーと値が書かれたファイルをアップロードし、タスク実行ロールにインラインポリシーをアタッチすることで、ECSからS3へ環境変数を参照できるように設計しました。**
  
## 1-2 CircleCI/CDによりテストとデプロイの自動化  
  
今までは手動でテストやECRへのプッシュやECSのデプロイを行っていましたが、かなり作業的であったためそれらの「自動化」を実装してみました。  
  
CIに関しては、PHPUnitを自動で実行できるよう設計しました。  
CDに関しては、新しい技術であるOrbsを利用して、ECRへの自動プッシュ、ECSへの自動デプロイを実現させました。  
  
## 1-3 完全SPA化  
  
SPA構築を取り入れたことで、UXの向上と新たにフロントエンドの知識が身につきました。  
VuexやVuerouterも使用し、非同期通信をうまく取り扱うことができるようになりました。  
  
## 1-4 Gitの操作  
  
入社してから困らないようにチーム開発を意識してGitの技術も学び、ポートフォリオ作成にも活かしました。  
**issueごとにブランチを切り、プルリクを発行し、developブランチにマージさせていきました。**  
**リリースする際は、releaseブランチを作成し、masterブランチとdevelopブランチにマージさせ、masterブランチにマージさせたコミットにはタグをつけました。**  
（本当はポートフォリオ作成段階で取り入れればよかったですが、終わりかけのところで気づきそれから取り入れました）  
  
## 1-5 すべての行程を独学で作りきったこと
  
スクールに通わず、チュートリアルをそのまま作成せず、０から一人で学び実装してきました。  
エラーに対応する力やテクニックなどが特に身につきました。  
  

# 3. アプリケーション主要機能一覧  
  
◯会員登録、ログイン、ログアウト  
◯プロフィールの作成  
◯ログイン、プロフィール作成状態に応じたホームページの切り替え  
◯グループの作成、参加、退出、検索  
◯グループ作成者のみができる、グループの削除、強制退出処理  
◯モデルにて6桁のグループのパスワードと12桁の画像IDの自動生成  
◯グループのパスワード確認、パスワードのコピー  
◯グループサムネイル、プロフィールサムネイルの画像アップロード（S3へ保存）  
◯グループ、プロフィールの編集処理  
◯モーダルウインドウ  
◯処理中のロード表示  
◯処理後のフラッシュメッセージ  
◯各マイページにコメント投稿、いいね機能  
◯エラーの際、ステータスコードに応じたエラーページに切り替える  
  
# 4. 使用技術一覧  
  
**◯インフラ**  
  
**開発環境**
Docker /docker-compose  
データベース Postgres  

**本番環境**  
AWS(ECS, EC2, ECR, RDS for postgres, VPC, S3, ALB, Route53, CloudWatch)   
  
**AWS アーキテクチャ図**    
自分で書きました。  
![AWS アーキテクチャ図](https://introductionapp.s3-ap-northeast-1.amazonaws.com/vue/intro-app-vue_AWS_Architecture.jpg)  
  
**CI/CD（CicleCI/CD）**  
CI・・・プッシュ時にPHPUnitが自動で実行される  
CD・・・Dockerfileより自前のイメージを作成し、そのイメージをOrbsを利用しECRへ自動プッシュし、そしてそれをECSへ自動デプロイする  
  
**ER図**  
自分で書きました。  
![ER図](https://introductionapp.s3-ap-northeast-1.amazonaws.com/vue/Intro-app-vue_er+(3).png)  
  
補足  
Q UsersとProfilesを紐付けてるけど、users.nameとprofiles.nameの違いは？  
→2つデータ存在してるんじゃないか  
A このアプリは、最終的に一人のユーザーが多数のプロフィールを所有することができ、グループに応じてプロフィールを使い分けることができる仕様にしたいので、ユーザーネームとプロフィールネームを分ける必要があった  
  
Q photos, comments, likesのFKをusersではなくprofilesにしている理由は？  
→一般的なDB設計であればusersを紐付けるはず  
A 上の理由と同じで、一人のユーザーが複数のプロフィールを所持しているので、そのプロフィールごとに、写真やコメント、いいねを付与していきたいため  
  
Q Photosにprofilesとgroupsの両方を紐付けたのはアップロードした人とグループと2つ保存したいから？  
→上記の理由であれば良し  
A LINEと同じようにプロフィールとグループのどちらにも写真を設定できるようにした。  
    
**◯使用言語**  
PHP,JavaScript, Sass  

**◯フレームワーク**  
Laravel, Vue.js  

**◯ライブラリ**  
Vuex（状態管理）    
micromodal（モーダル）    
vue-click-outside（要素以外のクリック時にイベント発火）    
vue-clipboard2（クリップボードへデータを保存）    

**◯プラグイン**  
VueRouter（ルーティングの制御）  

**◯その他の技術**  
・セッション管理は、AWS ALBによるトラフィックの負荷分散とスティッキーセッションによるユーザーごとにサーバーを固定する  
・Vue.js と Laravel を組み合わせたSPAの構築  
・SPA におけるクッキー認証と CSRF 対策  
・Vue Router を使用した画面遷移  
・Vuex を使用した状態管理  
・Vue でのタブやローディング UI の表現  
・SPA におけるエラー処理  
・ミドルウェアによるページ認証  
・PolicyとGateの使用  
・LaravelからS3へファイルの保存  
・レスポンシブデザイン  

# 5. 苦労した箇所  
  
**インフラの構築**  
  
ECSの場合、EC2だけの使用よりも少し難度が上がり、コンテナが何度も落ちるのを経験しました。  
コンテナが落ちる大きな原因は、Dockerfileの記述ミスでした。  
**Dockerfileを理解して自分で書けるようになることはかなり大変でしたが、何とか設計することができ、今ではDockerfileの内容も理解し安定してコンテナを走らせられるようになりました。**  
  
**CircleCI/CD**  
  
CircleCIは新しい技術でバージョンアップも頻繁に起こるので、文法ミスやパラメーター不足などの幾つものエラーと向き合いました。  
また開発環境とCircleCI環境の差異にも苦労しました。  
この差異によってDockerfileを調整したり、新たにインストールしなければならないものもあり、その対応に結構苦労しました。  
  
**SPA構築**  
  
アプリを完全にSAP化するには、思ったよりも多いコード量が必要で最初は苦労しました。  
しかしやっていくうちに、コンポーネント間のデータのやりとりやVuexを用いたデータの保管などにうまく対応できるようになりました。  
  

# 6. 今後追加したい機能  
  
自分のポートフォリオの見劣りする部分として、機能数が少なめ点があげられます。  
（ある程度基礎的な機能を実装した時点で、次に追加したい頭に浮かんだ機能もだいたいこれまでのロジックを応用すればできそうと考え、SPA化だったりインフラの構築など新たな知識の習得に走ったのが原因です）  
  
今後追加したい機能としては、  
・ユーザーがプロフィールを複数作成でき、参加するグループごとにプロフィールを使い分けることができる  
・グループ作成者が、グループ参加者に対してカスタマイズしたプロフィールを記入してもらうことができる  
・プロフィールとSNSとの連携  
・プロフィールに画像を複数枚掲載できる  
・チャット機能  
などです。  

# 7. アプリの使い方（一部分のみ抜粋）  

①ゲストログインボタンを押してゲストログインする（ゲストユーザーというユーザーネームでログインできる）   
②グループ一覧画面に遷移し、すでに所属しているグループ（あらかじめ用意）が一覧で表示される。  
③グループをタップすると、グループに所属しているユーザーのプロフィール（自分も含めた）が一覧として表示される。   
④自分のプロフィールの編集上にある編集ボタンを押すことで編集できる（自由に変更可）。  
⑤ドロップダウンをタップし、自分のユーザー名をタップすると、マイページに遷移する。マイページには、他のユーザーから寄せられたコメント一覧といいねが表示される（自由にコメントやいいね可）。  
⑥グループの中のプロフィール一覧で、他ユーザーのプロフィールをタップすると、マイページと同じように、そのユーザーのプロフィール詳細が表示され、寄せられたコメントやいいねが一覧で表示される（自由にコメントやいいね可）。  
  
⑦会員登録し新たなユーザーを作成した場合、自由にアプリを操作可能です。（プロフィールの作成、グループの作成、グループの編集、グループへの参加、グループの退会、など）  
  
・会員登録する際は以下の形で登録できます。    
メール:　メールの形式になっていれば何でもよい。（例　hello@email.com）   
パスワード: 8文字以上であれば何でもよい。  
  
・グループへ参加するときは、以下から試せます（あらかじめテストグループを用意しておきました）    
グループ名　テストグループ  
パスワード　CfRsha  

# 8. アプリケーションの制作背景 

**◯問題点の発見**
  
僕は尾崎豊が好きで、それが高じて尾崎豊に関するイベントのようなものを開催するようになりました。  
インスタグラム（https://instagram.com/ozamiyo2018?igshid=1q30651t32rza）  

イベントを運営していく上で、ある問題点に気が付きました。  
それは、**参加者どうしがイベント当日まで相手の情報をほとんど何も知らない**ということです。これは様々なデメリットと紐付いています。  
  
例えば、  
・イベント参加の心理的ハードルが高くなる（特に初参加者は、顔や名前をほとんど知らない人たちの中に一人で参加しなければならず、参加するだけで一定の勇気やストレスがかかることが想像される）  
・当日、会話が進みにくい（イベント自体の盛り上がりが減少する）  
・既存の参加者は初参加者の詳細を知らないためサポートしずらい（初参加者が孤立する可能性がある）  
これが重なると、イベントの質は下降線をたどることが予想されます。  
  
**◯解決案**  
  
そこで、もし自由にグループを作成でき、その中でお互いのプロフィールを自由に共有することができるアプリがあればこの問題は一気に解決するのではないかとふと考えました。    
あらかじめ参加者にプロフィールを作成しておいてもらい、作っておいたイベントグループに所属してもらうことで、初参加者は事前に相手の顔や趣味などのプロフィールを詳細に確認でき、コメントやいいねなどを通して事前に繋がり合うこともできます。    
そうすることで、**初めての方でもイベント参加の心理的ハードルは低いものになり、相手のことをある程度知っているので会話も円滑に進み、既存の参加者が積極的に初参加者のカバーもでき、結果総じてイベント自体の質が自然と上がります。**   
  
**◯まとめ**  
  
このような問題を解決するにあたって「自己紹介アプリ」の発見と作成をすることに至りました。    
  
**◯補足 LINEなどで一人ひとり自己紹介するのではダメなのか？**  
・イベントごとに一人ひとりが毎回自己紹介し合うのは、面倒だしやらない人も多数でてくる。その点自己紹介アプリは、一回プロフィールを作成しておきさえすればグループに参加するだけで自己紹介したことになる。また複数グループに参加する場合でも１つのプロフィールを使い回すことができる。      
・恐らく一言のみのため、詳細にプロフィールを確認することはできず、上に書いたデメリットは解決できない。  
・参加者が50人を超えるLINEグループでで一人ひとりが自己紹介するとトーク画面が忙しくなる。  

# 5. 補足    
プロフィールを複数作成できたり、ユーザー名とプロフィール名を分けたり、profilesテーブルにphotos,comments,likesテーブルが紐付いているのは、このアプリは最終的に一人のユーザーが多数のプロフィールを所有することができ、グループに応じてそのプロフィールを使い分けることができる仕様にしたいためです。
