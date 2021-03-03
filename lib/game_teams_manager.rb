require 'csv'
require_relative './game_teams'

class GameTeamsManager
  attr_reader :game_teams,
              :tracker

  def initialize(data, tracker)
    @game_teams = []
    @tracker = tracker
    create_game_teams(data)
  end

  def create_game_teams(data)
    @game_teams = data.map do |data|
      GameTeam.new(data, self)
    end
  end

  def goals_grouped_by_team_id
    grouped = Hash.new{|hash, key| hash[key] = []}
    @game_teams.each do |game_team|
      grouped[game_team.team_id] << game_team.goals.to_i
    end
    grouped
  end

  def best_offense
    average = goals_grouped_by_team_id.map do |team_id, goals|
      [team_id, (goals.sum / goals.count.to_f)]
    end
    max_avg = average.max_by do |team, score|
      score
    end
  end

  def worst_offense
    avg_score = goals_grouped_by_team_id.map do |team_id, goals|
      [team_id, (goals.sum / goals.count.to_f)]
    end
    min_avg = avg_score.min_by do |team, score|
      score
    end
  end

  def game_team_results_by_head_coach
    result = {}
    @game_teams.each do |game_team|
      result[game_team.head_coach] = [] if result[game_team.head_coach].nil?
      result[game_team.head_coach] << game_team.result
    end
    result
  end

  def winningest_coach(season_id)
    game_ids = tracker.game_manager.list_game_id_by_season_id(season_id)
    result = {}
    @game_teams.each do |team|
      game_ids.each do |id|
        if id == team.game_id
          result[team.head_coach] = [] if result[team.head_coach].nil?
          result[team.head_coach] << team.result
        end
      end
    end
    result
  end

  def worst_coach(season_id)
    game_ids = tracker.game_manager.list_game_id_by_season_id(season_id)
    result = {}
    @game_teams.each do |team|
      game_ids.each do |id|
        if id == team.game_id
          result[team.head_coach] = [] if result[team.head_coach].nil?
          result[team.head_coach] << team.result
        end
      end
    end
    result
  end

  def average_number_of_losses(result)
    average = result.transform_values do |value|
      (value.count("WIN") / value.length.to_f)
    end
    worst_coach = average.min_by {|key, value| value}
    worst_coach[0]
  end

  def average_number_of_wins(result)
    average = result.transform_values do |value|
      (value.count("WIN") / value.length.to_f)
    end
    best_coach = average.max_by {|key, value| value}
    best_coach[0]
  end


  def transform_hash_values_to_unique(hash)
    hash.transform_values do |value|
      value.unique
    end
  end

  def games_by_team_id
    game_teams.group_by do |game|
      game.team_id
    end
  end

  def wins_by_team_id(team_id)
    games_by_team_id[team_id].find_all {|game| game.result == "WIN"}
  end
  # Need test
  def game_ids_by_team_id(team_id)
    wins_by_team_id(team_id).map {|game| game.game_id}
  end

  def season_by_game_id(team_id)
    games_by_id = []
    game_ids_by_team_id(team_id).each do |id|
      tracker.game_manager.games.each do |game|
        games_by_id << game.season if game.game_id == id
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

  def game_result_by_team_id(team_id)
    game_results = []
    game_teams.each do |row|
      game_results << row.result if row.team_id == team_id
    end
    game_result
  end

  def average_win_percentage(team_id)
    game_result = game_result_by_team_id(team_id)
    (game_result.count("WIN").fdiv(game_result.length)).round(2)
  end

  def most_goals_scored(team_id)
    goals = games_by_team_id[team_id].max_by do |result|
      result.goals
    end
    goals.goals.to_i
  end

  def fewest_goals_scored(team_id)
    goals = games_by_team_id[team_id].min_by do |result|
      result.goals
    end
    goals.goals.to_i
  end

  def favorite_opponent(id)
    find_most_losses(id)
  end

  def rival(id)
    find_most_wins(id)
  end

  def team_id_by_game_id(id)
    game_id = []
    game_teams.each do |team_id|
      game_id << team_id.game_id if team_id.team_id == id
    end
    game_id
  end

  def hash_of_team_id_by_result(id)
    games_played = {}
    team_id_by_game_id(id).each do |games|
      game_teams.each do |data|
        if games == data.game_id && data.team_id != id
          games_played[data.team_id] = [] if games_played[data.team_id].nil?
          games_played[data.team_id] << data.result
        end
      end
    end
    games_played
  end

  def hash_of_results_to_average_lost(id)
    hash_of_team_id_by_result(id).transform_values do |value|
      (value.count("LOSS") / value.length.to_f)
    end
  end

  def hash_of_results_to_average_won(id)
    hash_of_team_id_by_result(id).transform_values do |value|
      (value.count("WIN") / value.length.to_f)
    end
  end

  def find_most_wins(id)
    hash_of_results_to_average_won(id).max_by do |key, value|
      value
    end
  end

  def find_most_losses(id)
    hash_of_results_to_average_lost(id).max_by do |key, value|
      value
    end
  end




  # def number_of_wins(home_or_away)
  #   return false unless ["home", "away"].include?(home_or_away)
  #   game_teams.find_all do |game_team|
  #     (game_team.hoa == home_or_away) && (game[:result] == "WIN")
  #   end.size.to_f
  #   # return false unless ["home", "away"].include?(home_or_away)
  #   # game_teams.find_all do |game|
  #   #   (game[:hoa] == home_or_away) && (game[:result] == "WIN")
  #   # end.size.to_f
  # end
end
