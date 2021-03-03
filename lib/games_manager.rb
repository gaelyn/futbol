require 'csv'
require_relative './game'

class GameManager
  attr_reader :games, :tracker

  def initialize(data, tracker)
    @games = []
    @tracker = tracker
    create_games(data)
  end

  def create_games(data)
    @games = data.map do |data|
      Game.new(data, self)
    end
  end

  def highest_total_score
    @games.map do |game|
      game.home_goals.to_i + game.away_goals.to_i
    end.max
  end

  def lowest_total_score
    @games.map do |game|
      game.home_goals.to_i + game.away_goals.to_i
    end.min
  end

  def percentage_home_wins
    result = @games.count do |count|
      count.away_goals < count.home_goals
    end
    result.fdiv(@games.count).round(2)
  end

  def percentage_visitor_wins
    result = @games.count do |count|
      count.away_goals > count.home_goals
    end
    result.fdiv(@games.count).round(2)
  end

  def percentage_ties
    (1 - (percentage_home_wins + percentage_visitor_wins)).round(2)
  end

  def count_of_games_by_season
    games_grouped_by_season.transform_values do |season|
      season.length
    end
  end

  def games_grouped_by_season
    @games.group_by do |game|
      game.season
    end
  end

  def average_goals_per_game
    sum = @games.sum do |game|
      (game.home_goals.to_i + game.away_goals.to_i)
    end.fdiv(@games.count).round(2)
  end

  def average_goals_by_season
    result = {}
    @games.each do |game|
      goals = (game.away_goals.to_f + game.home_goals.to_f)
      result[game.season] = [] if result[game.season].nil?
      result[game.season].push(goals)
    end
    average = result.transform_values do |value|
      (value.sum / value.length).round(2)
    end
  end

end


    # result = {}
    # @games.each do |game|
    #   goals = (game.away_goals.to_f + game.home_goals.to_f)
    #   result[game.season] = [] if result[game.season].nil?
    #   result[game,season].push(goals)
    # end
    # bucket = result.transform_values {|value| (value.sum / value.length).round(2)}
    # result = {}
    # games_data.each do |game|
    #   goals = (game[:away_goals].to_f + game[:home_goals].to_f)
    #   result[game[:season]] = [] if result[game[:season]].nil?
    #   result[game[:season]].push(goals)
    # end
    # bucket = result.transform_values {|value| (value.sum / value.length).round(2)}
