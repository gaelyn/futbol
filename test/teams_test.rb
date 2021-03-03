require 'CSV'
require 'minitest/autorun'
require 'minitest/pride'
require './lib/teams'
require './lib/stat_tracker'
require './lib/teams_manager'
require './lib/games_manager'
require './lib/game_teams_manager'


class TeamTest < Minitest::Test
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
    @team = @team_manager.teams[0]
  end

  def test_it_exists
    assert_instance_of Team, @team
  end

  def test_it_has_readable_attributes
    assert_equal "1", @team.team_id
    assert_equal "23", @team.franchise_id
    assert_equal "Atlanta United", @team.team_name
    assert_equal "ATL", @team.abbreviation
    assert_equal "/api/v1/teams/1", @team.link
    assert_instance_of TeamManager, @team.manager
  end

  def test_team_info_returns_hash
    assert_instance_of Hash, @team.team_info
  end
end
