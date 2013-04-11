module Forem
  module Admin
    class CategoriesController < BaseController
      before_filter :find_category, :only => [:edit, :update, :destroy]

      def index
        @category = Forem::Category.accessible_by(current_ability)
      end

      def new
        @category =  Forem::Category.new
      end

      def create
        @category = Forem::Category.new(category_params)
        authorize!(:create, @category)

        if @category.save
          flash[:notice] = t("forem.admin.category.created")
          redirect_to admin_categories_path
        else
          flash.now.alert = t("forem.admin.category.not_created")
          render :action => "new"
        end
      end

      def update
        authorize!(:update, @category)

        if @category.update_attributes(category_params)
          flash[:notice] = t("forem.admin.category.updated")
          redirect_to admin_categories_path
        else
          flash.now.alert = t("forem.admin.category.not_updated")
          render :action => "edit"
        end
      end

      def destroy
        authorize!(:destroy, @category)

        @category.destroy
        flash[:notice] = t("forem.admin.category.deleted")
        redirect_to admin_categories_path
      end

      private
        def find_category
          @category = Forem::Category.find(params[:id])
        end

        def category_params
          params.require(:category).permit(:name)
        end
    end
  end
end
