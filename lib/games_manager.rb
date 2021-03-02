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

  # def find_total_goals_per_game
  #   # games_data.map {|game| game[:home_goals].to_i + game[:away_goals].to_i}
  #   @games.map do |game|
  #     game.home_goals.to_i + game.away_goals.to_i
  #   end
  # end
end
