# frozen_string_literal: true

require 'shrine'

if Rails.env.production?
  require 'shrine/storage/s3'

  docean = Rails.application.credentials[:production][:docean]
  s3_options = {
    access_key_id: docean[:key],
    secret_access_key: docean[:secret],
    bucket: docean[:bucket],
    endpoint: docean[:endpoint],
    region: docean[:region]
  }

  Shrine.storages = {
    cache: Shrine::Storage::S3.new(
      prefix: 'cache', upload_options: { acl: 'public-read' }, **s3_options
    ),
    store: Shrine::Storage::S3.new(
      prefix: 'store', upload_options: { acl: 'public-read' }, **s3_options
    )
  }
else
  require 'shrine/storage/file_system'

  Shrine.storages = {
    cache: Shrine::Storage::FileSystem.new('public', prefix: 'uploads/cache'),
    store: Shrine::Storage::FileSystem.new('public', prefix: 'uploads/store')
  }
end

Shrine.plugin :mongoid
Shrine.plugin :remove_invalid
Shrine.plugin :determine_mime_type
Shrine.plugin :pretty_location
Shrine.plugin :moving
