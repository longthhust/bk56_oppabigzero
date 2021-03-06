class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: [:show, :index]
  before_action :set_question, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @questions = Question.all
    respond_with(@questions)
  end

  def show
    respond_with(@question)
  end

  def new
    @question = Question.new user: current_user
    respond_with(@question)
  end

  def edit
    if (current_user != @question.user)
      redirect_to questions_path
      flash[:notice] = "他人の質問を編集できない"
    end
  end

  def create
    @question = Question.new(question_params.merge!({user: current_user}))
    @question.save
    respond_with(@question)
  end

  def update
      @question.update(question_params)
      respond_with(@question)
  end

  def destroy
    @question.destroy
    respond_with(@question)
  end

  private
    def set_question
      @question = Question.find(params[:id])
    end

    def question_params
      params.require(:question).permit(:title, :content)
    end
end
