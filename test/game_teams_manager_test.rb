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

  def test_game_ids_by_head_coach
    #need more specific test
    assert_instance_of Hash, @game_team_manager. game_ids_by_head_coach
  end

  def test_average_number_of_losses

    assert_equal
  end

  def test_game_by_team_id

    assert_equal___, @game_team_manager.games_by_team_id
  end

  def test_wins_by_team_id

    assert_equal_____, @game_team_manager.wins_by_team_id
  end

  def test_game_ids_by_team_id

    assert_equal____, @game_team_manager.game_ids_by_team_id
  end

  def test_season_by_game_id

    assert_equal___, @game_team_manager.season_by_game_id
  end

  def test_best_season
    assert_equal "20132014", @game_team_manager.best_season("6")
  end

  def test_worst_season
    assert_equal "20142015", @game_team_manager.worst_season("6")
  end

  def test_game_result_by_team_id

    assert_equal___, @game_team_manager.game_result_by_team_id(" ")
  end

  def test_average_win_percentage

    assert_equal___, @game_team_manager.average_win_percentage(" ")
  end

  def test_most_goals_scored

    assert_equal___, @game_team_manager.most_goals_scored(" ")
  end

  def test_fewest_goals_scored

    assert_equal___, @game_team_manager.fewest_goals_scored(" ")
  end

  def test_team_id_by_game_id

    assert_equal___, @game_team_manager(" ")
  end

  def test_hash_of_team_id_by_result

    assert_equal___, @game_team_manager.hash_of_team_id_by_result(" ")
  end

  def test_hash_of_results_to_average_lost

    assert_equal___, @game_team_manager.hash_of_results_to_average_lost(" ")
  end

  def test_hash_of_results_to_average_won

    assert_equal___, @game_team_manager.hash_of_results_to_average_won(" ")
  end
end
