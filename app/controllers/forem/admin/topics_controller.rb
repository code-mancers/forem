module Forem
  module Admin
    class TopicsController < BaseController
      before_filter :find_topic

      def update
        authorize!(:update, @topic)

        if @topic.update_attributes(topic_params)
          flash[:notice] = t("forem.topic.updated")
          redirect_to forum_topic_path(@topic.forum, @topic)
        else
          flash.alert = t("forem.topic.not_updated")
          render :action => "edit"
        end
      end

      def destroy
        authorize!(:destroy, @topic)

        forum = @topic.forum
        @topic.destroy
        flash[:notice] = t("forem.topic.deleted")
        redirect_to forum_topics_path(forum)
      end

      def toggle_hide
        authorize!(:update, @topic)

        @topic.toggle!(:hidden)
        flash[:notice] = t("forem.topic.hidden.#{@topic.hidden?}")
        redirect_to forum_topic_path(@topic.forum, @topic)
      end

      def toggle_lock
        authorize!(:update, @topic)

        @topic.toggle!(:locked)
        flash[:notice] = t("forem.topic.locked.#{@topic.locked?}")
        redirect_to forum_topic_path(@topic.forum, @topic)
      end

      def toggle_pin
        authorize!(:update, @topic)

        @topic.toggle!(:pinned)
        flash[:notice] = t("forem.topic.pinned.#{@topic.pinned?}")
        redirect_to forum_topic_path(@topic.forum, @topic)
      end

      private
        def find_topic
          @topic = Forem::Topic.find(params[:id])
        end

        def topic_params
          params.require(:topic).permit(:subject, :pinned, :locked, :hidden,
            :forum_id, :posts_attributes => [:text] )
        end
    end
  end
end
