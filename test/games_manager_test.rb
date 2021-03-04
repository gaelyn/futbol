require 'simplecov'
require 'minitest/autorun'
require 'minitest/pride'
require './lib/stat_tracker'
# require './test/test_helper'
require './lib/games_manager'
require './lib/teams_manager'
require './lib/game_teams_manager'

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
    assert_equal 4.22, @stat_tracker.average_goals_per_game
  end

  def test_average_goals_by_season
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

  def test_away_goals_by_team_id
    assert_instance_of Hash, @game_manager.away_goals_by_away_team_id
  end

  def test_home_goals_by_team_id
    assert_instance_of Hash, @game_manager.home_goals_by_home_team_id
  end

  def test_highest_scoring_visitor
    assert_equal ["6", 2.25], @game_manager.highest_scoring_visitor
  end

  def test_highest_scoring_home_team
    assert_equal ["54", 2.59], @game_manager.highest_scoring_home_team
  end

  def test_lowest_scoring_visitor
    assert_equal ["27", 1.85], @game_manager.lowest_scoring_visitor
  end

  def test_lowest_scoring_home_team
    assert_equal ["7", 1.79], @game_manager.lowest_scoring_home_team
  end

  def test_list_game_id_by_season_id
    assert_instance_of Array, @game_manager.list_game_id_by_season_id("20122013")
  end

  def test_most_tackles
   assert_equal "FC Cincinnati", @game_manager.most_tackles("20132014")
   assert_equal "Seattle Sounders FC", @game_manager.most_tackles("20142015")
   end

   def test_least_tackles
     assert_equal "Atlanta United", @game_manager.most_tackles("20132014")
     assert_equal "Orlando City SC", @game_manager.most_tackles("20142015")
   end

end
