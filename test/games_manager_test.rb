require 'simplecov'
require 'minitest/autorun'
require 'minitest/pride'
require './lib/stat_tracker'
# require './test/test_helper'
require './lib/games_manager'

class GameManagerTest < Minitest::Test
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

  def test_percentage_of_home_wins
    assert_equal 0.44, @game_manager.percentage_home_wins
  end

  def test_percentage_of_visitor_wins
    assert_equal 0.36, @game_manager.percentage_visitor_wins
  end

  def test_percentage_ties
    assert_equal 0.20, @game_manager.percentage_ties
  end

  def test_it_can_group_games_by_season
    skip
    # Need more thought on test here. Mocks and stubs?
    # game1 = mocks
    # game1.stubs(season).return("20122013")
    # game1.stubs(id).return(20122013)
    #
    # game2 = mocks
    # game2.stubs(season).return("20132014")
    # game2.stubs(id).return(2012030334)
    #
    # game3 = mocks
    # game3.stubs(season).return("20132014")
    # game3.stubs(id).return(2012030335)
    #
    # games = [game1, game2, game3]
    # expected = {
    #   "20132014" => [2012030334, 2012030335],
    #   "20122013" => [20122013]
    # }
    #
    # result = games.games_grouped_by_season
    # assert_equal expected, result
    # assert_includes @game_manager.games_grouped_by_season.keys, "20122013"
    # assert_includes @game_manager.games_grouped_by_season.keys, "20132014"
    # assert_includes @game_manager.games_grouped_by_season.keys, "20142015"
  end

  def test_it_can_count_games_by_season
    expected = {
      "20122013"=>806,
      "20162017"=>1317,
      "20142015"=>1319,
      "20152016"=>1321,
      "20132014"=>1323,
      "20172018"=>1355
      }
    assert_equal expected, @game_manager.count_of_games_by_season
  end

  def test_average_goals_per_game
    # skip
    assert_equal 4.22, @stat_tracker.average_goals_per_game
  end

  def test_average_goals_by_season
    # skip
    expected = {
      "20122013"=>4.12,
      "20162017"=>4.23,
      "20142015"=>4.14,
      "20152016"=>4.16,
      "20132014"=>4.19,
      "20172018"=>4.44
      }
    assert_equal expected, @game_manager.average_goals_by_season
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
