class GameTeam
  attr_reader :game_id, :team_id, :hoa, :result, :head_coach, :goals, :shots,
              :tackles, :manager

  def initialize(row, manager)
    @game_id = row[:game_id]
    @team_id = row[:team_id]
    @hoa = row[:hoa]
    @result = row[:result]
    @head_coach = row[:head_coach]
    @goals = row[:goals]
    @shots = row[:shots]
    @tackles = row[:tackles]
    @manager = manager
  end
end
