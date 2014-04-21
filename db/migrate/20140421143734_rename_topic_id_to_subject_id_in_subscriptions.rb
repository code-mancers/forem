class RenameTopicIdToSubjectIdInSubscriptions < ActiveRecord::Migration
  def change
    rename_column :forem_subscriptions, :topic_id, :subject_id
  end
end
