class DropGalleryPhotoTables < ActiveRecord::Migration
  def up
    drop_table :galleries
    drop_table :photos
  end

  def down
  end
end
