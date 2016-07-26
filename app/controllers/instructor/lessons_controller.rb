class Instructor::LessonsController < ApplicationController
  def new
    # first
    # load the section that is being referenced
    # in the URL, by pulling the section_id from the params
    @section = Section.find(params[:section_id])
    # next
    # build a new empty lesson to give the form a template object
    @lesson = Lesson.new
  end

  def create
    # first
    # look up the section in the DB that the lesson is for
    @section = Section.find(params[:section_id])
    # next
    # create the lesson in the DB & connect it to the section we looked up
    @lesson = @section.lessons.create(lesson_params)
    # last
    # redirect the user to the instructor dashboard
    redirect_to instructor_course_path(@section.course)
  end

  private

  def lesson_params
    params.require(:lesson).permit(:title, :subtitle)
  end
end
