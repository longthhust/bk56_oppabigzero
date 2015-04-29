class AnswersController < ApplicationController
  #before_action :authenticate_user!,only: [:edit,:update,:destroy,:new,:create]
  before_action :authenticate_user!, except: [:show, :index]
  before_action :set_question
  before_action :set_answer, only: [:show, :edit, :update, :destroy]
  before_action :correct_user,   only: [:edit, :update, :destroy]

  respond_to :html

  def index
    @answers = @question.answers.all
    respond_with(@question, @answers)
  end

  def show
    respond_with(@question, @answer)
  end

  def new
    @answer = @question.answers.new user: current_user
    respond_with(@question, @answer)
  end

  def edit
  end

  def create
    #@answer = Answer.new(answer_params.merge!({question: @question}))
    @answer = @question.answers.new({user: current_user}.merge!(answer_params))
    @answer.save
    respond_with(@question, @answer)
  end

  def update
    @answer.update(answer_params)
    respond_with(@question, @answer)
  end

  def destroy
    @answer.destroy
    respond_with(@question, @answer)
  end

  private
    def set_question
      @question = Question.find(params[:question_id])
    end

    def set_answer
      @answer = @question.answers.find_by(id: params[:id])
    end

    def correct_user
      @user = @answer.user
      if (current_user != @user)
        redirect_to root_url
        flash[:notices] = "他人の回答を編集できない"
      end
    end

    def answer_params
      params.require(:answer).permit(:question_id, :content)
    end
end
