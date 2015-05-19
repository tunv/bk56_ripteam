class QuestionsController < ApplicationController
  before_action :set_question, only: [:show, :edit, :update, :destroy]
  before_filter :signed_in_user, only: [:create, :vote]

  def index
    qpp=4 #ques per page
    if params[:order] == "votes"
       @questions = Question.order(votes: :desc).paginate(page: params[:page], per_page: qpp)
    elsif params[:order] == "unanswered"
       @questions = Question.includes(:answers).group('questions.id, answers.id').having('COUNT(answers.id) = 0').references(:answers)
       @questions = @questions.order(created_at: :desc).paginate(page: params[:page], per_page: qpp)
    else
       @questions = Question.order(created_at: :desc).paginate(page: params[:page], per_page: qpp)
    end
  end

 
  def show
    @question = Question.find(params[:id])
    @answers =@question.answers.order(votes: :desc)
  end

  # GET /questions/new
  def new
    @question = Question.new
  end


  def create
    @question = current_user.questions.build(question_params)
    if @question.save
      redirect_to root_path
    else 
      render 'questions/index'
    end
  end

# Function vote and unvote
  def vote
    user=current_user
    question=Question.find(params[:question_id])

    vote_string= "#{user.email}_question_#{question.id}"
    vote_digest = Digest::MD5.hexdigest vote_string

    # Kiem tra trong cookies xem user da vote cau hoi or cau tl nay chua
    if cookies[vote_digest].nil?
      vote = params[:vote]
      if vote == 'up'
        question.update_attributes(:votes => (question[:votes] +1))
      elsif vote=='down'
        question.update_attributes(:votes => (question[:votes] -1))
      end

      cookies.permanent[vote_digest]=1
    end
    redirect_to question
  end

  # PATCH/PUT /questions/1
  # PATCH/PUT /questions/1.json
  def update
    respond_to do |format|     
      if @question.update(question_params)
        format.html { redirect_to @question, notice: 'Question was successfully updated.' }
        format.json { render :show, status: :ok, location: @question }
      else
        format.html { render :edit }
        format.json { render json: @question.errors, status: :unprocessable_entity }
      end
    end
  end
  
  # DELETE /questions/1
  # DELETE /questions/1.json
  def destroy
    @question.answers.each do |ans|
      ans.destroy
    end
    @question.destroy
    respond_to do |format|
      format.html { redirect_to root_path, notice: 'Question was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
     def set_question
      @question = Question.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def question_params
      params.require(:question).permit(:title, :content)
    end
end
