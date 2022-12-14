# frozen_string_literal: true

# == Schema Information
#
# Table name: testimonials
#
#  id           :bigint           not null, primary key
#  content      :string
#  discarded_at :datetime
#  name         :string           not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
# Indexes
#
#  index_testimonials_on_discarded_at  (discarded_at)
#
FactoryBot.define do
  factory :testimonial do
    name { Faker::Name.first_name }
    content { Faker::Lorem.paragraph }

    after(:build) do |testimonial|
      testimonial.image.attach(
        io: File.open(Rails.root.join('spec/factories_files/dummy_image.png')),
        filename: 'dummy_image.png',
        content_type: 'image/png'
      )
    end
  end
end
