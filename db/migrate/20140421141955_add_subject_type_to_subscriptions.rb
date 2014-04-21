class AddSubjectTypeToSubscriptions < ActiveRecord::Migration
  def change
    add_column :forem_subscriptions, :subject_type, :string

    begin
      Forem::Subscription.update_all({:subject_type => 'Forem::Topic'}, Forem::Subscription.arel_table[:topic_id].not_eq(nil))
    rescue ActiveRecord::StatementInvalid
    end
  end
end
