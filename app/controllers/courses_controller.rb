class CoursesController < ApplicationController
  def index
    @courses = Course.all.order(:id)
  end

  def show
    @course = Course.find(params[:id])
  end
end
