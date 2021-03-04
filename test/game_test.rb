require 'CSV'
require 'minitest/autorun'
require 'minitest/pride'
require './lib/game'
require './lib/stat_tracker'
require './lib/teams_manager'
require './lib/games_manager'
require './lib/game_teams_manager'


class GameTest < Minitest::Test
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
    @game = @game_manager.games[0]
  end

  def test_it_exists
    assert_instance_of Game, @game
  end

  def test_it_has_readable_attributes
    assert_equal "2012030221", @game.game_id
    assert_equal "20122013", @game.season
    assert_equal "3", @game.away_team_id
    assert_equal "6", @game.home_team_id
    assert_equal "2", @game.away_goals
    assert_equal "3", @game.home_goals
    assert_equal @game_manager, @game.manager
  end
end
