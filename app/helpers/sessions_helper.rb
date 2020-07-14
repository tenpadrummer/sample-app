module SessionsHelper
  # 渡されたユーザーでログインする
  # ユーザーのブラウザ内の一時cookiesに暗号化済みのユーザーIDが自動で作成するコード
  def log_in(user)
    session[:user_id] = user.id
  end

  # ユーザーのセッションを永続的にする
  def remember(user)
    user.remember
    cookies.permanent.signed[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
  end

  # 記憶トークンcookieに対応するユーザーを返す
  def current_user
    if (user_id = session[:user_id])
      @current_user ||= User.find_by(id: user_id)
    elsif (user_id = cookies.signed[:user_id])
      user = User.find_by(id: user_id)
      if user && user.authenticated?(cookies[:remember_token])
        log_in user
        @current_user = user
      end
    end
  end

  # ユーザーがログイン中の状態とは「sessionにユーザーidが存在している」こと
  # ユーザーがログインしていればtrue、その他ならfalseを返す
  def logged_in?
    # nilかどうかをチェックする否定演算子「!」
    !current_user.nil?
  end

  # 現在のユーザーをログアウトする
  def log_out
    session.delete(:user_id)
    @current_user = nil
  end
end
