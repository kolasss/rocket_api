# frozen_string_literal: true

module Locations
  class Address
    include Mongoid::Document
    field :title, type: String
    field :street, type: String
    field :building, type: String
    field :apartment, type: String
    field :entrance, type: String
    field :floor, type: String
    field :intercom, type: String
    field :note, type: String
    field :location, type: Mongoid::Geospatial::Point

    embedded_in :addressable, polymorphic: true
  end
end
