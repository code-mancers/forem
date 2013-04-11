module Forem
  module Admin
    class GroupsController < BaseController
      before_filter :find_group, :only => [:show, :destroy]

      def index
        @groups = Forem::Group.accessible_by(current_ability)
      end

      def new
        @group = Forem::Group.new
      end

      def create
        @group = Forem::Group.new(group_params)
        authorize!(:create, @group)

        if @group.save
          flash[:notice] = t("forem.admin.group.created")
          redirect_to [:admin, @group]
        else
          flash[:alert] = t("forem.admin.group.not_created")
          render :new
        end
      end

      def destroy
        authorize!(:destroy, @group)

        @group.destroy
        flash[:notice] = t("forem.admin.group.deleted")
        redirect_to admin_groups_path
      end

      private

        def find_group
          @group = Forem::Group.find(params[:id])
        end

        def group_params
          params.require(:group).permit(:name)
        end
    end
  end
end
