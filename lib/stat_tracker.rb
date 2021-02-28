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

# Game Statistics
  def highest_total_score
    # games_data = CSV.parse(File.read('./dummy_data/games_dummy.csv'), headers: true, header_converters: :symbol)
    highest_score = 0
    games_data.each do |game|
      sum = game[:home_goals].to_i + game[:away_goals].to_i
      if sum > highest_score
        highest_score = sum
      end
    end
    highest_score
  end

  def lowest_total_score
    lowest_score = 100
    games_data.each do |game|
      sum = game[:home_goals].to_i + game[:away_goals].to_i
      if sum < lowest_score
        lowest_score = sum
      end
    end
    lowest_score
  end

  def percentage_home_wins
    number_home_wins = game_teams_data.find_all do |game|
      (game[:hoa] == "home") && (game[:result] == "WIN")
    end.size.to_f

    all_games = games_data.find_all do |game|
      game
    end.size

    (number_home_wins / all_games).round(2)
  end

  def percentage_visitor_wins
    number_visitor_wins = game_teams_data.find_all do |game|
      (game[:hoa] == "away") && (game[:result] == "WIN")
    end.size.to_f

    all_games = games_data.find_all do |game|
      game
    end.size

    (number_visitor_wins / all_games).round(2)
  end

  def percentage_ties
    (1 - (percentage_home_wins + percentage_visitor_wins)).round(2)
  end

  # League Statistics
  def count_of_teams
    number_of_teams = team_data.map do |team|
      team
    end
    number_of_teams.count
  end

  def average_goals_per_game
    sum = 0
    games_data.each do |game|
      sum += game[:away_goals].to_i
      sum += game[:home_goals].to_i
    end
    (sum.to_f / games_data.count).round(2)
  end

  def average_goals_by_season
    result = {}
    games_data.each do |game|
      result[game[:season]] = [] if result[game[:season]].nil?

      # if result.keys == game[:season]
        # result[game[:season]] << game[:away_goals].to_i + game[:home_goals]
      # end
    end
    result
  end

  # Season Statistics

  # def most_tackles(season_id)
  #   find_season = games_data.find_all do |game|
  #     game[:season] == season_id
  #   end
  #
  #   games_array = []
  #   find_season.each do |season|
  #     games_array << season[:game_id]
  #   end
  #
  #   nuther_array = []
  #   game_teams_data.each do |rows|
  #     games_array.each do |id|
  #       nuther_array << rows if rows[:game_id] == id
  #     end
  #   end
  #   most_tackles = nuther_array.max_by {|rows| rows[:tackles]}
  # end

  # Team Statistics
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









































































































#Name of the team with the highest
#average number of goals scored per game across all seasons.
# average numebr of goals per game by team
#



  def count_of_games_by_season
    game_count = games_data.group_by do |game|
      game[:season]
    end
    final = game_count.transform_values { |season| season.length}
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
end
