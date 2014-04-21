module Forem
  class ForumsController < Forem::ApplicationController
    load_and_authorize_resource :class => 'Forem::Forum', :only => [:show, :subscribe, :unsubscribe]
    helper 'forem/topics'

    def index
      @categories = Forem::Category.all
    end

    def show
      register_view

      @topics = if forem_admin_or_moderator?(@forum)
        @forum.topics
      else
        @forum.topics.visible.approved_or_pending_review_for(forem_user)
      end

      @topics = @topics.by_pinned_or_most_recent_post.page(params[:page]).per(Forem.per_page)

      respond_to do |format|
        format.html
        format.atom { render :layout => false }
      end
    end

    def subscribe
      @forum.subscribe_user(forem_user.id)
      flash[:notice] = t("forem.forum.subscribed")
      redirect_to forum_path(@forum)
    end

    def unsubscribe
      @forum.unsubscribe_user(forem_user.id)
      flash[:notice] = t("forem.forum.unsubscribed")
      redirect_to forum_path(@forum)
    end

    private
    def register_view
      @forum.register_view_by(forem_user)
    end
  end
end
