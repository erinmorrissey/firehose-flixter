class Instructor::CoursesController < ApplicationController
  before_action :authenticate_user!
  before_action :require_authorized_for_current_course, only: [:show]

  def show
    # @course = Course.find(params[:id])
    #    ^ removed b/c we refactored @course into .current_course
    #      and now the view calls .current_course, so having it here
    #      would be redundant
    @section = Section.new
    #    ^ added when decided to move the new section form into a modal window
    #      on the instructor/courses#show page
    @lesson = Lesson.new
    #    ^ added when decided to move the new lesson form into a modal window
    #      on the instructor/courses#show page
  end

  def new
    @course = Course.new
  end

  def create
    @course = current_user.courses.create(course_params)
    if @course.valid?
      redirect_to instructor_course_path(@course)
    else
      render :new, status: :unprocessable_entity
    end
  end


  private

  def require_authorized_for_current_course
    if current_course.user != current_user
      render text: "Unauthorized", status: :unauthorized
    end
  end

  helper_method :current_course

  def current_course
    @current_course ||= Course.find(params[:id])
  end

  def course_params
    params.require(:course).permit(:title, :description, :cost, :image)
  end
end
