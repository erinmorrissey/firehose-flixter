class Section < ActiveRecord::Base
  belongs_to :course
  has_many :lessons

  # pulls in the functionality of the gem to Section model
  include RankedModel
  # Sections belong_to Courses, make the ranker scoped to one Course
  ranks :row_order, :with_same => :course_id
end
