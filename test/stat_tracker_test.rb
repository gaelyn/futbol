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
    # @stat_tracker_instance = StatTracker.new(@locations)
  end

  def test_it_exists
    skip
    assert_instance_of StatTracker, @stat_tracker
  end

  # Game Statistics Tests
  def test_it_can_find_highest_score
    skip
    # stat_tracker = StatTracker.from_csv(@locations)
    assert_equal 11, @stat_tracker.highest_total_score
  end
  
  def test_you_can_find_lowest_total_score
    skip
    assert_equal 0, @stat_tracker.lowest_total_score
  end

  def test_percentage_of_home_wins
    skip
    assert_equal 0.44, @stat_tracker.percentage_home_wins
  end

  def test_percentage_of_visitor_wins
    skip
    assert_equal 0.36, @stat_tracker.percentage_visitor_wins
  end

  def test_percentage_ties
    skip
    assert_equal 0.20, @stat_tracker.percentage_ties
  end

  def test_average_goals_per_game
    skip
    assert_equal 4.22, @stat_tracker.average_goals_per_game
  end

  def test_average_goals_by_season
    #WORK IN PROGRESS
    # skip
    expected = {
      "20122013"=>4.12,
      "20162017"=>4.23,
      "20142015"=>4.14,
      "20152016"=>4.16,
      "20132014"=>4.19,
      "20172018"=>4.44
    }
    assert_equal expected, @stat_tracker.average_goals_by_season
  end
  
  
  
  
  #League Statistics Tests
  def test_it_can_count_number_of_teams
    skip
    assert_equal 32, @stat_tracker.count_of_teams
  end

  def test_it_can_name_team_with_most_tackles
    skip
    assert_equal "FC Cincinnati", @stat_tracker.most_tackles("20132014")
    assert_equal "Seattle Sounders FC", @stat_tracker.most_tackles("20142015")
  end

  #Team Statistics
  def test_it_can_list_team_info
    skip

    expected = {
     "team_id" => "18",
     "franchise_id" => "34",
     "team_name" => "Minnesota United FC",
     "abbreviation" => "MIN",
     "link" => "/api/v1/teams/18"
   }

   assert_equal @stat_tracker.team_info("18"), expected
  end







































































































































































  def test_you_can_find_lowest_total_score

    assert_equal 0, @stat_tracker.lowest_total_score
  end

  def test_percentage_of_home_wins
    assert_equal 0.44, @stat_tracker.percentage_home_wins
  end

  def test_percentage_of_visitor_wins
    assert_equal 0.36, @stat_tracker.percentage_visitor_wins
  end

  def test_count_games_by_season
    expected = {
      "20122013"=>806,
      "20162017"=>1317,
      "20142015"=>1319,
      "20152016"=>1321,
      "20132014"=>1323,
      "20172018"=>1355
      }
    assert_equal expected, @stat_tracker.count_of_games_by_season
  end

  def test_it_can_calculate_best_offense
    assert_equal "Reign FC", @stat_tracker.best_offense
  end
end
