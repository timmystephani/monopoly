# == Schema Information
#
# Table name: board_spaces
#
#  id         :integer          not null, primary key
#  name       :string
#  position   :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class BoardSpace < ActiveRecord::Base
  has_one :owned_property
end
