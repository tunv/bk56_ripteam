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
end

  def pick_answer
    answer = Answer.find(params[:answer_id])
    if current_user?(answer.question.user)
      prev_pick =answer.question.answers.where(selected: true)
      prev_pick.each do |pick|
        pick.update_attributes(selected: false)
      end
      answer.update_attributes(selected: true)
      # redirect to question page
      redirect_to answer.question
    else
      redirect_to root_path
    end
  end
  
  # Function vote and unvote
  def vote
    user=current_user
    answer = Answer.find(params[:answer_id])
    question= answer.question
    vote_string= "#{user.email}_answer_#{answer.id}"
    vote_digest = Digest::MD5.hexdigest vote_string

    # Kiem tra trong cookies xem user da vote cau hoi or cau tl nay chua
    if cookies[vote_digest].nil?
      vote = params[:vote]
      if vote == 'up'
        answer.update_attributes(:votes => (answer[:votes] +1))
      elsif vote=='down'
        answer.update_attributes(:votes => (answer[:votes] -1))
      end

      cookies.permanent[vote_digest]=1
    end
    redirect_to question
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
  @answer=Answer.find(params[:id])
  @question=@answer.question
  @answer.destroy
  redirect_to @question
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
