$(function() {

    // 編集アイコンクリックでIDを取得してswitchToEdit関数を呼び出し
    // e.preventDefault();でaタグ#の機能を削除
    // .on(イベント, 対象(idなど), 動作(変数や関数など))
    // data属性のdata-comment-idから.data("comment-id")で<%= comment-id %>を取得
  $(document).on("click", '.js-edit-comment-button', function(e) {
      e.preventDefault();
      const commentId = $(this).data("comment-id")
      switchToEdit(commentId)
  })

  // エラーメッセージがあればクリアする
  // ベースは上のclickイベントと同じ
  $(document).on("click", '.js-button-edit-comment-cancel', function() {
      clearErrorMessages()
      const commentId = $(this).data("comment-id")
      switchToLabel(commentId)
  })

  // .catchに失敗した場合の処理を記載する
  // 失敗した際に.thenも通過するが最終的なresultは.catchに記述した内容になる
  // submitComment(Promise)がrejectを抱えていると.catchが作動するイメージ
  // bad_requestの場合はresult.responseJSONで
  $(document).on("click", '.js-button-comment-update', function() {
      clearErrorMessages()
      const commentId = $(this).data("comment-id")
      submitComment($("#js-textarea-comment-" + commentId).val(), commentId)
          .then(result => {
              debugger
              $("#js-comment-" + result.comment.id).html(result.comment.body.replace(/\r?\n/g, '<br>'))
              switchToLabel(result.comment.id)
          })
          .catch(result => {
              const commentId = result.responseJSON.comment.id
              const messages = result.responseJSON.errors.messages
              showErrorMessages(commentId, messages)
          })
  })

  // キャンセルを押した場合に元の表示に戻す
  function switchToLabel(commentId) {
      $("#js-textarea-comment-box-" + commentId).hide()
      $("#js-comment-" + commentId).show()
  }

  // 編集アイコンを押した場合に編集画面を出す
  function switchToEdit(commentId) {
      $("#js-comment-" + commentId).hide()
      $("#js-textarea-comment-box-" + commentId).show()
  }

  // pタグにerrors.messagesを入れてtextareaの前に挿入する
  function showErrorMessages(commentId, messages) {
      $('<p class="error_messages text-danger">' + messages.join('<br>') + '</p>').insertBefore($("#js-textarea-comment-" + commentId))
  }

  // new Promiseを定義する
  // .ajaxでcomments_controllerのupdateメソッドに非同期通信
  // statusがbad_requestの場合は.failも通過してrejectがPromiseに戻る
  function submitComment(body, commentId) {
      return new Promise(function(resolve, reject) {
          $.ajax({
              type: 'PATCH',
              url: '/comments/' + commentId,
              data: {
                  comment: {
                      body: body
                  }
              }
          }).done(function (result) {
              resolve(result)
          }).fail(function (result) {
              reject(result)
          });
      })
  }

  // pタグで生成したerror_messagesをremoveする
  function clearErrorMessages() {
      $("p.error_messages").remove()
  }
});
