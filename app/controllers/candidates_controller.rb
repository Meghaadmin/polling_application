class CandidatesController < ApplicationController
  before_action :set_candidate, only: [:show, :edit, :update, :destroy]

  # GET /candidates
  # GET /candidates.json
  def index
    @candidates = Candidate.all
    @selectors_list = User.selectors
  end

  # GET /candidates/1
  # GET /candidates/1.json
  def show
  end

  # GET /candidates/new
  def new
    @candidate = Candidate.new
    logger.debug @current_user = current_user.id
  end

  # GET /candidates/1/edit
  def edit
  end

  # POST /candidates
  # POST /candidates.json
  def create
    @candidate = Candidate.new(candidate_params)

    respond_to do |format|
      if @candidate.save
        format.html { redirect_to candidates_path, notice: 'Candidate was successfully created.' }
        format.json { render action: 'index', status: :created, location: candidates_path }
      else
        format.html { render action: 'new' }
        format.json { render json: @candidate.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /candidates/1
  # PATCH/PUT /candidates/1.json
  def update
    respond_to do |format|
      if @candidate.update(candidate_params)
        format.html { redirect_to @candidate, notice: 'Candidate was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @candidate.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /candidates/1
  # DELETE /candidates/1.json
  def destroy
    @candidate.destroy
    respond_to do |format|
      format.html { redirect_to candidates_url }
      format.json { head :no_content }
    end
  end

  # First selection of candidates for final voting by selectors.
  def voting
    @voter = Voting.new(:candidate_id=> params[:candidate_id],:selector_id=>current_user.id)
    @voter.save
    respond_to do |format|
      format.html { redirect_to candidates_path}
    end
  end

  # Final voting of two candidates by voters

  def second_voting
    @voter = Voting.new(:candidate_id=> params[:candidate_id],:selector_id=>current_user.id,:election_id=>params[:election_id])
    @voter.save
    respond_to do |format|
      format.html { redirect_to voter_candidates_path}
    end
  end

  # Admin will select final candidates for election using their votes by selectors.

  def final_candidates
    first_candidate ,second_candidate = Voting.final_candidates
    @election = Election.create(:name=>'E1',:first_candidate=>first_candidate,:second_candidate=>second_candidate)
    respond_to do |format|
      format.html { render 'final_candidates'}
    end
  end


  # After final 2 candidates selection admin will select a time frame for voters to vote and mail will be sent to mail

  def set_election_timeframe
    election = Election.find(params[:id])
    start_date =  Time.parse(params[:start_date])
    end_date  = Time.parse(params[:end_date])
    election.update_attributes(:start_date=> start_date,:end_date=>end_date)
   first_candidate = candidate_name(election.first_candidate)
   second_candidate = candidate_name(election.second_candidate)

    # Send mails to all the voters and selectors for voting with the time and candidates
   users = User.where(:user_type => [$is_selector,$is_voter])
   threads=Thread.new{
     users.each do |user|
   UserMailer.final_candidates_mail(user,first_candidate,second_candidate,election).deliver
   end
   }
    respond_to do |format|
      format.html { redirect_to candidates_path,notice: 'Mails has been sent to all the voters and selectors for voting.' }
    end

  end

    # Voter can vote after admin select the two candidates and set time frame
  def voter
    @election = Election.first
    unless @election.nil?
    @first_candidate =  Candidate.find(@election.first_candidate)
    @second_candidate =  Candidate.find(@election.second_candidate)
    end
  end

  # Result will appear only after time frame ends and then admin find the winner and send the mail to all
  def result
    winning_candidate = Voting.winner
    winner =  candidate_name(winning_candidate)
    users = User.where.not(:user_type => 1)
    threads=Thread.new{
      users.each do |user|
        UserMailer.result(user,winner).deliver
      end
    }
    respond_to do |format|
      format.html { redirect_to candidates_path,notice: "#{winner} has won the election. Result Declaration mail has been sent to all the voters and selectors." }
    end
  end

  def candidate_name candidate_id
    name = Candidate.find(candidate_id).name
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_candidate
      @candidate = Candidate.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def candidate_params
      params.require(:candidate).permit(:name, :age, :admin_id)
    end
end
