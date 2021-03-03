require 'CSV'

class StatTracker
  attr_reader :games_data,
              :team_data,
              :game_teams_data

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

  # def winningest_coach(season_id)
  #   game_ids = @game_manager.list_game_id_by_season_id(season_id)
  #   # result = {}
  #   # game_teams_data.each do |game_team|
  #     game_ids.each do |game_id|
  #       if game_id == game_team[:game_id]
  #         # result[game_team[:head_coach]] = [] if result[game_team[:head_coach]].nil?
  #         # result[game_team[:head_coach]] << game_team[:result]
  #       end
  #     end
  #   end
  #   average = result.transform_values do |value|
  #     (value.count("WIN") / value.length.to_f)
  #   end
  #   winning_coach = average.max_by {|key, value| value}
  #   winning_coach[0]
  # end

  def worst_coach(season_id)
    game_ids = list_game_id_by_season_id(season_id)
    result = {}
    game_teams_data.each do |game_team|
      game_id.each do |game_id|
        if game_id == game_team[:game_id]
          result[game_team[:head_coach]] = [] if result[game_team[:head_coach]].nil?
          result[game_team[:head_coach]] << game_team[:result]
        end
      end
    end
    average = result.transform_values do |value|
      (value.count("WIN") / value.length.to_f)
    end
    worst_coach = average.min_by {|key, value| value}
    worst_coach[0]
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
  # Need test
  # def games_grouped_by_season
  #   games_data.group_by {|game| game[:season]}
  # end

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
    team_data_string_headers = CSV.parse(File.read('./data/teams.csv'), headers: true)
    team_info = team_data_string_headers.find do |team|
      # require "pry"; binding.pry
      team["team_id"] == team_id
    end
    team_deets = team_info.to_h
    team_deets.delete("Stadium")
    team_deets["team_name"] = team_deets["teamName"]
    team_deets.delete("teamName")
    team_deets["franchise_id"] = team_deets["franchiseId"]
    team_deets.delete("franchiseId")
    team_deets
  end
  # Need test
  def games_by_team_id
    game_teams_data.group_by do |game|
      game[:team_id]
    end
  end
  # Need test
  def wins_by_team_id(team_id)
    games_by_team_id[team_id].find_all {|game| game[:result] == "WIN"}
  end
  # Need test
  def game_ids_by_team_id(team_id)
    wins_by_team_id(team_id).map {|game| game[:game_id]}
  end
  # Need test
  def season_by_game_id(team_id)
    games_by_id = []
    game_ids_by_team_id(team_id).each do |id|
      games_data.each do |game|
        games_by_id << game[:season] if game[:game_id] == id
      end
    end
    games_by_id
  end

  def best_season(team_id)
    seasons = season_by_game_id(team_id).group_by {|season| season}
    season_count = seasons.transform_values {|value| value.count}
    most_wins = season_count.max_by {|season, count| count}
    most_wins[0]
  end

  def worst_season(team_id)
    seasons = season_by_game_id(team_id).group_by {|season| season}
    season_count = seasons.transform_values {|value| value.count}
    least_wins = season_count.min_by {|season, count| count}
    least_wins[0]
  end
 # Need test
  def game_result_by_team_id(team_id)
    game_results = []
    game_teams_data.each do |row|
      game_results << row[:result] if row[:team_id] == team_id
    end
    game_results
  end

  def average_win_percentage(team_id)
    game_result = game_result_by_team_id(team_id)
    (game_result.count("WIN").fdiv(game_result.length)).round(2)
  end

  def most_goals_scored(team_id)
    goals = games_by_team_id[team_id].max_by {|result| result[:goals]}
    goals[:goals].to_i
  end

  def fewest_goals_scored(team_id)
    goals = games_by_team_id[team_id].min_by {|result| result[:goals]}
    goals[:goals].to_i
  end

  def favorite_opponent(id)
    game_id = []
    game_teams_data.each do |team_id|
      game_id << team_id[:game_id] if team_id[:team_id] == id
    end

    games_played = {}
    game_id.each do |games|
      game_teams_data.each do |data|
        if games == data[:game_id] && data[:team_id] != id
          games_played[data[:team_id]] = [] if games_played[data[:team_id]].nil?
          games_played[data[:team_id]] << data[:result]
        end
      end
    end
    games_lost = games_played.transform_values { |value| (value.count("LOSS") / value.length.to_f) }
    most_losses = games_lost.max_by { |key, value| value }
    return_team_name_by_id(most_losses[0])
  end

  def rival(id)
    game_id = []
    game_teams_data.each do |team_id|
      game_id << team_id[:game_id] if team_id[:team_id] == id
    end

    games_played = {}
    game_id.each do |games|
      game_teams_data.each do |data|
        if games == data[:game_id] && data[:team_id] != id
          games_played[data[:team_id]] = [] if games_played[data[:team_id]].nil?
          games_played[data[:team_id]] << data[:result]
        end
      end
    end
    games_won = games_played.transform_values { |value| (value.count("WIN") / value.length.to_f) }
    most_wins = games_won.max_by { |key, value| value }
    return_team_name_by_id(most_wins[0])
  end
end
