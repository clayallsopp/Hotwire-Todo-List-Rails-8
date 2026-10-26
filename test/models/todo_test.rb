require "test_helper"

class TodoTest < ActiveSupport::TestCase
  test "requires a title and a known status" do
    todo = Todo.new(title: "   ", status: "later")

    assert_not todo.valid?
    assert_includes todo.errors[:title], "can't be blank"
    assert_includes todo.errors[:status], "is not included in the list"
  end

  test "strips the title before saving" do
    todo = Todo.create!(title: "  Ship it  ", status: "incomplete")

    assert_equal "Ship it", todo.title
  end
end
