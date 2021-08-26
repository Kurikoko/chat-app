class MessagesController < ApplicationController
 
  def index
    @message = Message.new
    # ルーティングのネストから親Roomモデルのidパラメーター取得し、そのidのレコードのみインスタンス変数へ格納
    @room = Room.find(params[:room_id])
    # ルームのコメントを全て取得、ユーザー情報はN+1問題回避の為にincludes
    @messages = @room.messages.includes(:user)
  end

  def create
    # indexのコメントと同様
    @room = Room.find(params[:room_id])
    #ルーム内コメントパラメーターを取得
    @message = @room.messages.new(message_params)
    # コメントを保存できれば、そのまま、できなかたら入力情報保持したままそのまま
    if @message.save
      redirect_to room_messages_path(@room)
    else 
      # indexアクションが起きないのでここで@messagesを定義
      @messages = @room.messages.includes(:user)
      # 情報を保持したままindexに戻る
      render :index
    end
  end

  private
    # メッセージフォームのcontentをストロングパラメーター設定
    # ログインしているユーザーに紐付いたcontentを取得できるよう許可
    def message_params
      params.require(:message).permit(:content, :image).merge(user_id: current_user.id)
    end

end
