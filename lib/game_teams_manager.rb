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





  # def number_of_wins(home_or_away)
  #   return false unless ["home", "away"].include?(home_or_away)
  #   game_teams.find_all do |game_team|
  #     (game_team.hoa == home_or_away) && (game[:result] == "WIN")
  #   end.size.to_f
  #   # return false unless ["home", "away"].include?(home_or_away)
  #   # game_teams_data.find_all do |game|
  #   #   (game[:hoa] == home_or_away) && (game[:result] == "WIN")
  #   # end.size.to_f
  # end
end
