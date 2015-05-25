class LeadsController < ApplicationController

  def index
    @leads = Lead.where(:requester_id=>current_user.id)

  end

end
