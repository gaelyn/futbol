require 'simplecov'
require 'minitest/autorun'
require 'minitest/pride'
require './lib/stat_tracker'
# require './test/test_helper'
require './lib/games_manager'

class StatTrackerTest < Minitest::Test
  def setup
    @game_path = './data/games.csv'
    @team_path = './data/teams.csv'
    @game_teams_path = './data/game_teams.csv'


    @locations = {
      games: @game_path,
      teams: @team_path,
      game_teams: @game_teams_path
    }

    @stat_tracker = StatTracker.from_csv(@locations)
    @data = @stat_tracker.load_csv(@locations[:games])
    @game_manager = GameManager.new(@data, @stat_tracker)
  end

  def test_it_exists
    assert_instance_of GameManager, @game_manager
  end

  # def test_find_total_goals_per_game
  #   assert_instance_of Array, @game_manager.find_total_goals_per_game
  # end

  def test_it_can_find_highest_total_score
    assert_equal 11, @game_manager.highest_total_score
  end

  def test_it_can_find_lowest_total_score
    assert_equal 0, @game_manager.lowest_total_score
  end
  # def setup
  #   @game_path = './dummy_data/games_dummy.csv'
  #   @team_path = './dummy_data/teams_dummy.csv'
  #   @game_teams_path = './dummy_data/game_teams_dummy.csv'
  #   @locations = {
  #     games: @game_path,
  #     teams: @team_path,
  #     game_teams: @game_teams_path
  #   }
  #   @stat_tracker_method = StatTracker.from_csv(@locations)
  #   @stat_tracker_instance = StatTracker.new(@locations)
  # end
  #
  # def test_it_exists
  #   games_manager = GamesManager.new(
  #     @locations[:games],
  #     StatTracker.from_csv(@locations)
  #   )
  #   assert_instance_of GamesManager, games_manager
  # end

  # def test_it_can_create_games
  #   # skip
  #   games_manager = GamesManager.new(
  #     @locations[:games],
  #     StatTracker.from_csv(@locations)
  #   )
  #   assert_equal [], games_manager.games
  #   games_manager.create_games(@locations[:games])
  #   assert_equal false, games_manager.games.empty?
  # end






end
