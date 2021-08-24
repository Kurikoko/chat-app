class UsersController < ApplicationController

  def edit
  end

  def update
    if current_user.update(user_params)
      #更新が成功した場合、トップページにリダイレクトする
      redirect_to root_path
    else
      #更新に失敗した場合、入力の値はそのままに編集画面へ遷移する
      render :edit
      # :editアクションを指定することで、「編集画面を表示する」
    end

  end

  private

  def user_params
    params.require(:user).permit(:name, :email)
  end
end
