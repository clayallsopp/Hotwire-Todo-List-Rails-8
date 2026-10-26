class Todo < ApplicationRecord
  STATUSES = %w[incomplete complete].freeze

  validates :title, presence: true
  validates :status, inclusion: { in: STATUSES }

  before_validation :normalize_title

  after_create_commit -> { broadcast_append_to "todos", target: "todos-list" }
  after_update_commit -> { broadcast_replace_to "todos" }
  after_destroy_commit -> { broadcast_remove_to "todos" }

  private
    def normalize_title
      self.title = title.to_s.strip
    end
end
