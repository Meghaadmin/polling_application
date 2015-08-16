class Voting < ActiveRecord::Base

  def self.final_candidates
    voters = User.selectors.pluck(:id)
    candidates_count_M = Voting.where(:selector_id=>voters).group(:candidate_id).count
    highest_count = candidates_count_M.values.sort.reverse.first
    second_highest_count = candidates_count_M.values.sort.reverse.second
    if highest_count==second_highest_count                          # if there is tie between candidates, then randomly  2 candidates will be selected for final election
      candidates_count_M.values.sort.reverse.sample(2)
    else
      first_candidate =  candidates_count_M.key(highest_count)        #else two highest vote candidates will be selected for final election
      second_candidate =  candidates_count_M.key(second_highest_count)
    end

    [first_candidate,second_candidate]

  end

  #final selection of winner by voters vote
  def self.winner
    voters = User.where(:user_type=>3).pluck(:id)
    candidates_count_M = Voting.where(:selector_id=>voters).group(:candidate_id).count
    highest_count = candidates_count_M.values.sort.reverse.first
    winning_candidate = Candidate.find(candidates_count_M.key(highest_count))
    winning_candidate
  end

end
