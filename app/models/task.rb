class Task < ApplicationRecord
  self.table_name = 'tasks'
  self.primary_key = 'id'

  validates :title, presence: true, length: { minimum: 1 }
  validates :description, presence: true, length: { minimum: 1 }
  validates :isCompleted, presence: false, inclusion: { in: [true, false] }
  validates :user_id, presence: true, numericality: { only_integer: true, greater_than: 0 }

  belongs_to :user, foreign_key: 'user_id'
end
