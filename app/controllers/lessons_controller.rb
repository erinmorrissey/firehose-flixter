class LessonsController < ApplicationController
  before_action :authenticate_user!
  before_action :require_authorized_for_current_lesson, only: [:show]

  def show
  end

  private


  # We have access to a lesson, which has access to a section, 
  # which has access to a course. In order words, something like 
  # current_lesson.section.course will give you access to a course 
  # if you have a lesson...
  def require_authorized_for_current_lesson
    #if current_lesson.section.course.user != current_user
    if !current_user.enrolled_in?(current_lesson.section.course)
      redirect_to course_path(current_lesson.section.course), alert: 'You must enroll in this course to access the lessons'
    end
  end

  helper_method :current_lesson
  def current_lesson
    @current_lesson ||= Lesson.find(params[:id])
  end
end
