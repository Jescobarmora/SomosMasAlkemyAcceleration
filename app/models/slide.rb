# frozen_string_literal: true

# == Schema Information
#
# Table name: slides
#
#  id              :bigint           not null, primary key
#  order           :integer
#  text            :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  organization_id :bigint           not null
#
# Indexes
#
#  index_slides_on_organization_id  (organization_id)
#
# Foreign Keys
#
#  fk_rails_...  (organization_id => organizations.id)
#
class Slide < ApplicationRecord
  has_one_attached :image

  belongs_to :organization
end
