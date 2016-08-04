class Section < ActiveRecord::Base
  belongs_to :course
  has_many :lessons

  # pulls in the functionality of the gem to Section model
  include RankedModel
  # Sections belong_to Courses, make the ranker scoped to one Course
  ranks :row_order, :with_same => :course_id

  def next_section
    section = course.sections.where("row_order > ?", self.row_order).rank(:row_order).first
    return section
  end
end
