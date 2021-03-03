class Game
  attr_reader :game_id, :season, :away_team_id, :home_team_id, :away_goals,
              :home_goals, :manager

  def initialize(row, manager)
    @game_id = row[:game_id]
    @season = row[:season]
    @away_team_id = row[:away_team_id]
    @home_team_id = row[:home_team_id]
    @away_goals = row[:away_goals]
    @home_goals = row[:home_goals]
    @manager = manager
  end

end
