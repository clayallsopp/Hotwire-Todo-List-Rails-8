require "test_helper"

class TodosControllerTest < ActionDispatch::IntegrationTest
  setup do
    @todo = todos(:one)
  end

  test "should get index" do
    get todos_url
    assert_response :success
  end

  test "should get new" do
    get new_todo_url
    assert_response :success
  end

  test "should create todo" do
    assert_difference("Todo.count") do
      post todos_url, params: { todo: { status: "incomplete", title: "Fresh task" } }
    end

    assert_redirected_to todos_url
  end

  test "should append a todo over turbo stream" do
    assert_difference("Todo.count") do
      post todos_url, params: { todo: { status: "incomplete", title: "Streamed task" } }, as: :turbo_stream
    end

    assert_response :success
    assert_includes response.body, "Streamed task"
    assert_includes response.body, "todos-list"
  end

  test "should not create a blank todo" do
    assert_no_difference("Todo.count") do
      post todos_url, params: { todo: { status: "incomplete", title: "  " } }, as: :turbo_stream
    end

    assert_response :unprocessable_entity
    assert_includes response.body, "Title can&#39;t be blank"
  end

  test "should show todo" do
    get todo_url(@todo)
    assert_response :success
  end

  test "should get edit" do
    get edit_todo_url(@todo)
    assert_response :success
  end

  test "should update todo" do
    patch todo_url(@todo), params: { todo: { status: "complete", title: "Updated task" } }
    assert_redirected_to todos_url
    assert_equal "complete", @todo.reload.status
    assert_equal "Updated task", @todo.title
  end

  test "should replace a todo over turbo stream" do
    patch todo_url(@todo), params: { todo: { status: "complete" } }, as: :turbo_stream

    assert_response :success
    assert_equal "complete", @todo.reload.status
    assert_includes response.body, "turbo-stream"
    assert_includes response.body, "[x]"
  end

  test "should destroy todo" do
    assert_difference("Todo.count", -1) do
      delete todo_url(@todo)
    end

    assert_redirected_to todos_url
  end

  test "should remove a todo over turbo stream" do
    assert_difference("Todo.count", -1) do
      delete todo_url(@todo), as: :turbo_stream
    end

    assert_response :success
    assert_includes response.body, %(target="#{ActionView::RecordIdentifier.dom_id(@todo)}")
  end
end
