class TodosController < ApplicationController
  before_action :set_todo, only: %i[ show edit update destroy ]

  def index
    @todos = Todo.order(:created_at)
  end

  def show
  end

  def new
    @todo = Todo.new
  end

  def edit
  end

  def create
    @todo = Todo.new(todo_params)

    respond_to do |format|
      if @todo.save
        format.turbo_stream
        format.html { redirect_to todos_path, notice: "Todo was successfully created." }
      else
        format.turbo_stream { render_form_error }
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @todo.update(todo_params)
        format.turbo_stream { render turbo_stream: turbo_stream.replace(helpers.dom_id(@todo), partial: "todo", locals: { todo: @todo }) }
        format.html { redirect_to todos_path, notice: "Todo updated successfully." }
      else
        format.turbo_stream { render_form_error }
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @todo.destroy!

    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.remove(helpers.dom_id(@todo)) }
      format.html { redirect_to todos_path, status: :see_other, notice: "Todo was successfully destroyed." }
    end
  end

  private
    def set_todo
      @todo = Todo.find(params[:id])
    end

    def todo_params
      params.require(:todo).permit(:title, :status)
    end

    def render_form_error
      render turbo_stream: turbo_stream.replace(
        "#{helpers.dom_id(@todo)}_form",
        partial: "form",
        locals: { todo: @todo }
      ), status: :unprocessable_entity
    end
end
