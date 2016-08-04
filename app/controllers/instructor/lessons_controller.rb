class Instructor::LessonsController < ApplicationController
  # authenticate_user! is a helper method provided by devise gem
  # ensures user is a logged-in user before running any actions
  before_action :authenticate_user!
  # triggers private methods defined below
  before_action :require_authorization_for_current_section, only: [:create]
  before_action :require_authorization_for_current_lesson, only: [:update]

  def new
    # first
    # load the section that is being referenced
    # in the URL, by pulling the section_id from the params
    # (triggers the private method current_section)
    # @section = Section.find(params[:section_id])
    # @section = current_section
    #    ^ used to have the above as the first step, but now that the 
    #      'new' view was edited to call .current_section instead of @section,
    #      we can remove this explicit first step
    # second
    # build a new empty lesson to give the form a template object
    #@lesson = Lesson.new
    #    ^ removed after we moved the form for creating a new lesson into a modal window
    #      on the instructor/courses#show page, then removed the route that gave us an 
    #      instructor/lessons#new page
  end

  def create
    # first
    # look up the section in the DB that the lesson is for
    # @section = current_section
    #    ^ used to have the above as the first step, but now that the 
    #      'new' view was edited to call .current_section instead of @section,
    #      we can remove this explicit first step
    # create the lesson in the DB & connect it to the section we looked up
    @lesson = current_section.lessons.create(lesson_params)
    # last
    # redirect the user to the instructor dashboard
    redirect_to instructor_course_path(current_section.course)
  end

  # this method is for the drag-and-drop lesson reordering
  # this exposes an endpoint that will allow us to trigger a data update to a 
  #    lesson (ex. update the value of :row_order_position)
  # b/c of the route associated with instructor/lessons#update, it means
  # our app is listening for PUT requests to the instructor_lesson_path, 
  # which will trigger this update action
  def update
    current_lesson.update_attributes(lesson_params)
    render text: 'updated!'
  end

  private

  # same idea as require_auth below, but matches lesson creator to current_user
  def require_authorization_for_current_lesson
    if current_lesson.section.course.user != current_user
      return render text: 'Unathorized', status: :unauthorized
    end
  end

  def current_lesson
    @current_lesson ||= Lesson.find(params[:id])
  end

  # ensures logged-in user id (current_user) matches id of user who created course
  def require_authorization_for_current_section
    # (current_section.course.user grabs the course from the section, and the user from the course)
    if current_section.course.user != current_user
      # if mismatch, send 401 status & error message to web browser
      return render text: 'Unathorized', status: :unauthorized
    end
  end

  # declares a helper method to Rails, which will let us call it in our views
  helper_method :current_section

  def current_section
    @current_section ||= Section.find(params[:section_id])
    # ^ line above is same as if/end statement below
    # basically says:
    #     if we've looked up the current_section beforehand,
    #     use the value that we looked up previously. If we haven't 
    #     looked up this section before, go into the database, 
    #     look it up and also make sure to remember the value in 
    #     case we need to look it up again later. This technique of storing 
    #     certain values inside of the memory to reduce the times we have to 
    #     find a certain value inside the database is called memoization

    # if @current_section == nil
    #   @current_section = Section.find(params[:section_id])
    #   @current_section
    # else
    #   @current_section
    # end
  end

  def lesson_params
    params.require(:lesson).permit(:title, :subtitle, :video, :row_order_position)
  end
end
