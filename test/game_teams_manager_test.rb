require 'simplecov'
require 'minitest/autorun'
require 'minitest/pride'
require './lib/stat_tracker'
# require './test/test_helper'
require './lib/teams_manager'
require './lib/games_manager'
require './lib/game_teams_manager'

class GameTeamsManagerTest < Minitest::Test
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
    @data = @stat_tracker.load_csv(@locations[:game_teams])
    @game_team_manager = GameTeamsManager.new(@data, @stat_tracker)
  end

  def test_it_exists
    skip
    assert_instance_of GameTeamsManager, @game_team_manager
  end

  def test_goals_grouped_by_team_id
    skip
    #Need more specific test
    assert_instance_of Hash, @game_team_manager.goals_grouped_by_team_id
  end

  def test_it_can_calculate_best_offense
    skip
    assert_equal ["54", 2.343137254901961], @game_team_manager.best_offense
  end

  def test_it_can_calculate_worst_offense
    skip
    assert_equal ["7", 1.8362445414847162], @game_team_manager.worst_offense
  end

  def test_game_team_results_by_head_coach
    #need more specific test
    assert_instance_of Hash, @game_team_manager. game_team_results_by_head_coach
  end
end
