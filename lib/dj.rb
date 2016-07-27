class Dj < ActiveRecord::Base
  belongs_to :user
  belongs_to :song

  private
  def request
    requests -= 1
  end
end
