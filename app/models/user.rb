class User < ActiveRecord::Base
  has_many :courses
  has_many :enrollments
  has_many :enrolled_courses, through: :enrollments, source: :course

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  def enrolled_in?(course)
    ### original code
    # enrolled_courses = []
    # enrollments.each do |enrollment|
    #   enrolled_courses << enrollment.course
    # end

    ### refactored code (1st time)
    # enrolled_courses = enrollments.collect do |enrollment|
    #   enrollment.course
    # end

    ### refactored code (2nd time)
    # enrolled_courses = enrollments.collect(&:course)

    ### above line then removed because it is an N+1 query
    # and instead we added the has_many :through line above,
    # which is the exact same functionality but only makes ONE
    # call to the DB vs. N+1 calls

    return enrolled_courses.include?(course)
  end
end
