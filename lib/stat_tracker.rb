require 'CSV'


class StatTracker
  attr_reader :games_data,
              :team_data,
              :game_teams_data

  def initialize(locations)
    # @locations = locations
    @games_data = CSV.parse(File.read('./data/games.csv'), headers: true, header_converters: :symbol)
    @team_data = CSV.parse(File.read('./data/teams.csv'), headers: true, header_converters: :symbol)
    @game_teams_data = CSV.parse(File.read('./data/game_teams.csv'), headers: true, header_converters: :symbol)
    # @team_manager = TeamsManager.new(CSV.parse(File.read(locations[:teams]), headers: true, header_converters: :symbol), self)
    # @games_manager = GamesManager.new(CSV.parse(File.read(locations[:games]), headers: true, header_converters: :symbol), self)
    # @game_team_manager = GameTeamsManager.new(CSV.parse(File.read(locations[:game_teams]), headers: true, header_converters: :symbol), self)
  end

  def self.from_csv(locations)
    StatTracker.new(locations)
  end

# Game Statistics ##################################
  def highest_total_score
    find_total_goals_per_game.max_by {|goals| goals}
  end

  def lowest_total_score
    find_total_goals_per_game.min_by {|goals| goals}
  end

  # Need Test
  def find_total_goals_per_game
    games_data.map {|game| game[:home_goals].to_i + game[:away_goals].to_i}
  end

  # Need Test
  # def find_highest_home_team_score
  #   result = games_data.max_by {|game| game[:home_goals]}
  #   result[:home_goals].to_i
  # end
  #
  # # Need Test
  # def find_highest_away_team_score
  #   result = games_data.max_by {|game| game[:away_goals]}
  #   result[:away_goals].to_i
  # end

  def percentage_home_wins
    (number_of_wins("home") / all_games.size).round(2)
  end

  def percentage_visitor_wins
    (number_of_wins("away") / all_games.size).round(2)
  end

  # Need Test
  def number_of_wins(home_or_away)
    return false unless ["home", "away"].include?(home_or_away)
    game_teams_data.find_all do |game|
      (game[:hoa] == home_or_away) && (game[:result] == "WIN")
    end.size.to_f
  end
  # Need test
  def all_games
    games_data.find_all {|game| game}
  end

  def percentage_ties
    (1 - (percentage_home_wins + percentage_visitor_wins)).round(2)
  end

  def count_of_games_by_season
    games_grouped_by_season.transform_values { |season| season.length }
  end

  def average_goals_per_game
    sum = find_total_goals_per_game.sum
    length = find_total_goals_per_game.length
    (sum.fdiv(length)).round(2)
  end

  def average_goals_by_season
    result = {}
    games_data.each do |game|
      goals = (game[:away_goals].to_f + game[:home_goals].to_f)
      result[game[:season]] = [] if result[game[:season]].nil?
      result[game[:season]].push(goals)
    end
    bucket = result.transform_values {|value| (value.sum / value.length).round(2)}
  end

  # League Statistics ##########################

  def count_of_teams
    number_of_teams = team_data.map {|team| team}
    number_of_teams.count
  end

  def best_offense
    grouped = Hash.new{|hash, key| hash[key] = []}
    game_teams_data.each do |game_team|
      grouped[game_team[:team_id]] << game_team[:goals].to_i
    end
    avg_score = grouped.map { |k,v| [k, (v.sum / v.count.to_f) ]}
    max_avg = avg_score.max_by do |team, score|
      score
    end
    team_name = team_data.find do |team|
      team[:team_id] == max_avg[0]
    end
    team_name[:teamname]
  end

  def worst_offense
    grouped = Hash.new{|hash, key| hash[key] = []}
    game_teams_data.each do |game_team|
      grouped[game_team[:team_id]] << game_team[:goals].to_i
    end

    avg_score = grouped.map { |team_id, goals| [team_id, (goals.sum / goals.count.to_f) ]}

    min_avg = avg_score.min_by do |team, score|
      score
    end

    team_name = team_data.find do |team|
      team[:team_id] == min_avg[0]
    end
    team_name[:teamname]
  end

  def highest_scoring_visitor
    grouped = {}
    games_data.each do |game|
      grouped[game[:away_team_id]] = [] if grouped[game[:away_team_id]].nil?
      grouped[game[:away_team_id]] << game[:away_goals].to_f
    end
    averaged = grouped.transform_values do |values|
      (values.sum / values.length).round(2)
    end
    result = averaged.max_by {|key, value| value}
    find_team = team_data.find {|team| team[:team_id] == result[0]}
    find_team[:teamname]
  end

  def highest_scoring_home_team
    grouped = {}
    games_data.each do |game|
      grouped[game[:home_team_id]] = [] if grouped[game[:home_team_id]].nil?
      grouped[game[:home_team_id]] << game[:home_goals].to_f
    end
    averaged = grouped.transform_values do |values|
      (values.sum / values.length).round(2)
    end
    result = averaged.max_by {|key, value| value}
    find_team = team_data.find {|team| team[:team_id] == result[0]}
    find_team[:teamname]
  end

  def lowest_scoring_visitor
    grouped = {}
    games_data.each do |game|
      grouped[game[:away_team_id]] = [] if grouped[game[:away_team_id]].nil?
      grouped[game[:away_team_id]] << game[:away_goals].to_f
    end
    averaged = grouped.transform_values do |values|
      (values.sum / values.length).round(2)
    end
    result = averaged.min_by {|key, value| value}
    find_team = team_data.find {|team| team[:team_id] == result[0]}
    find_team[:teamname]
  end

  def lowest_scoring_home_team
    grouped = {}
    games_data.each do |game|
      grouped[game[:home_team_id]] = [] if grouped[game[:home_team_id]].nil?
      grouped[game[:home_team_id]] << game[:home_goals].to_f
    end
    averaged = grouped.transform_values do |values|
      (values.sum / values.length).round(2)
    end
    result = averaged.min_by {|key, value| value}
    find_team = team_data.find {|team| team[:team_id] == result[0]}
    find_team[:teamname]
  end

  # Season Statistics #########################

  def winningest_coach(season_id)
    season = []
    games_data.each do |game|
      season << game[:game_id] if game[:season] == season_id
    end
    result = {}
    game_teams_data.each do |game_team|
      season.each do |game_id|
        if game_id == game_team[:game_id]
          result[game_team[:head_coach]] = [] if result[game_team[:head_coach]].nil?
          result[game_team[:head_coach]] << game_team[:result]
        end
      end
    end
    average = result.transform_values do |value|
      (value.count("WIN") / value.length.to_f)
    end
    winning_coach = average.max_by {|key, value| value}
    winning_coach[0]
  end

  def worst_coach(season_id)
    season = []
    games_data.each do |game|
      season << game[:game_id] if game[:season] == season_id
    end
    result = {}
    game_teams_data.each do |game_team|
      season.each do |game_id|
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
  def games_grouped_by_season
    games_data.group_by {|game| game[:season]}
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

  def best_season(team_id)
    games_by_team = game_teams_data.find_all do |game|
      game[:team_id] == team_id
    end

    wins = games_by_team.find_all do |game|
      game[:result] == "WIN"
    end

    game_ids = wins.map do |game|
      game[:game_id]
    end

    games_by_id = []
    game_ids.each do |id|
      games_data.each do |game|
        if game[:game_id] == id
          games_by_id << game[:season]
        end
      end
    end

    seasons = games_by_id.group_by do |season|
      season
    end
    season_count = seasons.transform_values do |value|
      value.count
    end
    most_wins = season_count.max_by do |season, count|
      count
    end
    most_wins[0]
  end

  def worst_season(team_id)
    games_by_team = game_teams_data.find_all do |game|
      game[:team_id] == team_id
    end

    wins = games_by_team.find_all do |game|
      game[:result] == "WIN"
    end

    game_ids = wins.map do |game|
      game[:game_id]
    end

    games_by_id = []
    game_ids.each do |id|
      games_data.each do |game|
        if game[:game_id] == id
          games_by_id << game[:season]
        end
      end
    end

    seasons = games_by_id.group_by do |season|
      season
    end
    season_count = seasons.transform_values do |value|
      value.count
    end
    least_wins = season_count.min_by do |season, count|
      count
    end
    least_wins[0]
    end


  def average_win_percentage(team_id)
    game_results = []
    game_teams_data.each do |row|
      game_results << row[:result] if row[:team_id] == team_id
    end
    win_bucket = (game_results.count("WIN") / game_results.length.to_f).round(2)
  end

  def most_goals_scored(team_id)
    team_result = []
    game_teams_data.each do |games|
      team_result << games if games[:team_id] == team_id
    end
    goals = team_result.max_by do |result|
      result[:goals]
    end[:goals].to_i
  end

  def fewest_goals_scored(team_id)
    team_result = []
    game_teams_data.each do |games|
      team_result << games if games[:team_id] == team_id
    end
    goals = team_result.min_by do |result|
      result[:goals]
    end[:goals].to_i
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

    find_team = team_data.find { |team| team[:team_id] == most_losses[0] }
    find_team[:teamname]
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

    find_team = team_data.find { |team| team[:team_id] == most_wins[0] }
    find_team[:teamname]
  end
end
