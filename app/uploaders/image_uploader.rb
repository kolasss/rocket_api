# frozen_string_literal: true

require 'image_processing/mini_magick'

class ImageUploader < Shrine
  ALLOWED_TYPES = %w[image/jpeg image/png].freeze
  MIN_SIZE      = 5 * 1024 # 5 KB
  MAX_SIZE      = 5 * 1024 * 1024 # 5 MB
  # MAX_WIDTH     = 4096
  # MAX_HEIGHT    = MAX_WIDTH

  plugin :processing
  plugin :versions
  plugin :validation_helpers
  # plugin :pretty_location

  # plugin :remove_attachment
  # plugin :store_dimensions, analyzer: :mini_magick

  Attacher.validate do
    validate_min_size MIN_SIZE
    validate_max_size MAX_SIZE
    validate_mime_type_inclusion(ALLOWED_TYPES)
    # if validate_mime_type_inclusion(ALLOWED_TYPES)
    #   validate_max_width MAX_WIDTH
    #   validate_max_height MAX_HEIGHT
    # end
  end

  process(:store) do |io, _context|
    versions = { original: io } # retain original

    io.download do |original|
      pipeline = ImageProcessing::MiniMagick.source(original)

      # versions[:large]  = pipeline.resize_to_limit!(1024, 1024)
      versions[:medium] = pipeline.resize_to_limit!(512, 512)
      # versions[:small]  = pipeline.resize_to_limit!(256, 256)
    end

    versions # return the hash of processed files
  end
end
