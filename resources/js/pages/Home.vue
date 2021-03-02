<template>
  <div class="home">
    <nav class="initial-page">
      <div class="mainview">
        <div class="text-block">
          <h1 class="heading">好きなグループに参加し、<br>プロフィールを共有してみよう！</h1>
          <p class="discription">入ったことのないコミュニティーに参加するのはどんな人がいるのか不安。<br><br>大人数のコミュニティーになると一人一人把握するのは難しい。<br><br>自己紹介アプリを使ってお互いのことを深く理解し心の距離を縮めてみましょう！</p>
          <RouterLink
            v-if="isLogin && checkProfile"
            :to="`/mypage/${this.$store.getters['auth/userid']}/groups`"
            class="start-btn"
          >
          グループ一覧ページへ
          </RouterLink>
          <RouterLink
            v-else-if="isLogin"
            to="/profile/create"
            class="start-btn"
          >
          プロフィール設定へ
          </RouterLink>
          <RouterLink
            v-else
            to="/login"
            class="start-btn"
          >
          いますぐはじめる
          </RouterLink>
        </div>
        <div class="image-block">
          <img class="right-block__image" src="https://introduction-app.s3-ap-northeast-1.amazonaws.com/app-images/intro-app_movie_1.gif">
        </div>
      </div>
      <div class="about-service-block">
        <h3 class="heading">お互いを深く理解し交流し合えるコミュニティープラットフォーム</h3>
        <div class="about-service-block__item__wrapper">
          <div class="about-service-block__item">
            <div class="heading">自由にグループを作成できる</div>
            <img src="https://introduction-app.s3-ap-northeast-1.amazonaws.com/app-images/create-group.jpg">
            <p class="discription">誰でも自由にグループを作成することができます。<br>新しいコミュニティーを立ち上げたり、既存のコミュニティー内の交流を活発化させたいときおすすめです。</p>
          </div>
          <div class="about-service-block__item">
            <div class="heading">グループを検索して参加できる</div>
            <img src="https://introduction-app.s3-ap-northeast-1.amazonaws.com/app-images/serch-group.jpg">
            <p class="discription">グループ名とパスワードさえ知っていればグループに参加することができます。<br>自分の入りたいグループにいくつでも参加することができます。</p>
          </div>
          <div class="about-service-block__item">
            <div class="heading">グループ内の人たちと交流できる</div>
            <img src="https://introduction-app.s3-ap-northeast-1.amazonaws.com/app-images/friends.jpg">
            <p class="discription">グループ内に入ったらそのグループ参加者のプロフィールが一覧で表示されます。<br>そのプロフィールをクリックすることでプロフィール詳細画面に移り、そこでコメントなどしてユーザーどうし交流することができます。</p>
          </div>
        </div>
      </div>
    </nav>
  </div>
</template>

<script>

export default {

  computed: {
    isLogin() {
      return this.$store.getters['auth/check']
    },
    checkProfile() {
      return this.$store.getters['profile/check']
    }
  }
}

</script>
