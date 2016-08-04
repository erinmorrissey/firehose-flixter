class Lesson < ActiveRecord::Base
  belongs_to :section
  mount_uploader :video, VideoUploader

  # pulls in the functionality of the gem to Lesson model
  include RankedModel
  # Lessons belong_to Sections, make the ranker scoped to one Section
  ranks :row_order, :with_same => :section_id

  # looks up the next lesson within it's section. If there is none, it will return nil
  def next_lesson
    # section - loads the section that is connected to the lesson we are "in"
    # .lessons - loads ALL the lessons that belong_to the loaded section
    # .where - allows us to add snippets of SQL that can filter records
    #     "row_order > ?" - says we're asking for records where row_order > ?, and ?
    #           indicates we will be passing through an additional value in a moment
    #     self.row_order - passes the row_order of the current lesson to the previous filter
    #     * in total, we're asking for records that come after the current lesson
    # .rank(:row_order) - sort the remaining lesson results by row_order
    # .first - takes the first lesson in the remaining list
    lesson = section.lessons.where("row_order > ?", self.row_order).rank(:row_order).first
    # IF the lesson we just called is nil, meaning it is the last lesson in it's section
    # AND there is a truthy value when .next_section is called on the current section,
    # call .next_section on the current section, load all it's lessons, sort them by row_order
    # grab the first one, and return IT as the next_lesson
    if lesson.blank? && section.next_section
      return section.next_section.lessons.rank(:row_order).first
    end
    return lesson
  end
end
