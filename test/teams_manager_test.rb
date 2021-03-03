require 'simplecov'
require 'minitest/autorun'
require 'minitest/pride'
require './lib/stat_tracker'
# require './test/test_helper'
require './lib/teams_manager'
require './lib/games_manager'
require './lib/game_teams_manager'

class TeamManagerTest < Minitest::Test
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
    @data = @stat_tracker.load_csv(@locations[:teams])
    @team_manager = TeamManager.new(@data, @stat_tracker)
  end

  def test_it_exists
    assert_instance_of TeamManager, @team_manager
  end

  def test_count_of_teams
    # skip
    assert_equal 32, @team_manager.count_of_teams
  end

  def test_return_team_name_by_id
    assert_equal "Atlanta United", @team_manager.return_team_name_by_id("1")
  end

end
