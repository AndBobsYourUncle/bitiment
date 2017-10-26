# frozen_string_literal: true

class Snapshot < ApplicationRecord
  has_many :articles
end
