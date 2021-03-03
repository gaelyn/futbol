class Team
  attr_reader :team_id, :franchise_id, :team_name, :abbreviation, :link,
              :manager
  def initialize(row, manager)
    @team_id = row[:team_id]
    @franchise_id = row[:franchiseid]
    @team_name = row[:teamname]
    @abbreviation = row[:abbreviation]
    @link = row[:link]
    @manager = manager
  end

  def team_info
    info = {
      "team_id" => @team_id,
      "franchise_id" => @franchise_id,
      "team_name" => @team_name,
      "abbreviation" => @abbreviation,
      "link" => @link
    }
  end
end
