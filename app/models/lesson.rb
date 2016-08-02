class Lesson < ActiveRecord::Base
  belongs_to :section
  mount_uploader :video, VideoUploader

  # pulls in the functionality of the gem to Lesson model
  include RankedModel
  # Lessons belong_to Sections, make the ranker scoped to one Section
  ranks :row_order, :with_same => :section_id

end
