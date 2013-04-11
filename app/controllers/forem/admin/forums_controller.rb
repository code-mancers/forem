module Forem
  module Admin
    class ForumsController < BaseController
      before_filter :find_forum, :only => [:edit, :update, :destroy]

      def index
        @forums = Forem::Forum.accessible_by(current_ability)
      end

      def new
        @categories = Forem::Category.accessible_by(current_ability)
        @forum = Forem::Forum.new
      end

      def create
        @forum = Forem::Forum.new(forum_params)
        authorize!(:create, @forum)

        if @forum.save
          flash[:notice] = t("forem.admin.forum.created")
          redirect_to admin_forums_path
        else
          @categories = Forem::Category.accessible_by(current_ability)
          flash.now.alert = t("forem.admin.forum.not_created")
          render :action => "new"
        end
      end

      def edit
        @categories = Forem::Category.accessible_by(current_ability)
      end

      def update
        authorize!(:update, @forum)

        if @forum.update_attributes(forum_params)
          flash[:notice] = t("forem.admin.forum.updated")
          redirect_to admin_forums_path
        else
          @categories = Forem::Category.accessible_by(current_ability)
          flash.now.alert = t("forem.admin.forum.not_updated")
          render :action => "edit"
        end
      end

      def destroy
        authorize!(:destroy, @forum)

        @forum.destroy
        flash[:notice] = t("forem.admin.forum.deleted")
        redirect_to admin_forums_path
      end

      private

        def find_forum
          @forum = Forem::Forum.find(params[:id])
        end

        def forum_params
          params.require(:forum).permit(:category_id, :title, :name,
            :description, :moderator_ids => [])
        end
    end
  end
end
