class TopicsController < ApplicationController
 before_action :authenticate_user!
 before_action :set_topic, only: [:show, :edit, :update, :destroy]
   def index
  @topics = Topic.all
   respond_to do |format|
   format.html
    format.js
   end
  end

  # showアククションを定義します。入力フォームと一覧を表示するためインスタンスを2つ生成します。
   def show
     @topic = Topic.new
    @comment = @topic.comments.build
    @comments = @topic.comments
    Notification.find(params[:notification_id]).update(read: true) if params[:notification_id]
  end


  def new
    if params[:back]
      @topic = Topic.new(topics_params)

    else
      @topic = Topic.new
    end
  end


 def create
    @topic = Topic.new(topics_params)
    @topic.user_id = current_user.id
    @topic.frontcover.retrieve_from_cache! params[:cache][:frontcover_cache] if params[:cache][:frontcover_cache].present?
    @topic.save!

    if @topic.save
      # 一覧画面へ遷移して"ブログを作成しました！"とメッセージを表示します。
      redirect_to topics_path, notice: "トッピクを作成しました！"
      NoticeMailer.sendmail_topic(@topic).deliver
    else
      # 入力フォームを再描画します。
      render 'new'
    end
 end


     def edit

      if @topic.user_id != current_user.id
      redirect_to topics_path, notice: "権限がないため編集できません"
     else

     end
     end



  def update

    if @topic.update(topics_params)
    redirect_to topics_path
    else
     render 'edit'
    end
  end

  def destroy
    if @topic.user_id == current_user.id
     @topic.destroy
     redirect_to topics_path, notice: "ブログを削除しました！"
    else redirect_to topics_path, notice: "権限がないため編集できません"
    end

  end

  def confirm
   @topic = Topic.new(topics_params)
   @topic.frontcover.cache!
    render :new if @topic.invalid?

  end



   private
    def topics_params
      params.require(:topic).permit(:title,:content,:image,:frontcover)
    end
    def set_topic
      @topic = Topic.find(params[:id])
    end
end
