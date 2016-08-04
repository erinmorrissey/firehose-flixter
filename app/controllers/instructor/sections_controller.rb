class Instructor::SectionsController < ApplicationController
  before_action :authenticate_user!
  before_action :require_authorized_for_current_course, only: [:create]
  before_action :require_authorized_for_current_section, only: [:update]

  ### removed after we moved the form for creating a new section into a modal window
  ### on the instructor/courses#show page, then removed the route that gave us an 
  ### instructor/sections#new page
  # def new
  #   @section = Section.new
  # end

  def create
    @section = current_course.sections.create(section_params)
    redirect_to instructor_course_path(current_course)
  end

  def update
    current_section.update_attributes(section_params)
    render text: 'updated!'
  end


  private

  def require_authorized_for_current_section
    if current_section.course.user != current_user
      render text: 'Unauthorized', status: :Unauthorized
    end
  end

  def current_section
    @current_section ||= Section.find(params[:id])
  end

  def require_authorized_for_current_course
    if current_course.user != current_user
      render text: 'Unauthorized', status: :Unauthorized
    end
  end

  # declares a helper method to Rails, which will let us call it in our views
  helper_method :current_course

  def current_course
    @current_course ||= Course.find(params[:course_id])
    # ^ line above is same as if/end statement below
    # basically says:
    #     if we've looked up the current_course beforehand,
    #     use the value that we looked up previously. If we haven't 
    #     looked up this course before, go into the database, 
    #     look it up and also make sure to remember the value in 
    #     case we need to look it up again later. This technique of storing 
    #     certain values inside of the memory to reduce the times we have to 
    #     find a certain value inside the database is called memoization

    # if @current_course == nil
    #   @current_course = Course.find(params[:course_id])
    #   @current_course
    # else
    #   @current_course
    # end
  end

  def section_params
    params.require(:section).permit(:title, :row_order_position)
  end
end
