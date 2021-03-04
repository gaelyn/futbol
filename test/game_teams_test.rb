require 'minitest/autorun'
require 'minitest/pride'
require './lib/game_teams'
require './lib/game_teams_manager'
require './lib/teams_manager'
require './lib/stat_tracker'
require './lib/games_manager'

class GameTeamTest < Minitest::Test
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
    @game_teams = @game_team_manager.game_teams[0]
  end

  def test_it_exists
    assert_instance_of GameTeam, @game_teams
  end

  def test_it_has_readable_attributes
    assert_equal "2012030221", @game_teams.game_id
    assert_equal "3", @game_teams.team_id
    assert_equal "away", @game_teams.hoa
    assert_equal "LOSS", @game_teams.result
    assert_equal "John Tortorella", @game_teams.head_coach
    assert_equal "2", @game_teams.goals
    assert_equal "8", @game_teams.shots
    assert_equal "44", @game_teams.tackles
    assert_instance_of GameTeamsManager, @game_teams.manager
  end
end
