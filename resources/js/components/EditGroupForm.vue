<template>
  <div class="edit-group">
    <!-- ローディング -->
    <div class="loading" v-show="loading">
      <Loader>ロード中・・・</Loader>
    </div>
    <!-- フォーム -->
    <form class="form" v-if="!loading" @submit.prevent="submit">
      <div class="tittle">グループ編集ページ</div>
      <!-- 送信エラー -->
      <div class="errors" v-if="errors">
        <ul class="errors__list" v-if="errors.photo">
          <li class="errors__item" v-for="msg in errors.photo" :key="msg">{{ msg }}</li>
        </ul>
        <ul class="errors__list" v-if="errors.name">
          <li class="errors__item" v-for="msg in errors.name" :key="msg">{{ msg }}</li>
        </ul>
        <ul class="errors__list" v-if="errors.introduction">
          <li class="errors__item" v-for="msg in errors.introduction" :key="msg">{{ mag }}</li>
        </ul>
      </div>
      <!-- ファイル選択エラー -->
      <div class="errors" v-if="fileErrors.length">
        <ul class="errors__list">
          <li class="errors__item" v-for="msg in fileErrors" :key="msg">{{ msg }}</li>
        </ul>
      </div>
      <div class="form-photo">
        <!-- 画像選択 -->
        <input id="edit-group-input" class="form-photo__input" type="file" @change="onFileChange" name="photo">
        <!-- プレビュー -->
        <div class="form-photo__output--true" v-if="preview">
          <img :src="preview">
        </div>
        <div class="form-photo__output--false" v-else>
          <div class="form-photo-img" v-if="editGroup.photo">
            <img :src="editGroup.photo.url">
          </div>
          <div class="form-photo-img" v-else>
            <img src="https://introduction-app.s3-ap-northeast-1.amazonaws.com/groups/group_img.png">
          </div>
        </div>
      </div>
      <div class="form-text">
        <label class="form-text__label" for="name">グループ名</label>
        <input class="form-text__input" type="text" id="name" name="name" v-model="text.name">
      </div>
      <!-- ボタン -->
      <div class="btn-group">
        <button class="cancel" @click="cancel">キャンセル</button>
        <button class="submit" type="submit">完了</button>
      </div>
    </form>
  </div>
</template>

<script>
import { OK, CREATED, UNPROCESSABLE_ENTITY } from '../util.js'
import Loader from './Loader.vue'

export default {
  components: {
    Loader
  },
  data() {
    return {
      preview: null,
      photo: null,
      text: {
        name: `${ this.editGroup.name }`
      },
      errors: null,
      fileErrors: [],
      loading: false,
    }
  },
  props: {
    id: {
      type: Number,
      required: true
    },
    group: {
      type: Number,
      required: true
    },
    editGroup: {
      type: Object,
      required: true
    }
  },
  computed: {
    noEdit() {
      return this.photo === null && this.text.name === `${ this.editGroup.name }`
    }
  },
  methods: {
    //フォームでファイルが選択されたら実行
    onFileChange(event) {
      //ファイルに関するエラーメッセージをクリア
      this.fileErrors.length = 0

      if(event.target.files.length === 0) {
        this.reset()
        return false
      }

      if(! event.target.files[0].type.match('image.*')) {
        this.reset()
        return false
      }

      const reader = new FileReader()

      reader.onload = e => {
        this.preview = e.target.result
      }

      //ファイルを選択した時点でバリデーションをかける
      this.checkFile(event)

      reader.readAsDataURL(event.target.files[0])
      this.photo = event.target.files[0]
    },

    //選択ファイルのバリデーション
    checkFile(event) {
      //選択されたファイルの拡張子を取得
      var filename = event.target.files[0].name
      var position = filename.lastIndexOf('.')
      var extension = filename.slice(position + 1)
      //拡張子を小文字に変換
      var extLowerCase = extension.toLowerCase()
      const extensions = new Array('jpg','jpeg','png','gif','heic')
      const limit = 2000000
      var fileSize = event.target.files[0].size
      //ファイルエラーテキストの生成
      if(extLowerCase === 'heic') {
        this.fileErrors.push('拡張子HEICはPC上では扱えません（スマホでは扱えます）。')
      }
      if (extensions.indexOf(extLowerCase) === -1) {
        this.fileErrors.push('ファイルの拡張子は「jpg,jpeg,png,gif,heic」しか使用できません。')
      }
      if (fileSize > limit) {
        this.fileErrors.push('ファイルサイズが大きすぎる可能性があります')
      }
    },

    // 直前の入力をクリアする
    reset() {
      window:onload = () => {
        this.preview = ''
        this.photo = null
        this.$el.querySelector('#edit-profile-input').value = null
      }
    },

    // 編集処理へ
    async submit() {

    //何も編集をせず完了ボタンを押した場合、前のページにリダイレクトする
    if(this.noEdit) {
        this.$store.commit('message/setSuccessContent', {
          successContent: "編集は行われませんでした",
          timeout: 6000
        })
        this.cancel()
        return false
      }

      this.loading = true

      const formData = new FormData()

      if(this.photo) {
        formData.append('photo', this.photo)
      }

      formData.append('name', this.text.name)

      //グループ編集
      const response = await axios.post(`/api/mypage/${ this.id }/groups/${ this.group }/edit`, formData)

      this.loading = false

      //バリデーションエラーの場合は、エラーメッセージを表示する関係から、入力欄やプレビューのリセットの前にリターンする
      if(response.status === UNPROCESSABLE_ENTITY) {
        this.errors = response.data.errors
        this.$store.commit('message/setErrorContent', {
          errorContent: "グループの編集に失敗しました",
          timeout: 6000
        })
        return false
      }

      this.reset()

      if(response.status !== CREATED) {
        this.$store.commit('error/setCode', response.status)
        this.$store.commit('message/setErrorContent', {
          errorContent: "グループの編集に失敗しました",
          timeout: 6000
        })
        return false
      }

      this.$router.push(`/mypage/${ this.id }/groups`)
      this.$store.commit('message/setSuccessContent', {
        successContent: "グループの編集に成功しました",
        timeout: 6000
      })

    },
    cancel() {
      this.reset()
      this.$router.push(`${ this.$store.state.route.prevRoute.path}`)
    }
  }
}
</script>
