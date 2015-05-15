class AnswersController < ApplicationController
  include SessionsHelper
  
  before_filter :signed_in_user, only: [:create, :destroy, :pick_answer, :vote]

  # POST /answers
  # POST /answers.json
  def create
    @question =Question.find(params[:question_id])
    @answer = @question.answers.build(answer_params)
    @answer.user=current_user
    if @answer.save
      redirect_to @question
    else
      render 'questions/show'
  end

  def pick_answer
    answer = Answer.find(params[:answer_id])
    if current_user?(answer.question.user)

  end
  def update
    @answer.question = @question
    respond_to do |format|
      if @answer.update(answer_params)
        format.html { redirect_to @answer.question, notice: 'Answer was successfully updated.' }
        format.json { render 'question/show', status: :ok, location: @answer }
      else
        format.html { render :edit }
        format.json { render json: @answer.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @question = @answer.question
    @answer.destroy
    respond_to do |format|
      format.html { redirect_to @question, notice: 'Answer was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_answer
      @answer = Answer.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def answer_params
      params.require(:answer).permit(:question_id, :title, :content)
    end
end