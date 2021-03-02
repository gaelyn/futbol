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

  def number_of_wins(home_or_away)
    return false unless ["home", "away"].include?(home_or_away)
    game_teams.find_all do |game_team|
      (game_team.hoa == home_or_away) && (game[:result] == "WIN")
    end.size.to_f
    # return false unless ["home", "away"].include?(home_or_away)
    # game_teams_data.find_all do |game|
    #   (game[:hoa] == home_or_away) && (game[:result] == "WIN")
    # end.size.to_f
  end
end
