class FestivalsController < ApplicationController
  def index
    @festival = festival.all
  end
end
