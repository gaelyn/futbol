require 'CSV'

class StatTracker
  attr_reader :games_data,
              :team_data,
              :game_teams_data,
              :game_manager

  def initialize(locations)
    load_manager(locations)
  end

  def self.from_csv(locations)
    StatTracker.new(locations)
  end

  def load_manager(locations)
   @team_manager = TeamManager.new(load_csv(locations[:teams]), self)
   @game_manager = GameManager.new(load_csv(locations[:games]), self)
   @game_team_manager = GameTeamsManager.new(load_csv(locations[:game_teams]), self)
  end

  def load_csv(path)
    CSV.parse(File.read(path), headers: true, header_converters: :symbol)
  end

# Game Statistics ##################################
  def highest_total_score
    @game_manager.highest_total_score
  end

  def lowest_total_score
    @game_manager.lowest_total_score
  end

  def percentage_home_wins
    @game_manager.percentage_home_wins
  end

  def percentage_visitor_wins
    @game_manager.percentage_visitor_wins
  end

  def percentage_ties
    @game_manager.percentage_ties
  end

  def count_of_games_by_season
    @game_manager.count_of_games_by_season
  end

  def average_goals_per_game
    @game_manager.average_goals_per_game
  end

  def average_goals_by_season
    @game_manager.average_goals_by_season
  end

  # League Statistics ##########################

  def count_of_teams
    @team_manager.count_of_teams
  end

  def best_offense
    result = @game_team_manager.best_offense
    @team_manager.return_team_name_by_id(result[0])
  end

  def worst_offense
    result = @game_team_manager.worst_offense
    @team_manager.return_team_name_by_id(result[0])
  end

  def highest_scoring_visitor
    result = @game_manager.highest_scoring_visitor
    @team_manager.return_team_name_by_id(result[0])
  end

  def highest_scoring_home_team
    result = @game_manager.highest_scoring_home_team
    @team_manager.return_team_name_by_id(result[0])
  end

  def lowest_scoring_visitor
    result = @game_manager.lowest_scoring_visitor
    @team_manager.return_team_name_by_id(result[0])
  end

  def lowest_scoring_home_team
    result = @game_manager.lowest_scoring_home_team
    @team_manager.return_team_name_by_id(result[0])
  end

  # Season Statistics #########################

  def winningest_coach(season_id)
    result = @game_team_manager.winningest_coach(season_id)
    @game_team_manager.average_number_of_wins(result)
  end

  def worst_coach(season_id)
    result = @game_team_manager.worst_coach(season_id)
    @game_team_manager.average_number_of_losses(result)
  end

  def most_accurate_team(season_id)
    result = games_grouped_by_season[season_id]

    hash = {}
    game_teams_data.each do |game_team|
      result.each do |game|
        if game[:game_id] == game_team[:game_id]
          hash[game_team[:team_id]] = [] if hash[game_team[:team_id]].nil?
          calculation = game_team[:goals].to_f / (game_team[:shots].to_f)
          hash[game_team[:team_id]] << calculation
        end
      end
    end
    transformed = hash.transform_values {|value| value.sum / value.length}
    most_accurate = transformed.max_by {|key, value| value}
    final = team_data.find {|team| team[:team_id] == most_accurate[0]}
    final[:teamname]
  end

  def least_accurate_team(season_id)
    result = games_grouped_by_season[season_id]

    hash = {}
    game_teams_data.each do |game_team|
      result.each do |game|
        if game[:game_id] == game_team[:game_id]
          hash[game_team[:team_id]] = [] if hash[game_team[:team_id]].nil?
          calculation = game_team[:goals].to_f / (game_team[:shots].to_f)
          hash[game_team[:team_id]] << calculation
        end
      end
    end
    transformed = hash.transform_values {|value| value.sum / value.length}
    least_accurate = transformed.min_by {|key, value| value}
    final = team_data.find {|team| team[:team_id] == least_accurate[0]}
    final[:teamname]
  end

  def most_tackles(season_id)
    result = []
    games_data.each do |game|
      result << game[:game_id] if game[:season] == season_id
    end
    hash = {}
    game_teams_data.each do |game_team|
      result.each do |game|
        if game == game_team[:game_id]
          hash[game_team[:team_id]] = [] if hash[game_team[:team_id]].nil?
          hash[game_team[:team_id]] << game_team[:tackles].to_i
        end
      end
    end
    transformed = hash.transform_values {|value| value.sum}
    tackles = transformed.max_by {|key, value| value}
    find = team_data.find {|team| team[:team_id] == tackles[0]}
    find[:teamname]
  end

  def fewest_tackles(season_id)
    result = []
    games_data.each do |game|
      result << game[:game_id] if game[:season] == season_id
    end
    hash = {}
    game_teams_data.each do |game_team|
      result.each do |game|
        if game == game_team[:game_id]
          hash[game_team[:team_id]] = [] if hash[game_team[:team_id]].nil?
          hash[game_team[:team_id]] << game_team[:tackles].to_i
        end
      end
    end
    transformed = hash.transform_values {|value| value.sum}
    tackles = transformed.min_by {|key, value| value}
    find = team_data.find {|team| team[:team_id] == tackles[0]}
    find[:teamname]
  end

  # Team Statistics ###############################

  # A hash with key/value pairs for the following attributes: team_id,
  # franchise_id, team_name, abbreviation, and link
  def team_info(team_id)
    @team_manager.team_info(team_id)
  end

  def best_season(team_id)
    @game_team_manager.best_season(team_id)
  end

  def worst_season(team_id)
    @game_team_manager.worst_season(team_id)
  end

  def average_win_percentage(team_id)
    @game_team_manager.average_win_percentage(team_id)
  end

  def most_goals_scored(team_id)
    @game_team_manager.most_goals_scored(team_id)
  end

  def fewest_goals_scored(team_id)
    @game_team_manager.fewest_goals_scored(team_id)
  end

  def favorite_opponent(id)
    result = @game_team_manager.find_most_losses(id)
    @team_manager.return_team_name_by_id(result[0])
  end

  def rival(id)
    result = @game_team_manager.find_most_wins(id)
    @team_manager.return_team_name_by_id(result[0])
  end
end
