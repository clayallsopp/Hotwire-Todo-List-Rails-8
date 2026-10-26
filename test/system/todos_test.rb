require "application_system_test_case"

class TodosTest < ApplicationSystemTestCase
  setup do
    @todo = todos(:one)
  end

  test "visiting the index" do
    visit todos_url
    assert_selector "h1", text: "Todos"
    assert_text @todo.title
  end

  test "creating completing and deleting a todo" do
    visit todos_url

    fill_in "Item", with: "Ship the demo"
    click_on "Add"

    assert_text "Ship the demo"
    assert_field "Item", with: ""

    within(".todo-item", text: "Ship the demo") do
      click_on "Complete"
    end
    within(".todo-item", text: "Ship the demo") do
      assert_text "[x]"
      accept_confirm { click_on "Delete" }
    end

    assert_no_text "Ship the demo"
  end

  test "rejects a blank todo" do
    visit todos_url
    count = all(".todo-item").size

    click_on "Add"

    assert_text "Title can't be blank"
    assert_equal count, all(".todo-item").size
  end

  test "editing a todo" do
    visit edit_todo_url(@todo)

    fill_in "Item", with: "Renamed task"
    select "Complete", from: "Status"
    click_on "Save"

    assert_current_path todos_path
    assert_text "Todo updated successfully."
    assert_selector ".todo-title.completed", text: "Renamed task"
  end

  test "live updates can be completed and deleted in another tab" do
    visit todos_url
    assert_selector "turbo-cable-stream-source[connected]", visible: :all

    Capybara.using_session(:viewer) do
      visit todos_url
      assert_selector "turbo-cable-stream-source[connected]", visible: :all
    end

    fill_in "Item", with: "Live task"
    click_on "Add"
    assert_text "Live task"

    Capybara.using_session(:viewer) do
      assert_text "Live task", wait: 5
      within(".todo-item", text: "Live task") do
        click_on "Complete"
      end
      within(".todo-item", text: "Live task") do
        assert_text "[x]"
        accept_confirm { click_on "Delete" }
      end
      assert_no_text "Live task"
    end

    assert_no_text "Live task", wait: 5
  end
end
